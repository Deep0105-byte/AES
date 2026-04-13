module aes_128_core (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,       // Encryption shuru karne ka signal
    input  wire [127:0] plaintext,
    input  wire [127:0] key,         // 128-bit Cipher Key
    output reg  [127:0] ciphertext,
    output reg          done         // Encryption complete hone ka signal
);

    // --- Internal Signals & Wires ---
    reg  [3:0]   round_counter;
    wire [127:0] current_state;      // State Matrix se nikla hua data
    wire [127:0] next_state;         // Agle round ka data
    wire [127:0] round_out;          // aes_round.v ka output
    wire [127:0] round_key_in;       // Current round ke liye key
    wire [1407:0] full_key_schedule; // 11 keys * 128 bits (From Key Expansion)
    wire         is_final_round;

    // --- 1. Key Expansion Block (FIPS 197 Sec 5.2) ---
    // Yeh 128-bit key ko 11 round keys mein expand karega
    aes_key_expansion_128 key_gen (
        .key_in(key),
        .key_schedule(full_key_schedule)
    );

    // MUX to select the correct 128-bit Round Key based on round_counter
    assign round_key_in = full_key_schedule[ (round_counter * 128) +: 128 ];

    // --- 2. The AES Standard Round (SubBytes, ShiftRows, MixColumns, AddRoundKey) ---
    assign is_final_round = (round_counter == 10) ? 1'b1 : 1'b0;

    aes_round round_engine (
        .state_in(current_state),
        .round_key(round_key_in),
        .is_final_round(is_final_round),
        .state_out(round_out)
    );

    // --- 3. Initial AddRoundKey Logic (FIPS 197 Algorithm 1, Line 3) ---
    // Start hone par plaintext seedha round 0 key se XOR hoga, warna round engine se data aayega
    assign next_state = (round_counter == 0) ? (plaintext ^ round_key_in) : round_out;

    // --- 4. Aapka State Matrix (Memory Register for 'State') ---
    aes_state_matrix state_reg (
        .clk(clk),
        .rst(rst),
        .state_in(next_state),
        .state_out(current_state)
    );

    // --- 5. The FSM (Control Unit) ---
    reg [1:0] state, next_fsm_state;
    localparam IDLE = 2'b00, BUSY = 2'b01, FINISH = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            round_counter <= 0;
            done <= 0;
            ciphertext <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= BUSY;
                        round_counter <= 0; // Round 0 (Initial AddRoundKey)
                    end
                end

                BUSY: begin
                    if (round_counter < 10) begin
                        round_counter <= round_counter + 1; // Rounds 1 to 10
                    end else begin
                        state <= FINISH; // 10 rounds complete
                    end
                end

                FINISH: begin
                    ciphertext <= current_state; // Final cipher output
                    done <= 1;
                    state <= IDLE; // Wapas aagle data ke liye wait
                end
            endcase
        end
    end

endmodule
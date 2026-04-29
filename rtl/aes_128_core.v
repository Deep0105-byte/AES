module aes_128_core (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,       
    input  wire [127:0] plaintext,
    input  wire [127:0] key,         
    output reg  [127:0] ciphertext,
    output reg          done         
);

    
    reg  [3:0]   round_counter;
    wire [127:0] current_state;      
    wire [127:0] next_state;         
    wire [127:0] round_out;          
    wire [127:0] round_key_in;       
    wire [1407:0] full_key_schedule; 
    wire         is_final_round;

    
    aes_key_expansion_128 key_gen (
        .original_key(key),
        .key_schedule(full_key_schedule)
    );

    
    assign round_key_in = full_key_schedule[ (round_counter * 128) +: 128 ];

    
    assign is_final_round = (round_counter == 10) ? 1'b1 : 1'b0;

    aes_round round_engine (
        .state_in(current_state),
        .round_key(round_key_in),
        .is_final_round(is_final_round),
        .state_out(round_out)
    );

    
    assign next_state = (round_counter == 0) ? (plaintext ^ round_key_in) : round_out;

   
    wire [7:0] w_s00, w_s10, w_s20, w_s30;
    wire [7:0] w_s01, w_s11, w_s21, w_s31;
    wire [7:0] w_s02, w_s12, w_s22, w_s32;
    wire [7:0] w_s03, w_s13, w_s23, w_s33;

    aes_state_matrix state_reg (
        .clk(clk),
        .reset(rst),
        .in_data(next_state),
        .s00(w_s00), .s10(w_s10), .s20(w_s20), .s30(w_s30),
        .s01(w_s01), .s11(w_s11), .s21(w_s21), .s31(w_s31),
        .s02(w_s02), .s12(w_s12), .s22(w_s22), .s32(w_s32),
        .s03(w_s03), .s13(w_s13), .s23(w_s23), .s33(w_s33)
    );

    
    assign current_state = {w_s00, w_s10, w_s20, w_s30, 
                            w_s01, w_s11, w_s21, w_s31, 
                            w_s02, w_s12, w_s22, w_s32, 
                            w_s03, w_s13, w_s23, w_s33};


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
                        round_counter <= 0;
                    end
                end

                BUSY: begin
                    if (round_counter < 10) begin
                        round_counter <= round_counter + 1;
                    end else begin
                        state <= FINISH;
                    end
                end

                FINISH: begin
                    ciphertext <= current_state;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
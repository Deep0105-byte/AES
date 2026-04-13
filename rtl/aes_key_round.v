module aes_key_round (
    input  wire [127:0] w_prev,  // Pichli 128-bit Key (4 words: w[i-4], w[i-3], w[i-2], w[i-1])
    input  wire [7:0]   rcon,    // Is round ka fixed Rcon (Round Constant)
    output wire [127:0] w_next   // Nayi 128-bit Key (4 words: w[i], w[i+1], w[i+2], w[i+3])
);

    // Step 1: Pichli key ki 128-bit wire ko 4 alag-alag 32-bit Words mein todna
    wire [31:0] w_prev_0 = w_prev[127:96]; // w[i-4]
    wire [31:0] w_prev_1 = w_prev[95:64];  // w[i-3]
    wire [31:0] w_prev_2 = w_prev[63:32];  // w[i-2]
    wire [31:0] w_prev_3 = w_prev[31:0];   // w[i-1] (Yeh word sabse special hai)

    // Step 2: ROTWORD (Aakhri word w[i-1] ke bytes ko cyclically left shift karna)
    // Formula: [a0, a1, a2, a3] -> [a1, a2, a3, a0]
    wire [31:0] rot_word = {w_prev_3[23:0], w_prev_3[31:24]};

    // Step 3: SUBWORD (Rotated word ke chaaron bytes ko S-Box se nikalna)
    wire [31:0] sub_word;
    aes_sbox sbox_0 ( .in(rot_word[31:24]), .out(sub_word[31:24]) );
    aes_sbox sbox_1 ( .in(rot_word[23:16]), .out(sub_word[23:16]) );
    aes_sbox sbox_2 ( .in(rot_word[15:8]),  .out(sub_word[15:8])  );
    aes_sbox sbox_3 ( .in(rot_word[7:0]),   .out(sub_word[7:0])   );

    // Step 4: Naye 4 words calculate karna (XOR logic)
    // Pehla naya word w[i] = w[i-4] XOR sub_word XOR Rcon
    // (Dhyan de: Rcon sirf left-most byte mein XOR hota hai, baaki 24 bits 0 hote hain)
    wire [31:0] w_next_0 = w_prev_0 ^ sub_word ^ {rcon, 24'h000000}; 

    // Baaki ke teen words ka simple XOR chain
    wire [31:0] w_next_1 = w_prev_1 ^ w_next_0; // w[i+1] = w[i-3] XOR w[i]
    wire [31:0] w_next_2 = w_prev_2 ^ w_next_1; // w[i+2] = w[i-2] XOR w[i+1]
    wire [31:0] w_next_3 = w_prev_3 ^ w_next_2; // w[i+3] = w[i-1] XOR w[i+2]

    // Step 5: Naye chaaron 32-bit words ko wapas ek 128-bit wire mein jodh dena
    assign w_next = {w_next_0, w_next_1, w_next_2, w_next_3};

endmodule
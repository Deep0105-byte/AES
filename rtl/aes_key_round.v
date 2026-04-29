module aes_key_round (
    input  wire [127:0] w_prev,  
    input  wire [7:0]   rcon,    
    output wire [127:0] w_next   
);

    
    wire [31:0] w_prev_0 = w_prev[127:96]; 
    wire [31:0] w_prev_1 = w_prev[95:64];  
    wire [31:0] w_prev_2 = w_prev[63:32];  
    wire [31:0] w_prev_3 = w_prev[31:0];   

    
    wire [31:0] rot_word = {w_prev_3[23:0], w_prev_3[31:24]};

    wire [31:0] sub_word;
    aes_sbox sbox_0 ( .in(rot_word[31:24]), .out(sub_word[31:24]) );
    aes_sbox sbox_1 ( .in(rot_word[23:16]), .out(sub_word[23:16]) );
    aes_sbox sbox_2 ( .in(rot_word[15:8]),  .out(sub_word[15:8])  );
    aes_sbox sbox_3 ( .in(rot_word[7:0]),   .out(sub_word[7:0])   );

    
    wire [31:0] w_next_0 = w_prev_0 ^ sub_word ^ {rcon, 24'h000000}; 

    
    wire [31:0] w_next_1 = w_prev_1 ^ w_next_0; 
    wire [31:0] w_next_2 = w_prev_2 ^ w_next_1; 
    wire [31:0] w_next_3 = w_prev_3 ^ w_next_2; 

    assign w_next = {w_next_0, w_next_1, w_next_2, w_next_3};

endmodule
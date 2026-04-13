module aes_key_expansion_128 (
    input  wire [127:0] original_key,
    output wire [1407:0] key_schedule // 11 keys x 128 bit = 1408 bit ka lamba output
);

    // Wires declare karna har round ki key hold karne ke liye
    wire [127:0] key_0, key_1, key_2, key_3, key_4, key_5, key_6, key_7, key_8, key_9, key_10;

    // Pehli key toh seedha original key hi hoti hai
    assign key_0 = original_key;

    // Ab har round ke liye wo 'aes_key_round' block lagao, aur Table 5 se Rcon do
    aes_key_round r1 ( .w_prev(key_0), .rcon(8'h01), .w_next(key_1)  );
    aes_key_round r2 ( .w_prev(key_1), .rcon(8'h02), .w_next(key_2)  );
    aes_key_round r3 ( .w_prev(key_2), .rcon(8'h04), .w_next(key_3)  );
    aes_key_round r4 ( .w_prev(key_3), .rcon(8'h08), .w_next(key_4)  );
    aes_key_round r5 ( .w_prev(key_4), .rcon(8'h10), .w_next(key_5)  );
    aes_key_round r6 ( .w_prev(key_5), .rcon(8'h20), .w_next(key_6)  );
    aes_key_round r7 ( .w_prev(key_6), .rcon(8'h40), .w_next(key_7)  );
    aes_key_round r8 ( .w_prev(key_7), .rcon(8'h80), .w_next(key_8)  );
    aes_key_round r9 ( .w_prev(key_8), .rcon(8'h1b), .w_next(key_9)  );
    aes_key_round r10( .w_prev(key_9), .rcon(8'h36), .w_next(key_10) );

    // Saari 11 keys (key_10 se key_0) ko ek lambi 1408-bit wire mein jodh kar bahar bhej do
    assign key_schedule = {key_10, key_9, key_8, key_7, key_6, key_5, key_4, key_3, key_2, key_1, key_0};

endmodule
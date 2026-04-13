module aes_subbytes (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // FIPS 197 Section 5.1.1: S-Box is applied independently to each byte.
    // Hum 128-bit ki wire ko 8-bit ke 16 tukdon mein kaat kar 16 S-Boxes mein daal rahe hain.

    // Column 0
    aes_sbox sbox_00 ( .in(state_in[127:120]), .out(state_out[127:120]) );
    aes_sbox sbox_10 ( .in(state_in[119:112]), .out(state_out[119:112]) );
    aes_sbox sbox_20 ( .in(state_in[111:104]), .out(state_out[111:104]) );
    aes_sbox sbox_30 ( .in(state_in[103:96]),  .out(state_out[103:96])  );

    // Column 1
    aes_sbox sbox_01 ( .in(state_in[95:88]),   .out(state_out[95:88])   );
    aes_sbox sbox_11 ( .in(state_in[87:80]),   .out(state_out[87:80])   );
    aes_sbox sbox_21 ( .in(state_in[79:72]),   .out(state_out[79:72])   );
    aes_sbox sbox_31 ( .in(state_in[71:64]),   .out(state_out[71:64])   );

    // Column 2
    aes_sbox sbox_02 ( .in(state_in[63:56]),   .out(state_out[63:56])   );
    aes_sbox sbox_12 ( .in(state_in[55:48]),   .out(state_out[55:48])   );
    aes_sbox sbox_22 ( .in(state_in[47:40]),   .out(state_out[47:40])   );
    aes_sbox sbox_32 ( .in(state_in[39:32]),   .out(state_out[39:32])   );

    // Column 3
    aes_sbox sbox_03 ( .in(state_in[31:24]),   .out(state_out[31:24])   );
    aes_sbox sbox_13 ( .in(state_in[23:16]),   .out(state_out[23:16])   );
    aes_sbox sbox_23 ( .in(state_in[15:8]),    .out(state_out[15:8])    );
    aes_sbox sbox_33 ( .in(state_in[7:0]),     .out(state_out[7:0])     );

endmodule
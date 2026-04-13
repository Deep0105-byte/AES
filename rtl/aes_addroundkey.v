module aes_addroundkey (
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    output wire [127:0] state_out
);

    // FIPS 197 Section 5.1.4: ADDROUNDKEY() Transformation
    // State matrix ko Round Key ke sath bitwise XOR (^) kiya jata hai.
    
    assign state_out = state_in ^ round_key;

endmodule
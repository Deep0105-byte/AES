module mixcolumn_32bit (
    input  wire [31:0] in,
    output wire [31:0] out
);

    // XTIMES Function (FIPS 197 Section 4.2)
    // Yeh function kisi bhi byte ko Galois Field mein {02} se multiply karta hai
    function [7:0] xtimes;
        input [7:0] b;
        begin
            // Agar 7th bit 1 hai, toh left shift karke 8'h1b se XOR karo. 
            // Nahi toh sirf left shift karo.
            xtimes = (b[3] == 1'b1) ? ((b << 1) ^ 8'h1b) : (b << 1);
        end
    endfunction

    // 32-bit column ko 4 alag-alag 8-bit bytes (s0, s1, s2, s3) mein todna
    wire [7:0] s0, s1, s2, s3;
    assign s0 = in[31:24];
    assign s1 = in[23:16];
    assign s2 = in[15:8];
    assign s3 = in[7:0];

    // Output bytes (s'0, s'1, s'2, s'3) ke liye wires
    wire [7:0] out0, out1, out2, out3;

    // FIPS 197 Section 5.1.3: Matrix Multiplication Equations
    // Note: {02} * s  = xtimes(s)
    //       {03} * s  = xtimes(s) ^ s
    
    assign out0 = xtimes(s0) ^ (xtimes(s1) ^ s1) ^ s2 ^ s3;
    assign out1 = s0 ^ xtimes(s1) ^ (xtimes(s2) ^ s2) ^ s3;
    assign out2 = s0 ^ s1 ^ xtimes(s2) ^ (xtimes(s3) ^ s3);
    assign out3 = (xtimes(s0) ^ s0) ^ s1 ^ s2 ^ xtimes(s3);

    // Charo naye bytes ko wapas jodh kar 32-bit output bana dena
    assign out = {out0, out1, out2, out3};

endmodule
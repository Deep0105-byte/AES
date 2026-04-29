module mixcolumn_32bit (
    input  wire [31:0] in,
    output wire [31:0] out
);

    // XTIMES Function (FIPS 197 Section 4.2)
    function [7:0] xtimes;
        input [7:0] b;
        begin
            
            xtimes = (b[ 7 ] == 1'b1) ? ((b << 1) ^ 8'h1b) : (b << 1);
        end
    endfunction

    wire [7:0] s0, s1, s2, s3;
    assign s0 = in[31:24];
    assign s1 = in[23:16];
    assign s2 = in[15:8];
    assign s3 = in[7:0];

    wire [7:0] out0, out1, out2, out3;

    // FIPS 197 Section 5.1.3: Matrix Multiplication [3]
    assign out0 = xtimes(s0) ^ (xtimes(s1) ^ s1) ^ s2 ^ s3;
    assign out1 = s0 ^ xtimes(s1) ^ (xtimes(s2) ^ s2) ^ s3;
    assign out2 = s0 ^ s1 ^ xtimes(s2) ^ (xtimes(s3) ^ s3);
    assign out3 = (xtimes(s0) ^ s0) ^ s1 ^ s2 ^ xtimes(s3);

    assign out = {out0, out1, out2, out3};

endmodule
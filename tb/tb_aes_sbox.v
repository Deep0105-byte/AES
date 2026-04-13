module tb_aes_sbox;

    // Inputs and Outputs
    reg [7:0] in;
    wire [7:0] out;

    // S-Box module ko instantiate karna
    aes_sbox uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("--- AES S-Box Verification (FIPS 197 Table 4) ---");
        
        // Test 1: Pehli value (Row 0, Col 0) -> Expected: 63
        in = 8'h00; #10;
        $display("Input: %h | Output: %h | Expected: 63", in, out);

        // Test 2: Document ka example (Row 5, Col 3) -> Expected: ed
        in = 8'h53; #10;
        $display("Input: %h | Output: %h | Expected: ed", in, out);

        // Test 3: Ek random middle value (Row 8, Col e) -> Expected: 9b
        in = 8'h8e; #10;
        $display("Input: %h | Output: %h | Expected: 9b", in, out);

        // Test 4: Aakhri value (Row f, Col f) -> Expected: 16
        in = 8'hff; #10;
        $display("Input: %h | Output: %h | Expected: 16", in, out);

        // Test 5: Appendix B ka pehla data byte -> Expected: 23
        // (Input data '32' jab S-box mein jayega toh '23' banna chahiye)
        in = 8'h32; #10;
        $display("Input: %h | Output: %h | Expected: 23", in, out);

        #10 $finish;
    end
endmodule
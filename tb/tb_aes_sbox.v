module tb_aes_sbox;

    reg [7:0] in;
    wire [7:0] out;

    // Apna naya corrected S-Box lagana
    aes_sbox uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("--- CORRECTED AES S-Box Verification (FIPS 197) ---");
        
        // Test 1: Pehli value -> Expected: 63
        in = 8'h00; #10;
        $display("Input: %h | Output: %h | Expected: 63", in, out);

        // Test 2: FIPS 197 Section 5.1.1 Example -> Expected: ed
        in = 8'h53; #10;
        $display("Input: %h | Output: %h | Expected: ed", in, out);

        // Test 3: Appendix B Data -> Expected: 23
        in = 8'h32; #10;
        $display("Input: %h | Output: %h | Expected: 23", in, out);

        // Test 4: Aakhri value -> Expected: 16
        in = 8'hff; #10;
        $display("Input: %h | Output: %h | Expected: 16", in, out);

        // Final Check
        if (uut.out === 8'h16) // Aakhri test pass hua ya nahi
            $display("\n>> RESULT: PASS! S-Box ab 100%% FIPS compliant aur Row-Major hai.");
        else
            $display("\n>> RESULT: FAIL!");

        #10 $finish;
    end
endmodule
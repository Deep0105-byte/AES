module tb_aes_key_expansion;

    reg  [127:0] original_key;
    wire [1407:0] key_schedule; // Total 11 keys ka output

    // Key Expansion Module ko instantiate karna
    aes_key_expansion_128 uut (
        .original_key(original_key),
        .key_schedule(key_schedule)
    );

    // Wires to easily read specific round keys from the massive 1408-bit bus
    wire [127:0] round_0_key  = key_schedule[127:0];       // Original Key
    wire [127:0] round_1_key  = key_schedule[255:128];     // w[6] to w[7]
    wire [127:0] round_2_key  = key_schedule[383:256];     // w[8] to w[9]
    wire [127:0] round_3_key = key_schedule[511:384];
    wire [127:0] round_10_key = key_schedule[1407:1280];   // w[10] to w[11]

    initial begin
        $display("--- AES Key Expansion Verification (FIPS 197 Appendix A.1) ---");

        // Document Appendix A.1 ki Original Key:
        // 2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c
        original_key = 128'h2b7e151628aed2a6abf7158809cf4f3c; 
        
        #10; // Combinational logic ko propagate hone ka time dena
        
        $display("\n[Original Key / Round 0]");
        $display("Expected : 2b7e151628aed2a6abf7158809cf4f3c");
        $display("Hardware : %h", round_0_key);

        // Document mein Round 1 ki key (w[6], w[12], w[13], w[7])
        // a0fafe17 88542cb1 23a33939 2a6c7605
        $display("\n[Round 1 Key]");
        $display("Expected : a0fafe1788542cb123a339392a6c7605");
        $display("Hardware : %h", round_1_key);

        // Document mein Round 2 ki key (w[8], w[14], w[15], w[9])
        // f2c295f2 7a96b943 5935807a 7359f67f
        $display("\n[Round 2 Key]");
        $display("Expected : f2c295f27a96b9435935807a7359f67f");
        $display("Hardware : %h", round_2_key);

        $display("\n[Round 3 Key]");
        $display("Expected : 3d80477d4716fe3e1e237e446d7a883b");
        $display("Hardware : %h", round_3_key);

        // Document mein Round 10 ki key (w[10], w[16], w[17], w[11])
        // d014f9a8 c9ee2589 e13f0cc8 b6630ca6
        $display("\n[Round 10 Key (Final)]");
        $display("Expected : d014f9a8c9ee2589e13f0cc8b6630ca6");
        $display("Hardware : %h", round_10_key);

        // Final Verification Assertions
        if (round_1_key  === 128'ha0fafe1788542cb123a339392a6c7605 && 
            round_10_key === 128'hd014f9a8c9ee2589e13f0cc8b6630ca6) begin
            $display("\n>> RESULT: PASS! Key Expansion ekdum FIPS 197 compliant hai.");
        end else begin
            $display("\n>> RESULT: FAIL! Mismatch detected.");
        end

        #10 $finish;
    end
endmodule
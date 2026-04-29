module tb_aes_key_expansion;

    reg  [127:0] original_key;
    wire [1407:0] key_schedule;


    aes_key_expansion_128 uut (
        .original_key(original_key),
        .key_schedule(key_schedule)
    );

    wire [127:0] round_0_key  = key_schedule[127:0];       
    wire [127:0] round_1_key  = key_schedule[255:128];     
    wire [127:0] round_2_key  = key_schedule[383:256];     
    wire [127:0] round_3_key = key_schedule[511:384];
    wire [127:0] round_10_key = key_schedule[1407:1280];   

    initial begin
        $display("--- AES Key Expansion Verification (FIPS 197 Appendix A.1) ---");

        original_key = 128'h2b7e151628aed2a6abf7158809cf4f3c; 
        
        #10;
        
        $display("\n[Original Key / Round 0]");
        $display("Expected : 2b7e151628aed2a6abf7158809cf4f3c");
        $display("Hardware : %h", round_0_key);

        $display("\n[Round 1 Key]");
        $display("Expected : a0fafe1788542cb123a339392a6c7605");
        $display("Hardware : %h", round_1_key);

        $display("\n[Round 2 Key]");
        $display("Expected : f2c295f27a96b9435935807a7359f67f");
        $display("Hardware : %h", round_2_key);

        $display("\n[Round 3 Key]");
        $display("Expected : 3d80477d4716fe3e1e237e446d7a883b");
        $display("Hardware : %h", round_3_key);

        $display("\n[Round 10 Key (Final)]");
        $display("Expected : d014f9a8c9ee2589e13f0cc8b6630ca6");
        $display("Hardware : %h", round_10_key);

        // Final Verification Assertions
        if (round_1_key  === 128'ha0fafe1788542cb123a339392a6c7605 && 
            round_10_key === 128'hd014f9a8c9ee2589e13f0cc8b6630ca6) begin
            $display("\n>> RESULT: PASS! ");
        end else begin
            $display("\n>> RESULT: FAIL! Mismatch detected.");
        end

        #10 $finish;
    end
endmodule
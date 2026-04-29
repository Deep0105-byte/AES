module tb_aes_128_core;
    reg          clk;
    reg          rst;
    reg          start;
    reg  [127:0] plaintext;
    reg  [127:0] key;
    wire [127:0] ciphertext;
    wire         done;

    // Final Top Module Instantiate
    aes_128_core uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    always #5 clk = ~clk; 

    initial begin
        $display("--- Final AES-128 Core Verification (FIPS 197 Appendix B) ---");
        
        plaintext = 128'h00112233445566778899aabbccddeeff; 
        key       = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Initial setup
        clk   = 0;
        rst   = 1;
        start = 0;
        
        #20 rst = 0;
        
        #10 start = 1;
        #10 start = 0;
        
        $display("Encryption Started. FSM is running through 10 rounds...");
        
        wait(done == 1'b1);
        
        $display("Encryption Finished!\n");
        $display("Plaintext    : %h", plaintext);
        $display("Key          : %h", key);
        $display("Expected Out : 69c4e0d86a7b0430d8cdb78070b4c55a");
        $display("Hardware Out : %h", ciphertext);
        
        if (ciphertext === 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("\n>> RESULT: MASSIVE PASS! FIPS 197 AES-128 Core successfully verified against Appendix B test vector.");
        else
            $display("\n>> RESULT: FAIL! ");

        #20 $finish;

        $dumpfile("aes.vcd");
        $dumpvars(0, tb_aes_128_core);
    end
endmodule
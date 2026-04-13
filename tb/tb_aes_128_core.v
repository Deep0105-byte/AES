module tb_aes_128_core;
    reg          clk;
    reg          rst;
    reg          start;
    reg  [127:0] plaintext;
    reg  [127:0] key;
    wire [127:0] ciphertext;
    wire         done;

    // Apna Final Top Module Instantiate Karna
    aes_128_core uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk; 

    initial begin
        $display("--- Final AES-128 Core Verification (FIPS 197 Appendix B) ---");
        
        // NIST Appendix C (Extended CSRC Test Vector)
        plaintext = 128'h00112233445566778899aabbccddeeff; 
        key       = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Initial setup
        clk   = 0;
        rst   = 1;
        start = 0;
        
        // 1. Reset lagana aur hatana
        #20 rst = 0;
        
        // 2. Encryption Start karna (FSM ko signal dena)
        #10 start = 1;
        #10 start = 0; // Bas ek clock cycle ke liye start high hoga
        
        $display("Encryption Started. FSM is running through 10 rounds...");
        
        // 3. FSM ke 'done' signal ka intezaar karna
        wait(done == 1'b1);
        
        $display("Encryption Finished!\n");
        $display("Plaintext    : %h", plaintext);
        $display("Key          : %h", key);
        $display("Expected Out : 69c4e0d86a7b0430d8cdb78070b4c55a");
        $display("Hardware Out : %h", ciphertext);
        
        // 4. Final Output Check
        if (ciphertext === 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("\n>> RESULT: MASSIVE PASS! Aapka FIPS 197 AES-128 Core successfully verify ho gaya hai! 🎉🏆");
        else
            $display("\n>> RESULT: FAIL! Kahi integration ya FSM clocking mein galti hui hai.");

        #20 $finish;
    end
endmodule
module tb_aes_128_core;
    reg          clk;
    reg          rst;
    reg          start;
    reg  [127:0] plaintext;
    reg  [127:0] key;
    wire [127:0] ciphertext;
    wire         done;

    // DUT
    aes_128_core uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // ✅ FSDB - SABSE PEHLE, $finish se pehle
    initial begin
        $fsdbDumpfile("inter.fsdb");
        $fsdbDumpvars(0, tb_aes_128_core);
    end

    // Test
    initial begin
        $display("--- AES-128 Core Verification ---");

        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;
        rst       = 1;
        start     = 0;

        #20 rst   = 0;
        #10 start = 1;
        #10 start = 0;

        $display("Encryption Started...");

        wait(done == 1'b1);

        $display("Plaintext    : %h", plaintext);
        $display("Key          : %h", key);
        $display("Expected Out : 69c4e0d86a7b0430d8cdb78070b4c55a");
        $display("Hardware Out : %h", ciphertext);

        if (ciphertext === 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("RESULT: PASS!");
        else
            $display("RESULT: FAIL!");

        #20 $finish;   // ✅ $finish ab SABSE LAST mein hai
    end

endmodule
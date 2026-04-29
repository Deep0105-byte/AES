module tb_aes_addroundkey;
    reg  [127:0] state_in;
    reg  [127:0] round_key;
    wire [127:0] state_out;

    // Apna AddRoundKey module lagana
    aes_addroundkey uut (
        .state_in(state_in),
        .round_key(round_key),
        .state_out(state_out)
    );

    initial begin
        $display("--- AES AddRoundKey Verification (FIPS 197 Appendix B) ---");
        
        // FIPS 197 Appendix B: Initial Input and Key
        state_in  = 128'h3243f6a8885a308d313198a2e0370734; 
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        #10;
        
        $display("Input State  : %h", state_in);
        $display("Round Key    : %h", round_key);
        $display("Expected Out : 193de3bea0f4e22b9ac68d2ae9f84808");
        $display("Hardware Out : %h", state_out);
        
        if (state_out === 128'h193de3bea0f4e22b9ac68d2ae9f84808)
            $display("\n>> RESULT: PASS! ");
        else
            $display("\n>> RESULT: FAIL! .");

        #10 $finish;
    end
endmodule
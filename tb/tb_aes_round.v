module tb_aes_round;
    reg  [127:0] state_in;
    reg  [127:0] round_key;
    reg          is_final_round;
    wire [127:0] state_out;

    aes_round uut (
        .state_in(state_in),
        .round_key(round_key),
        .is_final_round(is_final_round),
        .state_out(state_out)
    );

    initial begin
        $display("--- AES Single Round Integration Verification (FIPS 197 Appendix B) ---");
        
        // FIPS 197 Appendix B: Round 1 Data
        state_in       = 128'h193de3bea0f4e22b9ac68d2ae9f84808; 
        round_key      = 128'ha0fafe1788542cb123a339392a6c7605;
        is_final_round = 1'b0;
        #10;
        
        $display("Input State    : %h", state_in);
        $display("Round 1 Key    : %h", round_key);
        $display("Expected Out   : a49c7ff2689f352b6b5bea43026a5049");
        $display("Hardware Out   : %h", state_out);
        
        if (state_out === 128'ha49c7ff2689f352b6b5bea43026a5049)
            $display("\n>> RESULT: PASS! Aapka integrated AES engine ekdum perfect ghoom raha hai!");
        else
            $display("\n>> RESULT: FAIL! Kahi wiring ya module inter-connection mein dikkat hai.");

        #10 $finish;
    end
endmodule
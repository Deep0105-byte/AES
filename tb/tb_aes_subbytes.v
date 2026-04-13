module tb_aes_subbytes;
    reg  [127:0] state_in;
    wire [127:0] state_out;

    // Apna parallel SubBytes module lagana
    aes_subbytes uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $display("--- AES SubBytes Verification (FIPS 197 Appendix B) ---");
        
        // Appendix B: Round 1 'Start of Round' data (Column-by-Column)
        state_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808; 
        #10;
        
        $display("Input State  : %h", state_in);
        $display("Expected Out : d42711aee0bf98f1b8b45de51e415230");
        $display("Hardware Out : %h", state_out);
        
        // Appendix B: Round 1 'After SubBytes' Expected data check karna
        if (state_out === 128'hd42711aee0bf98f1b8b45de51e415230)
            $display("\n>> RESULT: PASS! SubBytes ki 16 S-Boxes perfect wiring ke sath kaam kar rahi hain.");
        else
            $display("\n>> RESULT: FAIL!");

        #10 $finish;
    end
endmodule
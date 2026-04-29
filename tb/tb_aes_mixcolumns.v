module tb_aes_mixcolumns;
    reg  [127:0] state_in;
    wire [127:0] state_out;

    // Apna parallel MixColumns module lagana
    aes_mixcolumns uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $display("--- AES MixColumns Verification (FIPS 197 Appendix B) ---");
        
        // FIPS 197 Appendix B: Round 1 'After ShiftRows' data (Input)
        state_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5; 
        #10;
        
        $display("Input State  : %h", state_in);
        $display("Expected Out : 046681e5e0cb199a48f8d37a2806264c");
        $display("Hardware Out : %h", state_out);
        
        // FIPS 197 Appendix B: Round 1 'After MixColumns' expected data check
        if (state_out === 128'h046681e5e0cb199a48f8d37a2806264c)
            $display("\n>> RESULT: PASS! MixColumns");
        else                                                            
            $display("\n>> RESULT: FAIL! ");

        #10 $finish;
    end
endmodule
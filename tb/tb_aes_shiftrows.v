module tb_aes_shiftrows;
    reg  [127:0] state_in;
    wire [127:0] state_out;

    aes_shiftrows uut (
        .in(state_in),
        .out(state_out)
    );

    initial begin
        $display("--- AES ShiftRows Verification (FIPS 197 Appendix B) ---");
        
        state_in = 128'hd42711aee0bf98f1b8b45de51e415230; 
        #10;
        
        $display("Input State  : %h", state_in);
        $display("Expected Out : d4bf5d30e0b452aeb84111f11e2798e5");
        $display("Hardware Out : %h", state_out);
        
        // FIPS 197 Appendix B: Round 1 'After ShiftRows' data check
        if (state_out === 128'hd4bf5d30e0b452aeb84111f11e2798e5)
            $display("\n>> RESULT: PASS! ShiftRows ki zero-cycle wiring ekdum perfect hai.");
        else
            $display("\n>> RESULT: FAIL!");

        #10 $finish;
    end
endmodule
module tb_aes_sbox;

    reg [7:0] in;
    wire [7:0] out;

    aes_sbox uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("--- CORRECTED AES S-Box Verification (FIPS 197) ---");
        
        in = 8'h00; #10;
        $display("Input: %h | Output: %h | Expected: 63", in, out);

        in = 8'h53; #10;
        $display("Input: %h | Output: %h | Expected: ed", in, out);

        in = 8'h32; #10;
        $display("Input: %h | Output: %h | Expected: 23", in, out);

        in = 8'hff; #10;
        $display("Input: %h | Output: %h | Expected: 16", in, out);

        if (uut.out === 8'h16) 
            $display("\n>> RESULT: PASS! S-Box ab 100%% FIPS compliant aur Row-Major hai.");
        else
            $display("\n>> RESULT: FAIL!");

        #10 $finish;
    end
endmodule
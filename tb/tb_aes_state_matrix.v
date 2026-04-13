module tb_aes_state_matrix;

    // Inputs
    reg clk;
    reg reset;
    reg [127:0] in_data;

    // Outputs
    wire [7:0] s00, s10, s20, s30;
    wire [7:0] s01, s11, s21, s31;
    wire [7:0] s02, s12, s22, s32;
    wire [7:0] s03, s13, s23, s33;

    // UUT (Unit Under Test) Instantiate karna
    aes_state_matrix uut (
        .clk(clk), .reset(reset), .in_data(in_data),
        .s00(s00), .s10(s10), .s20(s20), .s30(s30),
        .s01(s01), .s11(s11), .s21(s21), .s31(s31),
        .s02(s02), .s12(s12), .s22(s22), .s32(s32),
        .s03(s03), .s13(s13), .s23(s23), .s33(s33)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        in_data = 128'h0;

        // Reset the system
        #10;
        reset = 0;

        // FIPS 197 Appendix B wala Test Vector dena (Hex format)
        in_data = 128'h3243f6a8_885a308d_313198a2_e0370734;

        // Wait for one clock cycle taaki data registers mein chala jaye
        #10;

        // 4x4 Matrix ko Console par Print karana
        $display("--- AES State Matrix (Appendix B Data) ---");
        $display("| Col 0 | Col 1 | Col 2 | Col 3 |");
        $display("---------------------------------");
        $display("|  %h   |  %h   |  %h   |  %h   |  <-- Row 0", s00, s01, s02, s03);
        $display("|  %h   |  %h   |  %h   |  %h   |  <-- Row 1", s10, s11, s21, s13);
        $display("|  %h   |  %h   |  %h   |  %h   |  <-- Row 2", s20, s21, s22, s23);
        $display("|  %h   |  %h   |  %h   |  %h   |  <-- Row 3", s30, s31, s32, s33);
        $display("---------------------------------");

        // Simulation Khatam
        #10 $finish;
    end
endmodule
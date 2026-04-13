module aes_state_matrix (
    input wire clk,
    input wire reset,
    input wire [127:0] in_data,
    
    // 4x4 State Matrix Outputs (Har dabba 8-bit ka)
    // Column 0
    output reg [7:0] s00, s10, s20, s30,
    // Column 1
    output reg [7:0] s01, s11, s21, s31,
    // Column 2
    output reg [7:0] s02, s12, s22, s32,
    // Column 3
    output reg [7:0] s03, s13, s23, s33
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset hone par sab 0 kar do
            s00 <= 8'd0; s10 <= 8'd0; s20 <= 8'd0; s30 <= 8'd0;
            s01 <= 8'd0; s11 <= 8'd0; s21 <= 8'd0; s31 <= 8'd0;
            s02 <= 8'd0; s12 <= 8'd0; s22 <= 8'd0; s32 <= 8'd0;
            s03 <= 8'd0; s13 <= 8'd0; s23 <= 8'd0; s33 <= 8'd0;
        end else begin
            // Document ke hisaab se Column-by-Column data bharna
            // Column 0 (Pehle 4 bytes)
            s00 <= in_data[127:120]; 
            s10 <= in_data[119:112];
            s20 <= in_data[111:104];
            s30 <= in_data[103:96];
            
            // Column 1 (Agle 4 bytes)
            s01 <= in_data[95:88];
            s11 <= in_data[87:80];
            s21 <= in_data[79:72];
            s31 <= in_data[71:64];
            
            // Column 2
            s02 <= in_data[63:56];
            s12 <= in_data[55:48];
            s22 <= in_data[47:40];
            s32 <= in_data[39:32];
            
            // Column 3 (Aakhri 4 bytes)
            s03 <= in_data[31:24];
            s13 <= in_data[23:16];
            s23 <= in_data[15:8];
            s33 <= in_data[7:0];
        end
    end
endmodule
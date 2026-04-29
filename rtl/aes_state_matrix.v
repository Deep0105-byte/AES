module aes_state_matrix (
    input wire clk,
    input wire reset,
    input wire [127:0] in_data,
    
    
    output reg [7:0] s00, s10, s20, s30,
    output reg [7:0] s01, s11, s21, s31,
    output reg [7:0] s02, s12, s22, s32,
    output reg [7:0] s03, s13, s23, s33
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            s00 <= 8'd0; s10 <= 8'd0; s20 <= 8'd0; s30 <= 8'd0;
            s01 <= 8'd0; s11 <= 8'd0; s21 <= 8'd0; s31 <= 8'd0;
            s02 <= 8'd0; s12 <= 8'd0; s22 <= 8'd0; s32 <= 8'd0;
            s03 <= 8'd0; s13 <= 8'd0; s23 <= 8'd0; s33 <= 8'd0;
        end else begin
            
            s00 <= in_data[127:120]; 
            s10 <= in_data[119:112];
            s20 <= in_data[111:104];
            s30 <= in_data[103:96];
            
            s01 <= in_data[95:88];
            s11 <= in_data[87:80];
            s21 <= in_data[79:72];
            s31 <= in_data[71:64];
           
            s02 <= in_data[63:56];
            s12 <= in_data[55:48];
            s22 <= in_data[47:40];
            s32 <= in_data[39:32];
         
            s03 <= in_data[31:24];
            s13 <= in_data[23:16];
            s23 <= in_data[15:8];
            s33 <= in_data[7:0];
        end
    end
endmodule
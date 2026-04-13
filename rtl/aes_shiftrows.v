module aes_shiftrows (
    input  wire [127:0] in,
    output wire [127:0] out
);

    // FIPS 197 Section 5.1.2: ShiftRows() Transformation
    // State array ki 16 bytes ko input se nikal kar nayi positions (wires) par jodhna.
    
    // --- Column 0 (Naya Column 0 kaise banega) ---
    assign out[127:120] = in[127:120]; // Row 0: s0,0 (No shift)
    assign out[119:112] = in[87:80];   // Row 1: s1,1 (Shift 1)
    assign out[111:104] = in[47:40];   // Row 2: s2,2 (Shift 2)
    assign out[103:96]  = in[7:0];     // Row 3: s3,3 (Shift 3)

    // --- Column 1 (Naya Column 1 kaise banega) ---
    assign out[95:88]   = in[95:88];   // Row 0: s0,1 (No shift)
    assign out[87:80]   = in[55:48];   // Row 1: s1,2 (Shift 1)
    assign out[79:72]   = in[15:8];    // Row 2: s2,3 (Shift 2)
    assign out[71:64]   = in[103:96];  // Row 3: s3,0 (Shift 3)

    // --- Column 2 (Naya Column 2 kaise banega) ---
    assign out[63:56]   = in[63:56];   // Row 0: s0,2 (No shift)
    assign out[55:48]   = in[23:16];   // Row 1: s1,3 (Shift 1)
    assign out[47:40]   = in[111:104]; // Row 2: s2,0 (Shift 2)
    assign out[39:32]   = in[71:64];   // Row 3: s3,1 (Shift 3)

    // --- Column 3 (Naya Column 3 kaise banega) ---
    assign out[31:24]   = in[31:24];   // Row 0: s0,3 (No shift)
    assign out[23:16]   = in[119:112]; // Row 1: s1,0 (Shift 1)
    assign out[15:8]    = in[79:72];   // Row 2: s2,1 (Shift 2)
    assign out[7:0]     = in[39:32];   // Row 3: s3,2 (Shift 3)

endmodule
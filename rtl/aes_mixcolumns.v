module aes_mixcolumns (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // FIPS 197 Section 5.1.3: MIXCOLUMNS() operates on the State column-by-column.
    // Hum 128-bit State ko 4 columns (32-bits each) mein divide karke 
    // 4 parallel 'mixcolumn_32bit' modules se process karenge.

    // --- Column 0 (Bits 127 to 96) ---
    mixcolumn_32bit mc0 (
        .in (state_in[127:96]),
        .out(state_out[127:96])
    );

    // --- Column 1 (Bits 95 to 64) ---
    mixcolumn_32bit mc1 (
        .in (state_in[95:64]),
        .out(state_out[95:64])
    );

    // --- Column 2 (Bits 63 to 32) ---
    mixcolumn_32bit mc2 (
        .in (state_in[63:32]),
        .out(state_out[63:32])
    );

    // --- Column 3 (Bits 31 to 0) ---
    mixcolumn_32bit mc3 (
        .in (state_in[31:0]),
        .out(state_out[31:0])
    );
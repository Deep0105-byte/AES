module aes_round (
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final_round, // 1 for Round 10, 0 for Rounds 1-9
    output wire [127:0] state_out
);

    // Internal wires ek block se dusre block mein data le jane ke liye
    wire [127:0] sb_out;      // SubBytes Output
    wire [127:0] sr_out;      // ShiftRows Output
    wire [127:0] mc_out;      // MixColumns Output
    wire [127:0] mc_mux_out;  // MUX Output (MixColumns bypass logic)

    // 1. SubBytes Transformation (FIPS 197 Sec 5.1.1)
    aes_subbytes sub_blk (
        .state_in (state_in),
        .state_out(sb_out)
    );

    // 2. ShiftRows Transformation (FIPS 197 Sec 5.1.2)
   
    aes_shiftrows sr_blk (
        .in (sb_out),   // .state_in ki jagah .in karein
        .out(sr_out)    // .state_out ki jagah .out karein
    );

    // 3. MixColumns Transformation (FIPS 197 Sec 5.1.3)
    aes_mixcolumns mc_blk (
        .state_in (sr_out),
        .state_out(mc_out)
    );

    // --- The Bypass MUX (For Final Round 10) ---
    // FIPS Algorithm 1: Final round omits MIXCOLUMNS()
    assign mc_mux_out = (is_final_round) ? sr_out : mc_out;

    // 4. AddRoundKey Transformation (FIPS 197 Sec 5.1.4)
    aes_addroundkey ark_blk (
        .state_in (mc_mux_out),
        .round_key(round_key),
        .state_out(state_out)
    );

endmodule
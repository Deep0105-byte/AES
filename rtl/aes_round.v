module aes_round (
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final_round, 
    output wire [127:0] state_out
);

    
    wire [127:0] sb_out;      
    wire [127:0] sr_out;      
    wire [127:0] mc_out;      
    wire [127:0] mc_mux_out;  

    aes_subbytes sub_blk (
        .state_in (state_in),
        .state_out(sb_out)
    );

   
    aes_shiftrows sr_blk (
        .in (sb_out),   
        .out(sr_out)    
    );

    aes_mixcolumns mc_blk (
        .state_in (sr_out),
        .state_out(mc_out)
    );

    assign mc_mux_out = (is_final_round) ? sr_out : mc_out;

    aes_addroundkey ark_blk (
        .state_in (mc_mux_out),
        .round_key(round_key),
        .state_out(state_out)
    );

endmodule
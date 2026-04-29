module aes_mixcolumns (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    
    mixcolumn_32bit mc0 (
        .in (state_in[127:96]),
        .out(state_out[127:96])
    );

    mixcolumn_32bit mc1 (
        .in (state_in[95:64]),
        .out(state_out[95:64])
    );

    mixcolumn_32bit mc2 (
        .in (state_in[63:32]),
        .out(state_out[63:32])
    );

    mixcolumn_32bit mc3 (
        .in (state_in[31:0]),
        .out(state_out[31:0])
    );

endmodule
4x1 Multiplexer Implementation


module mux4x1(
    input [3:0] data,
    input [1:0] sel,
    output out
);

wire [1:0] mux0_out;
wire [1:0] mux1_out;

// Level 1: 2x1 Muxes
mux2x1 mux0(
    .data({data[3], data[2]}),
    .sel(sel[0]),
    .out(mux0_out)
);

mux2x1 mux1(
    .data({data[1], data[0]}),
    .sel(sel[0]),
    .out(mux1_out)
);

// Level 2: Final 2x1 Mux
mux2x1 mux_final(
    .data({mux0_out, mux1_out}),
    .sel(sel[1]),
    .out(out)
);

endmodule
//2x1 Multiplexer Module


module mux2x1(
input [1:0] data,
input sel,
output out
);

assign out = (sel) ? data[1] : data[0];

endmodule

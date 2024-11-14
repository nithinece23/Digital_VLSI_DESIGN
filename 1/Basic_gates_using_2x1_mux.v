module gates(
    input A, B,
    output AND_out, OR_out, NOT_out, NAND_out, NOR_out, XOR_out, XNOR_out, BUFFER_out
);

// AND
assign AND_out = (A) ? B : 0;

// OR
assign OR_out = (A') ? 1 : B;

// NOT
assign NOT_out = (1) ? 0 : A;

// NAND
assign NAND_out = (A') ? 1 : B';

// NOR
assign NOR_out = (A') ? 0 : B';

// XOR
assign XOR_out = (A) ? B' : B;

// XNOR
assign XNOR_out = (A) ? B : B';

// Buffer
assign BUFFER_out = (0) ? A : A;

endmodule

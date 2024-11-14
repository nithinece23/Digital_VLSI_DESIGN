module gates_tb;

reg A, B;
wire AND_out, OR_out, NOT_out, NAND_out, NOR_out, XOR_out, XNOR_out, BUFFER_out;

gates uut (
    .A(A),
    .B(B),
    .AND_out(AND_out),
    .OR_out(OR_out),
    .NOT_out(NOT_out),
    .NAND_out(NAND_out),
    .NOR_out(NOR_out),
    .XOR_out(XOR_out),
    .XNOR_out(XNOR_out),
    .BUFFER_out(BUFFER_out)
);

initial begin
    // Test cases
    A = 0; B = 0; #10;
    A = 0; B = 1; #10;
    A = 1; B = 0; #10;
    A = 1; B = 1; #10;
    $finish;
end

initial begin
    $monitor("A=%b, B=%b, AND=%b, OR=%b, NOT=%b, NAND=%b, NOR=%b, XOR=%b, XNOR=%b, BUFFER=%b",
             A, B, AND_out, OR_out, NOT_out, NAND_out, NOR_out, XOR_out, XNOR_out, BUFFER_out);
end

endmodule

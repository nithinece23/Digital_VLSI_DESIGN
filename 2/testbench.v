module testbench;

reg a, b;
wire and_out, or_out, xor_out, not_out, nand_out, nor_out, xnor_out;

// Instantiate gate modules

initial begin
    // Test cases
    a = 0; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;
    $finish;
end

initial begin
    $monitor("a=%b, b=%b, AND=%b, OR=%b, XOR=%b, NOT=%b, NAND=%b, NOR=%b, XNOR=%b",
             a, b, and_out, or_out, xor_out, not_out, nand_out, nor_out, xnor_out);
end

endmodule

module tb_ArithmeticUnit;

// Inputs
reg [3:0] A;
reg [3:0] B;
reg [1:0] OpSel;

// Outputs
wire [3:0] Result;
wire Overflow;

// Instantiate the Arithmetic Unit
ArithmeticUnit uut (
    .A(A),
    .B(B),
    .OpSel(OpSel),
    .Result(Result),
    .Overflow(Overflow)
);

initial begin
    // Test Addition
    A = 4'b0101; B = 4'b0011; OpSel = 2'b00; #10; // 5 + 3 = 8
    A = 4'b1111; B = 4'b0001; OpSel = 2'b00; #10; // 15 + 1 = Overflow

    // Test Subtraction
    A = 4'b1000; B = 4'b0011; OpSel = 2'b01; #10; // 8 - 3 = 5
    A = 4'b0011; B = 4'b0100; OpSel = 2'b01; #10; // 3 - 4 = -1 (Overflow)

    // Test Multiplication
    A = 4'b0010; B = 4'b0011; OpSel = 2'b10; #10; // 2 * 3 = 6
    A = 4'b0100; B = 4'b0100; OpSel = 2'b10; #10; // 4 * 4 = 16 (Overflow)

    // Test Division
    A = 4'b1000; B = 4'b0010; OpSel = 2'b11; #10; // 8 / 2 = 4
    A = 4'b1000; B = 4'b0000; OpSel = 2'b11; #10; // 8 / 0 = Overflow

    $stop; // Stop simulation
end

endmodule

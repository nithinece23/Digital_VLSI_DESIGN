module tb_FloatingPointUnit;

reg [31:0] A, B;
reg [1:0] OpSel;
wire [31:0] Result;

// Instantiate FPU
FloatingPointUnit uut (
    .A(A),
    .B(B),
    .OpSel(OpSel),
    .Result(Result)
);

initial begin
    // Test Addition
    A = 32'h40400000; // 3.0
    B = 32'h40800000; // 4.0
    OpSel = 2'b00;    // Addition
    #10;
    
    // Test Subtraction
    A = 32'h40C00000; // 6.0
    B = 32'h40800000; // 4.0
    OpSel = 2'b01;    // Subtraction
    #10;
    
    // Test Multiplication
    A = 32'h3F800000; // 1.0
    B = 32'h40000000; // 2.0
    OpSel = 2'b10;    // Multiplication
    #10;
    
    // Test Division
    A = 32'h40400000; // 3.0
    B = 32'h40000000; // 2.0
    OpSel = 2'b11;    // Division
    #10;

    $stop;
end

endmodule

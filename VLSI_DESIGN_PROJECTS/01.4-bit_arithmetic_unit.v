module ArithmeticUnit (
    input  [3:0] A,       // 4-bit input A
    input  [3:0] B,       // 4-bit input B
    input  [1:0] OpSel,   // Operation selector
    output reg [3:0] Result, // 4-bit result
    output reg Overflow    // Overflow flag
);

always @(*) begin
    Overflow = 0; // Default overflow is 0
    case (OpSel)
        2'b00: begin // Addition
            {Overflow, Result} = A + B;
        end
        2'b01: begin // Subtraction
            {Overflow, Result} = A - B;
        end
        2'b10: begin // Multiplication
            Result = A * B;
            Overflow = (A * B > 15); // Check for overflow (more than 4 bits)
        end
        2'b11: begin // Division
            if (B != 0) begin
                Result = A / B;
                Overflow = 0; // No overflow for division
            end else begin
                Result = 4'b0000; // Division by zero yields 0
                Overflow = 1;    // Set overflow flag
            end
        end
        default: begin
            Result = 4'b0000;
            Overflow = 0;
        end
    endcase
end

endmodule

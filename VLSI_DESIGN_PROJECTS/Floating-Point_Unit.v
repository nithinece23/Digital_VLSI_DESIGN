module FloatingPointUnit (
    input  [31:0] A,       // 32-bit IEEE 754 floating-point input A
    input  [31:0] B,       // 32-bit IEEE 754 floating-point input B
    input  [1:0] OpSel,    // Operation selector: 00 - Add, 01 - Sub, 10 - Mul, 11 - Div
    output reg [31:0] Result // 32-bit IEEE 754 floating-point result
);

// Internal variables for components
wire sign_a, sign_b, sign_result;
wire [7:0] exp_a, exp_b, exp_result;
wire [23:0] mant_a, mant_b, mant_result;
reg  [23:0] mant_a_norm, mant_b_norm;
reg  [47:0] mant_mult;
wire [23:0] mant_div;
wire [7:0] exp_add_sub;

// Decompose IEEE 754 inputs
assign sign_a = A[31];
assign exp_a = A[30:23];
assign mant_a = {1'b1, A[22:0]}; // Implicit leading 1
assign sign_b = B[31];
assign exp_b = B[30:23];
assign mant_b = {1'b1, B[22:0]}; // Implicit leading 1

// Arithmetic operations
always @(*) begin
    case (OpSel)
        2'b00: begin // Addition
            if (exp_a > exp_b) begin
                mant_b_norm = mant_b >> (exp_a - exp_b);
                exp_result = exp_a;
            end else begin
                mant_a_norm = mant_a >> (exp_b - exp_a);
                exp_result = exp_b;
            end
            {sign_result, mant_result} = {sign_a, mant_a_norm} + {sign_b, mant_b_norm};
        end
        2'b01: begin // Subtraction
            if (exp_a > exp_b) begin
                mant_b_norm = mant_b >> (exp_a - exp_b);
                exp_result = exp_a;
            end else begin
                mant_a_norm = mant_a >> (exp_b - exp_a);
                exp_result = exp_b;
            end
            {sign_result, mant_result} = {sign_a, mant_a_norm} - {sign_b, mant_b_norm};
        end
        2'b10: begin // Multiplication
            mant_mult = mant_a * mant_b;
            exp_result = exp_a + exp_b - 127; // Adjust bias
            sign_result = sign_a ^ sign_b;
            mant_result = mant_mult[47:24]; // Normalize
        end
        2'b11: begin // Division
            mant_result = mant_a / mant_b;
            exp_result = exp_a - exp_b + 127; // Adjust bias
            sign_result = sign_a ^ sign_b;
        end
        default: begin
            exp_result = 8'b0;
            mant_result = 24'b0;
            sign_result = 1'b0;
        end
    endcase

    // Normalize result
    Result = {sign_result, exp_result, mant_result[22:0]};
end

endmodule

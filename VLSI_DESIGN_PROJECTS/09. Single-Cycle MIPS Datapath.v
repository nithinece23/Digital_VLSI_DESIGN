module SingleCycleMIPS(
    input clk, rst,
    output [31:0] pc_out,
    output [31:0] instruction,
    output [31:0] alu_result
);

    // Internal wires and registers
    reg [31:0] pc;
    wire [31:0] next_pc, read_data1, read_data2, sign_extended, write_data, alu_in2, mem_data;
    wire [31:0] instr;
    wire [4:0] write_reg;
    wire [3:0] alu_control;
    wire reg_write, alu_src, mem_to_reg, mem_write, mem_read, branch, jump, zero;

    // Instruction memory (32 words)
    reg [31:0] instruction_memory [0:31];
    initial begin
        // Preload instructions
        $readmemh("instructions.hex", instruction_memory);
    end
    assign instr = instruction_memory[pc[4:0]];

    // Control Unit
    ControlUnit control(
        .opcode(instr[31:26]),
        .funct(instr[5:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    // Register File
    RegisterFile reg_file(
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(instr[25:21]),
        .read_reg2(instr[20:16]),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU
    ALU alu(
        .input1(read_data1),
        .input2(alu_in2),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // Sign Extender
    assign sign_extended = {{16{instr[15]}}, instr[15:0]};

    // Data Memory
    DataMemory data_mem(
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
    );

    // PC Logic
    assign next_pc = pc + 4;
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else
            pc <= next_pc;
    end

    // MUXes
    assign alu_in2 = alu_src ? sign_extended : read_data2;
    assign write_reg = mem_to_reg ? mem_data : alu_result;
    assign pc_out = pc;
    assign instruction = instr;

endmodule
module ControlUnit(
    input [5:0] opcode, funct,
    output reg reg_write, alu_src, mem_to_reg, mem_write, mem_read, branch, jump,
    output reg [3:0] alu_control
);

    always @(*) begin
        // Default control signals
        reg_write = 0; alu_src = 0; mem_to_reg = 0;
        mem_write = 0; mem_read = 0; branch = 0; jump = 0;
        alu_control = 4'b0000;

        case (opcode)
            6'b000000: begin // R-type
                reg_write = 1;
                case (funct)
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    6'b101010: alu_control = 4'b0111; // SLT
                endcase
            end
            6'b100011: begin // LW
                reg_write = 1; alu_src = 1; mem_to_reg = 1; mem_read = 1;
                alu_control = 4'b0010; // ADD
            end
            6'b101011: begin // SW
                alu_src = 1; mem_write = 1;
                alu_control = 4'b0010; // ADD
            end
            6'b000100: begin // BEQ
                branch = 1;
                alu_control = 4'b0110; // SUB
            end
        endcase
    end

endmodule

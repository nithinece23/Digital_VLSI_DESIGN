module tb_SingleCycleMIPS;

    reg clk, rst;
    wire [31:0] pc_out, instruction, alu_result;

    SingleCycleMIPS uut (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .instruction(instruction),
        .alu_result(alu_result)
    );

    initial begin
        clk = 0; rst = 1;
        #10 rst = 0;

        // Run simulation
        #1000;
        $stop;
    end

    always #5 clk = ~clk;

endmodule

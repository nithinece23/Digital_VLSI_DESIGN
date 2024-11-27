module tb_AsyncFIFO;

    parameter WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;

    reg [WIDTH-1:0] wr_data;
    reg wr_en, wr_clk, wr_rst;
    reg rd_en, rd_clk, rd_rst;
    wire [WIDTH-1:0] rd_data;
    wire full, empty;

    // Instantiate FIFO
    AsyncFIFO #(.WIDTH(WIDTH), .DEPTH(DEPTH), .ADDR_WIDTH(ADDR_WIDTH)) uut (
        .wr_data(wr_data),
        .wr_en(wr_en),
        .wr_clk(wr_clk),
        .wr_rst(wr_rst),
        .rd_en(rd_en),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Write clock generation
    always #5 wr_clk = ~wr_clk;

    // Read clock generation
    always #7 rd_clk = ~rd_clk;

    initial begin
        // Initialize inputs
        wr_clk = 0; rd_clk = 0;
        wr_rst = 1; rd_rst = 1;
        wr_en = 0; rd_en = 0;
        wr_data = 0;

        #10;
        wr_rst = 0; rd_rst = 0;

        // Write 5 data elements
        repeat (5) begin
            @(posedge wr_clk);
            wr_data = wr_data + 1;
            wr_en = 1;
        end
        @(posedge wr_clk);
        wr_en = 0;

        // Read 3 data elements
        repeat (3) begin
            @(posedge rd_clk);
            rd_en = 1;
        end
        @(posedge rd_clk);
        rd_en = 0;

        #50; // Wait and observe

        $stop;
    end

endmodule

module AsyncFIFO #(parameter WIDTH = 8, DEPTH = 16, ADDR_WIDTH = 4) (
    input wire [WIDTH-1:0] wr_data,   // Data to write
    input wire wr_en, wr_clk, wr_rst, // Write control signals
    input wire rd_en, rd_clk, rd_rst, // Read control signals
    output reg [WIDTH-1:0] rd_data,   // Data to read
    output reg full, empty            // Status flags
);

    // Internal signals
    reg [WIDTH-1:0] mem [0:DEPTH-1];    // Memory array
    reg [ADDR_WIDTH:0] wr_ptr, rd_ptr; // Full-length pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray; // Gray-coded pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync, rd_ptr_gray_sync; // Synchronized pointers

    // Synchronize write pointer to read clock domain
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            wr_ptr_gray_sync <= 0;
        end else begin
            wr_ptr_gray_sync <= wr_ptr_gray;
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            rd_ptr_gray_sync <= 0;
        end else begin
            rd_ptr_gray_sync <= rd_ptr_gray;
        end
    end

    // Write pointer logic
    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= (wr_ptr + 1) ^ ((wr_ptr + 1) >> 1); // Convert to Gray code
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data; // Write to memory
        end
    end

    // Read pointer logic
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= (rd_ptr + 1) ^ ((rd_ptr + 1) >> 1); // Convert to Gray code
            rd_data <= mem[rd_ptr[ADDR_WIDTH-1:0]]; // Read from memory
        end
    end

    // Full flag logic
    always @(*) begin
        full = (wr_ptr_gray == {~rd_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync[ADDR_WIDTH-2:0]});
    end

    // Empty flag logic
    always @(*) begin
        empty = (wr_ptr_gray_sync == rd_ptr_gray);
    end

endmodule

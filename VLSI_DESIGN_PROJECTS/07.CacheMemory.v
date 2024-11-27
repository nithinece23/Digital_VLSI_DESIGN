module CacheMemory #(
    parameter ADDR_WIDTH = 8, // Address width
    parameter DATA_WIDTH = 32, // Data width
    parameter CACHE_LINES = 16, // Number of cache lines
    parameter WAYS = 4 // Number of ways (set associativity)
)(
    input wire clk, rst,
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire read_write, // 0: Read, 1: Write
    output reg hit,
    output reg [DATA_WIDTH-1:0] read_data
);

    // Derived parameters
    localparam SETS = CACHE_LINES / WAYS; // Number of sets
    localparam INDEX_WIDTH = $clog2(SETS);
    localparam TAG_WIDTH = ADDR_WIDTH - INDEX_WIDTH;

    // Cache storage
    reg [TAG_WIDTH-1:0] tag_array[SETS-1:0][WAYS-1:0];
    reg [DATA_WIDTH-1:0] data_array[SETS-1:0][WAYS-1:0];
    reg valid_array[SETS-1:0][WAYS-1:0];

    // LRU tracker (uses a 2-bit counter per set to track usage)
    reg [WAYS-1:0] lru_array[SETS-1:0];

    // Decompose address
    wire [TAG_WIDTH-1:0] tag = address[ADDR_WIDTH-1:ADDR_WIDTH-TAG_WIDTH];
    wire [INDEX_WIDTH-1:0] index = address[INDEX_WIDTH-1:0];

    // Cache logic
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all arrays
            for (i = 0; i < SETS; i = i + 1) begin
                lru_array[i] <= 0;
                for (int j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] <= 0;
                    tag_array[i][j] <= 0;
                    data_array[i][j] <= 0;
                end
            end
        end else begin
            hit = 0;
            read_data = 0;

            // Search for tag match in the set
            for (i = 0; i < WAYS; i = i + 1) begin
                if (valid_array[index][i] && (tag_array[index][i] == tag)) begin
                    hit = 1;
                    if (!read_write) begin
                        read_data = data_array[index][i]; // Read data
                    end else begin
                        data_array[index][i] = write_data; // Write data
                    end
                    lru_array[index][i] = 1; // Mark as most recently used
                end else begin
                    lru_array[index][i] = 0; // Mark as least used
                end
            end

            // Handle miss
            if (!hit) begin
                // Find the LRU way
                integer lru_way = 0;
                for (i = 0; i < WAYS; i = i + 1) begin
                    if (!valid_array[index][i]) begin
                        lru_way = i; // Use the first invalid way if available
                        break;
                    end else if (lru_array[index][i] == 0) begin
                        lru_way = i; // Use the least recently used way
                    end
                end

                // Replace the LRU line
                tag_array[index][lru_way] <= tag;
                data_array[index][lru_way] <= write_data;
                valid_array[index][lru_way] <= 1;
                lru_array[index][lru_way] <= 1; // Mark as most recently used
            end
        end
    end
endmodule

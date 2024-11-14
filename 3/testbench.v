module mux4x1_tb;

reg [3:0] data;
reg [1:0] sel;
wire out;

mux4x1 uut(
    .data(data),
    .sel(sel),
    .out(out)
);

initial begin
    // Test cases
    data = 4'b1000; sel = 2'b00; #10;
    data = 4'b1000; sel = 2'b01; #10;
    data = 4'b1000; sel = 2'b10; #10;
    data = 4'b1000; sel = 2'b11; #10;
    $finish;
end

initial begin
    $monitor("data=%b, sel=%b, out=%b", data, sel, out);
end

endmodule


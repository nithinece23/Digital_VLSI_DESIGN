//Half_adder
module half_adder(
    input  a,
    input  b,
    output sum,
    output carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

//AND Gate
module and_gate(
    input  a,
    input  b,
    output y
);

assign y = ~(a ^ b) & (a | b);

half_adder ha(.a(a), .b(b), .sum(s), .carry(c));
assign y = c;

endmodule
//OR Gate

module or_gate(
    input  a,
    input  b,
    output y
);

assign y = a | b;

half_adder ha(.a(a), .b(b), .sum(s), .carry(c));
assign y = s | c;

endmodule
//XOR Gate

module xor_gate(
    input  a,
    input  b,
    output y
);

half_adder ha(.a(a), .b(b), .sum(y), .carry());

endmodule


//NOT Gate (Inverter)


module not_gate(
    input  a,
    output y
);

half_adder ha(.a(a), .b(1'b1), .sum(y), .carry());

endmodule


//NAND Gate


module nand_gate(
    input  a,
    input  b,
    output y
);

half_adder ha(.a(a), .b(b), .sum(s), .carry(c));
assign y = ~(c);

endmodule


//NOR Gate


module nor_gate(
    input  a,
    input  b,
    output y
);

half_adder ha(.a(a), .b(b), .sum(s), .carry(c));
assign y = ~(s | c);

endmodule


//XNOR Gate


module xnor_gate(
    input  a,
    input  b,
    output y
);

half_adder ha(.a(a), .b(b), .sum(s), .carry(c));
assign y = ~(s) & (c);

endmodule

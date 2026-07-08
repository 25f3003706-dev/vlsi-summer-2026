module or_gate(
    input wire a,
    input wire b,
    output wire y
);
wire c;
nor_gate u1(.a(a), .b(b), .y(c));
nor_gate u2(.a(c), .b(c), .y(y));
endmodule
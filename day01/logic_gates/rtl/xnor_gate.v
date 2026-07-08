module xnor_gate(
    input wire a,
    input wire b,
    output wire y
);
wire c;
xor_gate u1(.a(a), .b(b), .y(c));
not_gate u2(.a(c), .y(y));
endmodule
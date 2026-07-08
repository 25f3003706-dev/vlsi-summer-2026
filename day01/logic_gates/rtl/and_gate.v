
module and_gate(
    input wire a,
    input wire b,
    output wire y
);
wire c;
nand_gate u1(.a(a), .b(b), .y(c));
nand_gate u2(.a(c), .b(c), .y(y));
endmodule
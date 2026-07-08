module half_adder(
    input a,
    input b,
    output sum,
    output carry
);
    xor_gate u1(.a(a), .b(b), .y(sum));
    and_gate u2(.a(a), .b(b), .y(carry));
endmodule
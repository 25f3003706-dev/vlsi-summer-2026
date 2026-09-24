module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire sum_half, carry_half1, carry_half2;

    // First half adder
    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(sum_half),
        .carry(carry_half1)
    );

    // Second half adder
    half_adder ha2 (
        .a(sum_half),
        .b(cin),
        .sum(sum),
        .carry(carry_half2)
    );

    // Final carry out
    assign cout = carry_half1 | carry_half2;
endmodule


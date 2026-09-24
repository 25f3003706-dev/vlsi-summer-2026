module xor_structural (
    input      a,
    input      b,
    output     y
);
    xor G1 (y, a, b);
endmodule

module xor_behavioral (
    input      a,
    input      b,
    output reg y
);
    always @(*) begin
        y = a ^ b;
    end
endmodule

module xor_dataflow (
    input      a,
    input      b,
    output     y
);
    assign y = a ^ b;
endmodule

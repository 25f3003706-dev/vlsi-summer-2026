module nor_structural (
    input      a,
    input      b,
    output     y
);
    nor G1 (y, a, b);
endmodule

module nor_behavioral (
    input      a,
    input      b,
    output reg y
);
    always @(*) begin
        y = ~(a | b);
    end
endmodule
module nor_dataflow (
    input      a,
    input      b,
    output     y
);
    assign y = ~(a | b);
endmodule
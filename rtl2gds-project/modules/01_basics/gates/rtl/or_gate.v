module or_behavioral(
    input a,
    input b,
    output reg y
);
    always @(*) begin
        y = a | b;
    end
endmodule

module or_dataflow(
    input a,
    input b,
    output wire y
);
    assign y = a | b;
endmodule

module or_structural(
    input  a,
    input  b,
    output wire y
);
    or G1 (y, a, b);
endmodule
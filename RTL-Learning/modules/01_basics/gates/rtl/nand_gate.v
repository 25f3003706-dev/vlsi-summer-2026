module nand_behavioral(
    input a,
    input b,
    output reg y
);
    always @(*) begin
        y = ~(a & b);
    end
endmodule

module nand_dataflow(
    input a,
    input b,
    output wire y
);
    assign y = ~(a & b);
endmodule

module nand_structural(
    input  a,
    input  b,
    output wire y
);
    nand G1 (y, a, b);
endmodule

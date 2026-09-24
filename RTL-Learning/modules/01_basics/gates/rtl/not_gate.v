module not_behavioral(
    input a,
    output reg y
);
    always @(*) begin
        y = ~a;
    end
endmodule

module not_dataflow(
    input a,
    output wire y
);
    assign y = ~a;
endmodule

module not_structural(
    input  a,
    output wire y
);
    not G1 (y, a);
endmodule
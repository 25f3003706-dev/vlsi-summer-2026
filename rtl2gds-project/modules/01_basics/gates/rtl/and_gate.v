`timescale 1ns/1ps

module and_gate_behavioral(
    input a,
    input b,
    output reg y
);

always @(*) begin
    y = a & b;
end

endmodule

module and_gate_dataflow(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module and_gate_structural(
    input  a,
    input  b,
    output wire y
);
    and G1 (y, a, b);
endmodule
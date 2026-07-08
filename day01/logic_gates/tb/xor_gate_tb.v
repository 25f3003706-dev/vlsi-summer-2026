`timescale 1ns/1ps

module xor_gate_tb;

reg a;
reg b;
wire y;

xor_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    $display("XOR Gate Truth Table");
    $display("---------------------");
    $display(" A B | Y");

    a = 0; b = 0;
    #10;
    $display(" %b %b | %b", a, b, y);

    a = 0; b = 1;
    #10;
    $display(" %b %b | %b", a, b, y);

    a = 1; b = 0;
    #10;
    $display(" %b %b | %b", a, b, y);

    a = 1; b = 1;
    #10;
    $display(" %b %b | %b", a, b, y);
    $dumpfile("waveforms/xor_gate.vcd");
    $dumpvars(0, xor_gate_tb);
    $finish;

end

endmodule
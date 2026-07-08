`timescale 1ns/1ps

module and_gate_tb;

reg a;
reg b;

wire y;

and_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    $display("Starting AND Gate Simulation");
    $display("------------------------------");
    $display(" A B | Y");
    $display("--------");

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
    $dumpfile("waveforms/and_gate.vcd");
    $dumpvars(0, and_gate_tb);
    $finish;

end

endmodule
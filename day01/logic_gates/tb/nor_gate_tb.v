`timescale 1ns/1ps

module nor_gate_tb;

reg a;
reg b;
wire y;

nor_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    $display("NOR Gate Truth Table");
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
    $dumpfile("waveforms/nor_gate.vcd");
    $dumpvars(0, nor_gate_tb);
    $finish;

end

endmodule
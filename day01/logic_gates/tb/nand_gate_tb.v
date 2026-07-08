`timescale 1ns/1ps

module nand_gate_tb;

reg a;
reg b;
wire y;

nand_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    $display("NAND Gate Truth Table");
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
    
    $dumpfile("waveforms/nand_gate.vcd");
    $dumpvars(0, nand_gate_tb);
    $finish;

end

endmodule
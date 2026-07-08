`timescale 1ns/1ps

module not_gate_tb;

reg a;
wire y;

not_gate dut (
    .a(a),
    .y(y)
);

initial begin

    $display("Starting NOT Gate Simulation");
    $display("------------------------------");
    $display(" A | Y");
    $display("--------");

    a = 0; 
    #10;
    $display(" %b | %b", a, y);

    a = 1; 
    #10;
    $display(" %b | %b", a, y);
    $dumpfile("waveforms/not_gate.vcd");
    $dumpvars(0, not_gate_tb);
    $finish;

end

endmodule
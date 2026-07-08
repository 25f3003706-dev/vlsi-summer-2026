`timescale 1ns/1ps

module half_adder_tb;

// Inputs
reg A;
reg B;

// Outputs
wire SUM;
wire CARRY;

// DUT
half_adder dut(
    .a(A),
    .b(B),
    .sum(SUM),
    .carry(CARRY)
);

initial begin

    $dumpfile("waveforms/half_adder.vcd");
    $dumpvars(0, half_adder_tb);

    A=0; B=0; #10;

    A=0; B=1; #10;

    A=1; B=0; #10;

    A=1; B=1; #10;

    $finish;

end

endmodule
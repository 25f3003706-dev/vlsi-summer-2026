// MODULE_NAME_tb.sv
// SystemVerilog Testbench for MODULE_NAME

`timescale 1ns/1ps

module MODULE_NAME_tb;

    logic clk;
    logic rst_n;
    logic dummy_out;

    // Instantiate DUT
    MODULE_NAME uut (
        .clk       (clk),
        .rst_n     (rst_n),
        .dummy_out (dummy_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("MODULE_NAME.vcd");
        $dumpvars(0, MODULE_NAME_tb);
    end

    // Stimulus
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;

        #100;
        $display("Simulation finished.");
        $finish;
    end

endmodule


//=====================================================
// Design Under Test (DUT)
//=====================================================
module MODULE_NAME (
    input  logic clk,
    input  logic rst_n,
    output logic dummy_out
);

    assign dummy_out = rst_n;

endmodule
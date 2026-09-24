`timescale 1ns / 1ps
`include "RTL-Learning/modules/05_memory/rtl/DFF.V"
module tb_DFF;
    reg clk;
    reg rst_n;
    reg d;
    wire q;
    wire q_bar;

    // Instantiate Design Under Test (DUT)
    DFF uut (
        .clk(clk),
        .rst_n(rst_n),
        .D(d),
        .Q(q),
        .Q_bar(q_bar)
    );

    // Generate 100MHz clock signal (Period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        d = 0;

        // Apply reset configuration
        #15 rst_n = 1; 
        
        // Stimulus patterns
        #10 d = 1;
        #10 d = 0;
        #14 d = 1; // Test behavior unaligned to clock edges
        #6  d = 0;
        #10 d = 1;
        
        #20 $finish;
    end

    initial begin
        $monitor("Time=%0dns | Reset=%b | D=%b | Q=%b | Q_bar=%b", $time, rst_n, d, q, q_bar);
    end
    initial begin
        $dumpfile("E:/ESHWAR NEW VOLUME (E)/DOWNLOADS/PROJECT/vlsi/rtl_project/vlsi-summer-2026/RTL-Learning/waves/DFF_tb.vcd");
        $dumpvars(0, tb_DFF);
    end
endmodule

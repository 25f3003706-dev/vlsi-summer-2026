`timescale 1ns/1ps

module mux4x1_tb;

    reg A;
    reg B;
    reg C;
    reg D;
    reg sel0;
    reg sel1;
    wire Y;


    // Instantiate DUT
    mux_4x1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel0(sel0),
        .sel1(sel1),
        .Y(Y)
    );

    initial begin

        // Generate waveform
        $dumpfile("sim/mux4x1.vcd");
        $dumpvars(0, mux4x1_tb);

        $display("-------------------------------------------");
        $display(" Time | S1 S0 | I0 I1 I2 I3 | Y");
        $display("-------------------------------------------");

        $monitor("%4t |  %b  %b |  %b  %b  %b  %b | %b",
                 $time, sel1, sel0, A, B, C, D, Y);

        // Test Case 1
        A = 0; B = 0; C = 0; D = 0;
        sel1 = 0; sel0 = 0;
        #10;

        // Test Case 2
        A = 1; B = 0; C = 0; D = 0;
        sel1 = 0; sel0 = 0;
        #10;

        // Test Case 3
        A = 0; B = 1; C = 0; D = 0;
        sel1 = 0; sel0 = 1;
        #10;

        // Test Case 4
        A = 0; B = 0; C = 1; D = 0;
        sel1 = 1; sel0 = 0;
        #10;

        // Test Case 5
        A = 0; B = 0; C = 0; D = 1;
        sel1 = 1; sel0 = 1;
        #10;

        // Test Case 6
        A = 1; B = 0; C = 1; D = 0;
        sel1 = 0; sel0 = 0;
        #10;

        // Test Case 7
        sel1 = 0; sel0 = 1;
        #10;

        // Test Case 8
        sel1 = 1; sel0 = 0;
        #10;

        // Test Case 9
        sel1 = 1; sel0 = 1;
        #10;

        $finish;

    end

endmodule
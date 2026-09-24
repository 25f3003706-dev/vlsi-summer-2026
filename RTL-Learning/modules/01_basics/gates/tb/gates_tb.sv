`timescale 1ns / 1ps

module tb_all_gates_together;
    // Common inputs
    reg a, b;
    
    // Gate outputs (Each will get its own row in the waveform)
    wire out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_not;

    // Gate Implementations
    assign out_and  = a & b;
    assign out_or   = a | b;
    assign out_xor  = a ^ b;
    assign out_nand = ~(a & b);
    assign out_nor  = ~(a | b);
    assign out_xnor = ~(a ^ b);
    assign out_not  = ~a;
    

    initial begin
        // Open a single waveform file
        $dumpfile("all_gates.vcd");
        
        // Dump all variables inside this module
        $dumpvars(0, tb_all_gates_together);

        // Run the truth table once. All outputs update in parallel!
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end
endmodule

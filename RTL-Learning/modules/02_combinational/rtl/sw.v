module sw_behavioral_structural(
    input  [7:0] a, b,
    input        c, // Input carry-in
    output [7:0] sum,
    output       carry
);

    // Internal carry network array
    // c_net[0] is the initial carry-in, c_net[8] is the final carry-out
    wire [8:0] c_net;
    
    // Assign input and output boundaries of the carry network
    assign c_net[0] = c;
    assign carry    = c_net[8];

    // Genvar variable used explicitly for behavioral hardware generation
    genvar i;

    // Behavioral generate block to automatically replicate the full adders
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_block
            fulladd fa (
                .sum  (sum[i]),
                .carry(c_net[i+1]),
                .a    (a[i]),
                .b    (b[i]),
                .c    (c_net[i])
            );
        end
    </generate>

endmodule

// Sub-Program (Full Adder Module)
module fulladd (
    output sum,carry, 
    input  a,b,c
);
    wire w1, w2, w3;

    // Gate-level or dataflow implementation inside the sub-module
    xor (sum, a, b, c);
    and (w1, a, b);
    and (w2, b, c);
    and (w3, c, a);
    or  (carry, w1, w2, w3);

endmodule

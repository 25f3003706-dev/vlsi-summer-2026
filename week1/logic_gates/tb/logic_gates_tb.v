`timescale 1ns/1ps

module logic_gates_tb;

reg a;
reg b;

wire and_y;
wire or_y;
wire xor_y;
wire not_y;

and_gate U1 (
    .a(a),
    .b(b),
    .y(and_y)
);

or_gate U2 (
    .a(a),
    .b(b),
    .y(or_y)
);

xor_gate U3 (
    .a(a),
    .b(b),
    .y(xor_y)
);

not_gate U4 (
    .a(a),
    .y(not_y)
);

initial begin

    $display("A B | AND OR XOR NOT");
    $display("-------------------");

    a = 0; b = 0; #10;
    $display("%b %b |  %b   %b   %b   %b",
             a,b,and_y,or_y,xor_y,not_y);

    a = 0; b = 1; #10;
    $display("%b %b |  %b   %b   %b   %b",
             a,b,and_y,or_y,xor_y,not_y);

    a = 1; b = 0; #10;
    $display("%b %b |  %b   %b   %b   %b",
             a,b,and_y,or_y,xor_y,not_y);

    a = 1; b = 1; #10;
    $display("%b %b |  %b   %b   %b   %b",
             a,b,and_y,or_y,xor_y,not_y);

    $finish;

end

endmodule
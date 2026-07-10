`timescale 1ns/1ps

module mux2x1_tb;
reg A;
reg B;
reg sel;
wire Y;

mux_2x1 dut(
    .A(A),
    .B(B),
    .sel(sel),
    .Y(Y)
);
initial begin
    $dumpfile("mux2x1.vcd");
    $dumpvars(0, mux2x1_tb);
    $display("2x1 MUX Truth table");
    $display("--------------------");
    $display("SEL A B | Y");
    $display("--------------------");
    sel=0; A=0; B=0; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=0; A=0; B=1; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=0; A=1; B=0; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=0; A=1; B=1; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=1; A=0; B=0; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=1; A=0; B=1; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=1; A=1; B=0; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    sel=1; A=1; B=1; #10;
    $display("%b   %b %b | %b", sel, A, B, Y);
    $finish;
end

endmodule
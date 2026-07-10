`timescale 1ns/1ps

module
    mux_2x1 (
        input wire A,
        input wire B,
        input wire sel,
        output wire Y
    );
    assign Y = sel ? B : A;
endmodule
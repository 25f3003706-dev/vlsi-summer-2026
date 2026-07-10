module mux_4x1(
        input wire A,
        input wire B,
        input wire C,
        input wire D,
        input wire sel0,
        input wire sel1,
        output wire Y
    );
    wire E;
    wire F;
    mux_2x1 u1(.A(A), .B(B), .sel(sel0), .Y(E));
    mux_2x1 u2(.A(C), .B(D), .sel(sel0), .Y(F));
    mux_2x1 u3(.A(E), .B(F), .sel(sel1), .Y(Y));
endmodule
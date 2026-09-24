module MUl_4x4 (
     input  [3:0] A, // 4-bit Multiplicand
    input  [3:0] B, // 4-bit Multiplier
    output [7:0] P  // 8-bit Product
);
    wire [3:0] p0=A & {4{B[0]}};
    wire [3:0] p1=A & {4{B[1]}};
    wire [3:0] p2=A & {4{B[2]}};
    wire [3:0] p3=A & {4{B[3]}};

    wire [2:0] s1,c1;
    wire [2:0] s2,c2;
    wire [2:0] s3,c3;

    assign P[0] = p0[0];
    // First stage of addition
    half_adder HA1 (.A(p0[1]), .B(p1[0]), .S(s1[0]), .C(c1[0]));
    full_adder FA1 (.A(p0[2]), .B(p1[1]), .Cin(c1[0]), .S(s1[1]), .C(c1[1]));
    full_adder FA2 (.A(p0[3]), .B(p1[2]), .Cin(c1[1]), .S(s1[2]), .C(c1[2]));
    // Second stage of addition
    assign P[1] = s1[0];
    full_adder FA (.A(s1[1]), .B(p2[0]), .Cin(c1[2]), .S(s2[0]), .C(c2[0]));
endmodule
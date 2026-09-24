`timescale 1ns / 1ps

module tb_multiplier_4bit_structural;

    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] product;

    // Instantiate Structural Array Multiplier
    multiplier_4bit_structural uut (
        .a(a),
        .b(b),
        .product(product)
    );

    initial begin
        $display("--------------------------------------------");
        $display("Simulating Structural HA/FA 4-Bit Multiplier");
        $display("--------------------------------------------");
        $monitor("Time: %0dns | A = %d (%4b) | B = %d (%4b) -> Product = %d", 
                 $time, a, a, b, b, product);

        // Test Vectors
        a = 4'd2;  b = 4'd3;  #10;  // 2 x 3 = 6
        a = 4'd4;  b = 4'd4;  #10;  // 4 x 4 = 16
        a = 4'd7;  b = 4'd5;  #10;  // 7 x 5 = 35
        a = 4'd12; b = 4'd8;  #10;  // 12 x 8 = 96
        a = 4'd15; b = 4'd15; #10;  // Max limit boundary: 15 x 15 = 225

        $display("--------------------------------------------");
        $finish;
    end
endmodule

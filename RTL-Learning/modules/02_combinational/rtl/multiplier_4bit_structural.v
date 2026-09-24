module multiplier_4bit_structural (
    input  [3:0] a,        // Multiplicand
    input  [3:0] b,        // Multiplier
    output [7:0] product   // 8-bit Product Result
);

    // 1. Generate all 16 Partial Products using AND gates
    wire p[3:0][3:0];
    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_p_row
            for (j = 0; j < 4; j = j + 1) begin : gen_p_col
                assign p[i][j] = a[i] & b[j];
            end
        end
    </generate>

    // 2. Interconnecting wires for carrying out intermediate Sums (S) and Carries (C)
    // Naming notation: s_row_col or c_row_col
    wire s_1_1, s_1_2, s_1_3;
    wire c_1_0, c_1_1, c_1_2, c_1_3;

    wire s_2_1, s_2_2, s_2_3;
    wire c_2_0, c_2_1, c_2_2, c_2_3;

    wire s_3_1, s_3_2, s_3_3;
    wire c_3_0, c_3_1, c_3_2, c_3_3;

    // --- ROW 1 ---
    assign product[0] = p[0][0]; // First bit maps directly to output

    halfadd ha_1_0 (s_1_1, c_1_0, p[1][0], p[0][1]);
    fulladd fa_1_1 (s_1_2, c_1_1, p[1][1], p[0][2], c_1_0);
    fulladd fa_1_2 (s_1_3, c_1_2, p[1][2], p[0][3], c_1_1);
    assign c_1_3 = p[1][3] & c_1_2; // Handled carry accumulation for upper border

    // --- ROW 2 ---
    assign product[1] = s_1_1;

    halfadd ha_2_0 (s_2_1, c_2_0, p[2][0], s_1_2);
    fulladd fa_2_1 (s_2_2, c_2_1, p[2][1], s_1_3, c_2_0);
    fulladd fa_2_2 (s_2_3, c_2_2, p[2][2], c_1_3, c_2_1);
    fulladd fa_2_3 (s_2_3_ext, c_2_3, p[2][3], 1'b0, c_2_2); // Dummy zero for placeholder alignment

    // --- ROW 3 ---
    assign product[2] = s_2_1;

    halfadd ha_3_0 (s_3_1, c_3_0, p[3][0], s_2_2);
    fulladd fa_3_1 (s_3_2, c_3_1, p[3][1], s_2_3, c_3_0);
    fulladd fa_3_2 (s_3_3, c_3_2, p[3][2], s_2_3_ext, c_3_1);
    fulladd fa_3_3 (product[7], c_3_3, p[3][3], c_2_3, c_3_2);

    // Final direct product mappings out of the last addition layer
    assign product[3] = s_3_1;
    assign product[4] = s_3_2;
    assign product[5] = s_3_3;
    assign product[6] = c_3_3; 

endmodule

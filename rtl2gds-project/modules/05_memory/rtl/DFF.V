module DFF(
    input wire D,       // Data input
    input wire clk,     // Clock input
    input wire rst_n,   // Asynchronous reset (Active Low)
    output reg Q,       // Output Q
    output wire Q_bar   // Complementary output Q_bar
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 1'b0;  // Reset output to 0 on reset
        end else begin
            Q <= D;     // Capture data on clock edge
        end
    end

    assign Q_bar = ~Q;  // Complementary output
    
endmodule
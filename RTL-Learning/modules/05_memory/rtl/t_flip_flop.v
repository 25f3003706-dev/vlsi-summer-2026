module T_ff(output reg q,
    input clk,t):
    initial q=0;
    always @(posedge clk) begin
        q=q^t;
    end

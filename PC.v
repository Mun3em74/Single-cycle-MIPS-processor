module PC #(parameter PC_Size = 32) (
    output reg [PC_Size-1:0] PC,
    input wire [PC_Size-1:0] PC_reg,
    input wire clk,rst
);
    
always @(posedge clk, negedge rst) begin
    if (!rst) begin
         PC <= 32'b0;
    end
    else PC <= PC_reg;
end
endmodule
module SignExtend (
    output reg  [31:0] SignImm,
    input  wire [15:0] Instr
);
    always @(*) begin
        if (Instr[15]) begin
            SignImm = { { 16 {1'b1} } ,Instr };
        end
        else SignImm = { { 16 {1'b0} } ,Instr }; 
    end
endmodule
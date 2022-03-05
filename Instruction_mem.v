module Instruction_mem #( parameter mem_width = 32, parameter mem_depth = 100 ) (
    output reg [mem_width-1:0] Instr,
    input  wire [31:0] PC
);
    reg [mem_width-1 : 0] mem [0 : mem_depth-1];
    
    initial begin
        $readmemh("instruction_mem.txt",mem);
    end

    always @(*) begin
        //divide by 4 and get the floor
        Instr = mem [PC>>2];
    end
endmodule
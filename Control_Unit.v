module Control_Unit (
    output reg  MemWrite,
    output reg  RegWrite,
    output reg  RegDst,
    output reg  ALUSrc,
    output reg  MemtoReg,
    output reg  PCSrc,
    output reg  Jump,
    output reg  [2:0] ALU_Control,
    input  wire [5:0] Opcode,
    input  wire [5:0] Funct,
    input  wire       zero_flag
);
    reg [1:0] ALUOp;
    reg Branch;

    always @(*) begin
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUSrc   = 1'b0;
        RegDst   = 1'b0;
        RegWrite = 1'b0;
        Jump     = 1'b0;
        ALUOp    = 2'b00;
        case (Opcode)
        6'b10_0011 : begin
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
        end 
        6'b10_1011 : begin
            MemWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemtoReg = 1'b1;
        end
         6'b00_0000 : begin
            RegWrite = 1'b1;
            RegDst   = 1'b1;
            ALUOp    = 2'b10;

        end
        6'b00_1000 : begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
        end
         6'b00_0100 : begin
            Branch   = 1'b1;
            ALUOp    = 2'b01;
        end
        6'b00_0010 : begin
            Jump = 1'b1;
        end
        default   : begin
            MemtoReg = 1'b0;
            MemWrite = 1'b0;
            Branch   = 1'b0;
            ALUSrc   = 1'b0;
            RegDst   = 1'b0;
            RegWrite = 1'b0;
            ALUOp    = 2'b00;
        end
    endcase
    end

    always @(*) begin
        case (ALUOp)
        2'b00 : ALU_Control = 3'b010;
        2'b01 : ALU_Control = 3'b100;
        2'b10 : begin
            case (Funct)
                6'b10_0000 : ALU_Control = 3'b010;
                6'b10_0010 : ALU_Control = 3'b100;
                6'b10_1010 : ALU_Control = 3'b110;
                6'b01_1100 : ALU_Control = 3'b101; 
                default :    ALU_Control = 3'b010;
            endcase
        end
        default: ALU_Control = 3'b010; 
    endcase
    end

    always @(*) begin
        PCSrc = Branch & zero_flag;
    end

endmodule
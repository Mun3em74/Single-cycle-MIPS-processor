module ALU #(parameter ALU_Size = 32 ) (
    output reg  [ALU_Size-1:0]      ALU_Result,
    output reg                      Zero_flag,
    input  wire [ALU_Size-1:0]      SrcA,SrcB,
    input  wire [2:0]               ALU_Cont
);
    always @(*) begin
        case (ALU_Cont)
        3'b000 : begin
            ALU_Result = SrcA & SrcB ; 
        end
        3'b001 : begin
            ALU_Result = SrcA | SrcB ;
        end 
        3'b010 : begin
            ALU_Result = SrcA + SrcB ; 
        end
        3'b011 : begin
            ALU_Result = 32'b0 ;
        end 
        3'b100 : begin
            ALU_Result = (SrcA - SrcB);
        end 
        3'b101 : begin
            ALU_Result = (SrcA * SrcB);
        end
        3'b110 : begin
            if (SrcA < SrcB) begin
                ALU_Result  = 32'b1;
            end 
            else ALU_Result = 32'b0;

        end
        4'b111 : begin
            ALU_Result = 32'b0;
        end 

            default: begin
                ALU_Result = 32'd0;
            end
        endcase
    end
    always @(*) begin
        Zero_flag = (ALU_Result == 32'b0);
    end
endmodule
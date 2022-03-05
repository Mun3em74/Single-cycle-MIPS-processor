module MIPS (
    output [15:0] test_value_final,
    input clock,
    input reset
);
    wire [31:0] WriteData;
    wire [31:0] A_Data;
    wire [31:0] PC_IM;
    wire        ZF;
    wire [31:0] Instruction;
    wire        RegWrite_WE3;
    wire        RegDst_selc;
    wire [2:0]  ALU__Control;
    wire        Jump_x;
    wire        PCSrc_x;
    wire        MemWrite_DM;
    wire [31:0] RD_mux;
    wire        MemtoReg_x;
    wire        ALUSrc_sel_x;

    Datapath DP (
        .CLK(clock),
        .RST(reset),
        .WD_(WriteData),
        .ALU_Result_(A_Data),
        .PC_(PC_IM),
        .Zero_flag_(ZF),
        .Instr_(Instruction),
        .WE3_(RegWrite_WE3),
        .RegDst_sel(RegDst_selc),
        .ALUControl(ALU__Control),
        .Jump_mux(Jump_x),
        .PCSrc_mux(PCSrc_x),
        .ReadData(RD_mux),
        .MemtoReg_mux(MemtoReg_x),
        .ALUSrc_sel(ALUSrc_sel_x)
    );

    Instruction_mem IM (
        .Instr(Instruction),
        .PC(PC_IM)
    );

    Data_mem DM (
        .RD(RD_mux),
        .test_value(test_value_final),
        .WD(WriteData),
        .A(A_Data),
        .WE(MemWrite_DM),
        .clk(clock),
        .rst(reset)
    );

    Control_Unit CU (
        .MemWrite(MemWrite_DM),
        .RegWrite(RegWrite_WE3),
        .RegDst(RegDst_selc),
        .ALUSrc(ALUSrc_sel_x),
        .MemtoReg(MemtoReg_x),
        .PCSrc(PCSrc_x),
        .Jump(Jump_x),
        .ALU_Control(ALU__Control),
        .Opcode(Instruction[31:26]),
        .Funct(Instruction[5:0]),
        .zero_flag(ZF)
    );


endmodule
module Datapath  #(parameter MIPS_Size = 32) (
    //#(parameter MIPS_Size,.data_width(MIPS_Size),.ALU_Size(MIPS_Size),.PC_Size(MIPS_Size),.mem_width(MIPS_Size),.data_width(MIPS_Size))
    output [MIPS_Size-1:0] WD_,
    output [MIPS_Size-1:0] ALU_Result_,
    output [MIPS_Size-1:0] PC_,
    output                 Zero_flag_,
    input  [MIPS_Size-1:0] Instr_,
    //input  [MIPS_Size-1:0] Result_,
    input                  WE3_,
    input                  CLK,
    input                  RST,
    input                  RegDst_sel,
    input        [2:0]     ALUControl,
    input                  Jump_mux,
    input                  PCSrc_mux,
    input                  MemtoReg_mux,
    input        [31:0]    ReadData,
    input                  ALUSrc_sel
    );
    wire [4:0] A3_mux         ;
    wire [MIPS_Size-1:0] WD3_Result     ;
    wire [MIPS_Size-1:0] RD1_SrcA       ;
    wire [MIPS_Size-1:0] SrcB_mux       ;
    wire [MIPS_Size-1:0] SignImm_mux    ;
    wire [MIPS_Size-1:0] Shift_PCBranch ;
    wire [MIPS_Size-1:0] Shift_mux      ;
    wire [MIPS_Size-1:0] mux_mux        ;
    wire [MIPS_Size-1:0] adder_mux      ;
    wire [MIPS_Size-1:0] PCBranch_mux   ;
    wire [MIPS_Size-1:0] PC_mux         ;

    Register_File RF (
        .clk    (CLK),
        .rst    (RST),
        .A1     (Instr_ [25:21]),
        .A2     (Instr_ [20:16]),
        .A3     (A3_mux),
        .WD3    (WD3_Result),
        .WE3    (WE3_),
        .RD1    (RD1_SrcA),
        .RD2    (WD_)
    );

    MUX #(.MUX_size(5)) muxA3 (
        .out_mux    (A3_mux),
        .in1_mux    (Instr_ [15:11]),
        .in0_mux    (Instr_ [20:16]),
        .sel        (RegDst_sel)
    );

    MUX muxRD2 (
        .out_mux    (SrcB_mux),
        .in1_mux    (SignImm_mux),
        .in0_mux    (WD_),
        .sel        (ALUSrc_sel)
    );

    MUX mux_PC (
        .out_mux    (PC_mux),
        .in1_mux    ({adder_mux[31:28],Shift_mux[27:0]}),
        .in0_mux    (mux_mux),
        .sel        (Jump_mux)
    );

    MUX mux__mux (
        .out_mux    (mux_mux),
        .in1_mux    (PCBranch_mux),
        .in0_mux    (adder_mux),
        .sel        (PCSrc_mux)
    );

    MUX mux_Result (
        .out_mux    (WD3_Result),
        .in1_mux    (ReadData),
        .in0_mux    (ALU_Result_),
        .sel        (MemtoReg_mux)
    );

    ALU ALU1 (
        .SrcA       (RD1_SrcA),
        .SrcB       (SrcB_mux),
        .Zero_flag  (Zero_flag_),
        .ALU_Cont   (ALUControl),
        .ALU_Result (ALU_Result_)
    );

    SignExtend SE (
        .Instr      (Instr_[15:0]),
        .SignImm    (SignImm_mux)
    );

    Shift_left_twice SLT_SignImm (
        .in_shift   (SignImm_mux),
        .out_shift  (Shift_PCBranch)
    );

    Shift_left_twice SLT_mux (
        .in_shift   ({6'd0,Instr_   [25:0]}),
        .out_shift  (Shift_mux)
    );

    Adder Adder_PCBranch (
        .C          (PCBranch_mux),
        .A          (Shift_PCBranch),
        .B          (adder_mux)
    );

    Adder Adder_PCPlus4 (
        .C          (adder_mux),
        .A          (PC_),
        .B          (32'd4)
    );


    PC PC1 (
        .clk    (CLK),
        .rst    (RST),
        .PC     (PC_),
        .PC_reg (PC_mux)
    );
endmodule
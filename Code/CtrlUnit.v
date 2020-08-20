`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 11:03:59
// Design Name: 
// Module Name: CtrlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.vh"

module CtrlUnit(
        input wire clk,
        input wire rst,
        input wire aluN,
        input wire aluZ,
        input wire divBusy,
        input wire [31:0] instr,
        input wire [31:0] cp0Status,
        output reg rPcIn,
        output reg rPcOut,
        output reg rMemR,
        output reg rMemW,
        output reg rIrIn,
        output reg rRfRsE,
        output reg rRfRtE,
        output reg rRfRdE,
        output reg [`ALU_CWIDTH-1:0] rAluC,
        output reg rZIn,
        output reg rZOut,
        output reg rExtS,
        output reg [`EXT_MEM_CWIDTH-1:0] rExtMemType,
        output reg rDivStart,
        output reg rDivS,
        output reg rMulS,
        output reg rCp0Mfc0,
        output reg rCp0Mtc0,
        output reg rCp0Exception,
        output reg rCp0Eret,
        output reg [31:0] rCp0Cause,
        output reg rHiIn,
        output reg rHiOut,
        output reg rLoIn,
        output reg rLoOut,
        output reg [`MUX_PC_CWIDTH-1:0] rMuxPcC,
        output reg [`MUX_MEM_CWIDTH-1:0] rMuxMemC,
        output reg [`MUX_RDC_CWIDTH-1:0] rMuxRdcC,
        output reg [`MUX_RD_CWIDTH-1:0] rMuxRdC,
        output reg [`MUX_ALUA_CWIDTH-1:0] rMuxAluaC,
        output reg [`MUX_ALUB_CWIDTH-1:0] rMuxAlubC,
        output reg [`MUX_EXT16_CWIDTH-1:0] rMuxExt16C,
        output reg [`MUX_HI_CWIDTH-1:0] rMuxHiC,
        output reg [`MUX_LO_CWIDTH-1:0] rMuxLoC,
        output wire oNewState
    );

    wire [5:0] op = instr[31:26];
    wire [5:0] rs = instr[25:21];
    wire [5:0] rt = instr[20:16];
    wire [5:0] funct = instr[5:0];

    wire opAddi = (op == `OP_ADDI);
    wire opAddiu = (op == `OP_ADDIU);
    wire opAndi = (op == `OP_ANDI);
    wire opOri = (op == `OP_ORI);
    wire opSltiu = (op == `OP_SLTIU);
    wire opLui = (op == `OP_LUI);
    wire opXori = (op == `OP_XORI);
    wire opSlti = (op == `OP_SLTI);
    wire opAddu = (op == `OP_SPECIAL && funct == `FUNCT_ADDU);
    wire opAnd = (op == `OP_SPECIAL && funct == `FUNCT_AND);
    wire opBeq = (op == `OP_BEQ);
    wire opBne = (op == `OP_BNE);
    wire opJ = (op == `OP_J);
    wire opJal = (op == `OP_JAL);
    wire opJr = (op == `OP_SPECIAL && funct == `FUNCT_JR);
    wire opLw = (op == `OP_LW);
    wire opXor = (op == `OP_SPECIAL && funct == `FUNCT_XOR);
    wire opNor = (op == `OP_SPECIAL && funct == `FUNCT_NOR);
    wire opOr = (op == `OP_SPECIAL && funct == `FUNCT_OR);
    wire opSll = (op == `OP_SPECIAL && funct == `FUNCT_SLL);
    wire opSllv = (op == `OP_SPECIAL && funct == `FUNCT_SLLV);
    wire opSltu = (op == `OP_SPECIAL && funct == `FUNCT_SLTU);
    wire opSra = (op == `OP_SPECIAL && funct == `FUNCT_SRA);
    wire opSrl = (op == `OP_SPECIAL && funct == `FUNCT_SRL);
    wire opSubu = (op == `OP_SPECIAL && funct == `FUNCT_SUBU);
    wire opSw = (op == `OP_SW);
    wire opAdd = (op == `OP_SPECIAL && funct == `FUNCT_ADD);
    wire opSub = (op == `OP_SPECIAL && funct == `FUNCT_SUB);
    wire opSlt = (op == `OP_SPECIAL && funct == `FUNCT_SLT);
    wire opSrlv = (op == `OP_SPECIAL && funct == `FUNCT_SRLV);
    wire opSrav = (op == `OP_SPECIAL && funct == `FUNCT_SRAV);
    wire opClz = (op == `OP_SPECIAL2 && funct == `FUNCT_CLZ);
    wire opDivu = (op == `OP_SPECIAL && funct == `FUNCT_DIVU);
    wire opEret = (op == `OP_COP0 && funct == `FUNCT_ERET);
    wire opJalr = (op == `OP_SPECIAL && funct == `FUNCT_JALR);
    wire opLb = (op == `OP_LB);
    wire opLbu = (op == `OP_LBU);
    wire opLhu = (op == `OP_LHU);
    wire opSb = (op == `OP_SB);
    wire opSh = (op == `OP_SH);
    wire opLh = (op == `OP_LH);
    wire opMfc0 = (op == `OP_COP0 && rs == `RS_MF);
    wire opMfhi = (op == `OP_SPECIAL && funct == `FUNCT_MFHI);
    wire opMflo = (op == `OP_SPECIAL && funct == `FUNCT_MFLO);
    wire opMtc0 = (op == `OP_COP0 && rs == `RS_MT);
    wire opMthi = (op == `OP_SPECIAL && funct == `FUNCT_MTHI);
    wire opMtlo = (op == `OP_SPECIAL && funct == `FUNCT_MTLO);
    wire opMul = (op == `OP_SPECIAL2 && funct == `FUNCT_MUL);
    wire opMultu = (op == `OP_SPECIAL && funct == `FUNCT_MULTU);
    wire opSyscall = (op == `OP_SPECIAL && funct == `FUNCT_SYSCALL);
    wire opTeq = (op == `OP_SPECIAL && funct == `FUNCT_TEQ);
    wire opBgez = (op == `OP_REGIMM && rt == `RT_BGEZ);
    wire opBreak = (op == `OP_SPECIAL && funct == `FUNCT_BREAK);
    wire opDiv = (op == `OP_SPECIAL && funct == `FUNCT_DIV);

    reg [2:0] curState;
    reg [2:0] nextState;

    assign oNewState = (curState == `CTRL_STATE_T1);


    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            curState <= `CTRL_STATE_INIT;
        end
        else begin
            curState <= nextState;
        end
    end

    always @ (*) begin
        case(curState)
            `CTRL_STATE_INIT: begin
                nextState <= `CTRL_STATE_T1;
            end
            `CTRL_STATE_T1: begin
                nextState <= `CTRL_STATE_T2;
            end
            `CTRL_STATE_T2: begin
                nextState <= `CTRL_STATE_T3;
            end
            `CTRL_STATE_T3: begin
                if(
                    opJ ||
                    opJr ||
                    (opBeq && !aluZ) ||
                    (opBne && aluZ) ||
                    (opBgez && aluN) ||
                    opMul ||
                    opMultu ||
                    opBreak ||
                    opEret ||
                    opSyscall ||
                    opTeq ||
                    opMfc0 ||
                    opMfhi ||
                    opMflo ||
                    opMtc0 ||
                    opMthi ||
                    opMtlo
                ) begin
                    nextState <= `CTRL_STATE_T1;
                end
                else begin
                    nextState <= `CTRL_STATE_T4;
                end
            end
            `CTRL_STATE_T4: begin
                if(
                    opJal ||
                    opJalr ||
                    opBeq ||
                    opBne ||
                    opBgez
                ) begin
                    nextState <= `CTRL_STATE_T5;
                end
                else if((opDiv || opDivu) && divBusy) begin
                    nextState <= `CTRL_STATE_T4;
                end
                else begin
                    nextState <= `CTRL_STATE_T1;
                end
            end
            `CTRL_STATE_T5: begin
                nextState <= `CTRL_STATE_T1;
            end
            default: begin
                nextState <= `CTRL_STATE_T1;
            end
        endcase
    end

    always @ (*) begin
        rPcIn = 0;
        rPcOut = 0;
        rMemR = 0;
        rMemW = 0;
        rIrIn = 0;
        rRfRsE = 0;
        rRfRtE = 0;
        rRfRdE = 0;
        rAluC = `ALU_CWIDTH'b0;
        rZIn = 0;
        rZOut = 0;
        rExtS = 0;
        rExtMemType = `EXT_MEM_CWIDTH'b0;
        rDivStart = 0;
        rDivS = 0;
        rMulS = 0;
        rCp0Mfc0 = 0;
        rCp0Mtc0 = 0;
        rCp0Exception = 0;
        rCp0Eret = 0;
        rCp0Cause = 32'b0;
        rHiIn = 0;
        rHiOut = 0;
        rLoIn = 0;
        rLoOut = 0;
        rMuxPcC = `MUX_PC_CWIDTH'b0;
        rMuxMemC = `MUX_MEM_CWIDTH'b0;
        rMuxRdcC = `MUX_RDC_CWIDTH'b0;
        rMuxRdC = `MUX_RD_CWIDTH'b0;
        rMuxAluaC = `MUX_ALUA_CWIDTH'b0;
        rMuxAlubC = `MUX_ALUB_CWIDTH'b0;
        rMuxExt16C = `MUX_EXT16_CWIDTH'b0;
        rMuxHiC = `MUX_HI_CWIDTH'b0;
        rMuxLoC = `MUX_LO_CWIDTH'b0;
        case(curState)
            `CTRL_STATE_T1: begin
                rPcOut = 1;
                rMemR = 1;
                rIrIn = 1;
                rAluC = `ALU_OP_ADD;
                rZIn = 1;
                rMuxMemC = `MUX_MEM_PC;
                rMuxAluaC = `MUX_ALUA_PC;
                rMuxAlubC = `MUX_ALUB_4;
            end
            `CTRL_STATE_T2: begin
                rPcIn = 1;
                rZOut = 1;
                rMuxPcC = `MUX_PC_Z;
            end
            `CTRL_STATE_T3: begin
                if(opAddi) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opAddiu) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADDU;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opAndi) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_AND;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opOri) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_OR;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opSltiu) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_SLTU;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opLui) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_SLL_SLA;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_16;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opXori) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_XOR;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opSlti) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_SLT;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opAddu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_ADDU;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opAnd) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_AND;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opBeq) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SUB;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opBne) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SUB;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opJ) begin
                    rPcIn = 1;
                    rPcOut = 1;
                    rMuxPcC = `MUX_PC_CON;
                end
                else if(opJal) begin
                    rPcOut = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_PC;
                    rMuxAlubC = `MUX_ALUB_0;    // 4 or 8 ?
                end
                else if(opJr) begin
                    rPcIn = 1;
                    rRfRsE = 1;
                    rMuxPcC = `MUX_PC_RS;
                end
                else if(opLw) begin
                    rRfRsE = 1;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opXor) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_XOR;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opNor) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_NOR;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opOr) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_OR;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSll) begin
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SLL_SLA;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_EXT5;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSllv) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SLL_SLA;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSltu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SLTU;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSra) begin
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SRA;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_EXT5;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSrl) begin
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SRL;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_EXT5;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSubu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SUBU;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSw) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opAdd) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSub) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SUB;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSlt) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rAluC = `ALU_OP_SLT;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSrlv) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rZIn = 1;
                    rAluC = `ALU_OP_SRL;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opSrav) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rZIn = 1;
                    rAluC = `ALU_OP_SRA;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_RT;
                end
                else if(opClz) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_CLZ;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_0;
                end
                else if(opDivu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rDivStart = 1;
                end
                else if(opEret) begin
                    rPcIn = 1;
                    rCp0Eret = 1;
                    rMuxPcC = `MUX_PC_EPCOUT;
                end
                else if(opJalr) begin
                    rPcOut = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rMuxAluaC = `MUX_ALUA_PC;
                    rMuxAlubC = `MUX_ALUB_0;    // 4 or 8 ?
                end
                else if(opLb) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opLbu) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opLhu) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opSb) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opSh) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opLh) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_EXT16;
                    rMuxExt16C = `MUX_EXT16_IMMOFF;
                end
                else if(opMfc0) begin
                    rRfRdE = 1;
                    rCp0Mfc0 = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_CP0OUT;
                end
                else if(opMfhi) begin
                    rRfRdE = 1;
                    rHiOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_HI;
                end
                else if(opMflo) begin
                    rRfRdE = 1;
                    rLoOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_LO;
                end
                else if(opMtc0) begin
                    rRfRtE = 1;
                    rCp0Mtc0 = 1;
                end
                else if(opMthi) begin
                    rRfRsE = 1;
                    rHiIn = 1;
                    rMuxHiC = `MUX_HI_RS;
                end
                else if(opMtlo) begin
                    rRfRsE = 1;
                    rLoIn = 1;
                    rMuxLoC = `MUX_LO_RS;
                end
                else if(opMul) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rRfRdE = 1;
                    rMulS = 1;
                    rHiIn = 1;
                    rLoIn = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_MULZ;
                    rMuxHiC = `MUX_HI_SZ;
                    rMuxLoC = `MUX_LO_SZ;
                end
                else if(opMultu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rHiIn = 1;
                    rLoIn = 1;
                    rMuxHiC = `MUX_HI_MULZ;
                    rMuxLoC = `MUX_LO_MULZ;
                end
                else if(opSyscall && cp0Status[0] && cp0Status[`CP0_SYSCALL_POS]) begin
                    rPcOut = 1;
                    rCp0Exception = 1;
                    rCp0Cause = `CP0_CAUSE_SYSCALL;
                end
                else if(opTeq && cp0Status[0] && cp0Status[`CP0_TEQ_POS]) begin
                    rPcOut = 1;
                    rCp0Exception = 1;
                    rCp0Cause = `CP0_CAUSE_TEQ;
                end
                else if(opBgez) begin
                    rRfRsE = 1;
                    rAluC = `ALU_OP_ADD;
                    rMuxAluaC = `MUX_ALUA_RS;
                    rMuxAlubC = `MUX_ALUB_0;
                end
                else if(opBreak && cp0Status[0] && cp0Status[`CP0_BREAK_POS]) begin
                    rPcOut = 1;
                    rCp0Exception = 1;
                    rCp0Cause = `CP0_CAUSE_BREAK;
                end
                else if(opDiv) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rDivStart = 1;
                    rDivS = 1;
                end
            end
            `CTRL_STATE_T4: begin
                if(opAddi) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opAddiu) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opAndi) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opOri) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSltiu) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opLui) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opXori) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSlti) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opAddu) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opAnd) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opBeq) begin
                    rPcOut = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_PC;
                    rMuxAlubC = `MUX_ALUB_EXT18;
                end
                else if(opBne) begin
                    rPcOut = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_PC;
                    rMuxAlubC = `MUX_ALUB_EXT18;
                end
                else if(opJal) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_31;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opLw) begin
                    rMemR = 1;
                    rRfRdE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_WORD;
                    rMuxMemC = `MUX_MEM_Z;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_MD;
                end
                else if(opXor) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opNor) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opOr) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSll) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSllv) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSltu) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSra) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSrl) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSubu) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSw) begin
                    rMemR = 1;
                    rMemW = 1;
                    rRfRtE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_WORD;
                    rMuxMemC = `MUX_MEM_Z;
                end
                else if(opAdd) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSub) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSlt) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSrlv) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opSrav) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opClz) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opDivu) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    if(!divBusy) begin
                        rHiIn = 1;
                        rLoIn = 1;
                        rMuxHiC = `MUX_HI_DIVR;
                        rMuxLoC = `MUX_LO_DIVQ;
                    end
                end
                else if(opJalr) begin
                    rRfRdE = 1;
                    rZOut = 1;
                    rMuxRdcC = `MUX_RDC_RD;
                    rMuxRdC = `MUX_RD_Z;
                end
                else if(opLb) begin
                    rMemR = 1;
                    rRfRdE = 1;
                    rZOut = 1;
                    rExtS = 1;
                    rExtMemType = `MEM_WTYPE_BYTE;
                    rMuxMemC = `MUX_MEM_Z;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_EXT8;
                end
                else if(opLbu) begin
                    rMemR = 1;
                    rRfRdE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_BYTE;
                    rMuxMemC = `MUX_MEM_Z;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_EXT8;
                end
                else if(opLhu) begin
                    rMemR = 1;
                    rRfRdE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_HALF;
                    rMuxMemC = `MUX_MEM_Z;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_EXT16;
                    rMuxExt16C = `MUX_EXT16_MD;
                end
                else if(opSb) begin
                    rMemR = 1;
                    rMemW = 1;
                    rRfRtE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_BYTE;
                    rMuxMemC = `MUX_MEM_Z;
                end
                else if(opSh) begin
                    rMemR = 1;
                    rMemW = 1;
                    rRfRtE = 1;
                    rZOut = 1;
                    rExtMemType = `MEM_WTYPE_HALF;
                    rMuxMemC = `MUX_MEM_Z;
                end
                else if(opLh) begin
                    rMemR = 1;
                    rRfRdE = 1;
                    rZOut = 1;
                    rExtS = 1;
                    rExtMemType = `MEM_WTYPE_HALF;
                    rMuxMemC = `MUX_MEM_Z;
                    rMuxRdcC = `MUX_RDC_RT;
                    rMuxRdC = `MUX_RD_EXT16;
                    rMuxExt16C = `MUX_EXT16_MD;
                end
                else if(opBgez) begin
                    rPcOut = 1;
                    rAluC = `ALU_OP_ADD;
                    rZIn = 1;
                    rExtS = 1;
                    rMuxAluaC = `MUX_ALUA_PC;
                    rMuxAlubC = `MUX_ALUB_EXT18;
                end
                else if(opDiv) begin
                    rRfRsE = 1;
                    rRfRtE = 1;
                    rDivS = 1;
                    if(!divBusy) begin
                        rHiIn = 1;
                        rLoIn = 1;
                        rMuxHiC = `MUX_HI_DIVR;
                        rMuxLoC = `MUX_LO_DIVQ;
                    end
                end
            end
            `CTRL_STATE_T5: begin
                if(opBeq) begin
                    rPcIn = 1;
                    rZOut = 1;
                    rMuxPcC = `MUX_PC_Z;
                end
                else if(opBne) begin
                    rPcIn = 1;
                    rZOut = 1;
                    rMuxPcC = `MUX_PC_Z;
                end
                else if(opJal) begin
                    rPcIn = 1;
                    rPcOut = 1;
                    rMuxPcC = `MUX_PC_CON;
                end
                else if(opJalr) begin
                    rPcIn = 1;
                    rRfRsE = 1;
                    rMuxPcC = `MUX_PC_RS;
                end
                else if(opBgez) begin
                    rPcIn = 1;
                    rZOut = 1;
                    rMuxPcC = `MUX_PC_Z;
                end
            end
            default: begin
            end
        endcase
    end

endmodule

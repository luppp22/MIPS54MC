`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 11:02:21
// Design Name: 
// Module Name: CPU
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

module CPU(
    input wire clk,
    input wire rst,
    input wire [31:0] iMemData,
    output wire oMemW,
    output wire oMemR,
    output wire [`EXT_MEM_CWIDTH-1:0] oMemDataType,
    output wire [31:0] oMemAddr,
    output wire [31:0] oMemData,
    output wire [31:0] oIrData,
    output wire [31:0] oPcData
    );

    wire aluN;
    wire aluZ;
    wire divBusy;
    wire [31:0] cp0Status;
    wire pcIn;
    wire pcOut;
    wire irIn;
    wire rfRsE;
    wire rfRtE;
    wire rfRdE;
    wire [`ALU_CWIDTH-1:0] aluC;
    wire zIn;
    wire zOut;
    wire extS;
    wire [`EXT_MEM_CWIDTH-1:0] extMemType;
    wire divStart;
    wire divS;
    wire mulS;
    wire cp0Mfc0;
    wire cp0Mtc0;
    wire cp0Exception;
    wire cp0Eret;
    wire [31:0] cp0Cause;
    wire hiIn;
    wire hiOut;
    wire loIn;
    wire loOut;
    wire [`MUX_PC_CWIDTH-1:0] muxPcC;
    wire [`MUX_MEM_CWIDTH-1:0] muxMemC;
    wire [`MUX_RDC_CWIDTH-1:0] muxRdcC;
    wire [`MUX_RD_CWIDTH-1:0] muxRdC;
    wire [`MUX_ALUA_CWIDTH-1:0] muxAluaC;
    wire [`MUX_ALUB_CWIDTH-1:0] muxAlubC;
    wire [`MUX_EXT16_CWIDTH-1:0] muxExt16C;
    wire [`MUX_HI_CWIDTH-1:0] muxHiC;
    wire [`MUX_LO_CWIDTH-1:0] muxLoC;

    wire [31:0] pcData;
    wire [31:0] irData;
    wire [4:0] insRs = irData[25:21];
    wire [4:0] insRt = irData[20:16];
    wire [4:0] insRd = irData[15:11];
    wire [4:0] insSa = irData[10:6];
    wire [15:0] insImmOff = irData[15:0];
    wire [25:0] insIndex = irData[25:0];
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [31:0] zData;
    wire [31:0] aluData;
    wire [63:0] mulData;
    wire [31:0] divQ;
    wire [31:0] divR;
    wire [31:0] hiData;
    wire [31:0] loData;
    wire [31:0] cp0Data;
    wire [31:0] epcData;
    wire [31:0] ext16Data;
    wire [31:0] ext18Data;
    wire [31:0] ext5Data;
    wire [31:0] ext8Data;

    wire [4:0] muxRdcData;
    wire [31:0] muxRdData;
    wire [31:0] muxPcData;
    wire [31:0] muxAluaData;
    wire [31:0] muxAlubData;
    wire [31:0] muxHiData;
    wire [31:0] muxLoData;
    wire [15:0] muxExt16Data;
    wire newState;

    assign oMemDataType = extMemType;
    assign oMemData = rtData;
    assign oIrData = irData;
    assign oPcData = newState ? pcData : 32'bz;


    CtrlUnit ctrlUnit(
        .clk(clk),
        .rst(rst),
        .aluN(aluN),
        .aluZ(aluZ),
        .divBusy(divBusy),
        .instr(irData),
        .cp0Status(cp0Status),
        .rPcIn(pcIn),
        .rPcOut(pcOut),
        .rMemR(oMemR),
        .rMemW(oMemW),
        .rIrIn(irIn),
        .rRfRsE(rfRsE),
        .rRfRtE(rfRtE),
        .rRfRdE(rfRdE),
        .rAluC(aluC),
        .rZIn(zIn),
        .rZOut(zOut),
        .rExtS(extS),
        .rExtMemType(extMemType),
        .rDivStart(divStart),
        .rDivS(divS),
        .rMulS(mulS),
        .rCp0Mfc0(cp0Mfc0),
        .rCp0Mtc0(cp0Mtc0),
        .rCp0Exception(cp0Exception),
        .rCp0Eret(cp0Eret),
        .rCp0Cause(cp0Cause),
        .rHiIn(hiIn),
        .rHiOut(hiOut),
        .rLoIn(loIn),
        .rLoOut(loOut),
        .rMuxPcC(muxPcC),
        .rMuxMemC(muxMemC),
        .rMuxRdcC(muxRdcC),
        .rMuxRdC(muxRdC),
        .rMuxAluaC(muxAluaC),
        .rMuxAlubC(muxAlubC),
        .rMuxExt16C(muxExt16C),
        .rMuxHiC(muxHiC),
        .rMuxLoC(muxLoC),
        .oNewState(newState)
    );

    RegFiles cpu_ref(
        .clk(clk),
        .rst(rst),
        .rsE(rfRsE),
        .rtE(rfRtE),
        .rdE(rfRdE),
        .iRsAddr(insRs),
        .iRtAddr(insRt),
        .iRdAddr(muxRdcData),
        .iRdData(muxRdData),
        .oRsData(rsData),
        .oRtData(rtData)
    );

    Reg32 #(
        .INIT_VALUE(32'h00400000)
    ) pcReg (
        .clk(clk),
        .rst(rst),
        .inEna(pcIn),
        .outEna(pcOut),
        .iData(muxPcData),
        .oData(pcData)
    );

    NegReg32 irReg(
        .clk(clk),
        .rst(rst),
        .inEna(irIn),
        .outEna(1'b1),
        .iData(iMemData),
        .oData(irData)
    );

    ALU alu(
        .iA(muxAluaData),
        .iB(muxAlubData),
        .oprType(aluC),
        .oResult(aluData),
        .oZero(aluZ),
        .oNegative(aluN)
    );

    Reg32 zReg(
        .clk(clk),
        .rst(rst),
        .inEna(zIn),
        .outEna(zOut),
        .iData(aluData),
        .oData(zData)
    );

    Multiplier multiplier(
        .sign(mulS),
        .iA(rsData),
        .iB(rtData),
        .oZ(mulData)
    );

    Divider divider(
        .iDividend(rsData),
        .iDivisor(rtData),
        .start(divStart),
        .clk(clk),
        .rst(rst),
        .sign(divS),
        .oQ(divQ),
        .oR(divR),
        .rBusy(divBusy)
    );

    Reg32 hi(
        .clk(clk),
        .rst(rst),
        .inEna(hiIn),
        .outEna(hiOut),
        .iData(muxHiData),
        .oData(hiData)
    );

    Reg32 lo(
        .clk(clk),
        .rst(rst),
        .inEna(loIn),
        .outEna(loOut),
        .iData(muxLoData),
        .oData(loData)
    );

    CP0 cp0(
        .clk(clk),
        .rst(rst),
        .mfc0(cp0Mfc0),
        .mtc0(cp0Mtc0),
        .exception(cp0Exception),
        .eret(cp0Eret),
        .iAddr(insRd),
        .iData(rtData),
        .iCause(cp0Cause),
        .iPc(pcData),
        .oCp0(cp0Data),
        .oStatus(cp0Status),
        .oEpc(epcData)
    );

    EXT #(
        .IWIDTH(16)
    ) ext16 (
        .iData(muxExt16Data),
        .sign(extS),
        .oData(ext16Data)
    );

    EXT #(
        .IWIDTH(18)
    ) ext18 (
        .iData({insImmOff, 2'b0}),
        .sign(extS),
        .oData(ext18Data)
    );

    EXT #(
        .IWIDTH(5)
    ) ext5 (
        .iData(insSa),
        .sign(extS),
        .oData(ext5Data)
    );

    EXT #(
        .IWIDTH(8)
    ) ext8 (
        .iData(iMemData[7:0]),
        .sign(extS),
        .oData(ext8Data)
    );

    MUX4 muxPc(
        .iData0(zData),
        .iData1(rsData),
        .iData2({pcData[31:28], insIndex, 2'b0}),
        .iData3(epcData),
        .select(muxPcC),
        .oData(muxPcData)
    );

    MUX2 muxMem(
        .iData0(zData),
        .iData1(pcData),
        .select(muxMemC),
        .oData(oMemAddr)
    );

    MUX8 muxRd(
        .iData0(zData),
        .iData1(hiData),
        .iData2(loData),
        .iData3(mulData[31:0]),
        .iData4(cp0Data),
        .iData5(iMemData),
        .iData6(ext16Data),
        .iData7(ext8Data),
        .select(muxRdC),
        .oData(muxRdData)
    );

    MUX3 #(
        .DATA_WIDTH(5)
    ) muxRdc (
        .iData0(insRd),
        .iData1(insRt),
        .iData2(5'h1f),
        .select(muxRdcC),
        .oData(muxRdcData)
    );

    MUX4 muxAlua(
        .iData0(pcData),
        .iData1(rsData),
        .iData2(ext5Data),
        .iData3(32'h10),
        .select(muxAluaC),
        .oData(muxAluaData)
    );

    MUX6 muxAlub(
        .iData0(rtData),
        .iData1(ext16Data),
        .iData2(ext18Data),
        .iData3(32'h0),
        .iData4(32'h4),
        .iData5(32'h8),
        .select(muxAlubC),
        .oData(muxAlubData)
    );

    MUX4 muxHi(
        .iData0(32'bz),
        .iData1(mulData[63:32]),
        .iData2(rsData),
        .iData3(divR),
        .select(muxHiC),
        .oData(muxHiData)
    );

    MUX4 muxLo(
        .iData0(32'bz),
        .iData1(mulData[31:0]),
        .iData2(rsData),
        .iData3(divQ),
        .select(muxLoC),
        .oData(muxLoData)
    );

    MUX2 #(
        .DATA_WIDTH(16)
    ) muxExt16 (
        .iData0(iMemData[15:0]),
        .iData1(insImmOff),
        .select(muxExt16C),
        .oData(muxExt16Data)
    );

endmodule

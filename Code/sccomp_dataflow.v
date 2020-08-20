`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/13 10:03:31
// Design Name: 
// Module Name: sccomp_dataflow
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

module sccomp_dataflow(
    input wire clk_in,
    input wire reset,
    output wire [31:0] inst,
    output wire [31:0] pc
    );

    wire memW;
    wire memR;
    wire [`EXT_MEM_CWIDTH-1:0] memDataType;
    wire [31:0] cpuInData;
    wire [31:0] cpuOutData;
    wire [31:0] memInData;
    wire [31:0] memOutData;
    wire [31:0] memAddr;

    CPU sccpu(
        .clk(clk_in),
        .rst(reset),
        .iMemData(cpuInData),
        .oMemW(memW),
        .oMemR(memR),
        .oMemDataType(memDataType),
        .oMemAddr(memAddr),
        .oMemData(cpuOutData),
        .oIrData(inst),
        .oPcData(pc)
    );

    `ifdef _WEB_TEST
        IP_RAM ram(
            .a(memAddr[12:2]),
            .d(memInData),
            .dpra(memAddr[12:2]),
            .clk(clk_in),
            .we(memW),
            .dpo(memOutData)
        );
    `else
        RAM ram(
            .clk(clk_in),
            .rst(reset),
            .rEna(memR),
            .wEna(memW),
            .iAddr(memAddr[12:2]),
            .iData(memInData),
            .oData(memOutData)
        );
    `endif

    MEM_CONV_1 memConv1(
        .iNewData(cpuOutData),
        .iOriData(memOutData),
        .iPos(memAddr[1:0]),
        .type(memDataType),
        .roData(memInData)
    );

    MEM_CONV_2 memConv2(
        .iOriData(memOutData),
        .iPos(memAddr[1:0]),
        .type(memDataType),
        .roData(cpuInData)
    );

endmodule

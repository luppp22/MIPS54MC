`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/13 15:59:58
// Design Name: 
// Module Name: NegReg32
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


module NegReg32(
    input wire clk,
    input wire rst,
    input wire inEna,
    input wire outEna,
    input wire [31:0] iData,
    output wire [31:0] oData
    );

    reg [31:0] rData;

    always @ (negedge clk or posedge rst) begin
        if(rst) rData <= 32'b0;
        else if(inEna) rData <= iData;
    end

    assign oData = outEna ? rData : 32'bz;
endmodule

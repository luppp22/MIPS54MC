`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 11:13:50
// Design Name: 
// Module Name: Reg32
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

module Reg32 #(
        parameter INIT_VALUE = 32'b0
    ) (
        input wire clk,
        input wire rst,
        input wire inEna,
        input wire outEna,
        input wire [31:0] iData,
        output wire [31:0] oData
    );

    reg [31:0] rData;

    always @ (posedge clk or posedge rst) begin
        if(rst) rData <= INIT_VALUE;
        else if(inEna) rData <= iData;
    end

    assign oData = outEna ? rData : 32'bz;

endmodule

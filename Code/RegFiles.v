`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/12 15:15:10
// Design Name: 
// Module Name: RegFiles
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


module RegFiles(
    input wire clk,
    input wire rst,
    input wire rsE,
    input wire rtE,
    input wire rdE,
    input wire [4:0] iRsAddr,
    input wire [4:0] iRtAddr,
    input wire [4:0] iRdAddr,
    input wire [31:0] iRdData,
    output wire [31:0] oRsData,
    output wire [31:0] oRtData
    );

    reg [31:0] array_reg [0:31];

    integer i;

    always @ (negedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1)
                array_reg[i] <= 32'b0;
        end
        else if(rdE && iRdAddr != 5'b0)
            array_reg[iRdAddr] <= iRdData;
    end

    assign oRsData = rsE ? array_reg[iRsAddr] : 32'bz;
    assign oRtData = rtE ? array_reg[iRtAddr] : 32'bz;
    //assign oRtData = array_reg[iRtAddr];

endmodule

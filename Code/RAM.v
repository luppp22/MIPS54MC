`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/12 20:49:05
// Design Name: 
// Module Name: RAM
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

module RAM(
    input wire clk,
    input wire rst,
    input wire rEna,
    input wire wEna,
    input wire [10:0] iAddr,
    input wire [31:0] iData,
    output wire [31:0] oData
    );

    reg [31:0] rData [0:2047];

    integer i;

    initial begin
        $readmemh(`TEST_FILE_NAME, rData);
    end

    
    always @ (posedge clk) begin
        if(wEna) rData[iAddr] <= iData;
    end
    

    assign oData = rEna ? rData[iAddr] : 32'bz;

endmodule

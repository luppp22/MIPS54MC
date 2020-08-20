`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/10 17:10:30
// Design Name: 
// Module Name: CP0
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

module CP0(
    input wire clk,
    input wire rst,
    input wire mfc0,
    input wire mtc0,
    input wire exception,
    input wire eret,
    input wire [4:0] iAddr,
    input wire [31:0] iData,
    input wire [31:0] iCause,
    input wire [31:0] iPc,
    output wire [31:0] oCp0,
    output wire [31:0] oStatus,
    output wire [31:0] oEpc
    );

    reg [31:0] rf[0:31];

    integer i;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1)
                rf[i] = (i == `CP0_STATUS_ADDR ? `CP0_STATUS_INIT : 32'b0);
        end
        else begin
            // mtc0
            if(mtc0) rf[iAddr] <= iData;
            // sysall / break / teq
            else if(exception) begin
                rf[`CP0_STATUS_ADDR] <= (rf[`CP0_STATUS_ADDR] << 5);
                rf[`CP0_EPC_ADDR] <= iPc;
                rf[`CP0_CAUSE_ADDR] <=iCause;
            end
            // eret
            else if(eret) begin
                rf[`CP0_STATUS_ADDR] <= (rf[`CP0_STATUS_ADDR] >> 5);
            end
        end
    end

    assign oStatus = rf[`CP0_STATUS_ADDR];
    assign oCp0 = mfc0 ? rf[iAddr] : 32'bz;
    assign oEpc = (!mfc0 && !exception) ? rf[`CP0_EPC_ADDR] : 32'bz;

endmodule

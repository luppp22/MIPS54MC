`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/14 16:03:02
// Design Name: 
// Module Name: MEM_CONV_2
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

module MEM_CONV_2(
        input wire [31:0] iOriData,
        input wire [`EXT_MEM_AWIDTH-1:0] iPos,
        input wire [`EXT_MEM_CWIDTH-1:0] type,
        output reg [31:0] roData
    );

    always @ (*) begin
        case(type)
            `MEM_WTYPE_WORD: begin
                roData = iOriData;
            end
            `MEM_WTYPE_HALF: begin
                case(iPos)
                    2'b00: roData = {16'b0, iOriData[15:0]};
                    2'b10: roData = {16'b0, iOriData[31:16]};
                    default: roData = iOriData;
                endcase
            end
            `MEM_WTYPE_BYTE: begin
                case(iPos)
                    2'b00: roData = {24'b0, iOriData[7:0]};
                    2'b01: roData = {24'b0, iOriData[15:8]};
                    2'b10: roData = {24'b0, iOriData[23:16]};
                    2'b11: roData = {24'b0, iOriData[31:24]};
                endcase
            end
            default: begin
                roData = iOriData;
            end
        endcase
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 10:27:48
// Design Name: 
// Module Name: MUX8
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


module MUX8 #(
        parameter DATA_WIDTH = 32
    ) (
        input wire [DATA_WIDTH-1:0] iData0,
        input wire [DATA_WIDTH-1:0] iData1,
        input wire [DATA_WIDTH-1:0] iData2,
        input wire [DATA_WIDTH-1:0] iData3,
        input wire [DATA_WIDTH-1:0] iData4,
        input wire [DATA_WIDTH-1:0] iData5,
        input wire [DATA_WIDTH-1:0] iData6,
        input wire [DATA_WIDTH-1:0] iData7,
        input wire [7:0] select,
        output wire [DATA_WIDTH-1:0] oData
    );

    reg [DATA_WIDTH-1:0] rData;

    always @ (*) begin
        case(select)
            8'b00000001: rData = iData0;
            8'b00000010: rData = iData1;
            8'b00000100: rData = iData2;
            8'b00001000: rData = iData3;
            8'b00010000: rData = iData4;
            8'b00100000: rData = iData5;
            8'b01000000: rData = iData6;
            8'b10000000: rData = iData7;
            default: rData = {DATA_WIDTH{1'bz}};
        endcase
    end

    assign oData = rData;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 10:05:37
// Design Name: 
// Module Name: MUX4
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


module MUX4 #(
        parameter DATA_WIDTH = 32
    ) (
        input wire [DATA_WIDTH-1:0] iData0,
        input wire [DATA_WIDTH-1:0] iData1,
        input wire [DATA_WIDTH-1:0] iData2,
        input wire [DATA_WIDTH-1:0] iData3,
        input wire [3:0] select,
        output wire [DATA_WIDTH-1:0] oData
    );

    reg [DATA_WIDTH-1:0] rData;

    always @ (*) begin
        case(select)
            4'b0001: rData = iData0;
            4'b0010: rData = iData1;
            4'b0100: rData = iData2;
            4'b1000: rData = iData3;
            default: rData = {DATA_WIDTH{1'bz}};
        endcase
    end

    assign oData = rData;

endmodule

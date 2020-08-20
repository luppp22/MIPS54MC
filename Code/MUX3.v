`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 10:29:01
// Design Name: 
// Module Name: MUX3
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


module MUX3 #(
        parameter DATA_WIDTH = 32
    ) (
        input wire [DATA_WIDTH-1:0] iData0,
        input wire [DATA_WIDTH-1:0] iData1,
        input wire [DATA_WIDTH-1:0] iData2,
        input wire [2:0] select,
        output wire [DATA_WIDTH-1:0] oData
    );

    reg [DATA_WIDTH-1:0] rData;

    always @ (*) begin
        case(select)
            3'b001: rData = iData0;
            3'b010: rData = iData1;
            3'b100: rData = iData2;
            default: rData = {DATA_WIDTH{1'bz}};
        endcase
    end

    assign oData = rData;

endmodule

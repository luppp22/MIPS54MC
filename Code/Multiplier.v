`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/10 17:09:57
// Design Name: 
// Module Name: Multiplier
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


module Multiplier(
        input wire sign,
        input wire [31:0] iA,
        input wire [31:0] iB,
        output wire [63:0] oZ
    );

    wire [31:0] aA = (sign && iA[31]) ? -iA : iA;
    wire [31:0] aB = (sign && iB[31]) ? -iB : iB;

    wire [63:0] part [0:31];
    wire [63:0] addl1 [0:15];
    wire [63:0] addl2 [0:7];
    wire [63:0] addl3 [0:3];
    wire [63:0] addl4 [0:1];

    genvar i;
    integer j;

    assign part[0] = aB[0] ? {32'b0, aA} : 64'b0;

    generate
        for(i = 1; i < 32; i = i + 1)
            assign part[i] = aB[i] ? {{(32-i){1'b0}}, aA, {(i){1'b0}}} : 64'b0;
    endgenerate

    generate
        for(i = 0; i < 16; i = i + 1)
            assign addl1[i] = part[i*2] + part[i*2+1];
    endgenerate

    generate
        for(i = 0; i < 8; i = i + 1)
            assign addl2[i] = addl1[i*2] + addl1[i*2+1];
    endgenerate

    generate
        for(i = 0; i < 4; i = i + 1)
            assign addl3[i] = addl2[i*2] + addl2[i*2+1];
    endgenerate

    assign addl4[0] = addl3[0] + addl3[1];
    assign addl4[1] = addl3[2] + addl3[3];
    assign oZ = (sign && (iA[31] ^ iB[31])) ? -(addl4[0] + addl4[1]) : addl4[0] + addl4[1];

endmodule

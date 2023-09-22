`timescale 1ns / 1ps

module alu#(
    parameter NB_DATA = 8,
    parameter NB_OP = 6
)(
    input wire [NB_DATA-1 :0] i_dato_A,
    input wire [NB_DATA-1 :0] i_dato_B,
    input wire [NB_OP-1 :0] i_OP,
    output wire [NB_DATA-1 :0] o_result //9bits, incluye carry
);

localparam OP_ADD = 6'b100000; //hex 20
localparam OP_SUB = 6'b100010; //hex 22
localparam OP_AND = 6'b100100; //hex 24
localparam OP_OR = 6'b100101; //hex 25
localparam OP_XOR = 6'b100110; //hex 26
localparam OP_SRA = 6'b000011; //hex 3
localparam OP_SRL = 6'b000010; //hex 2
localparam OP_NOR = 6'b100111;  //hex 27

reg [NB_DATA-1 :0] result;

assign o_result = result;

always @(*)
begin
    case(i_OP)
        OP_ADD    : result = i_dato_A + i_dato_B;
        OP_SUB    : result = i_dato_A - i_dato_B;
        OP_AND    : result = i_dato_A & i_dato_B;
        OP_OR     : result = i_dato_A | i_dato_B;
        OP_XOR    : result = i_dato_A ^ i_dato_B;
        OP_SRA    : result = {i_dato_A[NB_DATA-1],i_dato_A[NB_DATA-1:1]};
        OP_SRL    : result = i_dato_A >> 1;
        OP_NOR    : result = ~(i_dato_A | i_dato_B);
        default   : result = i_dato_A + i_dato_B;
    endcase
end
endmodule

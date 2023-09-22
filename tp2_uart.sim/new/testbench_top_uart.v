`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 10:00:54 AM
// Design Name: 
// Module Name: testbench_top_uart
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


module testbench_top_uart(

    );
localparam NB_DATA = 8;
localparam NB_OP=6;

localparam OP_ADD = 6'b100000;
localparam OP_SUB = 6'b100010;
localparam OP_AND = 6'b100100;
localparam OP_OR = 6'b100101;
localparam OP_XOR = 6'b100110;
localparam OP_SRA = 6'b000011;
localparam OP_SRL = 6'b000010;
localparam OP_NOR = 6'b100111;

reg t_rx;
reg t_clock;
reg t_reset;

wire t_tx;

reg [NB_DATA-1:0] dato_A_a_rx= 8'b10101010;
reg [NB_DATA-1:0] dato_B_a_rx= 8'b01010101;
reg [NB_OP-1:0] OP_a_rx= OP_OR;

wire alu;
top u_top(
    .i_top_rx(t_rx),
    .i_top_clock(t_clock),
    .i_top_reset(t_reset),
    .o_top_tx(t_tx),
    .o_alu(alu)
);


initial
begin
    t_clock   = 1'b0;
    t_reset   = 1'b1;
    t_rx      = 1'b1;
    #5
    t_reset   = 1'b0;
    #5 
    //ENVIO DE DATO A
    t_rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    t_rx      = dato_A_a_rx[0];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[1];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[2];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[3];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[4];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[5];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[6];
    #10432 //16 ticks 
    t_rx      = dato_A_a_rx[7];
    #10432 //16 ticks 
    t_rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    #10432 //16 ticks 
    //ENVIO DE DATO B
    t_rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    t_rx      = dato_B_a_rx[0];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[1];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[2];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[3];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[4];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[5];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[6];
    #10432 //16 ticks 
    t_rx      = dato_B_a_rx[7];
    #10432 //16 ticks 
    t_rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    #10432 //16 ticks 
    //ENVIO DE CODIGO DE OPERACION
    t_rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    t_rx      = OP_a_rx[0];
    #10432 //16 ticks 
    t_rx      = OP_a_rx[1];
    #10432 //16 ticks 
    t_rx      = OP_a_rx[2];
    #10432 //16 ticks 
    t_rx      = OP_a_rx[3];
    #10432 //16 ticks 
    t_rx      = OP_a_rx[4];
    #10432 //16 ticks 
    t_rx      = OP_a_rx[5];
    #10432 //16 ticks 
    t_rx      = 1'b0; //no se usan
    #10432 //16 ticks 
    t_rx      = 1'b0; //no se usan
    #10432 //16 ticks 
    t_rx      = 1'b1; //bit de stop
    #10432 //16 ticks
    #10432 //16 ticks 

    #104320
    
    $finish();

end

always 
begin
    #1
    t_clock = ~t_clock;
end

endmodule


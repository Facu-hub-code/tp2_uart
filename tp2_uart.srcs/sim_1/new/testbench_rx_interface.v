`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2022 10:47:10 AM
// Design Name: 
// Module Name: testbench_rx-interface
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


module testbench_rx_interface(

    );

localparam NB_DATA = 8;
localparam NB_OP=6;

reg rx;
reg clock;
reg reset;

wire tick;

wire [NB_DATA-1:0] rx_data;
wire rx_done;


reg [NB_DATA-1:0] alu_result;

wire [NB_DATA-1:0] dato_A;
wire [NB_DATA-1:0] dato_B;
wire [NB_OP-1:0] OP;
wire [NB_DATA-1:0] interface_data;
wire interface_done;

reg [NB_DATA-1:0] dato_A_a_rx= 8'b10101010;
reg [NB_DATA-1:0] dato_B_a_rx= 8'b00001111;
reg [NB_DATA-1:0] OP_a_rx= 8'b100100;

receiver u_receiver(
    .i_rx(rx), //entrada en serie
    .i_clock(clock),
    .i_reset(reset),
    .i_tick(tick),
    .o_rx_data(rx_data), //salida en paralelo de 8 bits
    .o_rx_done(rx_done)
);

baud_rate_generator u_baud_rate_generator(
    .i_clock(clock),
    .i_reset(reset),
    .o_tick(tick)
);

interface_alu u_interface_alu(
    .i_rx_data(rx_data),
    .i_rx_done(rx_done),
    //.i_tx_done(tx_done),
    .i_alu_result(alu_result),
    .i_clock(clock),
    .i_reset(reset),
    .o_dato_A(dato_A),
    .o_dato_B(dato_B),
    .o_OP(OP),
    .o_interface_data(interface_data),
    .o_interface_done(interface_done)
);

initial
begin
    clock   = 1'b0;
    reset   = 1'b1;
    rx      = 1'b1;
    #5
    reset   = 1'b0;
    alu_result = 8'b11111111;
    #5 
    //ENVIO DE DATO A
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = dato_A_a_rx[0];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[1];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[2];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[3];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[4];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[5];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[6];
    #10432 //16 ticks 
    rx      = dato_A_a_rx[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    //ENVIO DE DATO B
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = dato_B_a_rx[0];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[1];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[2];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[3];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[4];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[5];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[6];
    #10432 //16 ticks 
    rx      = dato_B_a_rx[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    //ENVIO DE CODIGO DE OPERACION
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = OP_a_rx[0];
    #10432 //16 ticks 
    rx      = OP_a_rx[1];
    #10432 //16 ticks 
    rx      = OP_a_rx[2];
    #10432 //16 ticks 
    rx      = OP_a_rx[3];
    #10432 //16 ticks 
    rx      = OP_a_rx[4];
    #10432 //16 ticks 
    rx      = OP_a_rx[5];
    #10432 //16 ticks 
    rx      = OP_a_rx[6];
    #10432 //16 ticks 
    rx      = OP_a_rx[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 

    $finish();

end

always 
begin
    #1
    clock = ~clock;
end

endmodule

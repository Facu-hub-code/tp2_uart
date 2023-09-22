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


module testbench_rx_int_alu_tx(

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

reg rx;
reg clock;
reg reset;

wire tick;

wire [NB_DATA-1:0] rx_data;
wire rx_done;


wire [NB_DATA-1:0] alu_result;

wire [NB_DATA-1:0] dato_A;
wire [NB_DATA-1:0] dato_B;
wire [NB_OP-1:0] OP;
wire [NB_DATA-1:0] interface_data;
wire interface_done;

wire tx;

reg [NB_DATA-1:0] dato_A_a_rx= 8'b00000001;
reg [NB_DATA-1:0] dato_B_a_rx= 8'b00000001;
reg [NB_OP-1:0] OP_a_rx= OP_ADD;

reg [NB_DATA-1:0] dato_A_a_rx2= 8'b00000010;
reg [NB_DATA-1:0] dato_B_a_rx2= 8'b00000001;
reg [NB_OP-1:0] OP_a_rx2= OP_SUB;

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

alu u_alu(
    .i_dato_A(dato_A),
    .i_dato_B(dato_B),
    .i_OP(OP),
    .o_result(alu_result)
);

transmitter u_transmitter(
    .i_interface_data(interface_data),
    .i_interface_done(interface_done),
    .i_tick(tick),
    .i_clock(clock),
    .i_reset(reset),
    .o_tx(tx)
    //.o_tx_done(tx_done)
);

initial
begin
    clock   = 1'b0;
    reset   = 1'b1;
    rx      = 1'b1;
    #5
    reset   = 1'b0;
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
    rx      = 1'b0;
    #10432 //16 ticks 
    rx      = 1'b0;
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    //ENVIO DE DATO A
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = dato_A_a_rx2[0];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[1];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[2];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[3];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[4];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[5];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[6];
    #10432 //16 ticks 
    rx      = dato_A_a_rx2[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    //ENVIO DE DATO B
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = dato_B_a_rx2[0];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[1];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[2];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[3];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[4];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[5];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[6];
    #10432 //16 ticks 
    rx      = dato_B_a_rx2[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    //ENVIO DE CODIGO DE OPERACION
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = OP_a_rx2[0];
    #10432 //16 ticks 
    rx      = OP_a_rx2[1];
    #10432 //16 ticks 
    rx      = OP_a_rx2[2];
    #10432 //16 ticks 
    rx      = OP_a_rx2[3];
    #10432 //16 ticks 
    rx      = OP_a_rx2[4];
    #10432 //16 ticks 
    rx      = OP_a_rx2[5];
    #10432 //16 ticks 
    rx      = 1'b0;
    #10432 //16 ticks 
    rx      = 1'b0;
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    
    #104320
    
    $finish();

end

always 
begin
    #1
    clock = ~clock;
end

endmodule

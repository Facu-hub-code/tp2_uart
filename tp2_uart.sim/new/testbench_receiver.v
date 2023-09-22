`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2022 06:53:10 PM
// Design Name: 
// Module Name: testbench_receiver
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


module testbench_receiver(
);

localparam NB_DATA = 8;
localparam DATA_A_RECIBIR = 8'b10101010;

reg rx;
reg clock;
reg reset;

wire tick;

wire [NB_DATA-1:0] rx_data;
wire rx_done;

//dato a recibir
reg [NB_DATA-1:0] data_a_rx=DATA_A_RECIBIR;
reg [NB_DATA-1:0] data_de_rx;

reg dato_recibido;

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

initial
begin
    clock   = 1'b0;
    reset   = 1'b1;
    rx      = 1'b1;
    dato_recibido = 1'b0;
    #6
    reset   = 1'b0;
    #6 
    rx      = 1'b0; //bit de start
    #10432 //16 ticks, cada ticke son 326 ciclso de clock, cada 2 pasos de sim hay un ciclo, 16x326x2 = 10432
    rx      = data_a_rx[0];
    #10432 //16 ticks 
    rx      = data_a_rx[1];
    #10432 //16 ticks 
    rx      = data_a_rx[2];
    #10432 //16 ticks 
    rx      = data_a_rx[3];
    #10432 //16 ticks 
    rx      = data_a_rx[4];
    #10432 //16 ticks 
    rx      = data_a_rx[5];
    #10432 //16 ticks 
    rx      = data_a_rx[6];
    #10432 //16 ticks 
    rx      = data_a_rx[7];
    #10432 //16 ticks 
    rx      = 1'b1; //bit de stop
    #10432 //16 ticks 
    $finish();

end


always@(posedge clock)
begin
    if(rx_done)
    begin
        data_de_rx <= rx_data;
    end
end

always 
begin
    #1
    clock = ~clock;
end

endmodule

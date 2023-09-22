`timescale 1ns / 1ps
module top#(
    parameter NB_DATA = 8,
    parameter NB_OP=6
)(
    input i_top_rx,
    input i_top_clock,
    input i_top_reset,
    output o_top_tx,
    output [NB_DATA-1:0] o_alu
);

wire [NB_DATA-1:0] rx_data;
wire rx_done;

wire tick;

wire [NB_DATA-1:0] dato_A;
wire [NB_DATA-1:0] dato_B;
wire [NB_OP-1:0] OP;
wire [NB_DATA-1:0] interface_data;
wire interface_done;

wire [NB_DATA-1:0] alu_result;

//wire top_tx;

receiver u_receiver(
    .i_rx(i_top_rx), //entrada en serie
    .i_clock(i_top_clock),
    .i_reset(i_top_reset),
    .i_tick(tick),
    .o_rx_data(rx_data), //salida en paralelo de 8 bits
    .o_rx_done(rx_done)
);

baud_rate_generator u_baud_rate_generator(
    .i_clock(i_top_clock),
    .i_reset(i_top_reset),
    .o_tick(tick)
);

interface_alu u_interface_alu(
    .i_rx_data(rx_data),
    .i_rx_done(rx_done),
    .i_alu_result(alu_result),
    .i_clock(i_top_clock),
    .i_reset(i_top_reset),
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
    .i_clock(i_top_clock),
    .i_reset(i_top_reset),
    .o_tx(o_top_tx)
    //.o_tx_done(tx_done)
);

assign o_alu = alu_result;

endmodule
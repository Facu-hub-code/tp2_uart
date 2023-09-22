`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2022 04:39:24 PM
// Design Name: 
// Module Name: testbench_rx_tx
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


module testbench_rx_tx(

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


reg clock;
reg reset;
wire tick;

wire [NB_DATA-1:0] rx_data; //salida de rx
wire rx_done; //salida de rx valid

reg [NB_DATA-1:0] interface_data; //Dato a tx
reg interface_done; //valid de dato a tx

wire tx; //salida de tx, entrada de rx


transmitter u_transmitter(
    .i_interface_data(interface_data),
    .i_interface_done(interface_done),
    .i_tick(tick),
    .i_clock(clock),
    .i_reset(reset),
    .o_tx(tx)
    //.o_tx_done(tx_done)
);

receiver u_receiver(
    .i_rx(tx), //entrada en serie
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
    interface_done = 1'b0; 
    #60
    reset   = 1'b0;
    #60 
    interface_data = 8'b11001100;
    interface_done = 1'b1;
    #20
    interface_done = 1'b0;
    
    #1043200
    
    $finish();

end

always 
begin
    #10
    clock = ~clock;
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 12:17:49 PM
// Design Name: 
// Module Name: testbench_transmitter
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


module testbench_transmitter(
    );

localparam NB_DATA = 8;

reg [NB_DATA-1:0] interface_data;
reg interface_done;
reg clock;
reg reset;

wire tx;
wire tx_done;
wire tick;

reg dato_a_tx=8'b10101010;

transmitter u_transmitter(
    .i_interface_data(interface_data),
    .i_interface_done(interface_done),
    .i_tick(tick),
    .i_clock(clock),
    .i_reset(reset),
    .o_tx(tx),
    .o_tx_done(tx_done)
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
    #5
    reset   = 1'b0;
    #2
    interface_data = 8'b10101010;
    interface_done = 1'b1;
    #104320 //10 bits, de 16ticks
    $finish();

end

always 
begin
    #1
    clock = ~clock;
end

endmodule

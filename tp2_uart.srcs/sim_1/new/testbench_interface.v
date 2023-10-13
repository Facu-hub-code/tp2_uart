`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2022 04:10:40 PM
// Design Name: 
// Module Name: testbench_interface
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


module testbench_interface(
    );

localparam NB_DATA = 8;
localparam NB_OP=6;

reg [NB_DATA-1:0] rx_data;
reg rx_done;
reg [NB_DATA-1:0] alu_result;
reg clock;
reg reset;

wire [NB_DATA-1:0] dato_A;
wire [NB_DATA-1:0] dato_B;
wire [NB_OP-1:0] OP;
wire [NB_DATA-1:0] interface_data;
wire interface_done;

reg [NB_DATA-1:0] rx_dato_a=8'b11110000;
reg [NB_DATA-1:0] rx_dato_b=8'b00001111;
reg [NB_OP-1:0]rx_op=6'b100100;

interface_alu u_interface_alu(
    .i_rx_data(rx_data),
    .i_rx_done(rx_done),
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
    rx_done = 1'b0;
    #5
    reset   = 1'b0;
    #6
    rx_data = rx_dato_a;
    rx_done = 1'b1;
    #2
    rx_done = 1'b0;
    #2
    rx_data = rx_dato_b;
    rx_done = 1'b1;
    #2
    rx_done = 1'b0;
    #2
    rx_data = rx_op;
    rx_done = 1'b1;
    alu_result = 8'b11111111;
    #2
    rx_done = 1'b0;
    #6
    
    $finish();

end

always 
begin
    #1
    clock = ~clock;
end

endmodule

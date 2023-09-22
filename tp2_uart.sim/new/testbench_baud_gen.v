`timescale 1ns / 1ps


module testbench_baud_gen(
);

reg clock;
reg reset;

wire tick;

baud_rate_generator u_baud_rate_generator(
    .i_clock(clock),
    .i_reset(reset),
    .o_tick(tick)
);

always 
begin
    #1
    clock = ~clock;
end

initial
begin
    clock = 1'b0;
    reset = 1'b1;
    #5
    reset = 1'b0;
end

endmodule

`timescale 1ns / 1ps

module transmitter#(
    parameter NB_DATA = 8
)(
    input wire [NB_DATA-1:0] i_interface_data,
    input wire i_interface_done,
    input wire i_tick,
    input wire i_clock,
    input wire i_reset,
    output wire o_tx
    //output wire o_tx_done
    );

localparam IDLE_STATE =     4'b0001;
localparam START_STATE =    4'b0010;
localparam DATA_STATE =     4'b0100;
localparam STOP_STATE =     4'b1000;

localparam NB_STATES = 4;
reg [NB_STATES-1:0] state;
reg [NB_STATES-1:0] next_state;

//contador de ticks, maxima cuenta hasta 15
localparam NB_TICK_COUNTER = 4; 
reg [NB_TICK_COUNTER-1:0] tick_counter,next_tick_counter;

//contador de data recibida, maximo hasta 8 
localparam NB_DATA_COUNTER = 3;
reg [NB_DATA_COUNTER-1:0] data_counter, next_data_counter;

reg [NB_DATA-1:0] tx_data, next_tx_data;

reg tx_out,next_tx_out;

assign o_tx = tx_out;

always@(posedge i_clock)
begin
    if(i_reset)
        state <= IDLE_STATE;
    else
        state <= next_state;
end

//contador de ticks
always@(posedge i_clock)
begin
    //if(i_reset || tick_counter_reset)
    if(i_reset)
    begin
        tick_counter <= {NB_TICK_COUNTER{1'b0}};
        //tick_counter_reset <= 1'b0;
    end
    else 
         tick_counter <= next_tick_counter;
end

//contador de datos
always@(posedge i_clock)
begin
    if(i_reset)
        data_counter <= {NB_DATA_COUNTER{1'b0}};
    else
        data_counter <= next_data_counter;
end

always@(posedge i_clock)
begin
    if(i_reset)
        tx_data <= {NB_DATA{1'b0}};
    else   
        tx_data <= next_tx_data; 
end

always@(posedge i_clock)
begin
    if(i_reset)
    begin
        tx_out <= 1'b0;
    end
    else 
    begin    
        tx_out <= next_tx_out; 
    end 
end

always@(*)
begin
    //next_state = state;
    //next_data_counter = data_counter;
    //next_tick_counter = tick_counter;
    //next_tx_data = tx_data;
    //next_tx_out = tx_out;
    case(state)
        IDLE_STATE:
        begin
            next_tx_out = 1'b1;
            next_tick_counter = {NB_TICK_COUNTER{1'b0}};
            next_data_counter = {NB_DATA_COUNTER{1'b0}};
            
            if(i_interface_done)
            begin
                next_tx_data = i_interface_data;
                next_state = START_STATE;
            end
            else
            begin
                next_tx_data = tx_data;
                next_state = IDLE_STATE;
            end
        end
        START_STATE:
        begin
            next_tx_out = 1'b0;
            if(i_tick)
            begin
                if(tick_counter == 4'b1111)
                begin
                    next_tick_counter = {NB_TICK_COUNTER{1'b0}};
                    next_state = DATA_STATE;
                end
                else
                begin
                    next_tick_counter = tick_counter + 1;
                    next_state = START_STATE;
                end
            end
            else
            begin
                next_tick_counter = tick_counter;
                next_state = START_STATE;
            end    
        end    
        DATA_STATE:
        begin
            next_tx_out = tx_data[0];
            if(i_tick)
            begin
                if(tick_counter == 4'b1111)
                begin
                    next_tick_counter = {NB_TICK_COUNTER{1'b0}};
                    next_tx_data = tx_data >> 1;
                    if(data_counter == 3'b111) //data igual a 8, ya estan todos los datos
                        next_state = STOP_STATE;
                    else
                        next_data_counter = data_counter + 1;
              
                end
                else
                begin
                    next_tick_counter = tick_counter + 1;
                    next_state = DATA_STATE;
                end      
            end
            else
            begin
                next_state = DATA_STATE;
                next_tx_data = tx_data;
                next_tick_counter = tick_counter;
                next_data_counter = data_counter;
            end
        end        
        STOP_STATE: //estado para verificar recepcion de bit de STOP
        begin
            next_tx_out = 1'b1;
            if(i_tick)
            begin
                if(tick_counter == 4'b1111)
                    next_state = IDLE_STATE;
                else
                begin
                    next_tick_counter = tick_counter + 1;
                    next_state = STOP_STATE;
                end
            end
            else
            begin
                next_state = STOP_STATE;
                next_tick_counter = tick_counter;
            end
        end
        default:
        begin
            next_state = IDLE_STATE;
        end
    endcase              
end



endmodule
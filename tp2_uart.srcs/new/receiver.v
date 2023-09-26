`timescale 1ns / 1ps

module receiver#(
    parameter NB_DATA = 8
)(
    input wire i_rx, //pin de entrada para recibir los datos en serie
    input wire i_tick,
    input wire i_clock, 
    input wire i_reset, 
    output wire [NB_DATA-1:0] o_rx_data, //Dato de entrada paralelizado
    output wire o_rx_done //Flag de fin del muestreo
);

/* Definimos 4 estados, sin bit partidad, 1 solo bit de stop. */
localparam IDLE_STATE =     4'b0001; //El receptor espera datos, Bit de start = 0.
localparam START_STATE =    4'b0010; //Bit de start = 1. y tics cuenta hasta 7.
localparam DATA_STATE =     4'b0100; // Bit de start = 0, tics cada 15 y data < 7.
localparam STOP_STATE =     4'b1000; //Bit de stop = 1.

localparam NB_STATES = 4;
reg [NB_STATES-1:0] state;
reg [NB_STATES-1:0] next_state;

//contador de ticks, maxima cuenta hasta 15
localparam NB_TICK_COUNTER = 4;
reg [NB_TICK_COUNTER-1:0] tick_counter,next_tick_counter;

//contador de data recibida, maximo hasta 7
localparam NB_DATA_COUNTER = 3;
reg [NB_DATA_COUNTER-1:0] data_counter, next_data_counter;


reg [NB_DATA-1:0] data, next_data;

reg rx_done, next_rx_done;

//memoria de estado
always@(posedge i_clock)
begin
    if(i_reset)
        state <= IDLE_STATE; //El estado de inicio es IDLE
    else
        state <= next_state;
end

//contador de ticks
always@(posedge i_clock)
begin
    if(i_reset)
        tick_counter <= {NB_TICK_COUNTER{1'b0}}; //Concatena 0s y limpia el contador de tics
    else 
        tick_counter <= next_tick_counter;
end

//Contador de datos
always@(posedge i_clock)
begin
    if(i_reset)
        data_counter <= {NB_DATA_COUNTER{1'b0}};
    else
    begin    
        data_counter <= next_data_counter;
    end 
end

always@(posedge i_clock)
begin
    if(i_reset)
        data <= {NB_DATA{1'b0}};
    else 
        data <= next_data;
end

always@(posedge i_clock)
begin
    if(i_reset)
        rx_done <= 1'b0;
    else 
        rx_done <= next_rx_done;
end

always@(*)
begin
    case(state)
        IDLE_STATE:
        begin
            next_rx_done = 1'b0;
            next_data = {NB_DATA{1'b0}};
            next_tick_counter = {NB_TICK_COUNTER{1'b0}};
            next_data_counter = {NB_DATA_COUNTER{1'b0}};
            if(i_rx == 0) //Cuando llega un bajo en i_rx significa START
                next_state = START_STATE;
            else
                next_state = IDLE_STATE;
        end
        START_STATE:
        begin
            if(i_tick)
            begin
                if(tick_counter == 4'b0111) //si el contador de ticks es igual a 8, mitad del START
                begin
                    if(i_rx == 0) 
                    begin
                        next_state = DATA_STATE; //Te vas al estado de datos
                        next_tick_counter = {NB_TICK_COUNTER{1'b0}}; //Limpias el contador de tics
                    end 
                    else 
                        next_state = IDLE_STATE;
                end
                else
                begin
                    next_tick_counter = tick_counter + 1; //Aumentas un tic
                    next_state = START_STATE; //Te quedas en start
                end
            end
            else //y sino, no paso nada
            begin
                next_state = START_STATE;
                next_tick_counter = tick_counter;
            end
        end    
        DATA_STATE:
        begin
            if(i_tick)
            begin
                if(tick_counter == 4'b1111) //si el contador de ticks es igual a 15 
                begin
                    next_data = {i_rx,data[NB_DATA-1: 1]}; //va concatenando la entrada, el primer dato recibido queda como LSB
                    next_data_counter = data_counter + 1;
                    next_tick_counter = {NB_TICK_COUNTER{1'b0}};

                    if(data_counter == 3'b111) //data igual a 7, ya estan todos los datos
                        next_state = STOP_STATE;
                    else
                        next_state = DATA_STATE;
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
                next_data = data;
                next_data_counter = data_counter;
                next_tick_counter = tick_counter;
            end
        end        
        STOP_STATE: //estado para verificar recepcion de bit de STOP
        begin
            if(i_tick)
                if(tick_counter == 4'b1111)
                begin
                    if(i_rx == 1'b1)   //verifica el bit de stop 
                    begin
                        next_rx_done = 1'b1; //indica q el dato termino de recibirse
                    end
                    
                    next_state = IDLE_STATE;
                end
                else
                begin
                    next_tick_counter = tick_counter + 1;
                    next_state = STOP_STATE;
                end
            else
            begin
                next_state = STOP_STATE;
                next_tick_counter = tick_counter;
            end                
        end
        default:
            next_state = IDLE_STATE; //Por las dudas
    endcase              
end

assign o_rx_done = rx_done;
assign o_rx_data = data;

endmodule

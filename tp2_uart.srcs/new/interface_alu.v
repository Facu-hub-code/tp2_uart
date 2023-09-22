`timescale 1ns / 1ps

module interface_alu#(
    parameter NB_DATA = 8,
    parameter NB_OP=6
)(
    input wire [NB_DATA-1:0] i_rx_data,
    input wire i_rx_done,
    //input wire i_tx_done,
    input wire [NB_DATA-1:0] i_alu_result,
    input wire i_clock,
    input wire i_reset,
    output wire [NB_DATA-1:0] o_dato_A,
    output wire [NB_DATA-1:0] o_dato_B,
    output wire [NB_OP-1:0] o_OP,
    output wire [NB_DATA-1:0] o_interface_data,
    output wire o_interface_done
);

localparam DATO_A_STATE =   5'b00001;
localparam DATO_B_STATE =   5'b00010;
localparam OP_STATE     =   5'b00100;
localparam SAVE_STATE   =   5'b01000;
localparam TX_STATE     =   5'b10000;

localparam NB_STATES = 5;
reg [NB_STATES-1:0] state;
reg [NB_STATES-1:0] next_state;

reg [NB_DATA-1:0] dato_A;
reg [NB_DATA-1:0] next_dato_A = {NB_DATA{1'b0}};
reg [NB_DATA-1:0] dato_B;
reg [NB_DATA-1:0] next_dato_B = {NB_DATA{1'b0}};
reg [NB_OP-1:0] OP;
reg [NB_OP-1:0] next_OP = {NB_OP{1'b0}};

//salida de la interface al tx
reg [NB_DATA-1:0] interface_data;
reg [NB_DATA-1:0] next_interface_data = {NB_DATA{1'b0}};
//reg interface_data_valid;

reg interface_done;

reg flag, next_flag; //VER NOMBRE

//asignacion de salidas
assign o_interface_done = interface_done;
assign o_interface_data = interface_data;
assign o_dato_A = dato_A;
assign o_dato_B = dato_B;
assign o_OP = OP;

always@(posedge i_clock)
begin
    if(i_reset)
        state <= DATO_A_STATE; 
    else
        state <= next_state;
end

always@(posedge i_clock)
begin
    if(i_reset)
        flag <= 0;
    else
        flag <= next_flag;
end

always@(posedge i_clock)
begin
    if(i_reset)
        dato_A <= {NB_DATA{1'b0}};
    else
        dato_A <= next_dato_A;
end

always@(posedge i_clock)
begin
    if(i_reset)
        dato_B <= {NB_DATA{1'b0}};
    else
        dato_B <= next_dato_B;
end

always@(posedge i_clock)
begin
    if(i_reset)
        OP <= {NB_OP{1'b0}};
    else
        OP <= next_OP;
end

always@(posedge i_clock)
begin
    if(i_reset)
        interface_data <= {NB_DATA{1'b0}};
    else
        interface_data <= next_interface_data;
end

//TODO: chequear lo de esperar a q rx_done baje para no guardar 2 veces lo mismo

always@(*)
begin
    next_flag = flag;
    case(state)
        DATO_A_STATE:
        begin
            interface_done = 1'b0;
            if(i_rx_done == 1'b1)
            begin
                next_dato_A = i_rx_data;
                next_flag = 1'b1; //la flag garantiza q el paso de estado se hago solo cuando ya se guardo el dato anterior
                next_state = DATO_A_STATE;
            end
            else
            begin
                next_dato_A = dato_A; 
                if(flag)
                begin
                    next_state = DATO_B_STATE;
                    next_flag = 1'b0;
                end
                else
                    next_state = DATO_A_STATE;
            end
                
        end
        DATO_B_STATE:
        begin
            if(i_rx_done == 1'b1)
            begin
                next_dato_B = i_rx_data;
                next_flag = 1;
                next_state = DATO_B_STATE;
            end
            else
            begin
                next_dato_B = dato_B; 
                if(flag)
                begin
                    next_state = OP_STATE;
                    next_flag = 0;
                end
                else
                    next_state = DATO_B_STATE;
            end
        end        
        OP_STATE:
         
        begin
            if(i_rx_done == 1'b1)
            begin
                next_OP = i_rx_data;
                next_flag = 1;
                next_state = OP_STATE;
            end
            else
            begin
                next_OP = OP;
                if(flag)
                begin
                    next_state = SAVE_STATE;
                    next_flag = 0;
                end
                else
                    next_state = OP_STATE;
            end
        end
        SAVE_STATE: 
        begin
            next_interface_data = i_alu_result;
            next_state = TX_STATE;
        end
        TX_STATE:
        begin
            interface_done = 1'b1;
            next_state = DATO_A_STATE;
        end

        default:
        begin
            next_state = DATO_A_STATE;
        end

    endcase              
end


endmodule

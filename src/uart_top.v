`include "baud_gen.v"
`include "Tx_updated.v"
`include "Rx3.v"

module uart_top (clk,arst_n,en,baud_div,Rx,data_in,baud_tick,data_out,Tx);
    input wire clk;          
    input wire arst_n;        
    input wire en;            
    input wire [31:0] baud_div; 
    input wire  Rx;           
    input wire [7:0] data_in; 
    output wire baud_tick; 
    output wire [7:0] data_out; 
    output wire Tx;     


    // Instantiate baud rate generator
    baud_gen uut (
        .clk(clk),
        .arst_n(arst_n),
        .en(en),
        .baud_div(baud_div),
        .baud_tick(baud_tick)
    );


//TX
    tx tx_uut1 (
        .clk(clk),
        .arst_n(arst_n),
        .en(en),
        .baud_tick(baud_tick),
        .data_in(data_in),
        .Tx(Tx)
    );


//RX
    rx rx_uut2 (
        .clk(clk),
        .arst_n(arst_n),
        .en(en),
        .baud_tick(baud_tick),
        .Rx(Tx),             
        .data_out(data_out)
    );


endmodule

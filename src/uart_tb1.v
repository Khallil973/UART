`timescale 1ns/1ns

module tx_tb;
    
    reg clk;           // Clock signal
    reg arst_n;        // Asynchronous reset
  //  reg baud_tick;     // Baud tick input
    wire [7:0] data_in; // Data to transmit
    reg en;            // Enable signal
    wire Tx;           // Transmitted signal
    reg baud_div;
    wire baud_tick;
    wire [7:0] data_out;

    // Instantiate the UART Tx module
    tx uut1 (
        .clk (clk),
        .arst_n (arst_n),
        .baud_tick (baud_tick),
        .data_in (data_out),
        .en (en),
        .Tx (Tx)
    );

    baud_gen uut (
            .clk(clk),
            .arst_n(arst_n),
            .en(en),
            .baud_div(130),
            .baud_tick(baud_tick)
            
    );

    rx rx_uut2(
            .clk(clk),
            .baud_tick(baud_tick),
            .arst_n(arst_n),
            .en(en),
            .Rx(Rx),
            .data_out(data_in)
            
);    

    // Generate clock with a short period
    initial clk = 0;
    always #50 clk = ~clk; // 50 MHz clock

/*    // Generate manual baud_tick
    initial begin
        baud_tick = 0;
        forever #100 baud_tick = ~baud_tick; // Manual toggle for testing
    end
*/
 /*
    // Test stimulus
    initial begin
        arst_n = 0; en = 0; data_in = 8'b0; // Initialize
        #20 arst_n = 1;                     // Release reset
        #40 en = 1;                         // Enable transmission
        #20 data_in = 8'b1010_1010;         // Load first data
        #100;
        while(uut.current_state != 2'b11 && uut.next_state == 2'b00) begin
            #20; 
        end 
        en = 0;                       // Disable transmission
        #40 data_in = 8'b1100_1100; en = 1;         // Load second data
        
                   // Re-enable transmission
        #100;           
        while(uut.current_state != 2'b00) begin
            #20; 
        end 
        #1000 $finish;                      // End simulation
    end
*/


    initial begin
        #10 arst_n = 0;
        #50 arst_n = 1;
        #10000 en = 1;
        #1000 data_in = 8'b1011_0100;
        #2000000 en = 0;
        #1000 data_in = 8'b1010_0101;
        #100 en = 1;
      #10000000 en = 0;
        #1200000 $finish;
    end

    // Check output data and display 
 /*
    initial begin
        $monitor("Time: %0t | data_in: %h | en: %b || arst_n: %b || Tx: %b | baud_tick: %b", 
                 $time, data_in, Tx,en, arst_n, baud_tick);
    end
*/
    // Dump waveforms for debugging
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0);
    end
    
endmodule

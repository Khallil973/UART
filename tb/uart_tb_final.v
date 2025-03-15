`timescale 1ns/1ns

module uart_tb;
   
    reg clk;
    reg arst_n;
    wire baud_tick;
    wire Rx; 
    wire [7:0] data_out;

/*
    rx uut (
        .clk (clk),
        .arst_n(arst_n),
        .baud_tick(baud_tick),
        .Rx(Rx),
        .en(en),
        .data_out(data_out)
    );
*/
    reg en;
    reg [7:0] data_in;


    uart_top uart (
                    .clk(clk),
                    .arst_n(arst_n),
                    .en(en),
                    .baud_div(130),
                    .Rx(Rx),
                    .data_in(data_in),
                    .baud_tick(baud_tick),
                    .data_out(data_out),
                    .Tx(Tx)
    );

/*
    tx tx_uut (
        .clk(clk),
        .arst_n(arst_n),
        .baud_tick(baud_tick),
        .data_in(data_in),
        .en(en),
        .Tx(Rx)
    );

   // Instantiate the baud rate generator
    baud_gen baud_gen_uut (
        .clk(clk),
        .arst_n(arst_n),
        .en(en),        // Always enabled for baud generation
        .baud_div(130),   // Configure baud rate divisor
        .baud_tick(baud_tick)
    );
*/
    initial begin
        $dumpfile("uart_tb_final.vcd");
        $dumpvars(0);
    end

    initial clk = 0;
    always #25 clk = ~clk;
/*
    // Test stimulus
    initial begin
        arst_n = 0; en = 0; data_in = 8'b0; // Initialize all signals
        #20 arst_n = 1;                     // Release asynchronous reset
        #100 en = 1;                        // Enable transmission
        data_in = 8'b1010_1010;             // Load first data byte
        #5000;                              // Wait for data to transmit
        en = 0;                             // Disable transmission
        #1000 data_in = 8'b1100_1100;       // Load second data byte
        en = 1;                             // Re-enable transmission
        #5000;                              // Wait for data to transmit
        en = 0;                             // Disable transmission
        #10000 $finish;                     // End simulation
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

endmodule


/*
    initial begin
        #10 arst_n = 0;
        #50 arst_n = 1;
        #10000 en = 1;
        #1000 data_in = 8'b1011_0100; // First data input
        #2000000 en = 0;
        #1000 data_in = 8'b1010_0101; // Second data input
        #100 en = 1;
        #100 en = 0;
        #100 en = 1;
        #3000000 data_in = 8'b1111_0000; // Third data input with delay
        #3000000 data_in = 8'b1101_1111; // Fourth data input with delay
      #10000000 en = 0;
        #1200000 $finish;
    end

*/   


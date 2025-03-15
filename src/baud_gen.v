module baud_gen(clk,arst_n,en,baud_div,baud_tick);
    input clk,arst_n;
    input en;
    input [31:0] baud_div;
    output reg baud_tick;


    reg [31:0] counter;
    /*
    Clock Frequency: f  = 20 MHz
    Baud Rate:       Bd = 9600 bit/s
    
    Baud Division = ____f____
                     16 x Bd
    */

//baud_div = 131


    always @(posedge clk) begin
        if(!arst_n) begin
            counter <= 0;
            baud_tick <= 0;
   //         baud_clk <= 0;

    end else if (en) begin
        if(counter == baud_div) begin
            counter <= 0;
            baud_tick <= 1'b1;
      //      baud_clk <= 1'b0;
            //two half clock = 1 clock(pos & neg)
          
        end else begin
            counter <= counter + 1;
            baud_tick <= 1'b0;
        end

        end else begin
            baud_tick <= 0;
            counter <= 0;
        end

    end


endmodule
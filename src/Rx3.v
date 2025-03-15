module rx(clk,baud_tick,arst_n,en,Rx,data_out);
    input wire clk,arst_n;
    input wire en;
    input wire baud_tick;
    input wire Rx;
    output reg [7:0] data_out;

    //Oversampling Counter
    reg [3:0] counter_16;
    reg counter_16_ind;
    reg counter_16_ind1;

    //Counter for oversampling
    always @(posedge clk or negedge arst_n) begin
        if (!arst_n) begin
        
            counter_16 <= 0;
            counter_16_ind <= 0;
            counter_16_ind1 <= 0;
        end
        else if (en && baud_tick) begin
                if (counter_16 == 15) begin
                    counter_16 <= 0;
                    counter_16_ind <= 1;
                end
                else begin
                    counter_16 <= counter_16 + 1;
                    counter_16_ind <= 0;
                end
                 if (counter_16 == 7 && Rx == 0 && current_state == START) begin
                        counter_16_ind1 <= 1;
                end
                else if(counter_16 == 7 && Rx == 1 && current_state == STOP) begin
                        counter_16_ind1 <= 1;
                end
                else if(current_state ==DATA) begin
                        counter_16_ind1 <= 0;
                end
                else begin
                        counter_16_ind1 <= counter_16_ind1;
                end

        end
        else begin
          counter_16 <= counter_16;
          counter_16_ind <= 0;
        end    
    end


    //Baud Clock Counter
    reg [2:0] counter_8;
    reg counter_8_ind;
    reg [7:0] shift_reg;

    //Shift Register and Baud Counter
    always @(posedge clk or negedge arst_n) begin
        if(!arst_n || en == 0) begin
            counter_8 <= 0;
            counter_8_ind <= 0;
            shift_reg <= 0;
        end
        else begin
            if (current_state == DATA) begin
              if (en && baud_tick && counter_16 == 15) begin
                if (counter_8 == 7) begin
                    counter_8 <= 0;
                    counter_8_ind <= 1;
                    shift_reg <= {shift_reg[6:0], Rx};
                end
                else begin
                    counter_8 <= counter_8 + 1;
                    counter_8_ind <= 0;
                    shift_reg <= {shift_reg[6:0], Rx};
                end
              end
              else begin
                counter_8 <= counter_8;
                counter_8_ind <= 0;
                shift_reg <= shift_reg;
              end
            end
            else begin
              counter_8 <= 0;
              counter_8_ind <= 0;
              shift_reg <= shift_reg;
            end
        end
    end

    always @(posedge clk or negedge arst_n) begin
      if (!arst_n) begin
           data_out <= 0; 
      end
      else begin
        if(current_state == STOP)  begin
            data_out <= shift_reg;
        end
        else
            data_out <= 0;
        end
    end

//FSM
    localparam IDLE = 0;
    localparam START = 1;
    localparam DATA = 2;
    localparam STOP = 3;


    reg [1:0] current_state,next_state;

    always @(posedge clk or negedge arst_n) begin
        if (!arst_n || en == 0) begin
            current_state <= IDLE;
        end else begin 
                if(en) begin
                current_state <= next_state;
                end else begin
                current_state <= IDLE;
                end
        end 
    end

    always @(*) begin
        if(!arst_n || en == 0) begin
            next_state <= 0;
        end
        else begin
          case (current_state)
            IDLE: begin
                if (Rx == 0) begin
                    next_state = START;
                end
            end
            START: begin
                if ((counter_16_ind == 1) && (counter_16_ind1 == 1)) begin
                    next_state <= DATA;
                end
            end
            DATA: begin
                if (counter_8_ind == 1) begin
                    next_state <= STOP;
                end
            end
            STOP: begin
                if ((counter_16_ind == 1) && (counter_16_ind1 == 1)) begin
                    next_state <= IDLE;
                end
            end
            default: next_state = IDLE;
           endcase 
        end
    end

endmodule    







module audio_driver( clk,
                     rst_n,
                     snd_sel,
                     audio_o
                   );

input clk;
input rst_n;
input wire[1:0] snd_sel;

output reg audio_o;

reg  [14:0] timer_1ms;
reg         msec;
reg  [3:0]  cycle_cnt;
reg  [3:0]  t1,t2,t3,t4;
reg  [3:0]  on_time,off_time;

always @(posedge clk) begin
   if(!rst_n) begin
      timer_1ms <= 15999;
   end else begin
      timer_1ms <= (timer_1ms==0) ? 15999 : timer_1ms -1;
   end
end


always @(posedge clk) begin
  if(!rst_n) begin
      msec <= 0;
  end else begin
      msec <= (timer_1ms==1) ? 1'b1 : 1'b0;
  end
end

reg[1:0] snd;
reg[3:0] state;

always @(posedge clk) begin
  if(!rst_n) begin
     snd     <= 0;
     t1      <= 0;
     t2      <= 0;
     t3      <= 0;
     t4      <= 0;
     audio_o <= 0;
     cycle_cnt <= 0;
     on_time   <= 0;
     off_time  <= 0;
     state <= 0;
  end else begin
     if( snd_sel!=0 && state ==0) begin
        cycle_cnt <= 10;
        state <= 1;
        case(snd_sel)
           0: begin  //Nothing
                 t1 <= 0; t2 <= 0;
                 t3 <= 0; t4 <= 0;
              end
           1: begin //Player missed
                 on_time <= 3;
                 //t1 <= 4; t2 <= 2;
                 //t3 <= 1; t4 <= 11;
                 t1 <= 3; t2 <= 1;
                 t3 <= 0; t4 <= 10;
              end
           2: begin //Ball Bounce
                 on_time <= 3;
                 t1 <= 3; t2 <= 1;
                 t3 <= 0; t4 <= 0;
              end
           3: begin //Ball Hit
                 on_time <= 0;
                 t1 <= 0; t2 <= 2;
                 t3 <= 2; t4 <= 2;
              end
        endcase
     end else begin
  
        if(msec==1) begin 
           case( state )
               1: begin
                     audio_o <= 1'b1;
                     on_time <=  (on_time==0) ? 0 : on_time-1;
                     if (on_time==0) begin
                        state <=2;
                        off_time <= t2;
                     end
                  end
               2: begin
                     audio_o <= 1'b0;
                     off_time <= ( off_time==0) ? 0 : off_time-1;
                     if (off_time==0) begin
                        cycle_cnt <= ( cycle_cnt==0) ? 0 : cycle_cnt-1;
                        if(cycle_cnt ==0) begin 
                           state <=3;
                           on_time <= t3;
                           cycle_cnt <= 10;
                        end else begin
                           state <=1;
                           on_time <= t1;
                        end
                     end
                  end
              3: begin
                     audio_o <= 1'b1;
                     on_time <= ( on_time==0) ? 0 : on_time-1;
                     if (on_time==0) begin
                        state <=4;
                        off_time <= t4;
                     end
                  end
               4: begin
                     audio_o <= 1'b0;
                     off_time <= ( off_time==0) ? 0 : off_time-1;
                     if (off_time==0) begin
                        cycle_cnt <= ( cycle_cnt==0) ? 0 : cycle_cnt-1;
                        if(cycle_cnt ==0) begin
                           state <=0;
                           on_time <= 0;
                           off_time <= 0;
                        end else begin
                           state <=3;
                           on_time <= t3;
                        end
                     end
                  end
           endcase 
        end //if(msec==1)
     end//if(snd_sel!=0)
  end //if(!rst_n)
end

endmodule

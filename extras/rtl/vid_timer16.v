
module vid_timer16(clk,
                 rst_n,
                 vid_sync,
                 vid_time,
                 x,
                 y
                 );

input           clk;
input           rst_n;
output reg      vid_sync;
output          vid_time;
output reg[8:0] x;
output reg[8:0] y;

//50Mhz
//parameter FULL_TIMER = 3174;
//parameter HALF_TIMER = 1587;
//parameter TIMEA    = 3174-235;
//parameter TIMEB    = 1587-235;

//16Mhz 
parameter FULL_TIMER = 1016;
parameter HALF_TIMER = 507;
parameter TIMEA    = 1016-75;
parameter TIMEB    = 507-75;


reg[10:0] sf_cnt;
reg[11:0] timer;
wire      hs_time;
wire      hs1_time;
reg[7:0]  h_pulse;
reg[7:0]  h1_pulse;
reg[4:0]  state;
reg       hs;
reg       vid_time;
reg[4:0]  x_timer;

always @(posedge clk) begin
  vid_sync <= (~hs) ^ (h_pulse!=0 && (state != 1 && state!=5)) ^ (h1_pulse!=0 && (state==1 || state==5 ));
end

always @(posedge clk) begin
   if(rst_n==0) begin
      sf_cnt  <= 0;
   end else begin
      //if(timer==3174 || timer==1587) begin
      if(timer==FULL_TIMER || timer==HALF_TIMER) begin
        sf_cnt <= (sf_cnt==1049) ? 11'h0 : sf_cnt+11'h1;  //was 625
      end
   end
end


//assign hs_time =  (timer==0 || (( sf_cnt<=17 || (sf_cnt>=524 && sf_cnt<=541 )) && timer==1587) );
//assign hs1_time = (state==1  && (timer==1587 || timer==(3174-235)) ) ||
//                  (state==5  && (timer==(3174-235)) || (timer==(1587-235)) );

assign hs_time =  (timer==0 || (( sf_cnt<=17 || (sf_cnt>=524 && sf_cnt<=541 )) && timer==HALF_TIMER) );
assign hs1_time = (state==1  && (timer==HALF_TIMER || timer==TIMEA) ) ||
                  (state==5  && (timer==TIMEA) || (timer==TIMEB) );

always @(posedge clk) begin
   if(rst_n==0) begin
      hs <= 1;
      state <= 0; 
   end else begin
      case( state) 
        5'h0:  begin  //hs_pre_a
                 hs <= 0;
                 if(sf_cnt== 6) state <= 5'h1;  //hsync time
               end
        5'h1:  begin  //hs_a
                 hs <= 1;
                 if(sf_cnt== 12) state <= 5'h2;  //hsync time
               end
        5'h2:  begin  //hs_post_a
                 hs <= 0;
                 if(sf_cnt== 18) state <= 5'h3;  //hsync time
               end
        5'h3:  begin  //vert
                 hs <= 0;
                 //if(sf_cnt== 524) state <= 5'h4;  //hsync time
                 if(sf_cnt== 525) state <= 5'h4;  //hsync time
               end
        5'h4:  begin  //hs_pre_b
                 hs <= 0;
                 if(sf_cnt== 531) state <= 5'h5;  //hsync time
               end
        5'h5:  begin  //hs_b
                 hs <= 1;
                 if(sf_cnt== 537) state <= 5'h6;  //hsync time
               end
        5'h6:  begin  //hs_post_a
                 hs <= 0;
                 if(sf_cnt== 542) state <= 5'h7;  //hsync time
               end
        5'h7:  begin  //vert
                 hs <= 0;
                 if(sf_cnt== 1049) state <= 5'h0;  //hsync time
               end
      endcase
   end
end



always @(posedge clk) begin
  if(rst_n==0) begin
     vid_time    <= 0;
     x_timer     <= 5'h0;
  
  end else begin
     vid_time    <= (((state==3 && sf_cnt>21)  || (state==7 && sf_cnt>545)) && h_pulse==0 && hs_time==0 ) ? 1'b1 : 1'b0;
     
     x_timer <= (vid_time ==1'b0 || x_timer==3) ? 5'h0 :  x_timer+1 ;
  end
end

always @(posedge clk) begin
  x <= (vid_time ==1'b0) ? 9'h000 : x_timer==3 ? x+1 : x;
end

always @(posedge clk) begin
  y <= (state==3 && sf_cnt==22) ? 8'h00 : (state==7 && sf_cnt==546) ? 9'h001 : (timer==0) ? y+9'h002 : y;
end

 

always @(posedge clk) begin
  if(rst_n==0) begin
    h_pulse  <= 8'h0;
    h1_pulse <= 8'h0;
  end else begin
    h_pulse  <= (hs_time ==1'b1 ) ? 75 : (h_pulse  !=0) ? h_pulse  -1 : 0;
    h1_pulse <= (hs1_time==1'b1 ) ? 75 : (h1_pulse !=0) ? h1_pulse -1 : 0;
  end
end

always @(posedge clk) begin
 if(rst_n==0) begin
   timer <= 12'h0;
 end else begin
   //timer <= (timer==3174) ? 12'h0 : timer+12'h001;
   timer <= (timer==FULL_TIMER) ? 12'h0 : timer+12'h001;
 end
end


endmodule

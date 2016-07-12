
module vid_score #(parameter POSITION = 114 )
                  (clk,
                   rst_n,
                   score,
                   vid_time,
                   x,
                   y,
                   num 
                  );

//Where to display the number of the score
localparam NUM_LOW = POSITION;
localparam NUM_HI  = POSITION+3;


input            clk;
input            rst_n;
input  wire[3:0] score;
input  wire      vid_time;
input  wire[8:0] x;
input  wire[7:0] y;
output reg       num;

always @(posedge clk) begin
   if(~rst_n) begin
      num <= 0;    //data used to display player 0 score
   end else begin
      case(score)
          0: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                        (vid_time==1 && (x==NUM_LOW || x==NUM_HI ) && (y>=19  && y<=32 ) ) ||
                        (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          1: begin
                num <= (vid_time==1 && (         x==NUM_HI ) && (y>=19  && y<=32 ) ) ;
             end
          2: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                        (vid_time==1 && (x==NUM_HI          ) && (y>=19  && y<=26 ) ) ||
                        (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                        (vid_time==1 && (x==NUM_LOW          ) && (y>=25  && y<=32 ) ) ||
                        (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          3: begin
                num <= (vid_time==1 && (x>=NUM_LOW    && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x>=(NUM_LOW+1) && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                       (vid_time==1 && (                   x==NUM_HI ) && (y>=19  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW     && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          4: begin
                num <= (vid_time==1 && (x==NUM_LOW          ) && (y>=19 && y<=26 ) ) ||
                       (vid_time==1 && (         x==NUM_HI ) && (y>=19 && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ;
             end
          5: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x==NUM_LOW          ) && (y>=19  && y<=26 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                       (vid_time==1 && (x==NUM_HI          ) && (y>=25  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          6: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x==NUM_LOW          ) && (y>=19  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                       (vid_time==1 && (x==NUM_HI          ) && (y>=25  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          7: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x==NUM_HI          ) && (y>=19  && y<=32 ) ) ;
             end
          8: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x==NUM_LOW          ) && (y>=19  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                       (vid_time==1 && (x==NUM_HI          ) && (y>=19  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
          9: begin
                num <= (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==19  || y==20 ) ) ||
                       (vid_time==1 && (x==NUM_LOW          ) && (y>=19  && y<=26 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==25  || y==26 ) ) ||
                       (vid_time==1 && (x==NUM_HI          ) && (y>=19  && y<=32 ) ) ||
                       (vid_time==1 && (x>=NUM_LOW && x<=NUM_HI ) && (y==31  || y==32 ) ) ;
             end
      endcase
   end
end

endmodule 

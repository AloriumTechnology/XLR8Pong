
module vid_driver(clk,
                  rst_n,
                  vid_time,
                  x,
                  y,
                  padl0,
                  padl1,
                  vid,
                  audio_o,
                  DEMO_MODE,
                  serv_ball,
                  game_rst,
                  ball_speed
                 );
input  clk;
input  rst_n;
input  vid_time;
input  wire[8:0] x;
input  wire[7:0] y;
input  wire[7:0] padl0;
input  wire[7:0] padl1;
input  DEMO_MODE;
input  serv_ball;
input  game_rst;
input  wire[1:0] ball_speed;

output reg vid;
output     audio_o;

localparam  X_L = 27;   //Left side of the screen 
localparam  X_R = 219;  //Right side of the screen
localparam  Y_T = 17;   //Top of the screen
localparam  Y_B = 243;  //Bottom of the screen

localparam  BAR      = 124;  //Center of the screen
localparam  NUM0_POS = BAR-10; //Position on the screen for Player0's score
localparam  NUM1_POS = BAR+7;  //Position on the screen for Player1's score
localparam  MISS     = 2'b01;
localparam  BOUNCE   = 2'b10;
localparam  HIT      = 2'b11;

//////////////////////////////////////////////////////////////////////////
//  num x pixels = 226                                                  //
//  num y pixels = 453                                                  //
//**********************************************************************//
//*24x17                                                       223x17  *//
//*                            124x130                                 *//
//*24x243                                                      223x243 *//
//**********************************************************************//
//////////////////////////////////////////////////////////////////////////

wire      num0,num1;
reg       ball;
reg [2:0] new_dir;  //000 no change, 101 decr, 110 incr, 111 straight
reg [2:0] newy_dir; //000 no change, 101 decr, 110 incr, 111 straight
reg       p0,p1,bar,xlr8;

reg [7:0] padl0_l; //captured paddle0 position low
reg [7:0] padl0_m0; //        paddle0 position middle low
reg [7:0] padl0_m1; //        paddle0 position middle hi
reg [7:0] padl0_h; //         paddle0 position high
reg       p0_hit;  //         paddle0 hit the ball

reg       stop_game;

reg [7:0] padl1_l; //captured paddle1 position low
reg [7:0] padl1_m0; //        paddle1 position middle low
reg [7:0] padl1_m1; //        paddle1 position middle hi
reg [7:0] padl1_h;  //        paddle1 position high
reg       p1_hit;   //        paddle1 hit the ball
reg [1:0] snd_sel;
reg [1:0] pad_snd_sel; 
reg [1:0] wall_snd_sel; 

reg      GO_GAME;
reg      winner;
reg[3:0] score0;
reg[3:0] score1;

reg       frame0;
reg       frame0_dly;
wire      sof;

reg[7:0] ballx;
reg[7:0] ballx_step;
reg[1:0] ballx_dir;  //0=none  1=decr 2=incr

reg[7:0] bally;
reg[7:0] bally_step;
reg[1:0] bally_dir;  //0=none  1=decr 2=incr

reg rst_n1;
reg rst_n2;
reg rst_n3;
reg rst_n4;

always @(posedge clk) begin
   if(!rst_n) begin
       GO_GAME <= 0;
   end else begin
       case( {serv_ball, stop_game})
          2'b00: GO_GAME <= GO_GAME;
          2'b01: GO_GAME <= 1'b0;
          2'b10: GO_GAME <= 1'b1;
          2'b11: GO_GAME <= 1'b1;
       endcase
   end
end


always @(posedge clk) begin
   if(!rst_n) begin
      vid <=0;
   end else begin
      vid <= ( p0   ||   //Paddle 0
               p1   ||   //Paddle 1
               num0 ||   //Num 0
               num1 ||   //Num 1
               ball ||   //Ball
               xlr8 ||
               bar ) ? 1'b1 : 1'b0; 
   end
end


always @(posedge clk) begin
    p0  <= ( vid_time==1 && (x>=25  && x<=26)  && (y>=padl0_l && y<=padl0_h) ) ; //Paddle0
    p1  <= ( vid_time==1 && (x>=221 && x<=222) && (y>=padl1_l && y<=padl1_h) ) ; //Paddle1
    bar <= ( vid_time==1 && (x==BAR) && (y>=18 && y<=243) ) ;                    //CenterBar
end

reg xx;
reg xl;
reg xr;
reg x8;

always @(posedge clk) begin
   xlr8 <= (vid_time==1 && winner==1 && (xx || xl || xr || x8) );

   xx   <= ( y==80 &&                              (x>=79 && x<=90 )) ||
           ((y==81 || y==82 || y==101|| y==102) && (x==91 || x==102)) ||
           ((y==83 || y==84 || y==99 || y==100) && (x==92 || x==101)) ||
           ((y==85 || y==86 || y==97 || y==98 ) && (x==93 || x==100)) ||
           ((y==87 || y==88 || y==95 || y==96 ) && (x==94 || x==99)) ||
           ((y==89 || y==90 || y==93 || y==94 ) && (x==95 || x==98)) ||
           ((y==91 || y==92)                    && (x==96 || x==97) );

   xl   <= (x>=110 && x<=119 && y==102) || (x==110 && y >=80 && y<= 102) ;

   xr   <= (x>=130 && x<=138 && y==80)   || (x==130 && y >=80 && y<=102) ||
           (x>=130 && x<=138 && y==91)   || (x==139 && y >=81 && y<= 90) ||

           (x==133 && (y==91  || y==92)) || (x==134 && (y==93 || y==94)) ||
           (x==135 && (y==95  || y==96)) || (x==136 && (y==97 || y==98)) ||
           (x==137 && (y==99  || y==100))|| (x==138 && (y==101 || y==102)) ||
           ((x>=139 && x<=151) && y==102);

   x8   <= ((x>=144 && x<=150)  && (y==85 || y==92 || y==99)) ||
           ((x==143 || x==151)  && y>=86 && y<=91) ||
           ((x==143 || x==151)  && y>=93 && y<=98) ;
end

//Capture Paddle 0 position
always @(posedge clk) begin
   if (sof==1) begin
      if(padl0 <= 17 ) begin
         padl0_l  <= 17;
         padl0_m0 <= 17+5;
         padl0_m1 <= 17+10;
         padl0_h  <= 17+14;
      end 
      if(padl0 > 17 && padl0<= 228) begin 
         padl0_l  <= padl0;
         padl0_m0 <= padl0+5;
         padl0_m1 <= padl0+10;
         padl0_h  <= padl0+15;
      end
      if(padl0 >  228) begin
         padl0_l  <= 229;
         padl0_m0 <= 229+5;
         padl0_m1 <= 229+10;
         padl0_h  <= 243;
      end 
   end 
end

//Capture Paddle 1 position
always @(posedge clk) begin
   if (sof==1) begin
       if(padl1 <= 17 ) begin
         padl1_l  <= 17;
         padl1_m0 <= 17+5;
         padl1_m1 <= 17+10;
         padl1_h  <= 17+14;
      end 
      if(padl1 > 17 && padl1<= 228) begin 
         padl1_l  <= padl1;
         padl1_m0 <= padl1+5;
         padl1_m1 <= padl1+10;
         padl1_h  <= padl1+15;
      end
      if(padl1 > 228) begin
         padl1_l  <= 229;
         padl1_m0 <= 229+5;
         padl1_m1 <= 229+10;
         padl1_h  <= 243;
      end 
   end 
end



reg[25:0] cnt;
always @(posedge clk) begin
   if(~rst_n) begin
      cnt <= 50000000;
   end else begin
      cnt <= (cnt!=0) ? cnt-1 : 50000000;
   end
end

always @(posedge clk) begin
   if(!rst_n) begin
       snd_sel <= 2'b00;
   end else begin
       snd_sel <= (pad_snd_sel!=0) ? pad_snd_sel : (wall_snd_sel != 0) ? wall_snd_sel : 2'b00;
   end
end


always @(posedge clk) begin
   if(~rst_n || game_rst) begin
      score0    <= 0;  //Player 0 Score
      score1    <= 0;  //Player 1 Score
      p0_hit    <= 0;
      p1_hit    <= 0;
      new_dir   <= 3'b100;
      stop_game <= 0;
      winner    <= 0;
      pad_snd_sel <= 2'b00;
   end else begin
      new_dir <= 3'b100;
      pad_snd_sel <= 2'b00;

      if( ! DEMO_MODE ) begin //if not Demo mode
         if(serv_ball) begin
            stop_game <= 1'b0;
         end

         //Player 0 Ball hit
         //
         if( ballx <= X_L ) begin
            if( (bally >= padl0_l)  &&  (bally <= padl0_h)) begin //Did Player 0 hit the ball
               p0_hit    <= 1'b1;
               stop_game <= 1'b0;
               pad_snd_sel   <= HIT;
               casez( { (bally >= padl0_l && bally < padl0_m0), (bally > padl0_m1 && bally <= padl0_h)} )
                  2'b01:   new_dir <= 3'b110; //Bottom of paddle deflect ball down
                  2'b10:   new_dir <= 3'b101; //Top of paddle deflect ball up
                  default: new_dir <= 3'b111; //Go straight
               endcase
            end else begin
               if(stop_game==0 && winner==0) score1 <= (score1==9) ? 9 : score1+1;
               if(score1==9) winner <= 1;
               p0_hit <=0;
               stop_game <= 1'b1;
               pad_snd_sel   <= MISS;
            end
         end

         //Player 1 Ball hit
         //
         if( ballx >= X_R ) begin
            if( (bally >= padl1_l)  &&  (bally <= padl1_h)) begin //Did Player 1 hit the ball
               p1_hit    <= 1'b1;
               stop_game <= 1'b0;
               pad_snd_sel   <= HIT;
               casez( { (bally >= padl1_l && bally < padl1_m0), (bally > padl1_m1 && bally <= padl1_h)} )
                  2'b01:   new_dir <= 3'b110; //Bottom of paddle deflect ball down
                  2'b10:   new_dir <= 3'b101; //Top of paddle deflect ball up
                  default: new_dir <= 3'b111; //go Straight
               endcase
            end else begin
               if(stop_game == 0 && winner==0) score0 <= (score0==9) ? 9 : score0+1;
               if(score0 == 9) winner <=1;
               p1_hit <=0;
               stop_game <= 1'b1;
               pad_snd_sel   <= MISS;
            end
         end 
      end else begin
         stop_game <= 1'b0;
      end
   end
end

vid_score #(.POSITION (NUM0_POS))
      p0_score (.clk      (clk),
                .rst_n    (rst_n),
                .score    (score0),
                .vid_time (vid_time),
                .x        (x),
                .y        (y),
                .num      (num0)
               );

vid_score #(.POSITION (NUM1_POS))
      p1_score (.clk      (clk),
                .rst_n    (rst_n),
                .score    (score1),
                .vid_time (vid_time),
                .x        (x),
                .y        (y),
                .num      (num1)
               );

always @(posedge clk) begin
    frame0_dly <= frame0;
    frame0     <= (vid_time==1 && x==0 && y==0);
end

assign sof = frame0 && ~frame0_dly;

reg[31:0]  new_sd;
wire[31:0] rnd_data;


always @(posedge clk) begin
  if(rst_n==0 && rst_n4==1) begin
     //seed <= 32'h9182f1ad;      
     new_sd <= 82582568;
  end else begin
     new_sd <= {rnd_data[30:0], rnd_data[31]};
  end
end

my_rand gen_rnd(.clk (clk),
                 .rst ( ((~rst_n) && (rst_n1))),
                 .seed0 (new_sd),
                 .num   (rnd_data)
                );

audio_driver audio(.clk     (clk),
                   .rst_n   (rst_n),
                   .snd_sel (snd_sel),
                   .audio_o (audio_o)
                  );


wire end_rst = (rst_n3==1) && (rst_n4==0);
wire [3:0] x_state = {end_rst, sof==1 , ballx_dir};
wire [3:0] y_state = {end_rst, sof==1 , bally_dir};

always @(posedge clk) begin
  if(~rst_n) begin
     bally_dir <= 2'b00;
  end else begin
     if(new_dir == 3'b111 || newy_dir == 3'b111) bally_dir <= 2'b00;  //Straigt
     if(new_dir == 3'b110 || newy_dir == 3'b110) bally_dir <= 2'b10;  //Ball down
     if(new_dir == 3'b101 || newy_dir == 3'b101) bally_dir <= 2'b01;  //Ball up
  end 
end

always @(posedge clk) begin
 if(~rst_n) begin
    ball <= 0;
    newy_dir <= 3'b100;
    wall_snd_sel <= 2'b00;
 end else begin
    ball <= (vid_time==1 && (GO_GAME||DEMO_MODE) && (x==ballx ) && (y==bally || y==bally+1 )) ? 1'b1 : 1'b0;
    wall_snd_sel <= 2'b00;

    casez( {(DEMO_MODE && end_rst),(GO_GAME|| DEMO_MODE), sof==1 , ballx_dir}) 
      5'b010??: ballx <= ballx;
      5'b01100: ballx <= ballx;
      5'b01101: begin //X decr   Ball Left
                 //if( ( DEMO_MODE==1 && ballx <= X_L) || (DEMO_MODE==0 && p0_hit)) begin           //Has the reached the left side?
                 if(ballx <= X_L ) begin
                    ballx <= ballx + ballx_step;  //if so change directiion and incr ball X
                    ballx_dir <= 2;
                    wall_snd_sel <= BOUNCE;
                 end else begin
                    ballx <= ballx - ballx_step;
                 end            
              end
      5'b01110: begin//X incr  Ball Right
                 //if( (DEMO_MODE==1 && ballx >= X_R) || (DEMO_MODE==0 && p1_hit))  begin           //Has the reached the right side?
                 if(ballx >= X_R ) begin
                    ballx <= ballx - ballx_step;  //if so change directiion and incr ball X
                    ballx_dir <= 1;
                    wall_snd_sel <= BOUNCE;
                 end else begin
                    ballx <= ballx + ballx_step;
                 end            
              end
      5'b01111: ballx <= ballx;
      5'b00???: begin
                  ballx      <= 124;
                  ballx_step <= ball_speed;
                  ballx_dir  <=  (rnd_data[13]==1) ? 2'b01 : 2'b10;
                end
      5'b1????: begin
                  ballx      <= 124;
                  ballx_step <= ball_speed;
                  ballx_dir  <=  (rnd_data[13]==1) ? 2'b01 : 2'b10;
               end
    endcase


    //Ball direction  2'b00 no change // 2'b01 Ball up (y--) // 2'b10 Ball down (y++) // 2'b11 no change
    casez( {(DEMO_MODE && end_rst),(GO_GAME || DEMO_MODE), sof==1 , bally_dir}) 
      5'b010??: begin 
                   bally <= bally;
                   newy_dir <= 3'b000;
                end
      5'b01100: begin
                   bally <= bally;
                   newy_dir <= 3'b000;
                end
      5'b01101: begin //Y decr   Ball up
                   if( bally <= Y_T ) begin  //Has the Ball reached the top OR Ball hit bottom paddle
                      bally <= bally + bally_step; //if so change directiion and incr ball X
                      newy_dir <= 3'b110;
                      wall_snd_sel <= BOUNCE;
                   end else begin
                      bally <= bally - bally_step;
                      newy_dir <= 3'b000;
                   end            
                end
      5'b01110: begin//Y incr   Ball down
                   if( bally >= Y_B ) begin  //Has the Ball reached the bottom OR Ball hit top of paddle
                      bally <= bally - bally_step;  //if so change directiion and incr ball X
                      newy_dir <= 3'b101;           //Ball needs to go up now
                      wall_snd_sel <= BOUNCE;
                   end else begin
                      bally <= bally + bally_step;
                      newy_dir <= 3'b000;
                   end            
                end
      5'b01111: begin
                   bally <= bally;
                   newy_dir <= 3'b000;
                end
      5'b00???: begin
                  bally      <=  rnd_data[6:0]+67;
                  case(rnd_data[9:8])
                     2'b00: newy_dir <= 3'b100;
                     2'b01: newy_dir <= 3'b101;
                     2'b10: newy_dir <= 3'b110;
                     2'b11: newy_dir <= 3'b111;
                  endcase

                  bally_step <= {6'h0, ball_speed};
                end
      5'b1????: begin//Y incr
                  bally      <=  rnd_data[6:0]+67;
                  case(rnd_data[9:8])
                     2'b00: newy_dir <= 3'b100;
                     2'b01: newy_dir <= 3'b101;
                     2'b10: newy_dir <= 3'b110;
                     2'b11: newy_dir <= 3'b111;
                  endcase

                  bally_step <= {6'h0,ball_speed};
                end
    endcase
    
 end //if(rst_n)
end //@always


always @(posedge clk) begin
  rst_n4 <= rst_n3;
  rst_n3 <= rst_n2;
  rst_n2 <= rst_n1;
  rst_n1 <= rst_n;
end


endmodule

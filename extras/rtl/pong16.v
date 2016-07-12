

module pong16 (sys_clk,
               rst_n,
               dm_sel,
               ramadr,
               ramwe,
               ramre,
               dbus_in,
               vid_sync_o,
               vid_o,
               audio_o
              );
//INPUTS
input logic      sys_clk;
input logic      rst_n;
input wire       dm_sel;
input wire       ramwe;
input wire       ramre;
input wire [7:0] ramadr;
input [7:0]      dbus_in;

//OUTPUTS
output      vid_sync_o;
output      vid_o;
output      audio_o;

`include "xb_adr_pack.vh"

//localparam PAD0_ADDR  = 8'hE0;
//localparam PAD1_ADDR  = 8'hE1;
//localparam PNGCR_ADDR = 8'hE2;

wire vid_sync;
wire vid;

reg vid_sync_o;
reg vid_o;

reg       rst_clk=0;
always @(posedge sys_clk) begin
   rst_clk <= ~rst_clk;
end

reg[7:0]  PAD0;
reg[7:0]  PAD1;
reg       DEMO_MODE;
wire      serv_ball;
wire      game_rst;
reg[3:0]  serv_ball_cnt;
reg[3:0]  game_rst_cnt;
reg[1:0]  ball_speed;

assign pad0_sel  = (dm_sel && ramadr == PAD0_ADDR);
assign pad1_sel  = (dm_sel && ramadr == PAD1_ADDR);
assign pngcr_sel = (dm_sel && ramadr == PNGCR_ADDR);

assign pad0_we   = pad0_sel & ramwe;
assign pad1_we   = pad1_sel & ramwe;
assign pngcr_we  = pngcr_sel & ramwe;


always @(posedge sys_clk) begin
  if(!rst_n) begin
     PAD0 <= 100;
  end else if( pad0_we) begin
     PAD0  <= dbus_in ;
  end
end

always @(posedge sys_clk) begin
  if(!rst_n) begin
     PAD1 <= 100;
  end else if( pad1_we) begin
     PAD1  <= dbus_in ;
  end
end

//Serve the Ball
assign serv_ball = | serv_ball_cnt;
always @(posedge sys_clk) begin
  if(!rst_n) begin
     serv_ball_cnt <= 0; 
  end else begin
     serv_ball_cnt <= (pngcr_we && dbus_in[1] ) ? 10 : (serv_ball_cnt != 0) ? serv_ball_cnt-1 : 0;
  end
end

//Game reset
assign game_rst = | game_rst_cnt;
always @(posedge sys_clk) begin
  if(!rst_n) begin
     game_rst_cnt <= 0; 
  end else begin
     game_rst_cnt <= (pngcr_we && dbus_in[0] ) ? 10 : (game_rst_cnt != 0) ? game_rst_cnt-1 : 0;
  end
end

//Ball Speed  PNGCR[4] sets ball speed to 2 to 1
always @(posedge sys_clk) begin
  if(!rst_n) begin
     ball_speed <= 2'b01;
  end else if( pngcr_we) begin
     ball_speed <= (dbus_in[4]==1) ? 2'b10 : 2'b01;
  end
end

// DEMO MODE
always @(posedge sys_clk) begin
  if(!rst_n) begin
     DEMO_MODE <= 1;
  end else if( pngcr_we) begin
     DEMO_MODE <= dbus_in[7];
  end
end

reg[23:0] cntr;
reg       rst_na;
always @(posedge rst_clk) begin
  if(~rst_n) begin
     cntr <= 400;
  end else begin
     cntr <= (cntr!=0) ? cntr-1 : 0;
  end
end

always @(negedge rst_clk) begin
  if(~rst_n) begin
     rst_na <= 1'b1;
  end else begin
     rst_na <= (cntr>10 && cntr <200) ? 1'b0 : 1'b1;
  end
end

always @(posedge sys_clk) begin
  vid_sync_o <= vid_sync;
  vid_o <= vid;
end


wire[8:0] x,y;
wire      vid_time;



//Video timing logic
//
vid_timer16 v_timer(.clk       (sys_clk),
                    .rst_n     (rst_na),
                    .vid_sync  (vid_sync),
                    .vid_time  (vid_time),
                    .x         (x),
                    .y         (y)
                   );

//Video driver
//
vid_driver v_drvr(.clk        (sys_clk),
                  .rst_n      (rst_na),
                  .vid_time   (vid_time),
                  .x          (x),
                  .y          (y[8:1]), 
                  .vid        (vid),
                  .audio_o    (audio_o),
                  .padl0      (PAD0),
                  .padl1      (PAD1),
                  .DEMO_MODE  (DEMO_MODE),
                  .serv_ball  (serv_ball),
                  .game_rst   (game_rst),
                  .ball_speed (ball_speed)
                 );
endmodule

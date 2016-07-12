module my_rand(clk,
               rst,
               seed0,
               num
              );

input clk;
input rst;
input [31:0]  seed0;

output [31:0] num;

reg [31:0] num;
reg [31:0] seed;
reg [31:0] seed1,seed2;
reg [5:0]  rst_d;

always @(posedge clk) begin
  rst_d <= {rst_d[4:0], rst};
end

wire rnd_rst = | rst_d ;

always @(posedge clk) begin
      seed <= seed0;
end


always @(posedge clk) begin
    num = seed ^ seed1 ^ ~seed2;
end

always @(posedge clk or posedge rnd_rst) begin
  if(rnd_rst) begin
    seed1 = 32'hab312def;
    seed2 = 32'hcd975130;
  end else begin
	seed1[31] = seed2[00]|  ~seed1[09]| seed1[13];
	seed1[30] =  ~seed[17]^  ~seed1[06]|  ~seed2[01];
	seed1[29] = seed1[08]^  ~seed[07]^ seed1[03];
	seed1[28] = seed2[20]^ seed1[02]&  ~seed2[01];
	seed1[27] =  ~seed1[01]& seed[18]^  ~seed1[13];
	seed1[26] = seed[04]^ seed[16]|  ~seed2[22];
	seed1[25] =  ~seed2[20]| seed1[14]^  ~seed[05];
	seed1[24] =  ~seed[04]^ seed[20]&  ~seed1[22];
	seed1[23] = seed[15]^  ~seed2[07]^ seed1[08];
	seed1[22] = seed2[05]| seed1[13]^ seed1[20];
	seed1[21] =  ~seed1[12]& seed[14]^  ~seed1[16];
	seed1[20] =  ~seed[11]^  ~seed1[11]^ seed2[01];
	seed1[19] = seed2[00]^ seed[08]^  ~seed2[18];
	seed1[18] =  ~seed1[13]^ seed2[08]^ seed2[15];
	seed1[17] =  ~seed[12]&  ~seed[16]| seed[15];
	seed1[16] =  ~seed2[14]|  ~seed1[17]|  ~seed[20];
	seed1[15] =  ~seed[18]&  ~seed1[08]^ seed2[07];
	seed1[14] = seed[13]^  ~seed[15]^  ~seed1[12];
	seed1[13] = seed[10]^  ~seed1[13]^  ~seed[22];
	seed1[12] =  ~seed2[07]& seed2[03]& seed2[01];
	seed1[11] =  ~seed[06]^  ~seed2[11]|  ~seed1[02];
	seed1[10] = seed1[19]^ seed1[03]^  ~seed1[22];
	seed1[09] = seed[15]^ seed2[11]^  ~seed1[10];
	seed1[08] =  ~seed1[15]^ seed2[22]^ seed[07];
	seed1[07] =  ~seed1[10]&  ~seed2[10]| seed[01];
	seed1[06] =  ~seed2[05]^  ~seed[16]^  ~seed1[01];
	seed1[05] = seed1[22]&  ~seed2[00]^ seed1[07];
	seed1[04] = seed[12]&  ~seed1[15]^  ~seed[02];
	seed1[03] =  ~seed2[22]&  ~seed[12]|  ~seed1[03];
	seed1[02] = seed2[17]^  ~seed1[02]^  ~seed1[21];
	seed1[01] = seed2[05]^  ~seed2[09]^  ~seed[02];
	seed1[00] = seed1[31] ^ seed2[16]^  ~seed1[14];


	seed2[31] =  ~seed1[20]& seed1[14]^ seed1[18];
	seed2[30] = seed1[12]&  ~seed1[04]^  ~seed[15];
	seed2[29] =  ~seed2[04]^ seed1[02]| seed1[02];
	seed2[28] = seed2[15]^  ~seed[10]| seed[15];
	seed2[27] = seed2[04]& seed[01]^ seed1[18];
	seed2[26] =  ~seed[09]^ seed1[22]^  ~seed1[20];
	seed2[25] =  ~seed[08]|  ~seed[19]^  ~seed[02];
	seed2[24] = seed[19]^ seed1[09]|  ~seed[08];
	seed2[23] = seed1[21]^ seed1[13]^  ~seed2[02];
	seed2[22] = seed2[16]|  ~seed[03]|  ~seed2[17];
	seed2[21] = seed[07]| seed1[20]^ seed1[13];
	seed2[20] =  ~seed2[22]& seed[22]& seed1[15];
	seed2[19] = seed[06]& seed2[04]^ seed2[12];
	seed2[18] = seed2[21]^ seed2[01]^  ~seed2[21];
	seed2[17] =  ~seed1[00]^  ~seed[15]^ seed2[08];
	seed2[16] =  ~seed2[21]^  ~seed1[07]^  ~seed1[06];
	seed2[15] =  ~seed2[20]^ seed[20]| seed1[00];
	seed2[14] =  ~seed2[09]^ seed2[18]^ seed1[14];
	seed2[13] =  ~seed[02]&  ~seed[08]^  ~seed1[02];
	seed2[12] =  ~seed[10]| seed1[19]^  ~seed2[03];
	seed2[11] = seed[02]^  ~seed[15]^ seed[11];
	seed2[10] = seed[15]^  ~seed1[19]^  ~seed[03];
	seed2[09] =  ~seed2[14]^ seed2[22]^  ~seed1[06];
	seed2[08] = seed[02]^ seed1[21]|  ~seed2[15];
	seed2[07] =  ~seed1[17]^ seed1[03]^ seed1[18];
	seed2[06] =  ~seed[21]^ seed1[16]^  ~seed1[22];
	seed2[05] = seed2[20]^ seed2[10]|  ~seed[09];
	seed2[04] = seed2[18]|  ~seed[21]^  ~seed[14];
	seed2[03] = seed2[14]^  ~seed1[13]^  ~seed[10];
	seed2[02] =  ~seed2[06]|  ~seed[03]^  ~seed[15];
	seed2[01] =  ~seed2[03]^  ~seed[13]| seed1[05];
	seed2[00] =  ~seed2[31] &  ~seed[15]&  ~seed1[22];



  end
end
endmodule

`timescale 1ns/1ps

module stopwatch(
	input clk,
	input btnL,
    input btnR,
    input [1:0] sw,
    output [3:0] an,
    output [6:0] seg
);

// all are clock enables!
wire clk_en_100hz;
wire clk_en_1hz;
wire clk_en_2hz;
wire clk_en_4hz;

wire sel, adj, rst, pause;

wire [3:0] sec;
wire [2:0] ten_sec;
wire [3:0] min;
wire [2:0] ten_min;

clock clock_inst(
    .clk(clk),
    .rst(rst),
    .second(clk_en_1hz),
    .adjust(clk_en_2hz),
    .blink(clk_en_4hz),
    .display(clk_en_100hz)
);

counter counter_inst(
    .clk(clk),
    .rst(rst),
    .second(clk_en_1hz),
    .adj_clk(clk_en_2hz),
    .adj(adj),
    .sel(sel),
    .pause(pause),
    .sec(sec),
    .ten_sec(ten_sec), 
	.min(min), 
	.ten_min(ten_min)
);
    
input_processing mod2(
    .clk(clk), 
	.btnL(btnL),
	.btnR(btnR),
	.sw(sw),
	.sel(sel),
	.adj(adj),
//	.rst(btnL),
	.pause(pause),
	.reset(rst)
);

display mod4(
    .clk(clk),
    .rst(rst),
    .clk_refresh(clk_en_100hz),	
	.clk_blink(clk_en_4hz),
	.adj(adj), 
	.sel(sel),
	.sec(sec), 
	.ten_sec(ten_sec), 
	.min(min), 
	.ten_min(ten_min),
	.seg(seg),
	.an(an)
);


endmodule
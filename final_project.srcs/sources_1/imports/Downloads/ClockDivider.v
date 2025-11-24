`timescale 1ns/1ps

module clock (
	input clk, //100 MHz - master clock <-- this one to track reaction time (in milliseconds)
	// THESE ARE CLOCK ENABLES
	output reg second, // 1 Hz <-- this one to track game time left
	output reg display, // 100 Hz <-- should use this one to do seven segment display
	output reg led //8 Hz <-- should use this one to turn on the LEDs
    );

	reg [19:0] div_hundred; // should hold the count to 100 Hz
	reg [26:0] div_one; //should hold the count to 1 Hz
	reg [23:0] div_eight; //should hold the count to 8 Hz

	always @(posedge clk) begin
		if (div_hundred == 499999) begin
			div_hundred <= 0;
			display <= 1'b1;
		end else begin
			div_hundred <= div_hundred + 1;
			display <= 1'b0;
		end
	
		if (div_one == 99999999) begin
			div_one <= 0;
			second <= 1'b1;
		end else begin
			div_one <= div_one + 1;
			second <= 1'b0;    
		end 

		if (div_eight == 12499999) begin
			div_eight <= 0;
			led <= 1'b1;
		end else begin
			div_eight <= div_eight + 1;
			led <= 1'b0;
		end
	end
endmodule
		

		
	

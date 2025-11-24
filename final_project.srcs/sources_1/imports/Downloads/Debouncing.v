module input_processing(
	input clk, //100 MHz clock
	input btnU, //start button
	input btnA,
	input btnB, 
	input btnC,
	input btnD,
	input [15:14] sw, //im not sure how many switches we are going to use
	output reg start,
	output reg a,
	output reg b,
	output reg c,
	output reg d,
	output reg sw15,
	output reg sw14
);
// need to make s.t. if multiple keypad buttons pressed, nothing should happen
//synchronize inputs w/ 2 flip flops
reg [1:0] sync_sw15, sync_sw14; //not sure how many switches
reg [1:0] sync_btnU, sync_btnA, sync_btnB, sync_btnC, sync_btnD;

always @(posedge clk) begin

    if (start == 1'b1) begin
        sync_sw15 <= 2'b00;
        sync_sw14 <= 2'b00;
	
        sync_btnU <= 2'b00;
        sync_btnA <= 2'b00;
	sync_btnB <= 2'b00;
	sync_btnC <= 2'b00;
	sync_btnD <= 2'b00;

    end else begin //two flip flops 

        sync_sw15[0] <= sw[15];
        sync_sw15[1] <= sync_sw0[0];
    
        sync_sw14[0] <= sw[14];
        sync_sw14[1] <= sync_sw14[0];
        
        //buttons
        sync_btnU[0] <= btnU;
        sync_btnU[1] <= sync_btnU[0];
        
        sync_btnA[0] <= btnA;
        sync_btnA[1] <= sync_btnA[0];

	sync_btnB[0] <= btnB;
        sync_btnB[1] <= sync_btnB[0];

	sync_btnC[0] <= btnC;
        sync_btnC[1] <= sync_btnC[0];

	sync_btnD[0] <= btnD;
        sync_btnD[1] <= sync_btnD[0];
	end
end   

//debouncing make sure it has been 'on' for two samples (2ms)
reg [1:0] deb_sw15, deb_sw14;
reg [1:0] deb_btnU, deb_btnA, deb_btnB, deb_btnC, deb_btnD;

reg stable_sw15, stable_sw14;
reg stable_btnU, stable_btnA, stable_btnB, stable_btnC, stable_btnD;

always @(posedge clk) begin

    if (start == 1'b1) begin
        deb_sw15 <= 2'b00;
        deb_sw14 <= 2'b00;
        deb_btnL <= 2'b00;
        deb_btnR <= 2'b00;
        stable_sw0 <= 1'b0;
        stable_sw1 <= 1'b0;
        stable_btnL <= 1'b0;
        stable_btnR <= 1'b0;

    end else begin

        deb_sw15[0] <= deb_sw15[1];
        deb_sw15[1] <= deb_sw15[0];
    
        deb_sw14[0] <= deb_sw14[1];
        deb_sw14[1] <= deb_sw14[0];
    
        deb_btnU[0] <= deb_btnU[1];
        deb_btnU[1] <= deb_btnU[0];
    
        deb_btnA[0] <= deb_btnA[1];
        deb_btnA[1] <= deb_btnA[0];

	deb_btnB[0] <= deb_btnB[1];
        deb_btnB[1] <= deb_btnB[0];

	deb_btnC[0] <= deb_btnC[1];
        deb_btnC[1] <= deb_btnC[0];

	deb_btnD[0] <= deb_btnD[1];
        deb_btnD[1] <= deb_btnD[0];
	end
	//if both are 11 switch is on, if both 00 switch is off, if diff current state
	stable_sw15 <= (deb_sw15 == 2'b11) ? 1'b1 : (deb_sw15 == 2'b00) ? 1'b0 : stable_sw15;
	stable_sw14 <= (deb_sw14 == 2'b11) ? 1'b1 : (deb_sw14 == 2'b00) ? 1'b0 : stable_sw14;
	stable_btnU <= (deb_btnU == 2'b11) ? 1'b1 : (deb_btnU == 2'b00) ? 1'b0 : stable_btnU;
	stable_btnA <= (deb_btnA == 2'b11) ? 1'b1 : (deb_btnA == 2'b00) ? 1'b0 : stable_btnA;
	stable_btnB <= (deb_btnB == 2'b11) ? 1'b1 : (deb_btnB == 2'b00) ? 1'b0 : stable_btnB;
	stable_btnC <= (deb_btnC == 2'b11) ? 1'b1 : (deb_btnC == 2'b00) ? 1'b0 : stable_btnC;
	stable_btnD <= (deb_btnD == 2'b11) ? 1'b1 : (deb_btnD == 2'b00) ? 1'b0 : stable_btnD;
end

reg prev_btnU, prev_btnA, prev_btnB, prev_btnC, prev_btnD;

//detect Button Pressed: 0 -> 1
wire btnU_pressed_edge = stable_btnU && !prev_btnU; // start
wire btnA_pressed_edge = stable_btnA && !prev_btnA; // A
wire btnB_pressed_edge = stable_btnB && !prev_btnB; // B
wire btnC_pressed_edge = stable_btnC && !prev_btnC; // C
wire btnD_pressed_edge = stable_btnD && !prev_btnD; // D

//assign button values
always @(posedge clk) begin

    if (start == 1'b1) begin
       	prev_btnU <= 1'b0;
        prev_btnA <= 1'b0;
	prev_btnB <= 1'b0;
	prev_btnC <= 1'b0;
	prev_btnD <= 1'b0;
        start <= 1'b0;
        a <= 1'b0;
	b <= 1'b0;
	c <= 1'b0;
	d <= 1'b0;

    end else begin
       	prev_btnU <= stable_btnU;
        prev_btnA <= stable_btnA;
	prev_btnB <= stable_btnB;
	prev_btnC <= stable_btnC;
	prev_btnD <= stable_btnD;

	start <= btnU_pressed_edge;
	a <= btnA_pressed_edge;
	b <= btnB_pressed_edge;
	c <= btnC_pressed_edge;
	d <= btnD_pressed_edge;
    end
end

//assign switch values
always @(posedge clk) begin
    if (start == 1'b1) begin
        sw15 <= 1'b0;
        sw14 <= 1'b0; 
    end else begin
        sw15 <= stable_sw15;
        sw14 <= stable_sw14;
    end
end 

endmodule
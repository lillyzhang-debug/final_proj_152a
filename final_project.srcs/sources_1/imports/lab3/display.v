module display(
    input clk,
	input clk_refresh,	//100 hz
	input clk_blink,	//4 hz
	input adj, 
	input sel,
	input rst, // mode
	input [3:0] ones, 
	input [2:0] tens, 
	input [3:0] hundreds, // dont need minutes
	input [2:0] thousands,
	input [3:0] LED_on,
	output reg [6:0] seg,
	output reg [3:0] an,
	output reg [3:0] led // check if low is on 
);
	
	reg [1:0] digit_sel;    
	reg flash_state;
	initial begin
        digit_sel <= 2'b00; 
        flash_state <= 0;
    end 
   //choose which digit to change
	reg [3:0] curr_digit;
	reg [6:0] seg_pattern;
	reg flash_this_digit = 0;
    
	always @(posedge clk) begin
	//loop through which digit to light up every 100 hz
	   if (rst == 1'b1) begin
	       digit_sel <= 2'b00;
	       flash_state <= 1'b0;
	   end else if(clk_refresh == 1'b1)
		  digit_sel <= digit_sel + 1; 
	//determine if it should be lit up or not every 4hz
	   if (clk_blink == 1'b1 && rst == 1'b0)  
           flash_state <= ~flash_state;
	end

	always @(*) begin //select the digit
		case(digit_sel)
			2'b00: begin
				an = 4'b1110;
				curr_digit = ones;
			end
			2'b01: begin
				an = 4'b1101;
				curr_digit = tens;
			end
			2'b10: begin
				an = 4'b1011;
				curr_digit = hundreds;
			end
			2'b11: begin
				an = 4'b0111;
				curr_digit = thousands;
			end
			default: begin
                an = 4'b1111; // All anodes off
                curr_digit = 4'd0;
            end
		endcase
		
	//seven-segment display number (0-9)
	//change the seven segment display for the selected digit
		case (curr_digit)
            4'd0: seg_pattern = 7'b1000000; //set to 0
            4'd1: seg_pattern = 7'b1111001;	//set to 1
            4'd2: seg_pattern = 7'b0100100; //set to 2
            4'd3: seg_pattern = 7'b0110000; //set to 3
            4'd4: seg_pattern = 7'b0011001; //set to 4
            4'd5: seg_pattern = 7'b0010010; //set to 5
            4'd6: seg_pattern = 7'b0000010; //set to 6
            4'd7: seg_pattern = 7'b1111000; //set to 7
            4'd8: seg_pattern = 7'b0000000; //set to 8
            4'd9: seg_pattern = 7'b0010000; //set to 9
            default: seg_pattern = 7'b1111111;
		endcase


	//determine whether current digit needs to flash
	flash_this_digit = 0;
	   if (adj == 1) begin
        	case (digit_sel)
            	2'b00, 2'b01: flash_this_digit = sel ? 1'b1:1'b0; // seconds (flash if sel is 1)
				2'b10, 2'b11: flash_this_digit = sel ? 1'b0:1'b1; // minutes (flash if sel is 0)
        	endcase
		end

	//actually flash the digit
        if (flash_this_digit && flash_state)
           	seg = 7'b1111111;  //blank for flashing
        else
            seg = seg_pattern; 
            
        case (LED_on)
            2'b00: led = 4'b1110; // need to check if 0 is high
            2'b01: led = 4'b1101;
            2'b10: led = 4'b1011;
            2'b11: led = 4'b0111;
            default: led = 4'b1111;
         endcase
            
    end
endmodule 
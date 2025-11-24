`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 11:27:11 PM
// Design Name: 
// Module Name: random_number_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module random_number_generator(
    input clk, // every .8 sec
    input rst,
    input generate_num, // when high, generate next number
    output reg [7:0] rand_num,
    output reg [1:0] led_to_flash
    );

// generate a new bit by XORing the values of bits 7,5,4, and 3
// aka feedback bit
assign feedback = rand_num[2] ^ rand_num[3] ^ rand_num[4] ^ rand_num[6]; 

reg [7:0] seed_val = 8'b11010110; // temporary seed value;

always @(posedge clk) begin
    if(rst) begin
        rand_num <= seed_val;
    end
    
    if (generate_num) begin
        // shift bits left and insert feedback at LSB
        rand_num[6] <= {rand_num[6:0], feedback};
        led_to_flash = rand_num % 4; // we only have 4 LEDs to choose between
    end
end
       
endmodule

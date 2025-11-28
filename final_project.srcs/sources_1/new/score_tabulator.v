`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 05:40:05 PM
// Design Name: 
// Module Name: score_tabulator
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
// handles score calcuations and splitting up the score for the display
module score_top_module (
    input clk,
    input game_mode,
    input reset,
    input user_hit,
    input [10:0] reaction_time,
    output [3:0] ones,
    output [3:0] tens,
    output [3:0] hundreds,
    output [3:0] thousands
    );
    
    wire [13:0] current_score; 
    
    score_tabulator (
        .clk(clk),
        .reaction_time(reaction_time),
        .game_mode(game_mode),
        .reset(reset),
        .user_hit(user_hit)
        );
    
    score_parser (
        .score(current_score)
        );
    
endmodule
    

// take in user's reaction time, calculate points gained, and add to current score value
// if reset, reset game mode
// if game_mode == 0, don't do anything
module score_tabulator (
    input clk,
    input [10:0] reaction_time, // user's reaction time to press button
    input game_mode,
    input reset,
    input user_hit,
    output reg [13:0] current_score
    );

    reg [10:0] diff;

always @(posedge clk) begin
    if (reset) begin
        current_score <= 0;
    end
    else if (user_hit) begin
        current_score <= current_score + (800 - reaction_time); // this is the additive score
    end
end
        
endmodule
 
 
  // takes score reg and breaks it down for the display
 module score_parser (
    input [13:0] score,
    output [3:0] ones,
    output [3:0] tens,
    output [3:0] hundreds,
    output [3:0] thousands
    );
    
    assign ones = score % 10;
    assign tens = (score/10) % 10;
    assign hundreds = (score/100) % 10;
    assign thousands = (score/1000) % 10;
    
endmodule

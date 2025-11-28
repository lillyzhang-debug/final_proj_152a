`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 07:35:55 PM
// Design Name: 
// Module Name: score_tab_tb
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


module score_tab_tb();
    reg clk;
    reg reset;
    reg user_hit;
    reg [10:0] reaction_time;
    
    wire [13:0] current_score;
    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] hundreds;
    wire [3:0] thousands;
    
    score_tabulator uut (
        .clk(clk),
        .reaction_time(reaction_time),
        .game_mode(game_mode),
        .reset(reset),
        .user_hit(user_hit)
        );
    
    score_parser uut_2 (
        .score(current_score)
        );
        
    // clock gen
    always #0.5 clk =~clk;
    
    initial begin
        $display("begin score tabulator test");
        
        clk = 0;
        reset = 0;
        user_hit = 0;
        reaction_time = 0;
        
        if (current_score == 0) $display("PASS: Score is 0 after reset.");
        else $display("FAIL: Score is %d after reset.", current_score);

        // --- TEST 2: FIRST HIT (Standard Speed) ---
        // Reaction time = 200ms. Formula: 800 - 200 = 600 points.
        $display("Test 2: Simulating 200ms reaction time...");
        
        reaction_time = 200;
        user_hit = 1; // Pulse high
        #1;           // Wait one clock cycle
        user_hit = 0; // Pulse low
        #10;          // Wait for logic to settle
        
        if (current_score == 600) 
            $display("PASS: Score is 600.");
        else 
            $display("FAIL: Score is %d (Expected 600).", current_score);

        // --- TEST 3: SECOND HIT (Fast Speed) ---
        // Reaction time = 50ms. Formula: 800 - 50 = 750 points.
        // Total should be: 600 + 750 = 1350.
        $display("Test 3: Simulating 50ms reaction time (accumulate)...");
        
        reaction_time = 50;
        user_hit = 1;
        #1;
        user_hit = 0;
        #10;
        
        if (current_score == 1350) 
            $display("PASS: Score is 1350.");
        else 
            $display("FAIL: Score is %d (Expected 1350).", current_score);

        // --- TEST 4: NO HIT (Stability Check) ---
        // Ensure score doesn't change if user_hit is 0, even if reaction_time changes
        $display("Test 4: Checking stability (no hit pulse)...");
        reaction_time = 100; // Changing input
        #20;                 // Waiting
        
        if (current_score == 1350) 
            $display("PASS: Score remained stable at 1350.");
        else 
            $display("FAIL: Score changed to %d unexpectedly.", current_score);

        // --- TEST 5: FINAL RESET ---
        $display("Test 5: Final Reset...");
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        if (current_score == 0) $display("PASS: Score reset to 0.");
        else $display("FAIL: Score did not reset.");

        $finish;
    end
        
        
endmodule

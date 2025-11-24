module controller (
    input countdown, // actual seconds
    input display_clk, // to cycle digits
    input ms_clock, // flash leds @ certain intervals of this
    input [1:0] keypad,
    input [2:0] sw,
    input start, // reset/start button, maybe done outside
    input [13:0] score,
    input mode,
    input [1:0] LED_2_disp,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands,
    output reg [3:0] LED_on
    );
reg [4:0] duration = 0;
reg started = 0; // have we started the game
reg [1:0] start_up = 3; // do startup actions before actually starting
reg [14:0] count;
integer i = 0;
    // always on the ms, update display based on if in menu = 0, game = 1
    always @(posedge ms_clock) begin
        if(mode == 0) begin
            // set seven seg display to the score
            ones <= score % 10;
            tens <= (score/10) % 10;
            hundreds <= (score/100) % 10;
            thousands <= score/1000;
            started <= 0;
            start_up <= 3; // ?
            if (duration != 0) begin
                //flash final score here
            end
        end
        if(mode == 1) begin
            // check sw to determine game mode
            // if more than one sw is flipped, just flash final score and return mode to 0
            if (started == 0) begin
                if (sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
                    duration <= 10;
                    started <= 1;
                end
                if (sw[0] == 0 && sw[1] == 1 && sw[2] == 0) begin
                    duration <= 20;
                    started <= 1;
                end
                if (sw[0] == 0 && sw[1] == 1 && sw[2] == 0) begin
                    duration <= 20;
                    started <= 1;
                end
                else begin
                    // final score should already be set
                    duration <= 3; // want to flash for 3 seconds
                    // directly flash the final score here???
                    started <= 0; // have not started the game
                end
            end
            if (started == 1) begin
                if (start_up) begin
                    // flash duration on display, 3 times per second
                    // ideally this blinks? probably do that somewhere else
                    ones <= 0;
                    tens <= duration/10;
                    hundreds <= 0;
                    thousands <= 0;
                    start_up <= start_up - 1; // set back to 3 at game end
                end
                else begin
                    count <= count + 1;
                    // if we've reached .8 ms increment, flash a random LED and turn all others off no matter what
                    if (count % 800 == 0) begin
                        // check which rand LED is to be flashed
                        // set it to on until the user presses or time runs out
                        for(i = 0; i < 4; i = i + 1) begin
                            if(i == LED_2_disp)
                                LED_on[LED_2_disp] <= 1;
                            else
                                LED_on[i] <= 0;
                         end
                    end
                    // check if the user has pressed the right button
                    // if so turn the flashed LED off
                    for (i = 0; i < 4; i = i + 1) begin
                        if(LED_2_disp == keypad)
                            LED_on[LED_2_disp] <= 0;
                    end
                 end
            end    
                                
        end 
    end
    
    // 
 endmodule
    
    
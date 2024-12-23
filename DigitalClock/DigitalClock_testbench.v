module clock_testbench;
    reg clk = 0;
    reg reset;
    wire [3:0] sec_ones, sec_tens, min_ones, min_tens, hour_ones, hour_tens;

    DigitalClock uut (
        .clk(clk),
        .reset(reset),
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min_ones(min_ones),
        .min_tens(min_tens),
        .hour_ones(hour_ones),
        .hour_tens(hour_tens)
    );

    // Generate a clock signal
    always #10 clk = ~clk; // 50 MHz clock simulation (20 ns period)

    initial begin
        reset = 1;                  // Do reset
        #50 reset = 0;              // Release reset
        #500000000;                 // Simulate for a long duration
        $stop;
    end
endmodule
module TrafficLightFSM_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire [2:0] light;

    // Instantiate the TrafficLightFSM module
    TrafficLightFSM uut (
        .clk(clk),
        .reset(reset),
        .light(light)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 ns
    end

     // Test sequence
    initial begin
        // simulation dump file 
        $dumpfile("TrafficLightFSM_tb.vcd");
        $dumpvars(0, TrafficLightFSM_tb);

        // Apply reset
        $display("Starting simulation...");
        reset = 1;
        #10;
        reset = 0;

        // Light transitions
        $display("Time(ns) | Reset | Light State");
        $monitor("%0dns | %b     | %b", $time, reset, light);

        // Run for a few clock cycles
        #100;

        // Test with reset during operation
        $display("Applying reset during operation...");
        reset = 1;
        #10;
        reset = 0;

        // Run for a few clock cycles
        #100;

        // End simulation
        $display("Ending simulation.");
        $finish;
    end
endmodule
# Traffic Light FSM in Verilog

## Author: Nima Bargestan
## Date: 12/25/2024

### Description:
This Verilog module implements a Traffic Light Finite State Machine (FSM) that simulates the sequencing of traffic lights (RED, YELLOW, GREEN). The FSM transitions through these states based on a configurable timer input. The timer is an 18-bit value, where each 6 bits defines the duration of each light state (RED, YELLOW, and GREEN). The FSM also includes error detection for invalid timer configurations and a pause/resume functionality for the FSM operation.

### Features:
- **Sequential State Transitions**: The FSM cycles through the RED, YELLOW, and GREEN states.
- **Configurable Timers**: The duration for each light state is determined by an 18-bit input (`timer_config`), with 6 bits assigned to each light state.
- **Error Handling**: If the timer input is invalid (any state duration is zero), the FSM enters an error state and sets the `error_status` flag.
- **Pause/Resume Control**: The FSM can be paused and resumed using the `enable` signal.

### Inputs:
- `clk`: Clock signal (1-bit)
- `reset`: Reset signal (1-bit)
- `timer_config`: 18-bit timer input in the format `RRRRRR | YYYYYY | GGGGGG`, where each 6-bit block defines the duration for the RED, YELLOW, and GREEN states, respectively.
- `enable`: Enable signal to pause/resume FSM operation.

### Outputs:
- `light`: 3-bit output representing the current light state:
  - `RED`: 3'b100
  - `YELLOW`: 3'b010
  - `GREEN`: 3'b001
  - `ERROR`: 3'b111 (if the timer input is invalid)
- `error_status`: 1-bit error flag indicating whether an invalid timer configuration has been detected.

### How to Use:
1. `TrafficLightFSM` Module: This module can be integrated into a larger design where a traffic light sequence is needed. Configure the timer_config input to specify the desired duration for each state.
2. `TrafficLightFSM_tb` Testbench Module : The provided testbench simulates different scenarios such as valid timer configurations, error detection, and pause/resume functionality. It also monitors the outputs for correctness.

### Usage:
```bash
$ cd TrafficLight
$ iverilog TrafficLightFSM.v TrafficLightFSM_tb.v
$ vvp a.out
```
*The Testbench also creates dumpfile for wave analysis - TrafficLightFSM_tb.vcd*
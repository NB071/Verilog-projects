<div align="center">
  <img src="https://static-00.iconduck.com/assets.00/file-type-verilog-icon-1024x1024-1hv3ysgx.png" alt="Verilog Logo" width="150">
  <h1>Passion Projects in Verilog</h1>
  <a href="https://github.com/NB071/Verilog-projects/issues">
    <img src="https://img.shields.io/github/issues/NB071/Verilog-projects" alt="GitHub Issues">
  </a>
  <a href="https://github.com/NB071/Verilog-projects/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/NB071/Verilog-projects?color=blue" alt="License">
  </a>
   <a href="https://github.com/NB071/Verilog-projects/stargazers">
    <img src="https://img.shields.io/github/stars/NB071/Verilog-projects?style=social" alt="GitHub Stars">
  </a>
</div>

## About the Repository

This repository is a collection of my **passion projects in Verilog**, inspired by my university course **EECS 2021**, where I discovered how fascinating Verilog is to learn. Its ability to design hardware through code, simulate complex systems, and create modular, reusable components sparked my interest.

For now, this repository contains a **Digital Clock**, but I plan to add more exciting projects soon!

---

## Projects (More to Be Added)

### **1. Digital Clock** ⏰
- **Description**: 
  - A digital clock that tracks hours, minutes, and seconds.
  - Configurable to work with any clock frequency.
  - Designed with modularity in mind, using separate modules for clock division and timekeeping.
- **Key Features**:
  - Modular design with a `ClockDivider` module.
  - Converts time into Binary Coded Decimal (BCD) for display purposes.
  - Includes a testbench to verify functionality.

### **2. Traffic Light** 🚦
- **Description**: 
  - A traffic light controller implemented as a Finite State Machine (FSM).
  - The system transitions between RED, YELLOW, and GREEN lights based on configurable timer inputs.
  - Designed to handle both normal and error states, with error detection for invalid timer configurations.
- **Key Features**:
  - Configurable timer for each light state using an 18-bit input.
  - Supports error detection for invalid timer configurations (e.g., zero-duration states).
  - Includes FSM pause/resume functionality based on the enable signal.
  - Provides a testbench to simulate various scenarios, including valid and invalid configurations, light transitions, and error recovery.
  - The FSM design ensures proper timing and smooth light transitions.

---

## File Structure

```plaintext
.
├── DigitalClock/              # Directory containing Verilog files
│   ├── DigitalClock.v         # Digital clock module
│   ├── ClockDivider.v         # Clock divider module
│   ├── clock_testbench.v      # Testbench for verifying the digital clock
|   ├── README.md  
├── TrafficLight/              # Directory containing Verilog files for the traffic light system
│   ├── TrafficLightFSM.v      # Traffic light FSM module
│   ├── TrafficLightFSM_tb.v   # Testbench for verifying the traffic light FSM functionality
|   ├── README.md  
├── .gitignore                 # Git configuration to exclude unnecessary files
├── README.md 
```

## Usage (ex. for DigitalClock)
1. Clone the repository:
```bash
git clone https://github.com/NB071/Verilog-projects.git
```
2. Navigate to the project directory:
```bash
cd Verilog-projects/DigitalClock
```
3. Compile the Verilog code using iverilog:
```bash
iverilog -o DigitalClock_testbench.vvp clock_testbench.v DigitalClock.v ClockDivider.v
```
4. Run the compiled file using vvp:
```bash
vvp DigitalClock_testbench.vvp
```
5. Observe the simulation output in the terminal.

---

## Future Plans
- 🧮 Digital Calculator: Exploring arithmetic logic and modular design.
- TBD: I’m always brainstorming new ideas to expand this repository!

## Acknowledgments
- Inspired by my coursework in EECS 2021 at York University.
- Thanks to my professors and peers for fostering my interest in digital design! 🙌 

<div align="center"> <h3>Stay tuned for more projects! 🚀</h3> </div>

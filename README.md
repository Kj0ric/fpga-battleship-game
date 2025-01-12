<h1 align="center">
    FPGA Battleship Game
</h1>

<div align="center">

[![Language](https://img.shields.io/badge/Icarus_Verilog-red?style=for-the-badge)](https://github.com/steveicarus/iverilog)
![Status](https://img.shields.io/badge/status-completed-green?style=for-the-badge)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](https://github.com/Kj0ric/lcd-semantic-analyzer/blob/main/LICENSE)

</div>

A digital implementation of the classic Battleship game on FPGA, featuring a 4x4 grid system with LED display and seven-segment display (SSD) interface. This project is implemented on the Sipeed Tang Nano 9K FPGA development board, supporting two players with a best-of-three rounds system.

[demo](https://youtu.be/PuR5qgpQ3kM)

## Table of Contents
- [Hardware Specifications](#hardware-specifications)
    - [FPGA Development Board](#fpga-development-board) 
    - [On-Board Components Used](#on-board-components-used)
- [Project Overview](#project-overview)
- [Input/Output Configuration](#inputoutput-configuration)
   - [Input Controls](#input-controls)
   - [Display System](#display-system)
- [Gameplay Instructions](#gameplay-instructions)
- [Project Structure](#project-structure)
- [Module Descriptions](#module-descriptions)
   - [Top Level Module (top.v)](#top-level-module-topv)
   - [Core Game Logic (battleship.v)](#core-game-logic-battleshipv)
   - [Support Modules](#support-modules)
- [State Machine Description](#state-machine-description)
- [Setup Guide](#setup-guide)
- [Technical Implementation Details](#technical-implementation-details)
   - [Clock Management](#clock-management)
   - [Timing Specifications](#timing-specifications)
- [Future Improvements](#future-improvements)
- [License](#license)
- [Acknowledgements](#acknowledgements)


## Hardware Specifications

### FPGA Development Board
- **Model**: Sipeed Tang Nano 9K
- **FPGA Chip**: Gowin GW1NR-9
- **Logic Elements**: 8640
- **Clock Speed**: 27MHz
- **Flash Memory**: 32Mb
- **SRAM**: 64Kb
- **Package**: QFN88

### On-Board Components Used
- **Push Buttons**: 4x (BTN0-BTN3)
- **DIP Switches**: 4x (SW0-SW3)
- **LEDs**: 8x user LEDs
- **Seven-Segment Display**: 4x common anode display
- **System Clock**: 27MHz crystal oscillator

## Project Overview

This project implements an electronic version of Battleship where:
- Each player has a 4x4 grid for ship placement
- Players take turns placing 4 ships and attempting to sink opponent's ships
- Game status is displayed through LED indicators and seven-segment displays
- First player to win 2 rounds wins the overall game

## Input/Output Configuration

### Input Controls
| Control | Function |
|---------|----------|
| BTN3    | Player A input button |
| BTN2    | Reset button |
| BTN1    | Start button |
| BTN0    | Player B input button |
| SW[3:2] | X coordinate input |
| SW[1:0] | Y coordinate input |

### Display System
| Display | Function |
|---------|----------|
| SSD3    | Player indicator/Winner display |
| SSD2-0  | Coordinates and score display |
| LED[7]  | Player A turn indicator |
| LED[5:4]| Player A score/input counter |
| LED[3:2]| Player B score/input counter |
| LED[0]  | Player B turn indicator |

## Gameplay Instructions
1. **Ship Placement Phase**
   - Use sw[3:0] to select coordinates
   - Press player buttons to place
   - Each player places 4 ships
   - Error when attempting to place to an existing coordinate

2. **Battle Phase**
   - Players alternate turns
   - Use sw[3:0] to select target coordinates
   - Press player button to attack
   - LED feedback for hits/misses

3. **Scoring**
   - One point per ship sunk
   - First to sink 4 ships wins round
   - Best of three rounds wins game

## Project Structure
```
fpga-battleship/
├── src/
│   ├── top.v             # Top-level module
│   ├── battleship.v      # Core game logic
│   ├── clk_divider.v     # Clock division module
│   ├── debouncer.v       # Button debouncer
│   └── ssd.v             # Seven-segment display controller
├── constraints/
│   └── pins.cst          # Pin constraints file
└── README.md
```

## Module Descriptions
### Top Level Module (`top.v`)
- System integration and clock management
- Button debouncing implementation
- Module interconnections
- Pin mapping for FPGA I/O

### Core Game Logic (`battleship.v`)
- FSM implementation with 16 states
- Game rules and scoring mechanism
- Display control logic
- Ship placement validation
- Hit detection and scoring

### Support Modules
- **Clock Divider** (`clk_divider.v`):
  - Converts 27MHz to 50Hz game clock
  - Configurable division ratio
  - Stable clock generation

- **Debouncer** (`debouncer.v`):
  - Button input debouncing
  - Clean signal generation
  - Edge detection

- **SSD Controller** (`ssd.v`):
  - Display multiplexing
  - Segment encoding
  - Display refresh management

## State Machine Description
1. **Initial States**
   - IDLE: Initial reset state
   - DISPLAY_A/B: Player turn indication
   - INPUT_A/B: Ship placement phase

2. **Game Play States**
   - SHOW_SCORE
   - SHOOT_A/B: Attack phase
   - SINK_A/B: Hit registration
   - ERROR_A/B: Invalid move handling

3. **Victory States**
   - WIN_A/B: Round victory
   - OVRWIN_A/B: Game victory


## Setup Guide
### Prerequisites
- Visual Studio Code
- USB port
- Administrative privileges on your computer
### Tool Installation
1. **Install VS Code Extensions**
   - Open VS Code
   - Go to Extensions tab
   - Search for "Lushay Code" and install 
2. **Install OSS CAD Suite**
   - Download OSS CAD Suite 2023-02-10 for your platform: https://github.com/YosysHQ/oss-cad-suite-build/releases/tag/2023-02-10
     - Windows: windows-x64
     - Intel Mac: darwin-x64
     - M1/M2/M3 Mac: darwin-arm64
     - Linux: linux-x64
   - Extract to a folder named "oss-cad-suite"
   - For Windows: Run the extracted .exe as administrator
   - For macOS:
     - Open terminal in oss-cad-suite folder
     - Run: 
      ```bash
      chmod +x activate
      ./activate
      ```
3. **Driver Setup (Windows Only)**
   - Download Zadig from https://zadig.akeo.ie
   - Connect TANG NANO 9K to USB
   - In Zadig:
     - Select Options > List All Devices
     - Select "JTAG Debugger (Interface 0)"
     - Select "WinUSB" as driver
     - Click "Replace Driver"
     - Restart computer if installation fails

### Project Setup
1. **Create Project Directory**

   - Open VS Code
   - Go to File > Open Folder
   - Create a new folder for your project
   - Open the created folder

2. **Configure Project**

   - Click "Auto-Detect Project" button in bottom right
   - Click "Create new Project File"
   - Name your project
   - Modify the generated .lushay.json file to add:
     ```json
     "top": "battleship"
     ```
3. **Add Source Files**

   - Copy all source files into project directory:
     - top.v
     - battleship.v
     - clk_divider.v
     - debouncer.v
     - ssd.v
   - Add the constraint file (tangnano9k.cst)

### Building and Programming

1. **Verify Setup**
   - Ensure TANG NANO 9K is connected via USB
   - Check that all source files are present
   - Verify constraint file is in place

2. **Program FPGA**
   - Click "FPGA Toolchain" button
   - Select "Build and Program"
   - Wait for compilation and programming to complete
   - Verify successful programming via terminal output

### Troubleshooting

- If driver installation fails, try restarting your computer
- Ensure no file paths contain spaces or non-English characters
- Verify that the top module name in .lushay.json matches your main module
- Check USB connection if programming fails
- Ensure all required files are in the correct directory

## Technical Implementation Details

### Clock Management
- Base System Clock: 27 MHz (from hardware specifications)
- Clock Division:
  - Game Logic Clock: Generated by clk_divider.v
    - Division ratio: 27MHz ÷ 50Hz = 540,000
    - Used for game state updates and input processing
  - Display Refresh Clock: Generated by clk_divider.v
    - Division ratio: 27MHz ÷ 1kHz = 27,000
    - Controls seven-segment display multiplexing

### Timing Specifications
- Button Debouncing:
  - Implemented in debouncer.v
  - Sampling period: Calculate based on chosen counter width
  - Example: Using 10-bit counter at 27MHz:
    - 2^10 cycles = 1024 cycles
    - 1024 ÷ 27MHz ≈ 37.9 μs per sample
  
- Display Multiplexing:
  - Four digits to cycle through
  - Minimum refresh rate needed: 60Hz per digit
  - Total refresh rate: 240Hz minimum
  - Actual implementation: 1kHz (comfortable margin for smooth display)
  
- State Machine Timing:
  - State transitions synchronized to game logic clock (50Hz)
  - Minimum response time: 20ms (one game clock cycle)
  - Input processing: Complete within one game clock cycle


## Future Improvements
- Expandable grid size
- Sound effects support
- Score persistence
- Multiple game modes
- Enhanced visual feedback

## License
This project is licensed under the MIT license - see the LICENSE file for details.

## Acknowledgements
This project was developed as part of our Logic & Digital System Design course. 

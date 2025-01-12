<h1 align="center">
    FPGA Battleship Game
</h1>

<div align="center">

[![Language](https://img.shields.io/badge/Icarus_Verilog-red?style=for-the-badge)](https://github.com/steveicarus/iverilog)
![Status](https://img.shields.io/badge/status-completed-green?style=for-the-badge)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](https://github.com/Kj0ric/lcd-semantic-analyzer/blob/main/LICENSE)

</div>

A digital implementation of the classic Battleship game on FPGA, featuring a 4x4 grid system with LED display and seven-segment display (SSD) interface. This project is implemented on the Sipeed Tang Nano 9K FPGA development board, supporting two players with a best-of-three rounds system.

<div align="center">
      <a href="https://youtu.be/PuR5qgpQ3kM">
        <img src="/demo-thumbnail.png" alt="demo" width="500">
      </a>
    <p><em>Click for the demo video</em></p>
</div>


## Table of Contents
- [Hardware Specifications](#hardware-specifications)
- [Project Overview](#project-overview)
- [Input/Output Configuration](#inputoutput-configuration)
- [Gameplay Instructions](#gameplay-instructions)
- [Module Descriptions](#module-descriptions)
- [Setup and Installation](#setup-and-installation)
- [Future Improvements](#future-improvements)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Hardware Specifications
### FPGA Development Board
| Specification            | Details                 |
|--------------------------|-------------------------|
| **Model**                | Sipeed Tang Nano 9K     |
| **FPGA Chip**            | Gowin GW1NR-9           |
| **Logic Elements**       | 8640                    |
| **Clock Speed**          | 27MHz                   |
| **Flash Memory**         | 32Mb                    |
| **SRAM**                 | 64Kb                    |
| **Package**              | QFN88                   |

### On-Board Components Used

| Component                | Details                    |
|--------------------------|----------------------------|
| **Push Buttons**          | 4x (BTN0-BTN3)             |
| **DIP Switches**          | 4x (SW0-SW3)               |
| **LEDs**                  | 8x user LEDs               |
| **Seven-Segment Display** | 4x common anode display    |
| **System Clock**          | 27MHz crystal oscillator   |

## Project Overview
This project implements an electronic version of Battleship where:
- Each player has a 4x4 grid for ship placement
- Players take turns placing 4 ships and attempting to sink opponent's ships
- Game status is displayed through LED indicators and seven-segment displays
- First player to win 2 rounds wins the overall game

## Input/Output Configuration

| Control | Function                | Display  | Function                          |
|---------|-------------------------|----------|-----------------------------------|
| BTN3    | Player A input button   | SSD3     | Player indicator/Winner display  |
| BTN2    | Reset button            | SSD2-0   | Coordinates and score display     |
| BTN1    | Start button            | LED[7]   | Player A turn indicator           |
| BTN0    | Player B input button   | LED[5:4] | Player A score/input counter      |
| SW[3:2] | X coordinate input      | LED[3:2] | Player B score/input counter      |
| SW[1:0] | Y coordinate input      | LED[0]   | Player B turn indicator           |


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

---
## Setup and Installation
For detailed instructions installing the project, please see [INSTALLATION.md](INSTALLATION.md).

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

## Future Improvements
- Expandable grid size
- Sound effects support
- Multiple game modes
- Enhanced visual feedback

## License
This project is licensed under the MIT license - see the LICENSE file for details.

## Acknowledgements
This project was developed as part of our Logic & Digital System Design course. 

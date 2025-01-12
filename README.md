<h1 align="center">
    FPGA Battleship Game
</h1>

A digital implementation of the classic Battleship game on FPGA, featuring a 4x4 grid system with LED display and seven-segment display (SSD) interface. This project is implemented on the Sipeed Tang Nano 9K FPGA development board, supporting two players with a best-of-three rounds system.

[demo](https://youtu.be/PuR5qgpQ3kM)

## Table of Contents
- [Hardware Specifications](#hardware-specifications)
    - [FPGA Development Board](#fpga-development-board) 
    - [On-Board Components Used](#on-board-components-used)


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

### Game States
1. **Initial States**
   - IDLE: Initial reset state
   - DISPLAY_A/B: Player turn indication
   - INPUT_A/B: Ship placement phase

2. **Game Play States**
   - SHOOT_A/B: Attack phase
   - SINK_A/B: Hit registration
   - ERROR_A/B: Invalid move handling

3. **Victory States**
   - WIN_A/B: Round victory
   - OVRWIN_A/B: Game victory

## Setup Instructions

1. **Hardware Setup**
   - Connect Tang Nano 9K to power and USB
   - Ensure all switches and buttons are accessible
   - Verify LED and SSD connections

2. **Project Build**
   - Open project in Gowin IDE
   - Set pin constraints according to `pins.cst`
   - Synthesize and generate bitstream
   - Program FPGA using built-in USB programmer

3. **Game Initialization**
   - Press BTN2 for system reset
   - Press BTN1 to start game
   - Follow SSD prompts for gameplay

## Gameplay Instructions

1. **Ship Placement Phase**
   - Use SW[3:0] to select coordinates
   - Each player places 4 ships
   - Invalid placements show "Erro"

2. **Battle Phase**
   - Players alternate turns
   - Select target coordinates
   - Press player button to attack
   - LED feedback for hits/misses

3. **Scoring**
   - One point per ship sunk
   - First to sink 4 ships wins round
   - Best of three rounds wins game

## Technical Notes

### Clock Management
- System clock: 27MHz
- Game logic clock: 50Hz
- Display refresh: ~1kHz

### Memory Usage
- Ship positions: 16-bit registers per player
- Score tracking: 4-bit counters
- State storage: 4-bit register

### Timing Considerations
- Debounce delay: ~20ms
- Display update: ~1ms
- State transitions: 20ms

## Development and Testing

This project was developed as part of CS 303 Logic & Digital System Design course. Testing included:
- Input validation testing
- State transition verification
- Display timing analysis
- Game rule compliance checks

## Future Improvements

- Expandable grid size
- Sound effects support
- Score persistence
- Multiple game modes
- Enhanced visual feedback

## License

[Add your license information here]
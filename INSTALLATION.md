# Installation Guide for FPGA Battleship Game

## Prerequisites
- Visual Studio Code
- USB port
- Administrative privileges on your computer

## Tool Installation

### 1. VS Code Extensions
1. Open Visual Studio Code
2. Navigate to Extensions tab (or press `Ctrl+Shift+X`)
3. Search for "Lushay Code"
4. Install the extension

### 2. OSS CAD Suite Installation
1. Download OSS CAD Suite 2023-02-10 for your platform from [GitHub Releases](https://github.com/YosysHQ/oss-cad-suite-build/releases/tag/2023-02-10)
2. Extract the downloaded file to a folder named "oss-cad-suite"
3. Platform-specific steps:
   - **Windows**:
     - Run the extracted .exe as administrator
   - **macOS**:
     - Open terminal in oss-cad-suite folder
     - Run the following commands:
       ```bash
       chmod +x activate
       ./activate
       ```

### 3. Driver Setup (Windows Only)
1. Download Zadig from [https://zadig.akeo.ie](https://zadig.akeo.ie)
2. Connect your TANG NANO 9K to USB
3. In Zadig:
   - Select Options > List All Devices
   - Select "JTAG Debugger (Interface 0)"
   - Select "WinUSB" as driver
   - Click "Replace Driver"
   - If installation fails, restart your computer

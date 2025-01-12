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
  
## Project Setup

### 1. Create Project Directory
1. Open VS Code
2. Go to File > Open Folder
3. Create a new folder for your project
4. Open the created folder

### 2. Configure Project
1. Click "Auto-Detect Project" button in bottom right
2. Click "Create new Project File"
3. Name your project
4. Modify the generated .lushay.json file to add:
   ```json
   "top": "battleship"
   ```

### 3. Add Source Files
1. Copy all source files into project directory:
   - top.v
   - battleship.v
   - clk_divider.v
   - debouncer.v
   - ssd.v
2. Add the constraint file (tangnano9k.cst)

## Building and Programming

### 1. Verify Setup
- Ensure TANG NANO 9K is connected via USB
- Check that all source files are present
- Verify constraint file is in place

### 2. Program FPGA
1. Click "FPGA Toolchain" button
2. Select "Build and Program"
3. Wait for compilation and programming to complete
4. Verify successful programming via terminal output

## Troubleshooting

### Common Issues and Solutions
- **Driver Installation Fails**
  - Try restarting your computer
  - Run installer as administrator
  
- **File Path Issues**
  - Ensure no file paths contain spaces
  - Avoid non-English characters in file paths
  
- **Programming Failures**
  - Verify USB connection is secure
  - Check that top module name in .lushay.json matches your main module
  - Ensure all required files are in the correct directory
  
- **Build Errors**
  - Verify all source files are present
  - Check file permissions
  - Ensure constraint file is properly configured

### Getting Help
If you encounter issues not covered in this guide:
1. Check the project's issue tracker
2. Verify against the example project structure
3. Consult the Sipeed Tang Nano 9K documentation

## Additional Resources
- [Sipeed Tang Nano 9K Documentation](https://tang.sipeed.com/en/)
- [Lushay Code Extension Documentation](https://marketplace.visualstudio.com/items?itemName=LushayCode.lushay-code)
- [OSS CAD Suite Documentation](https://github.com/YosysHQ/oss-cad-suite-build)

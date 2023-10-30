# BISS-C

This is N channel BISS-C FPGA IP and It's Driver Repo.

we used a ZYNQ7020 Core board and an extension BISS-C board to implement this demo, this is a 8 channel BISS-C sensor grabber demo.

![image-20231027163109709](README.assets/image-20231027163109709.png)

## doc

Include the BISS protocol specification, sensor user manual,  BISS-C FPGA IP user manual, and the ZYNQ7020 board schematic pdf.

## IP

FPGA IP Core

## scripts

Run the build.bat to recreate the VIVADO project, you can change the VIVADO location to your own location. This demo is implemented on VIVADO2019.1



## constraints

The FPGA project constraints.

# QA

### Where is the software code?

We offer a standalone software demo based on Xilinx SDK 2019.1, the source code located in ./IP/BISS_C/drivers_demo

### How can we get the hardware?

You can contact us with email info@hello-fpga.com , the price will be 3000RMB (include the power and cables), we will sell or open source the hardware later.

### What is the sensor you tested?

Right now, we only test 2 type sensors, one is RENISHAW L-9709-9005-03-F 32bit, one is a 14bit Chinese local sensor. But we believe that all RENISHAW sensors will works well on this code. And we welcome you give us more feedback if you used our hardware or software.

/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "biss-c.h"
#include "sleep.h"


int main()
{
    init_platform();

    print("Hello BISS, This is BISS-C stand alone demo\n\r");

    //single point mode
    int hdev = 0;//the device handle will be useful on other platform like PCIe
    int status = 0;
    status = BISS_C_Init(hdev);
    if(status)
    {
        print("BISS_C_Init failed\n\r");
    }

    //ignore the crc check ,user can also enable the crc check
    status = BISS_C_IgnoreCRC(hdev,1);
    if(status)
    {
        print("BISS_C_IgnoreCRC failed\n\r");
    }

    // the main clock is 50Mhz, we can set the ma as 1Mhz ,so the divider will be 50/2
    print("MAClk is 1Mhz\n\r");
    status =  BISS_C_ConfigMAClk(hdev, 400);
    if(status)
    {
        print("BISS_C_ConfigMAClk failed\n\r");
    }

    //32bit
    status =   BISS_C_ConfigPositionDatabits(hdev, 24);
    if(status)
    {
        print("BISS_C_ConfigPositionDatabits failed\n\r");
    }

    //channel 0 enabled
    status =    BISS_C_ConfigChannels(hdev,0xfe);
    if(status)
    {
        print("BISS_C_ConfigChannels failed\n\r");
    }
    print("channel 0 enabled\n\r");

    unsigned int singlePointData = 0;
    bool dataValid = false;
    int i = 0;
    do{
    	i++;
    	WriteReg(hdev,0x41200000 , i);
    	usleep(1000);
    	if(i == 8)
    	{
    		i=0;
    	}
        status =    BISS_C_ReadSinglePoint(hdev,0,&singlePointData,&dataValid);
        if(status)
        {
            print("BISS_C_ReadSinglePoint failed\n\r");
        }
        printf("channel 0 singlePointData is 0x%x ,dataValid is 0x%x\n\r",singlePointData,dataValid );
        //multiple point mode
    }while(1);


    cleanup_platform();
    return 0;
}

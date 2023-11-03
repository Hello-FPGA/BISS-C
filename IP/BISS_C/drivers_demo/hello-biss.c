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
#include "xaxidma.h"
#include "xparameters.h"

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
		 DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR		0x10000000
#else
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x01000000)
#endif

#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

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

    // the main clock is 50Mhz, the actual frequency will be 50Mhz/(400*2)
    print("MAClk is 1Mhz\n\r");
    status =  BISS_C_ConfigMAClk(hdev, 40);
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


    print("channel 0 single point data read\n\r");
    unsigned int singlePointData = 0;
    bool dataValid = false;
    int i = 0;
    do{
    	i++;
    	WriteReg(hdev,0x41200000 , i%8);//test the led
    	sleep(1);
        status =    BISS_C_ReadSinglePoint(hdev,0,&singlePointData,&dataValid);
        if(status)
        {
            print("BISS_C_ReadSinglePoint failed\n\r");
        }
        printf("channel 0 singlePointData 0x%x \n\r",singlePointData );
        //multiple point mode
    }while(i<100);


    print("BISS_C  multi point data read\n\r");

	BISS_C_Stop(hdev);
    //axi dma read the multiple points data
    XAxiDma AxiDma;
	XAxiDma_Config *CfgPtr;
	int Tries = 10;//read 10 times
	int Index;
	int *RxBufferPtr;
	int length = 16;

	RxBufferPtr = (int *)RX_BUFFER_BASE;


	for(Index = 0; Index < Tries; Index ++) {

		/* Initialize the XAxiDma device.
			 */
			CfgPtr = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
			if (!CfgPtr) {
				printf("No config found for %d\r\n", XPAR_AXIDMA_0_DEVICE_ID);
				return XST_FAILURE;
			}

			status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
			if (status != XST_SUCCESS) {
				printf("Initialization failed %d\r\n", status);
				return XST_FAILURE;
			}

			if(XAxiDma_HasSg(&AxiDma)){
				printf("Device configured as SG mode \r\n");
				return XST_FAILURE;
			}

			/* Disable interrupts, we use polling mode
			 */
			XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
					XAXIDMA_DEVICE_TO_DMA);
			XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
					XAXIDMA_DMA_TO_DEVICE);
			int reg_value = 0;

		//read 16 point data

		status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
				length, XAXIDMA_DEVICE_TO_DMA);

		if (status) {
			return XST_FAILURE;
		}

		//开启数据源
		//config the s2mm filter
		WriteReg(hdev, 0x41240008,length/4 -1);//4 byte 数据位宽，设置filter 要过滤的数据长度
		WriteReg(hdev, 0x41240000,0);//复位
		WriteReg(hdev, 0x41240000,1);//启动数据筛选

		BISS_C_Start(hdev);//start biss


		while (XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA)) {
				/* Wait */
	    	sleep(1);
		}
		/* Invalidate the DestBuffer before receiving the data, in case the
		 * Data Cache is enabled
		 */
	#ifndef __aarch64__
		Xil_DCacheInvalidateRange((UINTPTR)RxBufferPtr, length);
	#endif

		for(int i=0; i < length/4; i++)
		{
			printf("position data 0x%x \r\n",RxBufferPtr[i]);
		}

    	sleep(1);
		printf("finite transfer finished \r\n");
	    print("BISS_C  multi point data read\n\r");
	}
    cleanup_platform();
    return 0;
}

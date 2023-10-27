/*
* @Author: yaxingshi
* @Date:   2023-10-27 15:14:59
* @Last Modified by:   yaxingshi
* @Last Modified time: 2023-10-27 15:18:30
*/
#include "axi_lite_rw.h"

int WriteReg(int hdev, int offset, int data)
{
	Xil_Out32(offset,data);
	return 0;
}

int ReadReg(int hdev, int offset, int *data)
{
	*data = Xil_In32(offset);
	return 0;
}
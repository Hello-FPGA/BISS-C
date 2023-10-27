
#include "biss-c.h"

#define BISS_AXI_LITE_BASE_ADDR 0x41230000

#define BISS_SOFT_RESET						BISS_AXI_LITE_BASE_ADDR + (0<<2 )
#define BISS_IS_EXT_SAMPLE_CLK				BISS_AXI_LITE_BASE_ADDR + (1<<2 )
#define BISS_IS_SINGLE_POINT_MODE			BISS_AXI_LITE_BASE_ADDR + (2<<2 )
#define BISS_SINGLE_POINT_DATA_READ_EN		BISS_AXI_LITE_BASE_ADDR + (3<<2 )
#define BISS_INTERNEL_SAMPLE_CLK_BISSVIDER	BISS_AXI_LITE_BASE_ADDR + (4<<2 )
#define BISS_MA_CLK_BISSVIDER					BISS_AXI_LITE_BASE_ADDR + (5<<2 )
#define BISS_RESOLUTION_BITS				BISS_AXI_LITE_BASE_ADDR + (6<<2 )
#define BISS_IGNORE_CRC_CHECK				BISS_AXI_LITE_BASE_ADDR + (7<<2 )
#define BISS_CHANNEL_ENABLE					BISS_AXI_LITE_BASE_ADDR + (8<<2 )
#define BISS_CHANNEL_INDEX					BISS_AXI_LITE_BASE_ADDR + (9<<2 )
#define BISS_IF_SHIFT_MA_CLK				BISS_AXI_LITE_BASE_ADDR + (10<<2 )
#define BISS_SHIFTED_CRC_DATA				BISS_AXI_LITE_BASE_ADDR + (11<<2 )
#define BISS_CRC_CHECK_VALUE_DATA			BISS_AXI_LITE_BASE_ADDR + (12<<2 )
#define BISS_SINGLE_POINT_DATA_IS_VALID		BISS_AXI_LITE_BASE_ADDR + (13<<2)
#define BISS_SINGLE_POINT_DATA				BISS_AXI_LITE_BASE_ADDR + (14<<2)
#define BISS_LINE_DELAY_TICKS				BISS_AXI_LITE_BASE_ADDR + (15<<2)



int BISS_C_Init(int hdev)
{
	int status = 0;
	status = WriteReg(hdev, BISS_SOFT_RESET, 1);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_SOFT_RESET, 0);
	if (status)
	{
		return status;
	}

	status = WriteReg(hdev, BISS_IS_SINGLE_POINT_MODE, 0);
	if (status)
	{
		return status;
	}

	//100M, 1k
	status = BISS_C_ConfigSampleClk(hdev,100000, false);
	if (status)
	{
		return status;
	}
	status = BISS_C_ConfigPositionDatabits(hdev,32);
	if (status)
	{
		return status;
	}
	//100M, 250K
	status = BISS_C_ConfigMAClk(hdev, 400);
	if (status)
	{
		return status;
	}
	status = BISS_C_IgnoreCRC(hdev,0xff);
	return status;
}

int BISS_C_IgnoreCRC(int hdev, int ignoreCRC)
{
	int status = 0;
	status = WriteReg(hdev, BISS_IGNORE_CRC_CHECK, ignoreCRC);
	if (status)
	{
		return status;
	}
	return status;
}

int BISS_C_CheckAjustDelay(int hdev, int channelIndex, int *maSloDelayTicks)
{
	int status = 0;
	unsigned int data = 0;
	bool isValid = false;
	status = BISS_C_ReadSinglePoint(hdev, channelIndex, &data, &isValid);
	if (status)
	{
		return status;
	}
	status = ReadReg(hdev, BISS_LINE_DELAY_TICKS, maSloDelayTicks);
	if (status)
	{
		return status;
	}
	int ajustChannelDelay = 0;
	status = ReadReg(hdev, BISS_IF_SHIFT_MA_CLK, &ajustChannelDelay);
	if (status)
	{
		return status;
	}
	int maClkDivider = 0;
	status = ReadReg(hdev, BISS_MA_CLK_BISSVIDER, &maClkDivider);
	if (status)
	{
		return status;
	}
	if (*maSloDelayTicks%maClkDivider<=2)
	{
		status = WriteReg(hdev, BISS_IF_SHIFT_MA_CLK, 0xff);
	}
	else
	{
		status = WriteReg(hdev, BISS_IF_SHIFT_MA_CLK, 0x00);
	}
	
	return status;
}

int BISS_C_ConfigSampleClk(int hdev, int highlowTicksNum, bool isExtSampleClk)
{
	int status = 0;
	status = WriteReg(hdev, BISS_IS_EXT_SAMPLE_CLK, isExtSampleClk);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_INTERNEL_SAMPLE_CLK_BISSVIDER, highlowTicksNum);
	if (status)
	{
		return status;
	}
	return status;	
}

int BISS_C_ConfigMAClk(int hdev, int highlowTicksNum)
{
	int status = 0;
	status = WriteReg(hdev, BISS_MA_CLK_BISSVIDER, highlowTicksNum);
	if (status)
	{
		return status;
	}
	return status;
}

int BISS_C_ConfigPositionDatabits(int hdev, int bitsNum)
{
	int status = 0;
	status = WriteReg(hdev, BISS_RESOLUTION_BITS, bitsNum);
	if (status)
	{
		return status;
	}
	return status;
}

int BISS_C_ConfigChannels(int hdev, int channelEnable)
{
	int status = 0;
	status = WriteReg(hdev, BISS_CHANNEL_ENABLE, channelEnable);// BIT ACTIVE 0
	if (status)
	{
		return status;
	}
	return status;
}

int BISS_C_ReadSinglePoint(int hdev, int channelIndex, unsigned int* data, bool* isValid)
{
	int status = 0;
	//reset first
	status = WriteReg(hdev, BISS_SOFT_RESET, 1);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_SOFT_RESET, 0);
	if (status)
	{
		return status;
	}

	//config chnanel index
	status = WriteReg(hdev, BISS_CHANNEL_INDEX, channelIndex);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_IS_SINGLE_POINT_MODE, 1);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_SINGLE_POINT_DATA_READ_EN, 0);
	if (status)
	{
		return status;
	}
	status = WriteReg(hdev, BISS_SINGLE_POINT_DATA_READ_EN, 1);
	if (status)
	{
		return status;
	}

	int tryTimes = 0;
	int is_valid = 0;
	*isValid = false;
	do
	{
		status = ReadReg(hdev, BISS_SINGLE_POINT_DATA_IS_VALID, &is_valid);
		if (status)
		{
			return status;
		}
		usleep(100);
		tryTimes++;
		if (tryTimes>500)//2s
		{
			*data = 0;
			return BISS_IS_NOT_CONNECTED;
		}
	} while (is_valid==0);

	if (is_valid>>channelIndex==1)
	{
		*isValid = true;
	}
	int single_point_data = 0;
	status = ReadReg(hdev, BISS_SINGLE_POINT_DATA, &single_point_data);
	if (status)
	{
		return status;
	}
	*data = (unsigned int)single_point_data;

	status = WriteReg(hdev, BISS_IS_SINGLE_POINT_MODE, 0);
	if (status)
	{
		return status;
	}
	//debug
	int shiftedCRC = 0;
	int checkCRC = 0;
	status = ReadReg(hdev, BISS_SHIFTED_CRC_DATA, &shiftedCRC);
	if (status)
	{
		return status;
	}
	status = ReadReg(hdev, BISS_CRC_CHECK_VALUE_DATA, &checkCRC);
	if (status)
	{
		return status;
	}
	return status;

}

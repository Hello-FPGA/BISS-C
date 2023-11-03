#pragma once

#include "axi_lite_rw.h"

//error code define
#define BISS_IS_NOT_CONNECTED		-9999

// ********************************************************************************
/// <summary>
/// initial configure the biss ip
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_Init(int hdev);

int BISS_C_Start(int hdev);

int BISS_C_Stop(int hdev);

// ********************************************************************************
/// <summary>
/// ignore crc check for the data
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="ignoreCRC">1: ignore the internal crc check</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_IgnoreCRC(int hdev, int ignoreCRC);

// ********************************************************************************
/// <summary>
/// this is for debug, read back the MA delay ticks
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="channelIndex">chanel index</param>
/// <param name="maSloDelayTicks">delayed ticks of ma clock</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_CheckAjustDelay(int hdev, int channelIndex, int *maSloDelayTicks );

// ********************************************************************************
/// <summary>
/// config the sample clock of the biss-c ip
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="highlowTicksNum">the divider parameters of the divider</param>
/// <param name="isExtSampleClk">1: external sample clock</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_ConfigSampleClk(int hdev, int highlowTicksNum, bool isExtSampleClk);

// ********************************************************************************
/// <summary>
/// MA signal divider, user can change the ma clock frequency 
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="highlowTicksNum">the divider parameters of the divider</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_ConfigMAClk(int hdev, int highlowTicksNum);

// ********************************************************************************
/// <summary>
/// the position data bits number
/// </summary>
/// <param name="hdev"></param>
/// <param name="bitsNum"></param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_ConfigPositionDatabits(int hdev, int bitsNum);

// ********************************************************************************
/// <summary>
/// enable the channels
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="channelEnable">active low, bit active, 0xfc means channel 0 and channel 1 are enabled</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_ConfigChannels(int hdev, int channelEnable);

// ********************************************************************************
/// <summary>
/// read back single point data of the sensors
/// </summary>
/// <param name="hdev">register configuration device handle</param>
/// <param name="channelIndex">0:means the chnanel index</param>
/// <param name="data">sigle point data of the specified channel dara</param>
/// <param name="isValid">check if the dara is valid or not</param>
/// <returns>0: sucess;others: faild</returns>
// ********************************************************************************
int BISS_C_ReadSinglePoint(int hdev, int channelIndex, unsigned int* data, bool* isValid);


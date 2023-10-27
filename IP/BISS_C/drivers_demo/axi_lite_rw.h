
#pragma once

#include "xil_types.h"
#include "xil_io.h"
#include "stdbool.h"

int WriteReg(int hdev, int offset, int data);

int ReadReg(int hdev, int offset, int *data);

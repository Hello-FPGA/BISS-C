# FirmDrive使用说明
FirmDrive®是基于Xilinx—FPGA芯片的PCIe、PXIe的软件驱动架构，本文档包含了FirmDrive发布内容、使用方法、版本更新说明等，FirmDrive®使用细节请参考“FirmDrive及PXIe-1010总线控制器使用手册”；

## 包含内容
* FirmDrive Runtime：FirmDrive®架构对应的上位机驱动安装包和FirmDriveCore基础函数库，具体使用方法参考目录ReadMe文件和手册第二章节；
* FirmDrive Framework：FirmDrive®架构的IP和对应的跨平台C++ API，具体使用方法参考目录ReadMe文件和手册第四章节；

## release notes
分为两部分，分别是FirmDrive Runtime和FirmDrive Framework更新说明,详细使用方法请查看

### FirmDrive Runtime更新说明

    1、FirmDriveRuntime_Installer_V1.0.2.msi无更新；
    
    2、新增linux安装包；

### FirmDrive Framework版本更新说明
* 2018/11 V1.1.1

    1、修订FirmDrive 1.1 API   Modifications.xlsx中拼写错误，UnpackageStream对应改名后为ParallelDO；

    2、修正ParallelDO、ParallelDI当选定数据位宽变化时，接口显示不合理；

    3、修订AnalogTrigger阈值计算设置归一化不正确,32位输入数据时阈值取值不正确的问题;

    4、修改Parallel DIO stream 总线的tready和tvalid对应信号输入源选择；

    5、统一IP在block design中的寄存器显示名称为Reg;

    6、修改RX采集点数的计数逻辑，使得RX支持非输出字节整数倍的有限点采集；

* 2018/12/17 V1.1.2

    1、修订FirmDriveCore中寄存器写函数的数据类型，UINT32改为INT32；

    2、修订RX中的Rx_ConfigAquisition()函数单词拼写错误,改为Rx_ConfigAcquisition()；

    3、修改TRIGER_MODE的拼写错误，改为TRIGGER_MODE；

    4、修订在将smart connect更换为interconnect后，TX在高速运行时出现的发送数据错误问题，首先要使能DataMover的MM2S control 
    signals，然后将TX的genetation_done连接到DataMover的mm2s_halt引脚；

    5、增加RX应对输入数据的稳健性，避免因为输入stream数据的tlast和tvalid信号不同步造成的单点采集错误问题；

* 2018/12/29 V1.1.3

    1、修改Rx_Read()超时处理出现的未到达超时时间即返回错误的问题；

    2、解决RX没有接收到触发信号时，调用Rx_Stop()后，依然可以读取到数据的问题；

    3、解决RX、TX可能由于复位时刻不正确导致的单次AXI传输未完成，从而下一次开启传输时读取到不正确数据的问题，增加Tx输入引脚mm2s_halt_cmplt，用于表示data mover复位完成(需要与data mover的mm2s_halt_complt引脚连接)；
	
* 2018/03/05 V1.1.4

    1、修订FirmDriveCore 在初始化板卡时，如果当前系统有两块不通VENDOR ID的卡，会出现初始化失败的问题,FirmDriveCore.dll；

    2、修订Rx传输可能出现的数据错乱、快速retrigger时，采集偶尔不正常问题,Rx_Engine IP；

    3、修订Rx Tx回环测试时，发现的传输数据不正常问题, Tx_Engine IP；

* 2019/04/10 V1.2

    1、优化各个IP的资源占用；

    2、为RX TX加入版本寄存器，位于偏移地址0处；

    3、修改analog trigger配置函数AnalogTrigger_Config()参数mask在并行数据源时的定义为通道序号,同时固件需要配置其单通道的数据宽度；
    
    4、counter加入编码器功能；
    
    5、PFI 增加到64位，routing matrix增加到128位；
    
    6、优化目录层级；
    
* 2019/04/29 V1.2.0.1

    1、fix rx check_status multirecord error report http://git.jxinst.com:8081/FirmDrive/daqfw/daqfw-api/issues/21

    
* 2019/04/30 V1.2.0.2

    1、fix rx cann't reset data mover error, issue http://git.jxinst.com:8081/DeviceDrivers/PXIe7506/PXIe7506-sw/issues/20

* 2019/05/17 V1.2.0.3

    1、fix Rx_CheckStatus() overflow 判断条件不正确导致的采集丢点错误, issue http://git.jxinst.com:8081/DeviceDrivers/PXIe5510/PXIe5510-sw/issues/39

    2、 优化Rx commite 命令部分的时序，解决PCIe7506遇到的偶尔配置不成功问题;
	
    3、调整AnalogTrigger IP配置界面参数的显示顺序；

* 2021/05/31 V1.3.2.0

	1、该版本相对于V1.2.0.6有了较大的改动，详细改动情形可以查看IP的使用手册；


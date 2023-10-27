
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/ClkDivider_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set ENABLE_TRIGGER_SYNC [ipgui::add_param $IPINST -name "ENABLE_TRIGGER_SYNC" -parent ${Page_0}]
  set_property tooltip {Enable Trigger Sync to sync the divider output} ${ENABLE_TRIGGER_SYNC}
  ipgui::add_param $IPINST -name "ENABLE_SYNC_DELAY" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "NUM_OF_CHANNELS" -parent ${Page_0}
  #Adding Group
  set Channel_0 [ipgui::add_group $IPINST -name "Channel 0" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "RATIO_0" -parent ${Channel_0}
  ipgui::add_param $IPINST -name "RISING_EDGE_0" -parent ${Channel_0}
  ipgui::add_param $IPINST -name "DYNAMIC_RECONFIG_0" -parent ${Channel_0}

  #Adding Group
  set Channel_1 [ipgui::add_group $IPINST -name "Channel 1" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "RATIO_1" -parent ${Channel_1}
  ipgui::add_param $IPINST -name "RISING_EDGE_1" -parent ${Channel_1}
  ipgui::add_param $IPINST -name "DYNAMIC_RECONFIG_1" -parent ${Channel_1}

  #Adding Group
  set Channel_2 [ipgui::add_group $IPINST -name "Channel 2" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "RATIO_2" -parent ${Channel_2}
  ipgui::add_param $IPINST -name "RISING_EDGE_2" -parent ${Channel_2}
  ipgui::add_param $IPINST -name "DYNAMIC_RECONFIG_2" -parent ${Channel_2}

  #Adding Group
  set Channel_3 [ipgui::add_group $IPINST -name "Channel 3" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "RATIO_3" -parent ${Channel_3}
  ipgui::add_param $IPINST -name "RISING_EDGE_3" -parent ${Channel_3}
  ipgui::add_param $IPINST -name "DYNAMIC_RECONFIG_3" -parent ${Channel_3}



}

proc update_PARAM_VALUE.DYNAMIC_RECONFIG_1 { PARAM_VALUE.DYNAMIC_RECONFIG_1 PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to update DYNAMIC_RECONFIG_1 when any of the dependent parameters in the arguments change
	
	set DYNAMIC_RECONFIG_1 ${PARAM_VALUE.DYNAMIC_RECONFIG_1}
	set NUM_OF_CHANNELS ${PARAM_VALUE.NUM_OF_CHANNELS}
	set values(NUM_OF_CHANNELS) [get_property value $NUM_OF_CHANNELS]
	if { [gen_USERPARAMETER_DYNAMIC_RECONFIG_1_ENABLEMENT $values(NUM_OF_CHANNELS)] } {
		set_property enabled true $DYNAMIC_RECONFIG_1
	} else {
		set_property enabled false $DYNAMIC_RECONFIG_1
		set_property value [gen_USERPARAMETER_DYNAMIC_RECONFIG_1_VALUE $values(NUM_OF_CHANNELS)] $DYNAMIC_RECONFIG_1
	}
}

proc validate_PARAM_VALUE.DYNAMIC_RECONFIG_1 { PARAM_VALUE.DYNAMIC_RECONFIG_1 } {
	# Procedure called to validate DYNAMIC_RECONFIG_1
	return true
}

proc update_PARAM_VALUE.DYNAMIC_RECONFIG_2 { PARAM_VALUE.DYNAMIC_RECONFIG_2 PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to update DYNAMIC_RECONFIG_2 when any of the dependent parameters in the arguments change
	
	set DYNAMIC_RECONFIG_2 ${PARAM_VALUE.DYNAMIC_RECONFIG_2}
	set NUM_OF_CHANNELS ${PARAM_VALUE.NUM_OF_CHANNELS}
	set values(NUM_OF_CHANNELS) [get_property value $NUM_OF_CHANNELS]
	if { [gen_USERPARAMETER_DYNAMIC_RECONFIG_2_ENABLEMENT $values(NUM_OF_CHANNELS)] } {
		set_property enabled true $DYNAMIC_RECONFIG_2
	} else {
		set_property enabled false $DYNAMIC_RECONFIG_2
		set_property value [gen_USERPARAMETER_DYNAMIC_RECONFIG_2_VALUE $values(NUM_OF_CHANNELS)] $DYNAMIC_RECONFIG_2
	}
}

proc validate_PARAM_VALUE.DYNAMIC_RECONFIG_2 { PARAM_VALUE.DYNAMIC_RECONFIG_2 } {
	# Procedure called to validate DYNAMIC_RECONFIG_2
	return true
}

proc update_PARAM_VALUE.DYNAMIC_RECONFIG_3 { PARAM_VALUE.DYNAMIC_RECONFIG_3 PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to update DYNAMIC_RECONFIG_3 when any of the dependent parameters in the arguments change
	
	set DYNAMIC_RECONFIG_3 ${PARAM_VALUE.DYNAMIC_RECONFIG_3}
	set NUM_OF_CHANNELS ${PARAM_VALUE.NUM_OF_CHANNELS}
	set values(NUM_OF_CHANNELS) [get_property value $NUM_OF_CHANNELS]
	if { [gen_USERPARAMETER_DYNAMIC_RECONFIG_3_ENABLEMENT $values(NUM_OF_CHANNELS)] } {
		set_property enabled true $DYNAMIC_RECONFIG_3
	} else {
		set_property enabled false $DYNAMIC_RECONFIG_3
		set_property value [gen_USERPARAMETER_DYNAMIC_RECONFIG_3_VALUE $values(NUM_OF_CHANNELS)] $DYNAMIC_RECONFIG_3
	}
}

proc validate_PARAM_VALUE.DYNAMIC_RECONFIG_3 { PARAM_VALUE.DYNAMIC_RECONFIG_3 } {
	# Procedure called to validate DYNAMIC_RECONFIG_3
	return true
}

proc update_PARAM_VALUE.DYNAMIC_RECONFIG_0 { PARAM_VALUE.DYNAMIC_RECONFIG_0 } {
	# Procedure called to update DYNAMIC_RECONFIG_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DYNAMIC_RECONFIG_0 { PARAM_VALUE.DYNAMIC_RECONFIG_0 } {
	# Procedure called to validate DYNAMIC_RECONFIG_0
	return true
}

proc update_PARAM_VALUE.ENABLE_SYNC_DELAY { PARAM_VALUE.ENABLE_SYNC_DELAY } {
	# Procedure called to update ENABLE_SYNC_DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_SYNC_DELAY { PARAM_VALUE.ENABLE_SYNC_DELAY } {
	# Procedure called to validate ENABLE_SYNC_DELAY
	return true
}

proc update_PARAM_VALUE.ENABLE_TRIGGER_SYNC { PARAM_VALUE.ENABLE_TRIGGER_SYNC } {
	# Procedure called to update ENABLE_TRIGGER_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_TRIGGER_SYNC { PARAM_VALUE.ENABLE_TRIGGER_SYNC } {
	# Procedure called to validate ENABLE_TRIGGER_SYNC
	return true
}

proc update_PARAM_VALUE.NUM_OF_CHANNELS { PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to update NUM_OF_CHANNELS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_CHANNELS { PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to validate NUM_OF_CHANNELS
	return true
}

proc update_PARAM_VALUE.RATIO_0 { PARAM_VALUE.RATIO_0 } {
	# Procedure called to update RATIO_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RATIO_0 { PARAM_VALUE.RATIO_0 } {
	# Procedure called to validate RATIO_0
	return true
}

proc update_PARAM_VALUE.RATIO_1 { PARAM_VALUE.RATIO_1 } {
	# Procedure called to update RATIO_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RATIO_1 { PARAM_VALUE.RATIO_1 } {
	# Procedure called to validate RATIO_1
	return true
}

proc update_PARAM_VALUE.RATIO_2 { PARAM_VALUE.RATIO_2 } {
	# Procedure called to update RATIO_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RATIO_2 { PARAM_VALUE.RATIO_2 } {
	# Procedure called to validate RATIO_2
	return true
}

proc update_PARAM_VALUE.RATIO_3 { PARAM_VALUE.RATIO_3 } {
	# Procedure called to update RATIO_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RATIO_3 { PARAM_VALUE.RATIO_3 } {
	# Procedure called to validate RATIO_3
	return true
}

proc update_PARAM_VALUE.RISING_EDGE_0 { PARAM_VALUE.RISING_EDGE_0 } {
	# Procedure called to update RISING_EDGE_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISING_EDGE_0 { PARAM_VALUE.RISING_EDGE_0 } {
	# Procedure called to validate RISING_EDGE_0
	return true
}

proc update_PARAM_VALUE.RISING_EDGE_1 { PARAM_VALUE.RISING_EDGE_1 } {
	# Procedure called to update RISING_EDGE_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISING_EDGE_1 { PARAM_VALUE.RISING_EDGE_1 } {
	# Procedure called to validate RISING_EDGE_1
	return true
}

proc update_PARAM_VALUE.RISING_EDGE_2 { PARAM_VALUE.RISING_EDGE_2 } {
	# Procedure called to update RISING_EDGE_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISING_EDGE_2 { PARAM_VALUE.RISING_EDGE_2 } {
	# Procedure called to validate RISING_EDGE_2
	return true
}

proc update_PARAM_VALUE.RISING_EDGE_3 { PARAM_VALUE.RISING_EDGE_3 } {
	# Procedure called to update RISING_EDGE_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISING_EDGE_3 { PARAM_VALUE.RISING_EDGE_3 } {
	# Procedure called to validate RISING_EDGE_3
	return true
}


proc update_MODELPARAM_VALUE.ENABLE_TRIGGER_SYNC { MODELPARAM_VALUE.ENABLE_TRIGGER_SYNC PARAM_VALUE.ENABLE_TRIGGER_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_TRIGGER_SYNC}] ${MODELPARAM_VALUE.ENABLE_TRIGGER_SYNC}
}

proc update_MODELPARAM_VALUE.NUM_OF_CHANNELS { MODELPARAM_VALUE.NUM_OF_CHANNELS PARAM_VALUE.NUM_OF_CHANNELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_OF_CHANNELS}] ${MODELPARAM_VALUE.NUM_OF_CHANNELS}
}

proc update_MODELPARAM_VALUE.RATIO_0 { MODELPARAM_VALUE.RATIO_0 PARAM_VALUE.RATIO_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RATIO_0}] ${MODELPARAM_VALUE.RATIO_0}
}

proc update_MODELPARAM_VALUE.DYNAMIC_RECONFIG_0 { MODELPARAM_VALUE.DYNAMIC_RECONFIG_0 PARAM_VALUE.DYNAMIC_RECONFIG_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DYNAMIC_RECONFIG_0}] ${MODELPARAM_VALUE.DYNAMIC_RECONFIG_0}
}

proc update_MODELPARAM_VALUE.RISING_EDGE_0 { MODELPARAM_VALUE.RISING_EDGE_0 PARAM_VALUE.RISING_EDGE_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISING_EDGE_0}] ${MODELPARAM_VALUE.RISING_EDGE_0}
}

proc update_MODELPARAM_VALUE.RATIO_1 { MODELPARAM_VALUE.RATIO_1 PARAM_VALUE.RATIO_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RATIO_1}] ${MODELPARAM_VALUE.RATIO_1}
}

proc update_MODELPARAM_VALUE.DYNAMIC_RECONFIG_1 { MODELPARAM_VALUE.DYNAMIC_RECONFIG_1 PARAM_VALUE.DYNAMIC_RECONFIG_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DYNAMIC_RECONFIG_1}] ${MODELPARAM_VALUE.DYNAMIC_RECONFIG_1}
}

proc update_MODELPARAM_VALUE.RISING_EDGE_1 { MODELPARAM_VALUE.RISING_EDGE_1 PARAM_VALUE.RISING_EDGE_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISING_EDGE_1}] ${MODELPARAM_VALUE.RISING_EDGE_1}
}

proc update_MODELPARAM_VALUE.RATIO_2 { MODELPARAM_VALUE.RATIO_2 PARAM_VALUE.RATIO_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RATIO_2}] ${MODELPARAM_VALUE.RATIO_2}
}

proc update_MODELPARAM_VALUE.DYNAMIC_RECONFIG_2 { MODELPARAM_VALUE.DYNAMIC_RECONFIG_2 PARAM_VALUE.DYNAMIC_RECONFIG_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DYNAMIC_RECONFIG_2}] ${MODELPARAM_VALUE.DYNAMIC_RECONFIG_2}
}

proc update_MODELPARAM_VALUE.RISING_EDGE_2 { MODELPARAM_VALUE.RISING_EDGE_2 PARAM_VALUE.RISING_EDGE_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISING_EDGE_2}] ${MODELPARAM_VALUE.RISING_EDGE_2}
}

proc update_MODELPARAM_VALUE.RATIO_3 { MODELPARAM_VALUE.RATIO_3 PARAM_VALUE.RATIO_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RATIO_3}] ${MODELPARAM_VALUE.RATIO_3}
}

proc update_MODELPARAM_VALUE.DYNAMIC_RECONFIG_3 { MODELPARAM_VALUE.DYNAMIC_RECONFIG_3 PARAM_VALUE.DYNAMIC_RECONFIG_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DYNAMIC_RECONFIG_3}] ${MODELPARAM_VALUE.DYNAMIC_RECONFIG_3}
}

proc update_MODELPARAM_VALUE.RISING_EDGE_3 { MODELPARAM_VALUE.RISING_EDGE_3 PARAM_VALUE.RISING_EDGE_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISING_EDGE_3}] ${MODELPARAM_VALUE.RISING_EDGE_3}
}

proc update_MODELPARAM_VALUE.ENABLE_SYNC_DELAY { MODELPARAM_VALUE.ENABLE_SYNC_DELAY PARAM_VALUE.ENABLE_SYNC_DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_SYNC_DELAY}] ${MODELPARAM_VALUE.ENABLE_SYNC_DELAY}
}


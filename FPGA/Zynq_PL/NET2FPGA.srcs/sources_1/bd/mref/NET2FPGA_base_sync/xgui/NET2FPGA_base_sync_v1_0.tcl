# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CONSTANT_REGISTER_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PORT_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.CONSTANT_REGISTER_DEPTH { PARAM_VALUE.CONSTANT_REGISTER_DEPTH } {
	# Procedure called to update CONSTANT_REGISTER_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONSTANT_REGISTER_DEPTH { PARAM_VALUE.CONSTANT_REGISTER_DEPTH } {
	# Procedure called to validate CONSTANT_REGISTER_DEPTH
	return true
}

proc update_PARAM_VALUE.PORT_WIDTH { PARAM_VALUE.PORT_WIDTH } {
	# Procedure called to update PORT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_WIDTH { PARAM_VALUE.PORT_WIDTH } {
	# Procedure called to validate PORT_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.PORT_WIDTH { MODELPARAM_VALUE.PORT_WIDTH PARAM_VALUE.PORT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_WIDTH}] ${MODELPARAM_VALUE.PORT_WIDTH}
}

proc update_MODELPARAM_VALUE.CONSTANT_REGISTER_DEPTH { MODELPARAM_VALUE.CONSTANT_REGISTER_DEPTH PARAM_VALUE.CONSTANT_REGISTER_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONSTANT_REGISTER_DEPTH}] ${MODELPARAM_VALUE.CONSTANT_REGISTER_DEPTH}
}


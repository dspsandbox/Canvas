
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# NET2FPGA_base_DAC, NET2FPGA_base_DSP_core, NET2FPGA_base_convertType_14_32, NET2FPGA_base_convertType_14_32, NET2FPGA_base_convertType_32_14, NET2FPGA_base_convertType_32_14, NET2FPGA_base_sync

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: PS_ZYNQ
proc create_hier_cell_PS_ZYNQ { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_PS_ZYNQ() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir I -type clk M01_ACLK
  create_bd_pin -dir O -from 31 -to 0 gpio_io_o
  create_bd_pin -dir O -from 31 -to 0 gpio_io_o1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset

  # Create instance: axi_gpio_WrtEn, and set properties
  set axi_gpio_WrtEn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_WrtEn ]

  # Create instance: axi_gpio_regAddr, and set properties
  set axi_gpio_regAddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_regAddr ]

  # Create instance: axi_gpio_regVal, and set properties
  set axi_gpio_regVal [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_regVal ]

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
 ] $axi_interconnect

  # Create instance: proc_sys_reset_125, and set properties
  set proc_sys_reset_125 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_125 ]

  # Create instance: proc_sys_reset_AXI, and set properties
  set proc_sys_reset_AXI [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_AXI ]

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
 ] $processing_system7

  # Create instance: xlslice, and set properties
  set xlslice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_regAddr/S_AXI] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_gpio_regVal/S_AXI] [get_bd_intf_pins axi_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_WrtEn/S_AXI] [get_bd_intf_pins axi_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect/S00_AXI] [get_bd_intf_pins processing_system7/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net ADC_and_DAC_clk_clk_out1 [get_bd_pins M01_ACLK] [get_bd_pins axi_gpio_WrtEn/s_axi_aclk] [get_bd_pins axi_gpio_regAddr/s_axi_aclk] [get_bd_pins axi_gpio_regVal/s_axi_aclk] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins proc_sys_reset_125/slowest_sync_clk]
  connect_bd_net -net Net [get_bd_pins axi_gpio_WrtEn/s_axi_aresetn] [get_bd_pins axi_gpio_regAddr/s_axi_aresetn] [get_bd_pins axi_gpio_regVal/s_axi_aresetn] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins proc_sys_reset_125/peripheral_aresetn]
  connect_bd_net -net PS_ZYNQ_Dout [get_bd_pins Dout] [get_bd_pins xlslice/Dout]
  connect_bd_net -net PS_ZYNQ_gpio_io_o [get_bd_pins gpio_io_o] [get_bd_pins axi_gpio_regAddr/gpio_io_o]
  connect_bd_net -net PS_ZYNQ_gpio_io_o1 [get_bd_pins gpio_io_o1] [get_bd_pins axi_gpio_regVal/gpio_io_o]
  connect_bd_net -net PS_ZYNQ_peripheral_reset [get_bd_pins peripheral_reset] [get_bd_pins proc_sys_reset_AXI/peripheral_reset]
  connect_bd_net -net axi_gpio_regValWrtEn_gpio_io_o [get_bd_pins axi_gpio_WrtEn/gpio_io_o] [get_bd_pins xlslice/Din]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins proc_sys_reset_AXI/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins proc_sys_reset_AXI/slowest_sync_clk] [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins processing_system7/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_125/ext_reset_in] [get_bd_pins proc_sys_reset_AXI/ext_reset_in] [get_bd_pins processing_system7/FCLK_RESET0_N]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ADC
proc create_hier_cell_ADC { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ADC() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 adc_cdcs_o
  create_bd_pin -dir I -from 0 -to 0 -type clk adc_clk_n_i
  create_bd_pin -dir I -from 0 -to 0 -type clk adc_clk_p_i
  create_bd_pin -dir O -type clk clk
  create_bd_pin -dir O -type clk dac_clk
  create_bd_pin -dir I -type rst reset

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {128.871} \
   CONFIG.CLKOUT1_PHASE_ERROR {112.379} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.CLKOUT1_REQUESTED_PHASE {0} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {112.962} \
   CONFIG.CLKOUT2_PHASE_ERROR {112.379} \
   CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {150} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.JITTER_SEL {Min_O_Jitter} \
   CONFIG.MMCM_BANDWIDTH {HIGH} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.MMCM_CLKOUT0_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT1_PHASE {150.000} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_IN_FREQ {125} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
 ] $clk_wiz

  # Create instance: const_1, and set properties
  set const_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_1 ]

  # Create port connections
  connect_bd_net -net ADC_and_DAC_clk_clk250 [get_bd_pins dac_clk] [get_bd_pins clk_wiz/clk_out2]
  connect_bd_net -net ADC_and_DAC_clk_clk_out1 [get_bd_pins clk] [get_bd_pins clk_wiz/clk_out1]
  connect_bd_net -net ADC_clk_adc_cdcs_o [get_bd_pins adc_cdcs_o] [get_bd_pins const_1/dout]
  connect_bd_net -net PS_ZYNQ_peripheral_reset [get_bd_pins reset] [get_bd_pins clk_wiz/reset]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_pins adc_clk_n_i] [get_bd_pins clk_wiz/clk_in1_n]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_pins adc_clk_p_i] [get_bd_pins clk_wiz/clk_in1_p]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set adc_cdcs_o [ create_bd_port -dir O -from 0 -to 0 adc_cdcs_o ]
  set adc_clk_n_i [ create_bd_port -dir I -type clk adc_clk_n_i ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $adc_clk_n_i
  set adc_clk_p_i [ create_bd_port -dir I -type clk adc_clk_p_i ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $adc_clk_p_i
  set adc_data1_i [ create_bd_port -dir I -from 13 -to 0 adc_data1_i ]
  set adc_data2_i [ create_bd_port -dir I -from 13 -to 0 adc_data2_i ]
  set dac_clk_o [ create_bd_port -dir O dac_clk_o ]
  set dac_data_o [ create_bd_port -dir O -from 13 -to 0 dac_data_o ]
  set dac_rst_o [ create_bd_port -dir O -from 0 -to 0 dac_rst_o ]
  set dac_sel_o [ create_bd_port -dir O -from 0 -to 0 dac_sel_o ]
  set dac_wrt_o [ create_bd_port -dir O -from 0 -to 0 dac_wrt_o ]
  set digital_i [ create_bd_port -dir I -from 7 -to 0 digital_i ]
  set digital_o [ create_bd_port -dir O -from 7 -to 0 digital_o ]
  set led_o [ create_bd_port -dir O -from 7 -to 0 led_o ]

  # Create instance: ADC
  create_hier_cell_ADC [current_bd_instance .] ADC

  # Create instance: DAC, and set properties
  set block_name NET2FPGA_base_DAC
  set block_cell_name DAC
  if { [catch {set DAC [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DAC eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: DSP_core, and set properties
  set block_name NET2FPGA_base_DSP_core
  set block_cell_name DSP_core
  if { [catch {set DSP_core [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DSP_core eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: PS_ZYNQ
  create_hier_cell_PS_ZYNQ [current_bd_instance .] PS_ZYNQ

  # Create instance: convertType_14_32_ADC1, and set properties
  set block_name NET2FPGA_base_convertType_14_32
  set block_cell_name convertType_14_32_ADC1
  if { [catch {set convertType_14_32_ADC1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $convertType_14_32_ADC1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: convertType_14_32_ADC2, and set properties
  set block_name NET2FPGA_base_convertType_14_32
  set block_cell_name convertType_14_32_ADC2
  if { [catch {set convertType_14_32_ADC2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $convertType_14_32_ADC2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: convertType_32_14_DAC1, and set properties
  set block_name NET2FPGA_base_convertType_32_14
  set block_cell_name convertType_32_14_DAC1
  if { [catch {set convertType_32_14_DAC1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $convertType_32_14_DAC1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: convertType_32_14_DAC2, and set properties
  set block_name NET2FPGA_base_convertType_32_14
  set block_cell_name convertType_32_14_DAC2
  if { [catch {set convertType_32_14_DAC2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $convertType_32_14_DAC2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sync_digitalIn, and set properties
  set block_name NET2FPGA_base_sync
  set block_cell_name sync_digitalIn
  if { [catch {set sync_digitalIn [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sync_digitalIn eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins PS_ZYNQ/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins PS_ZYNQ/FIXED_IO]

  # Create port connections
  connect_bd_net -net ADC_and_DAC_clk_clk250 [get_bd_pins ADC/dac_clk] [get_bd_pins DAC/dac_clk]
  connect_bd_net -net ADC_and_DAC_clk_clk_out1 [get_bd_pins ADC/clk] [get_bd_pins DAC/clk] [get_bd_pins DSP_core/clk] [get_bd_pins PS_ZYNQ/M01_ACLK] [get_bd_pins convertType_14_32_ADC1/clk] [get_bd_pins convertType_14_32_ADC2/clk] [get_bd_pins convertType_32_14_DAC1/clk] [get_bd_pins convertType_32_14_DAC2/clk] [get_bd_pins sync_digitalIn/clk]
  connect_bd_net -net ADC_clk_adc_cdcs_o [get_bd_ports adc_cdcs_o] [get_bd_pins ADC/adc_cdcs_o]
  connect_bd_net -net NET2FPGA_base_DAC_dac_clk_o [get_bd_ports dac_clk_o] [get_bd_pins DAC/dac_clk_o]
  connect_bd_net -net NET2FPGA_base_DAC_dac_dat_o [get_bd_ports dac_data_o] [get_bd_pins DAC/dac_dat_o]
  connect_bd_net -net NET2FPGA_base_DAC_dac_rst_o [get_bd_ports dac_rst_o] [get_bd_pins DAC/dac_rst_o]
  connect_bd_net -net NET2FPGA_base_DAC_dac_sel_o [get_bd_ports dac_sel_o] [get_bd_pins DAC/dac_sel_o]
  connect_bd_net -net NET2FPGA_base_DAC_dac_wrt_o [get_bd_ports dac_wrt_o] [get_bd_pins DAC/dac_wrt_o]
  connect_bd_net -net NET2FPGA_base_DSP_co_0_dac_data1_o [get_bd_pins DAC/dac_data1] [get_bd_pins convertType_32_14_DAC1/dataOut]
  connect_bd_net -net NET2FPGA_base_DSP_co_0_dac_data2_o [get_bd_pins DAC/dac_data2] [get_bd_pins convertType_32_14_DAC2/dataOut]
  connect_bd_net -net NET2FPGA_base_DSP_co_0_digital_o [get_bd_ports digital_o] [get_bd_pins DSP_core/digitalOut]
  connect_bd_net -net NET2FPGA_base_DSP_co_0_led_o [get_bd_ports led_o] [get_bd_pins DSP_core/led]
  connect_bd_net -net NET2FPGA_base_DSP_core_dac1 [get_bd_pins DSP_core/dac1] [get_bd_pins convertType_32_14_DAC1/dataIn]
  connect_bd_net -net NET2FPGA_base_DSP_core_dac2 [get_bd_pins DSP_core/dac2] [get_bd_pins convertType_32_14_DAC2/dataIn]
  connect_bd_net -net NET2FPGA_base_conver_0_dataOut [get_bd_pins DSP_core/adc1] [get_bd_pins convertType_14_32_ADC1/dataOut]
  connect_bd_net -net NET2FPGA_base_convertType_14_32_ADC2_dataOut [get_bd_pins DSP_core/adc2] [get_bd_pins convertType_14_32_ADC2/dataOut]
  connect_bd_net -net NET2FPGA_base_sync_0_dataOut [get_bd_pins DSP_core/digitalIn] [get_bd_pins sync_digitalIn/dataOut]
  connect_bd_net -net PS_ZYNQ_Dout [get_bd_pins DSP_core/regWrtEn] [get_bd_pins PS_ZYNQ/Dout]
  connect_bd_net -net PS_ZYNQ_gpio_io_o [get_bd_pins DSP_core/regAddr] [get_bd_pins PS_ZYNQ/gpio_io_o]
  connect_bd_net -net PS_ZYNQ_gpio_io_o1 [get_bd_pins DSP_core/regVal] [get_bd_pins PS_ZYNQ/gpio_io_o1]
  connect_bd_net -net PS_ZYNQ_peripheral_reset [get_bd_pins ADC/reset] [get_bd_pins PS_ZYNQ/peripheral_reset]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_ports adc_clk_n_i] [get_bd_pins ADC/adc_clk_n_i]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_ports adc_clk_p_i] [get_bd_pins ADC/adc_clk_p_i]
  connect_bd_net -net adc_data1_i_1 [get_bd_ports adc_data1_i] [get_bd_pins convertType_14_32_ADC1/dataIn]
  connect_bd_net -net adc_data2_i_1 [get_bd_ports adc_data2_i] [get_bd_pins convertType_14_32_ADC2/dataIn]
  connect_bd_net -net digital_i_1 [get_bd_ports digital_i] [get_bd_pins sync_digitalIn/dataIn]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces PS_ZYNQ/processing_system7/Data] [get_bd_addr_segs PS_ZYNQ/axi_gpio_regAddr/S_AXI/Reg] SEG_axi_gpio_regAddr_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41220000 [get_bd_addr_spaces PS_ZYNQ/processing_system7/Data] [get_bd_addr_segs PS_ZYNQ/axi_gpio_regVal/S_AXI/Reg] SEG_axi_gpio_regValLow_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces PS_ZYNQ/processing_system7/Data] [get_bd_addr_segs PS_ZYNQ/axi_gpio_WrtEn/S_AXI/Reg] SEG_axi_gpio_regValWrtEn_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



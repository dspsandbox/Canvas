############################################################################
#NET2FPGA_redpitaya constrains file
 
#MIT License
#Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
############################################################################

#######################
# ADC
#######################

# ADC data 1
set_property IOSTANDARD LVCMOS18 [get_ports {adc_data1_i[*]}]
set_property IOB        TRUE     [get_ports {adc_data1_i[*]}]

set_property PACKAGE_PIN Y17     [get_ports {adc_data1_i[0]}]
set_property PACKAGE_PIN W16     [get_ports {adc_data1_i[1]}]
set_property PACKAGE_PIN Y16     [get_ports {adc_data1_i[2]}]
set_property PACKAGE_PIN W15     [get_ports {adc_data1_i[3]}]
set_property PACKAGE_PIN W14     [get_ports {adc_data1_i[4]}]
set_property PACKAGE_PIN Y14     [get_ports {adc_data1_i[5]}]
set_property PACKAGE_PIN W13     [get_ports {adc_data1_i[6]}]
set_property PACKAGE_PIN V12     [get_ports {adc_data1_i[7]}]
set_property PACKAGE_PIN V13     [get_ports {adc_data1_i[8]}]
set_property PACKAGE_PIN T14     [get_ports {adc_data1_i[9]}]
set_property PACKAGE_PIN T15     [get_ports {adc_data1_i[10]}]
set_property PACKAGE_PIN V15     [get_ports {adc_data1_i[11]}]
set_property PACKAGE_PIN T16     [get_ports {adc_data1_i[12]}]
set_property PACKAGE_PIN V16     [get_ports {adc_data1_i[13]}]

# ADC data 2
set_property IOSTANDARD LVCMOS18 [get_ports {adc_data2_i[*]}]
set_property IOB        TRUE     [get_ports {adc_data2_i[*]}]

set_property PACKAGE_PIN R18     [get_ports {adc_data2_i[0]}]
set_property PACKAGE_PIN P16     [get_ports {adc_data2_i[1]}]
set_property PACKAGE_PIN P18     [get_ports {adc_data2_i[2]}]
set_property PACKAGE_PIN N17     [get_ports {adc_data2_i[3]}]
set_property PACKAGE_PIN R19     [get_ports {adc_data2_i[4]}]
set_property PACKAGE_PIN T20     [get_ports {adc_data2_i[5]}]
set_property PACKAGE_PIN T19     [get_ports {adc_data2_i[6]}]
set_property PACKAGE_PIN U20     [get_ports {adc_data2_i[7]}]
set_property PACKAGE_PIN V20     [get_ports {adc_data2_i[8]}]
set_property PACKAGE_PIN W20     [get_ports {adc_data2_i[9]}]
set_property PACKAGE_PIN W19     [get_ports {adc_data2_i[10]}]
set_property PACKAGE_PIN Y19     [get_ports {adc_data2_i[11]}]
set_property PACKAGE_PIN W18     [get_ports {adc_data2_i[12]}]
set_property PACKAGE_PIN Y18     [get_ports {adc_data2_i[13]}]

# ADC clk input
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports adc_clk_p_i]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports adc_clk_n_i]

set_property PACKAGE_PIN U18           [get_ports adc_clk_p_i]
set_property PACKAGE_PIN U19           [get_ports adc_clk_n_i]


# ADC clock duty cycle stabilizer (cdcs)
set_property IOSTANDARD LVCMOS18 [get_ports adc_cdcs_o]
set_property SLEW       FAST     [get_ports adc_cdcs_o]
set_property DRIVE      8        [get_ports adc_cdcs_o]
set_property PACKAGE_PIN V18     [get_ports adc_cdcs_o]


#######################
# DAC
#######################


# DAC data
set_property IOSTANDARD LVCMOS33 [get_ports {dac_data_o[*]}]
set_property SLEW       SLOW     [get_ports {dac_data_o[*]}]
set_property DRIVE      4        [get_ports {dac_data_o[*]}]
#set_property IOB        FALSE     [get_ports {dac_data_o[*]}]


set_property PACKAGE_PIN M19 [get_ports {dac_data_o[0]}]
set_property PACKAGE_PIN M20 [get_ports {dac_data_o[1]}]
set_property PACKAGE_PIN L19 [get_ports {dac_data_o[2]}]
set_property PACKAGE_PIN L20 [get_ports {dac_data_o[3]}]
set_property PACKAGE_PIN K19 [get_ports {dac_data_o[4]}]
set_property PACKAGE_PIN J19 [get_ports {dac_data_o[5]}]
set_property PACKAGE_PIN J20 [get_ports {dac_data_o[6]}]
set_property PACKAGE_PIN H20 [get_ports {dac_data_o[7]}]
set_property PACKAGE_PIN G19 [get_ports {dac_data_o[8]}]
set_property PACKAGE_PIN G20 [get_ports {dac_data_o[9]}]
set_property PACKAGE_PIN F19 [get_ports {dac_data_o[10]}]
set_property PACKAGE_PIN F20 [get_ports {dac_data_o[11]}]
set_property PACKAGE_PIN D20 [get_ports {dac_data_o[12]}]
set_property PACKAGE_PIN D19 [get_ports {dac_data_o[13]}]

# DAC control
set_property IOSTANDARD LVCMOS33 [get_ports dac_wrt_o]
set_property SLEW       FAST     [get_ports dac_wrt_o]
set_property DRIVE      8        [get_ports dac_wrt_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_sel_o]
set_property SLEW       FAST     [get_ports dac_sel_o]
set_property DRIVE      8        [get_ports dac_sel_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_clk_o]
set_property SLEW       FAST     [get_ports dac_clk_o]
set_property DRIVE      8        [get_ports dac_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports dac_rst_o]
set_property SLEW       FAST     [get_ports dac_rst_o]
set_property DRIVE      8        [get_ports dac_rst_o]

set_property PACKAGE_PIN M17 [get_ports dac_wrt_o]
set_property PACKAGE_PIN N16 [get_ports dac_sel_o]
set_property PACKAGE_PIN M18 [get_ports dac_clk_o]
set_property PACKAGE_PIN N15 [get_ports dac_rst_o]

#set_property IOB        FALSE     [get_ports {dac_wrt_o}]
#set_property IOB        FALSE     [get_ports {dac_sel_o}]
#set_property IOB        FALSE     [get_ports {dac_clk_o}]
#set_property IOB        FALSE     [get_ports {dac_rst_o}]


#######################
# LED
#######################

set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
set_property SLEW       SLOW     [get_ports {led_o[*]}]
set_property DRIVE      4        [get_ports {led_o[*]}]

set_property PACKAGE_PIN F16     [get_ports {led_o[0]}]
set_property PACKAGE_PIN F17     [get_ports {led_o[1]}]
set_property PACKAGE_PIN G15     [get_ports {led_o[2]}]
set_property PACKAGE_PIN H15     [get_ports {led_o[3]}]
set_property PACKAGE_PIN K14     [get_ports {led_o[4]}]
set_property PACKAGE_PIN G14     [get_ports {led_o[5]}]
set_property PACKAGE_PIN J15     [get_ports {led_o[6]}]
set_property PACKAGE_PIN J14     [get_ports {led_o[7]}]

#######################
# Digital input 
# digitalIn0 ----- > expansionConnector_positive_0
# digitalIn1 ----- > expansionConnector_positive_1
# digitalIn2 ----- > expansionConnector_positive_2
# digitalIn3 ----- > expansionConnector_positive_3
# digitalIn4 ----- > expansionConnector_positive_4
# digitalIn5 ----- > expansionConnector_positive_5
# digitalIn6 ----- > expansionConnector_positive_6
# digitalIn7 ----- > expansionConnector_positive_7
#######################
set_property IOSTANDARD LVCMOS33 [get_ports {digital_i[*]}]
set_property IOB        TRUE     [get_ports {digital_i[*]}]
set_property PULLTYPE PULLDOWN [get_ports {digital_i[*]}]


set_property PACKAGE_PIN G17 [get_ports {digital_i[0]}]
set_property PACKAGE_PIN H16 [get_ports {digital_i[1]}]
set_property PACKAGE_PIN J18 [get_ports {digital_i[2]}]
set_property PACKAGE_PIN K17 [get_ports {digital_i[3]}]
set_property PACKAGE_PIN L14 [get_ports {digital_i[4]}]
set_property PACKAGE_PIN L16 [get_ports {digital_i[5]}]
set_property PACKAGE_PIN K16 [get_ports {digital_i[6]}]
set_property PACKAGE_PIN M14 [get_ports {digital_i[7]}]

#######################
# Digital output 
# digitalOut0 ----- > expansionConnector_negative_0
# digitalOut1 ----- > expansionConnector_negative_1
# digitalOut2 ----- > expansionConnector_negative_2
# digitalOut3 ----- > expansionConnector_negative_3
# digitalOut4 ----- > expansionConnector_negative_4
# digitalOut5 ----- > expansionConnector_negative_5
# digitalOut6 ----- > expansionConnector_negative_6
# digitalOut7 ----- > expansionConnector_negative_7
#######################
set_property IOSTANDARD LVCMOS33 [get_ports {digital_o[*]}]
set_property SLEW FAST [get_ports {digital_o[*]}]
set_property DRIVE 8 [get_ports {digital_o[*]}]

set_property PACKAGE_PIN G18 [get_ports {digital_o[0]}]
set_property PACKAGE_PIN H17 [get_ports {digital_o[1]}]
set_property PACKAGE_PIN H18 [get_ports {digital_o[2]}]
set_property PACKAGE_PIN K18 [get_ports {digital_o[3]}]
set_property PACKAGE_PIN L15 [get_ports {digital_o[4]}]
set_property PACKAGE_PIN L17 [get_ports {digital_o[5]}]
set_property PACKAGE_PIN J16 [get_ports {digital_o[6]}]
set_property PACKAGE_PIN M15 [get_ports {digital_o[7]}]


#######################
# CLOCK
#######################

#create_clock -period 8.000 -name adc_clk [get_ports adc_clk_p_i]
set_input_delay -clock adc_clk_p_i 3.400 [get_ports adc_data1_i[*]]
set_input_delay -clock adc_clk_p_i 3.400 [get_ports adc_data2_i[*]]
#create_generated_clock -name dac_clk250  -divide_by 1 -source [get_pins design_1_i/DAC/U0/ODDR_dac_clk/C] [get_ports dac_clk_o]
#set_output_delay -clock [get_clocks dac_clk250] -max 1 [get_ports dac_data_o[*]]
#set_output_delay -clock [get_clocks dac_clk250] -min -1 [get_ports dac_data_o[*]]
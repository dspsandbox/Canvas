--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
--Date        : Mon Jul 29 12:55:36 2019
--Host        : PC1091 running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    adc_cdcs_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clk_n_i : in STD_LOGIC;
    adc_clk_p_i : in STD_LOGIC;
    adc_data1_i : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data2_i : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dac_clk_o : out STD_LOGIC;
    dac_data_o : out STD_LOGIC_VECTOR ( 13 downto 0 );
    dac_rst_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    dac_sel_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    dac_wrt_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    digital_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    digital_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    led_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    adc_data1_i : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_data2_i : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dac_data_o : out STD_LOGIC_VECTOR ( 13 downto 0 );
    dac_wrt_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    dac_rst_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clk_p_i : in STD_LOGIC;
    adc_clk_n_i : in STD_LOGIC;
    led_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    digital_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    digital_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    adc_cdcs_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    dac_sel_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    dac_clk_o : out STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      adc_cdcs_o(0) => adc_cdcs_o(0),
      adc_clk_n_i => adc_clk_n_i,
      adc_clk_p_i => adc_clk_p_i,
      adc_data1_i(13 downto 0) => adc_data1_i(13 downto 0),
      adc_data2_i(13 downto 0) => adc_data2_i(13 downto 0),
      dac_clk_o => dac_clk_o,
      dac_data_o(13 downto 0) => dac_data_o(13 downto 0),
      dac_rst_o(0) => dac_rst_o(0),
      dac_sel_o(0) => dac_sel_o(0),
      dac_wrt_o(0) => dac_wrt_o(0),
      digital_i(7 downto 0) => digital_i(7 downto 0),
      digital_o(7 downto 0) => digital_o(7 downto 0),
      led_o(7 downto 0) => led_o(7 downto 0)
    );
end STRUCTURE;

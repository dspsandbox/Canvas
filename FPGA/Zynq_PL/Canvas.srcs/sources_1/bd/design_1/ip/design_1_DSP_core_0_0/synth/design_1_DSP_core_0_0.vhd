-- (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:DSP_core:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_DSP_core_0_0 IS
  PORT (
    clk : IN STD_LOGIC;
    regAddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    regVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    regWrtEn : IN STD_LOGIC;
    adc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    adc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    digitalIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dac1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dac2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    digitalOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    led : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END design_1_DSP_core_0_0;

ARCHITECTURE design_1_DSP_core_0_0_arch OF design_1_DSP_core_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_DSP_core_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT DSP_core IS
    GENERIC (
      PORT_WIDTH : INTEGER;
      CONSTANT_REGISTER_DEPTH : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      regAddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      regVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      regWrtEn : IN STD_LOGIC;
      adc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      adc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      digitalIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      dac1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dac2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      digitalOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      led : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT DSP_core;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_DSP_core_0_0_arch: ARCHITECTURE IS "DSP_core,Vivado 2018.3";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_DSP_core_0_0_arch : ARCHITECTURE IS "design_1_DSP_core_0_0,DSP_core,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_DSP_core_0_0_arch: ARCHITECTURE IS "design_1_DSP_core_0_0,DSP_core,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=DSP_core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,PORT_WIDTH=32,CONSTANT_REGISTER_DEPTH=8}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_DSP_core_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF clk: SIGNAL IS "XIL_INTERFACENAME clk, FREQ_HZ 125000000, PHASE 0.0, CLK_DOMAIN /ADC/clk_wiz_clk_out1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF clk: SIGNAL IS "xilinx.com:signal:clock:1.0 clk CLK";
BEGIN
  U0 : DSP_core
    GENERIC MAP (
      PORT_WIDTH => 32,
      CONSTANT_REGISTER_DEPTH => 8
    )
    PORT MAP (
      clk => clk,
      regAddr => regAddr,
      regVal => regVal,
      regWrtEn => regWrtEn,
      adc1 => adc1,
      adc2 => adc2,
      digitalIn => digitalIn,
      dac1 => dac1,
      dac2 => dac2,
      digitalOut => digitalOut,
      led => led
    );
END design_1_DSP_core_0_0_arch;

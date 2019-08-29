----------------------------------------------------------------------------------
--NET2FPGA_base_DSP_core module

--MIT License
--Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NET2FPGA_base_DSP_core is
	Generic(PORT_WIDTH : integer := 32;
			CONSTANT_REGISTER_DEPTH : integer := 8);
    Port ( clk : in STD_LOGIC;
           regAddr : in STD_LOGIC_VECTOR (31 downto 0);
           regVal : in STD_LOGIC_VECTOR (31 downto 0);
           regWrtEn : in STD_LOGIC;
           adc1 : in STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           adc2 : in STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           digitalIn : in STD_LOGIC_VECTOR (7 downto 0);
           dac1 : out STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           dac2 : out STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           digitalOut : out STD_LOGIC_VECTOR (7 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0));
end NET2FPGA_base_DSP_core;

architecture Behavioral of NET2FPGA_base_DSP_core is

type constantRegister32BitType is array (((2**CONSTANT_REGISTER_DEPTH)-1) downto 0) of STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0);
type constantRegister1BitType is array (((2**CONSTANT_REGISTER_DEPTH)-1) downto 0) of STD_LOGIC;

signal constantRegister32Bit :  constantRegister32BitType:= (others=>(others=>'0'));
signal constantRegister1Bit :  constantRegister1BitType:= (others=>'0');
signal adc1_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal adc2_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal dac1_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal dac2_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal digitalIn_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal digitalOut_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal led_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');

---------------------------------------------------------------------------------------------------
--NET2FPGA SIGNALS START
signal N000 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N001 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N002 : STD_LOGIC := '0';
signal N003 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N004 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N005 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N006 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N007 : STD_LOGIC := '0';
signal N008 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N009 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N010 : STD_LOGIC := '0';
signal N011 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N012 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N013 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N014 : STD_LOGIC := '0';
signal N015 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N016 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N017 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N018 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N019 : STD_LOGIC := '0';
signal N020 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N021 : STD_LOGIC := '0';
signal N022 : STD_LOGIC := '0';
--NET2FPGA SIGNALS END
---------------------------------------------------------------------------------------------------


begin
	process(clk)
	variable regAddr_var : integer :=0;
	variable regVal32Bit_var : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):= (others=>'0');
	variable regVal1Bit_var : STD_LOGIC:='0';
	variable regType: STD_LOGIC := '0';  --   regType=1 -> 32bit   regType=0 -> 1 bit
	begin
		if rising_edge(clk) then
		--Parse communication for setting constants
			if regWrtEn='1' then
				regType:= regAddr(31);
				regAddr_var:=to_integer(unsigned(regAddr((CONSTANT_REGISTER_DEPTH-1) downto 0)));
				regVal32Bit_var:= regVal;
				regVal1Bit_var:= regVal(0);

				if regType='1' then
					constantRegister32Bit(regAddr_var)<=regVal32Bit_var;
				else
					constantRegister1Bit(regAddr_var)<=regVal1Bit_var;
				end if;	
			end if;
		end if;	
	end process;

	-- in/out port <-> signal assignements	
    adc1_signal<=adc1;
    adc2_signal<=adc2;
    dac1<=dac1_signal;
    dac2<=dac2_signal;
    digitalIn_signal<=digitalIn;
    digitalOut<=digitalOut_signal;
    led<=led_signal;	
    
---------------------------------------------------------------------------------------------------
--NET2FPGA INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS START
--X_NET2FPGA_32Bit_DAC1_0:
dac1_signal<=N000;

X_NET2FPGA_32Bit_add_0 : entity xil_defaultlib.NET2FPGA_32Bit_add
port map(clk=>clk,reset=>N002,dataIn0=>N001,dataIn1=>N000,dataOut=>N000);

X_NET2FPGA_32Bit_shiftR_0 : entity xil_defaultlib.NET2FPGA_32Bit_shiftR
port map(clk=>clk,dataIn=>N003,dataShiftR=>N004,dataOut=>N001);

X_NET2FPGA_32Bit_switch_0 : entity xil_defaultlib.NET2FPGA_32Bit_switch
port map(clk=>clk,dataInSwitch=>N007,dataIn0=>N005,dataIn1=>N006,dataOut=>N003);

--X_NET2FPGA_32Bit_const_0:
N005<=constantRegister32Bit(0);

X_NET2FPGA_32Bit_add_1 : entity xil_defaultlib.NET2FPGA_32Bit_add
port map(clk=>clk,reset=>N010,dataIn0=>N008,dataIn1=>N009,dataOut=>N006);

--X_NET2FPGA_32Bit_ADC1_0:
N008<=adc1_signal;

--X_NET2FPGA_32Bit_const_1:
N009<=constantRegister32Bit(1);

--X_NET2FPGA_1Bit_const_0:
N010<=constantRegister1Bit(0);

--X_NET2FPGA_1Bit_digitalIn1_0:
N007<=digitalIn_signal(1);

--X_NET2FPGA_32Bit_const_2:
N004<=constantRegister32Bit(2);

--X_NET2FPGA_1Bit_digitalIn0_0:
N002<=digitalIn_signal(0);

--X_NET2FPGA_32Bit_DAC2_0:
dac2_signal<=N011;

X_NET2FPGA_32Bit_add_2 : entity xil_defaultlib.NET2FPGA_32Bit_add
port map(clk=>clk,reset=>N014,dataIn0=>N012,dataIn1=>N013,dataOut=>N011);

X_NET2FPGA_32Bit_shiftL_0 : entity xil_defaultlib.NET2FPGA_32Bit_shiftL
port map(clk=>clk,dataIn=>N015,dataShiftL=>N016,dataOut=>N012);

X_NET2FPGA_32Bit_sub_0 : entity xil_defaultlib.NET2FPGA_32Bit_sub
port map(clk=>clk,reset=>N019,dataIn0=>N017,dataIn1=>N018,dataOut=>N015);

X_NET2FPGA_32Bit_sampleHold_0 : entity xil_defaultlib.NET2FPGA_32Bit_sampleHold
port map(clk=>clk,hold=>N021,dataIn=>N020,dataOut=>N017);

--X_NET2FPGA_32Bit_ADC2_0:
N020<=adc2_signal;

--X_NET2FPGA_1Bit_digitalIn3_0:
N021<=digitalIn_signal(3);

X_NET2FPGA_32Bit_sampleHold_1 : entity xil_defaultlib.NET2FPGA_32Bit_sampleHold
port map(clk=>clk,hold=>N022,dataIn=>N020,dataOut=>N018);

--X_NET2FPGA_1Bit_digitalIn2_0:
N022<=digitalIn_signal(2);

--X_NET2FPGA_1Bit_const_1:
N019<=constantRegister1Bit(1);

--X_NET2FPGA_32Bit_const_3:
N016<=constantRegister32Bit(3);

--X_NET2FPGA_32Bit_const_4:
N013<=constantRegister32Bit(4);

--X_NET2FPGA_1Bit_const_2:
N014<=constantRegister1Bit(2);

--NET2FPGA INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS END
---------------------------------------------------------------------------------------------------

end Behavioral;
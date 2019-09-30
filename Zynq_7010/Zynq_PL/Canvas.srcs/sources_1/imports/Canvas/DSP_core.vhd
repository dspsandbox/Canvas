----------------------------------------------------------------------------------
--DSP_core module

--MIT License
--Copyright (c) 2019 DSPsandbox (Pau Gomez pau.gomez@dspsandbox.org)
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

entity DSP_core is
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
end DSP_core;

architecture Behavioral of DSP_core is

type x32ConstRegType is array (((2**CONSTANT_REGISTER_DEPTH)-1) downto 0) of STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0);
type x1ConstRegType is array (((2**CONSTANT_REGISTER_DEPTH)-1) downto 0) of STD_LOGIC;

signal x32ConstReg :  x32ConstRegType:= (others=>(others=>'0'));
signal x1ConstReg :  x1ConstRegType:= (others=>'0');
signal adc1_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal adc2_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal dac1_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal dac2_signal : STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');
signal digitalIn_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal digitalOut_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal led_signal : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');

---------------------------------------------------------------------------------------------------
--AUTO GENERATED SIGNALS START
signal N000 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N001 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N002 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N003 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N004 : STD_LOGIC := '0';
signal N005 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N006 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N007 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
--AUTO GENERATED SIGNALS END
---------------------------------------------------------------------------------------------------


begin
	process(clk)
	variable regAddr_var : integer :=0;
	variable x32RegVal_var : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):= (others=>'0');
	variable x1RegVal_var : STD_LOGIC:='0';
	variable regType: STD_LOGIC := '0';  --   regType=1 -> 32bit   regType=0 -> 1 bit
	begin
		if rising_edge(clk) then
		--Parse communication for setting constants
			if regWrtEn='1' then
				regType:= regAddr(31);
				regAddr_var:=to_integer(unsigned(regAddr((CONSTANT_REGISTER_DEPTH-1) downto 0)));
				x32RegVal_var:= regVal;
				x1RegVal_var:= regVal(0);

				if regType='1' then
					x32ConstReg(regAddr_var)<=x32RegVal_var;
				else
					x1ConstReg(regAddr_var)<=x1RegVal_var;
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
--AUTO GENERATED INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS START
--x32_dac1_0:
dac1_signal<=N000;

x32_shiftL_0 : entity xil_defaultlib.x32_shiftL
port map(clk=>clk,dataIn=>N001,dataShiftL=>N002,dataOut=>N000);

x32_add_0 : entity xil_defaultlib.x32_add
port map(clk=>clk,reset=>N004,dataIn0=>N003,dataIn1=>N001,dataOut=>N001);

x32_mult_0 : entity xil_defaultlib.x32_mult
port map(clk=>clk,reset=>N004,dataIn0=>N005,dataIn1=>N006,dataOut=>N003);

x32_sub_0 : entity xil_defaultlib.x32_sub
port map(clk=>clk,reset=>N004,dataIn0=>N007,dataIn1=>N001,dataOut=>N005);

--x32_adc1_0:
N007<=adc1_signal;

--x1_const_0:
N004<=x1ConstReg(0);

--x32_const_0:
N006<=x32ConstReg(0);

--x32_const_1:
N002<=x32ConstReg(1);

--AUTO GENERATED INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS END
---------------------------------------------------------------------------------------------------

end Behavioral;

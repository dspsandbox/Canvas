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
    Port ( clk125 : in STD_LOGIC;
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

---------------------------------------------------------------------------------------------------
--NET2FPGA SIGNALS START
signal N000 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N001 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N002 : STD_LOGIC_VECTOR((PORT_WIDTH-1) downto 0) := ((PORT_WIDTH-1)=>'1',others=>'0');
signal N003 : STD_LOGIC := '0';
signal N004 : STD_LOGIC := '0';
signal N005 : STD_LOGIC := '0';
--NET2FPGA SIGNALS END
---------------------------------------------------------------------------------------------------

begin
	process(clk125)
	variable regAddr_var : integer :=0;
	variable regVal32Bit_var : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):= (others=>'0');
	variable regVal1Bit_var : STD_LOGIC:='0';
	variable regType: STD_LOGIC := '0';  --   regType=1 -> 32bit   regType=0 -> 1 bit
	begin
		if rising_edge(clk125) then
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

---------------------------------------------------------------------------------------------------
--NET2FPGA INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS START
--X_NET2FPGA_32Bit_DAC1_0:
dac1<=N000;

--X_NET2FPGA_32Bit_const_0:
N000<=constantRegister32Bit(0);

--X_NET2FPGA_32Bit_DAC2_0:
dac2<=N001;

X_NET2FPGA_32Bit_add_0 : entity xil_defaultlib.NET2FPGA_32Bit_add
port map(clk=>clk125,reset=>N003,dataInA=>N002,dataInB=>N000,dataOut=>N001);

--X_NET2FPGA_32Bit_ADC1_0:
N002<=adc1;

--X_NET2FPGA_1Bit_in0_0:
N003<=digitalIn(0);

--X_NET2FPGA_1Bit_LED0_0:
led(0)<=N003;

--X_NET2FPGA_1Bit_LED1_0:
led(1)<=N004;

--X_NET2FPGA_1Bit_in1_0:
N004<=digitalIn(1);

--X_NET2FPGA_1Bit_LED2_0:
led(2)<=N005;

--X_NET2FPGA_1Bit_const_0:
N005<=constantRegister1Bit(0);

--NET2FPGA INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS END
---------------------------------------------------------------------------------------------------

end Behavioral;

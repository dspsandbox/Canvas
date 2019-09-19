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
signal N000 : STD_LOGIC := '0';
signal N001 : STD_LOGIC := '0';
signal N002 : STD_LOGIC := '0';
signal N003 : STD_LOGIC := '0';
signal N004 : STD_LOGIC := '0';
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
--x1_led0_0:
led_signal(0)<=N000;

--x1_const_0:
N000<=x1ConstReg(0);

--x1_led1_0:
led_signal(1)<=N001;

--x1_const_1:
N001<=x1ConstReg(1);

--x1_led2_0:
led_signal(2)<=N002;

--x1_const_2:
N002<=x1ConstReg(2);

--x1_led3_0:
led_signal(3)<=N003;

--x1_const_3:
N003<=x1ConstReg(3);

--x1_led4_0:
led_signal(4)<=N004;

--x1_const_4:
N004<=x1ConstReg(4);

--x1_led5_0:
led_signal(5)<=N004;

--x1_led6_0:
led_signal(6)<=N004;

--x1_led7_0:
led_signal(7)<=N004;

--AUTO GENERATED INSTANTIATIONS AND BEHAVIORAL ASSIGNEMENTS END
---------------------------------------------------------------------------------------------------

end Behavioral;

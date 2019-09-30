----------------------------------------------------------------------------------
--x32_mult module
 
--MIT License
--Copyright (c) 2019 DSPsandbox (Pau Gomez pau.gomez@dspsandbox.org)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity x32_mult is
	Generic(PORT_WIDTH : integer := 32;
	 EXCLUDE_VAL : STD_LOGIC_VECTOR(31 downto 0) := (31=>'1',others=>'0');
	 SUBS_VAL : STD_LOGIC_VECTOR(31 downto 0) := (31=>'1',0=>'1',others=>'0')
	);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataIn0 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataIn1 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
     
           
end x32_mult;

architecture Behavioral of x32_mult is
signal A : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
signal B : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
signal P : STD_LOGIC_VECTOR ((2*PORT_WIDTH-1) downto 0);

COMPONENT mult_gen_x32
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR((PORT_WIDTH-1) DOWNTO 0);
    B : IN STD_LOGIC_VECTOR((PORT_WIDTH-1) DOWNTO 0);
    SCLR : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR((2*PORT_WIDTH-1) DOWNTO 0)
  );
END COMPONENT;



begin
--INSTANTIATION OF DSP MULTIPLIER	
	DSP_mult_core : mult_gen_x32
  	PORT MAP (
    CLK => clk,
    A => A,
    B => B,
    SCLR => reset,
    P => P
  );


--Consistency check to avoid A=-2**31 or B=-2**31
	A <=  SUBS_VAL when (dataIn0=EXCLUDE_VAL)  else
	      dataIn0;
	   
	B <=  SUBS_VAL when (dataIn1=EXCLUDE_VAL)  else
	      dataIn1;

	dataOut <= P((2*PORT_WIDTH-2) downto (PORT_WIDTH-1));
	

end Behavioral;
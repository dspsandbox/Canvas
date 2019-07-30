----------------------------------------------------------------------------------
--NET2FPGA_32Bit_mult module
 
--MIT License
--Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NET2FPGA_32Bit_mult is
	Generic(PORT_WIDTH : integer := 32;
	 THRESHOLD_0 : STD_LOGIC_VECTOR :="1000000000000000000000000";
	 THRESHOLD_1 : STD_LOGIC_VECTOR :="100000000000000000"
	);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataIn0 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataIn1 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
     
           
end NET2FPGA_32Bit_mult;

architecture Behavioral of NET2FPGA_32Bit_mult is
signal A : STD_LOGIC_VECTOR (24 downto 0);
signal B : STD_LOGIC_VECTOR (17 downto 0);
signal P : STD_LOGIC_VECTOR (42 downto 0);

COMPONENT mult_gen_0
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    SCLR : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(42 DOWNTO 0)
  );
END COMPONENT;



begin
--INSTANTIATION OF DSP MULTIPLIER	
	DSP_mult_core : mult_gen_0
  	PORT MAP (
    CLK => clk,
    A => A,
    B => B,
    SCLR => reset,
    P => P
  );


--Consistency check to avoid A=1000000000000000000000000 or B=100000000000000000
	A <= "1000000000000000000000001" when (dataIn0((PORT_WIDTH-1) downto (PORT_WIDTH-25))=THRESHOLD_0)  else
	      dataIn0((PORT_WIDTH-1) downto (PORT_WIDTH-25));
	   
	B <= "100000000000000001" when (dataIn1((PORT_WIDTH-1) downto (PORT_WIDTH-18))=THRESHOLD_1) else
	      dataIn1((PORT_WIDTH-1) downto (PORT_WIDTH-18));
	
	dataOut(31)<=P(42);
	dataOut(30 downto 0) <= P(40 downto 10);
	

end Behavioral;
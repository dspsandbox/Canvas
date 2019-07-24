----------------------------------------------------------------------------------
--NET2FPGA_32Bit_add module
 
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

entity NET2FPGA_32Bit_add is
	Generic(PORT_WIDTH : integer := 32
	);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataInA : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataInB : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
     
           
end NET2FPGA_32Bit_add;

architecture Behavioral of NET2FPGA_32Bit_add is

COMPONENT c_add_0
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CLK : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    S : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;



begin
--INSTANTIATION OF DSP ADDER	
DSP_Add_core : c_add_0
  PORT MAP (
    A => dataInA,
    B => dataInB,
    CLK => CLK,
    SCLR => reset,
    S => dataOut
  );


end Behavioral;
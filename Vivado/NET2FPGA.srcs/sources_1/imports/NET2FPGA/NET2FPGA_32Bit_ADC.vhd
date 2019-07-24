----------------------------------------------------------------------------------
--NET2FPGA_32Bit_ADC module
 
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

entity NET2FPGA_32Bit_ADC is
	Generic(PORT_WIDTH : integer := 32
	);
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (13 downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
     
end NET2FPGA_32Bit_ADC;

architecture Behavioral of NET2FPGA_32Bit_ADC is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			dataOut(PORT_WIDTH-1)<=dataIn(13);
			dataOut((PORT_WIDTH-2) downto (PORT_WIDTH-14))<=not(dataIn(12 downto 0));
			dataOut((PORT_WIDTH-14-1) downto 0)<=(others=>'0');
		end if;
	end process;
			

end Behavioral;
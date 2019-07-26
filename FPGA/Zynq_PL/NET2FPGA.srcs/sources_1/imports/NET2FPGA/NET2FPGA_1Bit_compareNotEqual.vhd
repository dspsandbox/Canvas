----------------------------------------------------------------------------------
--NET2FPGA_1Bit_compareNotEqual module
 
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

entity NET2FPGA_1Bit_compareNotEqual is
    Port ( clk : in STD_LOGIC;
           dataInA : in STD_LOGIC;
           dataInB : in STD_LOGIC;
           dataOut : out STD_LOGIC
           );
end NET2FPGA_1Bit_compareNotEqual;

architecture Behavioral of NET2FPGA_1Bit_compareNotEqual is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if dataInA/=dataInB then
				dataOut<='1';
			else
				dataOut<='0';
			end if;
		end if;
	end process;
end Behavioral;

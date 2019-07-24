----------------------------------------------------------------------------------
--NET2FPGA_1Bit_not module
 
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

entity NET2FPGA_1Bit_not is
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC;
           dataOut : out STD_LOGIC
           );
end NET2FPGA_1Bit_not;

architecture Behavioral of NET2FPGA_1Bit_not is

begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			dataOut<= not(dataIn);
		end if;

	end process;

end Behavioral;
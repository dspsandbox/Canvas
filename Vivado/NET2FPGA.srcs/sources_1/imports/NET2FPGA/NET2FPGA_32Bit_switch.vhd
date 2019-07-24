----------------------------------------------------------------------------------
--NET2FPGA_32Bit_switch module
 
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

entity NET2FPGA_32Bit_switch is
	Generic(PORT_WIDTH : integer := 32);
    Port ( clk : in STD_LOGIC;
           dataInSwitch : in STD_LOGIC;
           dataInA : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataInB : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
end NET2FPGA_32Bit_switch;

architecture Behavioral of NET2FPGA_32Bit_switch is

begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			if dataInSwitch='1' then
				dataOut<= dataInA;
			else
				dataOut<= dataInB;
			end if;
		end if;

	end process;

end Behavioral;

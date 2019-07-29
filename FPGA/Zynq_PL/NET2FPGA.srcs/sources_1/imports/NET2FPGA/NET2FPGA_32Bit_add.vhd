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
begin
	process(clk)
	begin
		if rising_edge(clk) then
            if reset='1' then
                dataOut<=(others=>'0');
            else
                dataOut<=STD_LOGIC_VECTOR(signed(dataInA)+signed(dataInB));
            end if;
        end if;
    end process;
end Behavioral;
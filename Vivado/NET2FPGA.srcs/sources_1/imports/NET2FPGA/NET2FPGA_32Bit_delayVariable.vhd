----------------------------------------------------------------------------------
--NET2FPGA_32Bit_delayVariable module
 
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

entity NET2FPGA_32Bit_delayVariable is
	Generic(PORT_WIDTH : integer := 32;
	        RAM_DEPTH : integer := 8);
    Port ( clk : in STD_LOGIC;
    	   clr: in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataDelay : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
end NET2FPGA_32Bit_delayVariable;

architecture Behavioral of NET2FPGA_32Bit_delayVariable is
signal pointerWrite : unsigned((RAM_DEPTH-1) downto 0):= (others=>'0');
signal pointerRead : unsigned((RAM_DEPTH-1) downto 0):= (others=>'0');
signal d : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):= (others=>'0'); 
signal qdpo : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):= (others=>'0'); 

COMPONENT dist_mem_gen_32Bit
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(32 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    qdpo : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
  );
END COMPONENT;

 
begin
--DRAM instantiation
  DRAM_core_32Bit : dist_mem_gen_32Bit
  PORT MAP (
    a => STD_LOGIC_VECTOR(pointerWrite),
    d => d,
    dpra => STD_LOGIC_VECTOR(pointerRead),
    clk => clk,
    we => '1',
    qdpo => qdpo
  );

--CLR conditions
	d<=(others=>'0') when clr='1' else
			 dataIn;
	dataOut<=(others=>'0') when clr='1' else
			 qdpo;
--CLK process
	process(clk)
	variable delay : unsigned((RAM_DEPTH-1) downto 0):= (others=>'0');
	begin
		if rising_edge(clk) then
			delay:=unsigned(dataDelay((RAM_DEPTH-1) downto 0));
			pointerWrite<=pointerWrite+1;
			pointerRead<=pointerWrite+2-delay;
		
		end if;
	end process;
end Behavioral;


-----------------------------------------------------------------------------------
--x32_DDS module
 
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

entity x32_DDS is
	Generic(
	PORT_WIDTH : integer := 32
	);
    Port ( clk : in STD_LOGIC;
    	   pinc : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           poff : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           resync : in STD_LOGIC;
           sin : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           cos : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
end x32_DDS;


architecture Behavioral of x32_DDS is

signal ddsIn_signal: STD_LOGIC_VECTOR(71 DOWNTO 0):=(others=>'0');
signal ddsOut_signal: STD_LOGIC_VECTOR(31 DOWNTO 0):=(others=>'0');
signal ddsOutValid_signal: STD_LOGIC:='0';

signal sin_signal: STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):=(others=>'0');
signal cos_signal: STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0):=(others=>'0');

COMPONENT dds_compiler
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


begin
	inst_DDS_compiler : dds_compiler
		PORT MAP (
		aclk => clk,
		s_axis_phase_tvalid => '1',
		s_axis_phase_tdata => ddsIn_signal,
		m_axis_data_tvalid => ddsOutValid_signal,
		m_axis_data_tdata => ddsOut_signal
		);

	process(clk)
	begin
		if rising_edge(clk) then
            if ddsOutValid_signal='1' then
           		ddsIn_signal(64)<=resync;
           		ddsIn_signal(63 downto 32)<=poff;
           		ddsIn_signal(31 downto 0)<=pinc;
				
				sin_signal(31 downto 16)<=ddsOut_signal(31 downto 16);
				cos_signal(31 downto 16)<=ddsOut_signal(15 downto 0);

            end if;
        end if;    
    end process;
    
    sin<=sin_signal;
    cos<=cos_signal;

end Behavioral;

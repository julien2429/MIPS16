library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMemory is
    Port ( Address : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           clk : in STD_LOGIC;
           ReadData : out STD_LOGIC_VECTOR (15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type mem_type is array (0 to 2000) of std_logic_vector (15 downto 0) ;
signal mem: mem_type:=(
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"000E",
		X"000F",
		X"0009",
		X"0008",
		
		others =>X"0000");


begin

process (clk)
    begin
        if rising_edge(clk) then
                if MemWrite = '1' then
                    mem(conv_integer(Address)) <= WriteData;
                end if;
            end if;
         
    end process;
ReadData <= mem( conv_integer(Address));

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2024 12:36:26 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
  Port ( 
  btn_up : in std_logic;
  btn_down : in std_logic;
  clk : in std_logic;
  cat : out STD_LOGIC_VECTOR (6 downto 0);         
  an : out STD_LOGIC_VECTOR (3 downto 0)
  
  );
end test_env;

architecture Behavioral of test_env is

component seven_seg 
    Port ( digit_bus : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cathode : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0));
end component seven_seg;

component MPG 
 Port ( 
        btn : in std_logic;
        clk : in std_logic;
        enable: out std_logic
  );
end component MPG;

component reg_file 
port (
clk : in std_logic;
ra1 : in std_logic_vector (3 downto 0);
ra2 : in std_logic_vector (3 downto 0);
wa : in std_logic_vector (3 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component reg_file;


signal counter: std_logic_vector(3 downto 0) := ( others => '0'); 

signal up : std_logic;
signal down: std_logic;

type rom_mem is array (0 to 256-1) of std_logic_vector(16-1 downto 0);
signal rom: rom_mem:= (
x"0000", -- M bits, use hexadecimal representation when possible
x"0001",
x"0002",
others => x"FFFF"
);
signal rom_out :  std_logic_vector(16-1 downto 0) := x"0000";

signal rd1 : std_logic_vector(15 downto 0) ; 
signal rd2 : std_logic_vector(15 downto 0) ; 
signal sum : std_logic_vector(15 downto 0); 

begin

sum <= rd1 + rd2 ; 

c1: MPG port map( btn_up, clk , up);
c2: MPG port map( btn_down, clk , down);
c3: reg_file port map(clk, counter,counter,counter,sum,down,rd1,rd2);




process(up,clk)
begin
    if rising_edge(up) then
        counter<=counter+1;
    end if;
end process;

c4: seven_seg port map(sum,clk,cat,an);


end Behavioral;

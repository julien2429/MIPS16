library IEEE;                   
use IEEE.STD_LOGIC_1164.ALL;    
use IEEE.STD_LOGIC_ARITH.ALL;   
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_inst_fetch is
 Port (
  btn_up : in std_logic;
  btn_down : in std_logic;
  clk : in std_logic;
  cat : out STD_LOGIC_VECTOR (6 downto 0);         
  an : out STD_LOGIC_VECTOR (3 downto 0) );
end test_inst_fetch;

architecture Behavioral of test_inst_fetch is
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

component Instruction_Fetch 
 Port (  we : in std_logic;
         rst : in std_logic;
         clk : in std_logic;
         pc_src : in std_logic;
         jump: in std_logic;
         branch_address : in std_logic_vector(15 downto 0);
         jump_address : in std_logic_vector(15 downto 0);
         instruction : out std_logic_vector(15 downto 0);
         pc_out : out std_logic_vector(15 downto 0)
  );
end component Instruction_Fetch;

signal btn_down_mpg: std_logic;
signal btn_up_mpg: std_logic;
signal instruction :  std_logic_vector(15 downto 0);
signal pc_out : std_logic_vector(15 downto 0);
begin

b1: MPG port map(btn_up,clk,btn_up_mpg);
b2: MPG port map(btn_down,clk,btn_down_mpg);
ifetcher: Instruction_Fetch port map(btn_up_mpg, btn_down_mpg , clk,'0','0',x"0000",x"0000",instruction, pc_out);
display: seven_seg port map(instruction,clk,cat,an);
end Behavioral;

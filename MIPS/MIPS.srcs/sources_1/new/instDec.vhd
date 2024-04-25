library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity instDec is
 Port (
    clk: in std_logic;
    inst: in std_logic_vector(15 downto 0);
    RegDst: in std_logic;
    RegWrite: in std_logic;
    ExtOp: in std_logic;
    writeData : in std_logic_vector(15 downto 0);
    readD1: out std_logic_vector(15 downto 0);
    readD2: out std_logic_vector(15 downto 0);
    extImm: out std_logic_vector(15 downto 0);    
    shift: out std_logic;
    func: out std_logic_vector(2 downto 0)  
  );
end instDec;

architecture Behavioral of instDec is

component reg_file 
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    wen : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
);
end component reg_file;

signal wa: std_logic_vector(2 downto 0):= "000";
begin

selector: process(RegDst,inst(9 downto 7),inst(6 downto 4))

begin 
    if (RegDst = '0') then
        wa<= inst(9 downto 7);
    else
        wa<= inst(6 downto 4);
    end if;
end process;

reg: reg_file port map(clk,inst(12 downto 10), inst(9 downto 7), wa, writeData, RegWrite, readD1,readD2);

shift<= inst(3);

func<=inst(2 downto 0);

extender: process(inst(6 downto 0))
begin
    if(inst(6)= '0') then 
        extImm<= "000000000" & inst(6 downto 0);
    else 
        extImm<= "111111111" & inst(6 downto 0);
    end if;
end process;


end Behavioral;

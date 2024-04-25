library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
entity MainControl is
 Port (
       OpCode: in std_logic_vector(2 downto 0);
       RegDst: out std_logic;
       RegWrite: out std_logic;
       ExtOp: out std_logic;
       Jump: out std_logic;
       ALUSrc: out std_logic;
       branch: out std_logic;
       --ALUOp: out std_logic_vector(2 downto 0);
       MemToReg: out std_logic;
       MemWrite: out std_logic
  );
end MainControl;

architecture Behavioral of MainControl is

begin

clc: process(OpCode)
     
     
     begin
     RegDst <= '0' ;
     RegWrite <= '0';
     ExtOp <= '0';
     Jump <= '0';
     ALUSrc <= '0';
     --ALUOp <= "000";
     MemToReg <= '0';
     MemWrite <= '0';
     branch<= '0';
     
     case(OpCode) is 
        when "000" => RegDst<='1'; RegWrite<='1'; ExtOp <= '1'; ---ALUSrc <= '1'; --ALUOp <= "000"; -- R-Type
        when "001" => RegWrite<='1'; ALUSrc <= '1'; ExtOp <= '1'; --ADD IMM
        when "010" => RegWrite<='1'; ALUSrc <= '1'; ExtOp <= '1'; MemToReg <= '1'; --Load Word
        when "011" => ALUSrc <= '1'; ExtOp <= '1'; MemWrite <= '1'; --Store Word
        when "100" => ExtOp <= '1'; branch<= '1';  --Bracnh on Equal
        when "101" => ExtOp <= '1'; branch<= '1';  --Bracnh on greater than zero !! BGTZ
        when "110" => ExtOp <= '1'; branch<= '1'; --Bracnh on greater than zero !!BLTZ
        when "111" => ExtOp <= '1'; Jump <= '1'; --Jump
        when others=> RegDst<='X'; RegWrite<='X';-- ALUOp <= "XXX";
      end case;
     end process;

end Behavioral;

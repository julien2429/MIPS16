----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2024 08:43:48 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
 Port ( operation : in std_logic_vector(1 downto 0);
        first_number : in std_logic_vector(15 downto 0);
        second_number : in std_logic_vector(15 downto 0);
        output: out std_logic_vector(15 downto 0)
  );
end ALU;


architecture Behavioral of ALU is

begin

process(operation,first_number, second_number)
begin
    case operation(1 downto 0) is
        when "00" => output <= first_number + second_number;
        when "01" => output<=first_number + second_number;
        when "10" => output <= first_number( 13 downto 0) & "00";
        when "11" => output <= "00" & first_number( 15 downto 2) ;
        when others => output<="1111";
    end case;
end process;

end Behavioral;

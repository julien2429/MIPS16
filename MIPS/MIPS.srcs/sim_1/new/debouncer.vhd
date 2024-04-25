
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 12:48:21 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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
--use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
 Port ( btn : in std_logic;
        clk : in std_logic;
        enable: out std_logic
  );
end MPG;

architecture Behavioral of MPG is

signal counter : std_logic_vector(0 to 15) := (others => '0');
signal q1, q2, q3 : std_logic;
signal enab: std_logic := '0';

begin

enable <= q2 and not q3;

and_enable: process(counter)
begin
    if counter = x"000F" then
        enab<='1';
    else
        enab<='0';
    end if;
 end process;

count: process (clk)
begin 
    if rising_edge(clk) then
        counter <= counter + '1';
    end if;
end process; 

d1 : process (clk)
begin
    if rising_edge(clk) then
       if enab = '1' then
          q1 <= btn;
       end if;
   end if;
end process;

d2 : process (clk)
begin
   if rising_edge(clk) then
      q2 <= q1;
   end if;
end process;

d3 : process (clk)
begin
   if rising_edge(clk) then
      q3 <= q2;
   end if;
end process;


end Behavioral;

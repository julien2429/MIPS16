library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;


entity Instruction_Fetch is
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
end Instruction_Fetch;

architecture Behavioral of Instruction_Fetch is
type rom_memory is array(0 to 255) of std_logic_vector(15 downto 0);

signal rom : rom_memory := (

--B"000_000_000_001_0_000", -- add $1, $0, $0      0010
--B"001_000_100_0001010", -- addi $4, $0, 10       220A
--B"000_000_000_010_0_000", --$0 $0, $2, add       0020
--B"010_010_101_0000000", --lw $5, 0($2)           4A80
--B"100_001_100_0000111", --beq $1, $4, 7          8607
--B"010_010_011_0000000", --lw $3, 0($2)           4980
--B"000_101_011_110_0_001", --sub $6, $5, $3       15E1
--B"101_110_000_0000001", --bgez $6, 1             B801
--B"000_000_011_101_0_000", -- add $5, $0, $3      01D0
--B"001_010_010_0000010", --addi $2, $2, 2         2902
--B"001_001_001_0000001", --addi $1, $1, 1         2481
--B"111_0000000000100", -- j 4                     E004
--B"011_000_101_0010100",-- sw $5, 20($0)          6294
        B"001_000_001_0000000",  --X"2080"	--addi $1,$0,0
		B"001_000_010_0000001",	 --X"2101"	--addi $2,$0,1	
		B"001_000_011_0000000",	 --X"2180"	--addi $3,$0,0	
		B"001_000_100_0000001",	 --X"2201"	--addi $4,$0,1
		B"011_011_001_0000000", --X"6C80"   --sw $1,0($3)
		B"011_100_010_0000000", --X"7100"   --sw $2,0($4)
		B"010_011_001_0000000", --X"4C80"   --lw $1,0($3)
		B"010_100_010_0000000", --X"5100"   --lw $2,0($4)
		B"000_001_010_101_0_000", --X"0550" --add $5,$1,$2
		B"000_000_010_001_0_000", --X"0110" --add $1,$0,$2
		B"000_000_101_010_0_000", --X"02A0" --add $2,$0,$5
		B"111_0000000001000", --X"E008"       --j 8
others => x"2222"
);


signal pc : std_logic_vector(15 downto 0):=x"0000";
signal adder_pc: std_logic_vector(15 downto 0):=x"0000";
signal branch_mux_pc: std_logic_vector(15 downto 0):=x"0000";   
signal jump_mux_pc: std_logic_vector(15 downto 0):=x"0000"; 
signal jump_add : std_logic_vector(15 downto 0);
signal instr: std_logic_vector(15 downto 0);
begin

instr <= rom(conv_integer(pc));
instruction<=instr;
pc_out<=adder_pc;
--pc advance

adder_pc<=pc+'1';


jump_calc: process(instr)
        begin 
        jump_add<= "000" & instr(12 downto 0);
      end process;

pc_advance: process(clk,rst,we)
begin
    if rst='1' then
        pc<=x"0000";
    else
       if rising_edge(clk) then 
            if we='1' then 
                pc<=jump_mux_pc;
            end if;
       end if;
    end if;
end process;

--branch mux
branch_mux:process(adder_pc, branch_address,pc_src)
begin
    case pc_src is
        when '0' => branch_mux_pc <= adder_pc;
        when '1' => branch_mux_pc <= branch_address; 
        when others =>  branch_mux_pc<= x"0000";
    end case;
 end process;  

--jmp mux
jmp_mux:process(branch_mux_pc, jump_add,jump)
begin
    case jump is
        when '0' => jump_mux_pc <= branch_mux_pc;
        when '1' => jump_mux_pc <= jump_add;  
        when others =>  jump_mux_pc<= x"0000";
    end case;
 end process;


end Behavioral;

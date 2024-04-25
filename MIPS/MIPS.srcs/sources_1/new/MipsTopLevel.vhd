----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2024 12:32:30 PM
-- Design Name: 
-- Module Name: MipsTopLevel - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MipsTopLevel is
    Port (
        clk : in std_logic;
        we : in std_logic;
        rst : in std_logic;
        DisplayCode: in STD_LOGIC_VECTOR (2 downto 0);
        DisplayControl: in std_logic;
        
        led : out STD_LOGIC_VECTOR (15 downto 0);    
        cat : out STD_LOGIC_VECTOR (6 downto 0);         
        an : out STD_LOGIC_VECTOR (3 downto 0)
    
     );
end MipsTopLevel;

architecture Behavioral of MipsTopLevel is 

component MainControl 
 Port (
       OpCode: in std_logic_vector(2 downto 0);
       RegDst: out std_logic;
       RegWrite: out std_logic;
       ExtOp: out std_logic;
       Jump: out std_logic;
       ALUSrc: out std_logic;
       branch: out std_logic;
       MemToReg: out std_logic;
       MemWrite: out std_logic
  );
end component MainControl;

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

component MPG 
 Port ( btn : in std_logic;
        clk : in std_logic;
        
        enable: out std_logic
  );
end component MPG;

component instDec 
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
end component instDec;

component ExecutionUnit 
    Port ( PCOut : in STD_LOGIC_VECTOR (15 downto 0);
           ReadD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ReadD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ExImm : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           SA : in STD_LOGIC;
           Func : in STD_LOGIC_VECTOR (2 downto 0);
           
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           BranchAdd : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end component ExecutionUnit;

component DataMemory 
    Port ( Address : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           clk : in STD_LOGIC;
           ReadData : out STD_LOGIC_VECTOR (15 downto 0));
end component DataMemory;

component seven_seg 
    Port ( digit_bus : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cathode : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0));
end component seven_seg;

signal pc_src_after_and : std_logic;
signal zero : std_logic;
signal we_mpg : std_logic;
signal rst_mpg : std_logic;

signal jump_signal     :  std_logic;
signal branch_signal   :  std_logic;
signal ExtOp_signal    : std_logic;
signal ALUSrc_signal   : std_logic;
signal MemWrite_signal : std_logic;
signal MemToReg_signal : std_logic;
signal RegWrite_signal : std_logic;

signal RegDst_signal :std_logic;


signal branch_add : std_logic_vector(15 downto 0);
signal jump_add : std_logic_vector(15 downto 0);

signal instruction : std_logic_vector(15 downto 0);
signal pc_out : std_logic_vector(15 downto 0);

signal mem_to_reg_mux_value : std_logic_vector(15 downto 0);

signal read_data_1_out :std_logic_vector(15 downto 0);

signal read_data_2_out :std_logic_vector(15 downto 0);

signal ext_imm_out:std_logic_vector(15 downto 0);

signal shift_amount: std_logic;

signal opCode:std_logic_vector(2 downto 0);

signal alu_out :std_logic_vector(15 downto 0);

signal data_mem_out:std_logic_vector(15 downto 0);

signal ssd_value:std_logic_vector(15 downto 0);
begin

--MPG-URI

MPG_WE: MPG port map (we,clk,we_mpg);
MPG_RST: MPG port map (rst,clk,rst_mpg);

--MUX SI AND
 PC_SRC_AND: pc_src_after_and<= zero and branch_signal;
 MUX_MEM_TO_REG: process(MemToReg_signal,  data_mem_out, alu_out)
                    begin
                        if(MemToReg_signal ='1') then
                            mem_to_reg_mux_value<=data_mem_out;
                        else
                            mem_to_reg_mux_value<= alu_out;
                        end if;
                  end process;



INSTR_FETCH: Instruction_Fetch port map ( we_mpg , rst_mpg ,clk , pc_src_after_and , jump_signal ,branch_add , jump_add, instruction, pc_out);
    
MAIN_CONTROL: MainControl port map(instruction(15 downto 13), RegDst_signal, RegWrite_signal, ExtOp_signal, Jump_signal, ALUSrc_signal, branch_signal, MemToReg_signal, MemWrite_signal);

INSTR_DECODE: instDec port map (clk, instruction ,RegDst_signal , RegWrite_signal, ExtOp_signal ,mem_to_reg_mux_value , read_data_1_out, read_data_2_out,ext_imm_out ,shift_amount , opCode);

--EXECUTION_UNIT: ExecutionUnit port map ( pc_out ,read_data_1_out, read_data_2_out , ext_imm_out, ALUSrc_signal, instruction(15 downto 13), shift_amount, opCode, alu_out ,branch_add ,zero);

EXECUTION_UNIT: ExecutionUnit port map ( pc_out ,read_data_1_out, read_data_2_out , ext_imm_out, ALUSrc_signal, instruction(15 downto 13), shift_amount, instruction(2 downto 0), alu_out ,branch_add ,zero);
DATA_MEMORY: DataMemory port map ( alu_out, read_data_2_out, MemWrite_signal, clk, data_mem_out);

seven_seg_val: process(DisplayCode , DisplayControl)
                begin
                    if(DisplayControl = '0') then
                        led <= "000000000" & jump_signal & branch_signal & ExtOp_signal & ALUSrc_signal & MemWrite_signal & MemToReg_signal & RegWrite_signal;
                     else
                         led <=instruction;
                    end if;
                    
                    case DisplayCode is
                        when "000" =>  ssd_value<= instruction;
                        when "001" => ssd_value<= pc_out;
                        when "010" => ssd_value<= read_data_1_out;
                        when "011" => ssd_value<= read_data_2_out;
                        when "100" => ssd_value<= ext_imm_out;
                        when "101" => ssd_value<= alu_out;
                        when "110" => ssd_value<= data_mem_out;
                        when others => ssd_value <= mem_to_reg_mux_value;
                     end case;
                   end process;
                        
ssd: seven_seg port map(ssd_value, clk, cat,an);                           
                             
end Behavioral; 
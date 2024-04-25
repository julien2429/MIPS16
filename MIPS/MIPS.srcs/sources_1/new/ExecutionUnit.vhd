library IEEE;
use IEEE.std_logic_arith.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ExecutionUnit is
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
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

    signal ALUInput : STD_LOGIC_VECTOR (15 downto 0);
    signal ALUCtrl : STD_LOGIC_VECTOR (3 downto 0);
    signal ALUOut : STD_LOGIC_VECTOR (15 downto 0);
    signal BranchAddressOut : STD_LOGIC_VECTOR (15 downto 0);
    signal ZeroOut : STD_LOGIC;

begin

--out signals
    BranchAddressOut <=PCOut + ExImm;
    BranchAdd<=BranchAddressOut;
    ALURes<=ALUOut;
    Zero <= ZeroOut;

--Alu ctrl
    process(ALUOp,Func)
        begin
        case(ALUOp) is
            when "000" => case(Func) is
                            when "000" => ALUCtrl <= "0000"; --Add
                            when "001" => ALUCtrl <= "0001"; --Sub   
                            when "010" => ALUCtrl <= "0010"; --Sll  
                            when "011" => ALUCtrl <= "0011"; --Srl
                            when "100" =>ALUCtrl <= "0100"; --and 
                            when "101" =>ALUCtrl <= "0101"; --or
                            when "110" => ALUCtrl <= "0110"; --xor 
                            when others => ALUCtrl <= "0111"; --slt  
                           end case;
              when "001" =>  ALUCtrl <= "0000"; --AddI
              when "010" =>  ALUCtrl <= "0000"; --lw ???
              when "011" =>  ALUCtrl <= "0000"; --sw ??
              when "100" =>  ALUCtrl <= "0001"; --beq
              when "101" =>  ALUCtrl <= "0001"; --bgtz
              when "110" =>  ALUCtrl <= "0001"; --blez
              when others =>  ALUCtrl <= "1000"; --jmp??
         end case;
     end process;
    
    --Alu
    process(ReadD1, ALUInput, ALUCtrl,SA)
        begin
            case (ALUCtrl) is
                when "0000" => ALUOut <= ReadD1 + ALUInput;  
                when "0001" => ALUOut <= ReadD1 - ALUInput;
                when "0010" => case(SA) is 
                                    when '1' =>  ALUOut<= ReadD1(14 downto 0) & '0';
                                    when others => ALUOut<= ReadD1;
                               end case;
                when "0011" => case(SA) is 
                                    when '1' =>  ALUOut<=  '0' & ReadD1(15 downto 1);
                                    when others => ALUOut<= ReadD1;
                               end case;
                when "0100" => ALUOut <= ReadD1 and ALUInput;
                when "0101" => ALUOut <= ReadD1 or ALUInput;
                when "0110" => ALUOut <= ReadD1 xor ALUInput;
                
                when "0111" => if ReadD1 < ALUInput then
                                    ALUOut <= x"0001";
                                else
                                     ALUOut <= x"0000";
                               end if;
                when others => ALUOut <= ReadD1 xor ALUInput; --??????
            end case;
            
            case (ALUOut) is
                when x"0000" => ZeroOut<='1';
                when others=>ZeroOut<='0';
             end case;
    end process;
    
    ---MUX ALU
    process(ReadD2, ExImm, ALUSrc)
    begin
        if (ALUSrc= '0') then
           ALUInput<=ReadD2;
        else
           ALUInput <= ExImm;
        end if;
    end process;
                
end Behavioral;

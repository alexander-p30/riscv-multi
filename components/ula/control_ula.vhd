library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity CTL_ULA is
  port (
    ULAop : in std_logic_vector(6 downto 0);
    current_ctl_state : in std_logic_vector(2 downto 0) := STATE_0;
    funct3 : in std_logic_vector(2 downto 0);
    funct7 : in std_logic_vector(6 downto 0);
    op : out std_logic_vector(3 downto 0)
  );
end entity CTL_ULA;

architecture CTL_ULA_arch of CTL_ULA is
  procedure translate_to_ula_opcode(
    signal ULAop : in std_logic_vector(6 downto 0);
    signal funct3 : in std_logic_vector(2 downto 0);
    signal funct7 : in std_logic_vector(6 downto 0);
    signal op: out std_logic_vector(3 downto 0)
  ) is
  begin
    case ULAop & funct3 & funct7 is
      when R_TYPE & "000" & "0000000" =>  op <= "0000"; -- add
      when R_TYPE & "000" & "0100000" =>  op <= "0001"; -- sub
      when R_TYPE & "111" & "0000000" =>  op <= "0010"; -- and
      when R_TYPE & "110" & "0000000" =>  op <= "0011"; -- or
      when R_TYPE & "100" & "0000000" =>  op <= "0100"; -- xor
      when R_TYPE & "010" & "0000000" =>  op <= "1000"; --slt
      when others =>                      NULL;
    end case;

    case ULAop & funct3 is
      when B_TYPE & "000" =>              op <= "1100"; -- seq pro BEQ
      when B_TYPE & "001" =>              op <= "1101"; -- sne pro BNE
      when I_TYPE & "000" =>              op <= "0000"; -- addi
      when I_TYPE & "110" =>              op <= "0011"; -- ori
      when I_TYPE & "111" =>              op <= "0010"; -- andi
      when I_TYPE & "100" =>              op <= "0100"; -- xori == not pra nand e nor
      when I_2_TYPE & "010" =>            op <= "0000"; -- lw
      when I_3_TYPE & "000" =>            op <= "0000"; -- jalr
      when S_TYPE & "010" =>              op <= "0000"; -- sw
      when others =>                      NULL;
    end case;

    case ULAop is
      when J_TYPE =>                      op <= "0000"; -- jal
      when U_TYPE =>                      op <= "0000"; -- lui
      when others =>                      NULL;
    end case;
  end translate_to_ula_opcode;

begin
  process(ULAop, funct3, funct7, current_ctl_state) is
  begin
    case current_ctl_state is
      when STATE_0 =>
        op <= "0000";
      when STATE_1 | STATE_2 | STATE_3 =>
        translate_to_ula_opcode(ULAop => ULAop, funct3 => funct3, funct7 => funct7, op => op);
      when others => NULL;
    end case;
    -- sll???
    -- "0000" when ULAop = "0010111" else -- auipc ? addi pc, lui(imm)

  end process;
end CTL_ULA_arch;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.riscv_pkg.all;

entity genImm32 is
  port(
        instr: in std_logic_vector(WSIZE-1 downto 0);
        imm32: out signed(WSIZE-1 downto 0)
      );
end genImm32;

architecture genImm32_arch of genImm32 is
  type FORMAT_RV is ( R_type, I_type, S_type, SB_type, UJ_type, U_type, INVALID_type );

  signal opcode : std_logic_vector(6 downto 0);
  signal funct3 : std_logic_vector(2 downto 0);
  signal funct7 : std_logic_vector(6 downto 0);
  signal instr_format : FORMAT_RV;
begin
  opcode <= instr(6 downto 0);

  process(instr, opcode) is
  begin
    case '0' & opcode is
      when x"33" => instr_format <= R_type;
      when x"03" | x"13" | x"67" => instr_format <= I_type;
      when x"23" => instr_format <= S_type;
      when x"63" => instr_format <= SB_type;
      when x"37" | x"17" => instr_format <= U_type;
      when x"6F" => instr_format <= UJ_type;
      when others => instr_format <= INVALID_type;
    end case;
  end process;

  process(instr, opcode, instr_format) is
  begin
    case instr_format is
      when R_type => imm32 <= x"00000000";
      when I_type => imm32 <= resize(signed(instr(31 downto 20)), 32);
      when S_type => imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
      when SB_type => imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0') , 32);
      when U_type => imm32 <= signed(instr(31 downto 12) & x"000");
      when UJ_type => imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 25) & instr(24 downto 21) & '0'), 32);
      when others => imm32 <= x"00000000";
    end case;
  end process;
end genImm32_arch;

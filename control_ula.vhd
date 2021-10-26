library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity CTL_ULA is
  port (
    ULAop : in std_logic_vector(6 downto 0);
    funct3 : in std_logic_vector(2 downto 0);
    funct7 : in std_logic_vector(6 downto 0);
    op : out std_logic_vector(3 downto 0)
  );
end entity CTL_ULA;

architecture CTL_ULA_arch of CTL_ULA is
begin
  op <=
    "0000" when ULAop = R_TYPE and funct3 = "000" and funct7 = "0000000" else	-- add
    "0001" when ULAop = R_TYPE and funct3 = "000" and funct7 = "0100000" else 	-- sub
    "0010" when ULAop = R_TYPE and funct3 = "111" and funct7 = "0000000" else  -- and
    "0011" when ULAop = R_TYPE and funct3 = "110" and funct7 = "0000000" else  -- or
    "0100" when ULAop = R_TYPE and funct3 = "100" and funct7 = "0000000" else  -- xor
    "1000" when ULAop = R_TYPE and funct3 = "010" and funct7 = "0000000" else  -- slt
    -- sll???
    "1100" when ULAop = B_TYPE and funct3 = "000" else  -- seq pro BEQ
    "1101" when ULAop = B_TYPE and funct3 = "001" else  -- sne pro BNE

    "0000" when ULAop = I_TYPE and funct3 = "000" else -- addi
    "0000" when ULAop = I_TYPE and funct3 = "100" else -- xori == not pra nand e nor
    "0000" when ULAop = I_2_TYPE and funct3 = "010" else -- lw
    "0000" when ULAop = I_3_TYPE and funct3 = "000" else -- jalr
    "0000" when ULAop = J_TYPE else -- jal
    "0101" when ULAop = U_TYPE else -- lui
    -- "0000" when ULAop = "0010111" else -- auipc ? addi pc, lui(imm)

    "0000" when ULAop = S_TYPE and funct3 = "010"; -- sw
  end CTL_ULA_arch;


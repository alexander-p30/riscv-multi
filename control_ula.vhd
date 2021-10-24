library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CTL_ULA is
  generic (
    R : std_logic_vector(6 downto 0) := "0110011";
    B : std_logic_vector(6 downto 0) := "1100011";
    I : std_logic_vector(6 downto 0) := "0010011";
    I_2 : std_logic_vector(6 downto 0) := "0000011";
    I_3 : std_logic_vector(6 downto 0) := "1100111";
    J : std_logic_vector(6 downto 0) := "1101111";
    U : std_logic_vector(6 downto 0) := "0110111";
    S : std_logic_vector(6 downto 0) := "0100011"
  );

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
    "0000" when ULAop = R and funct3 = "000" and funct7 = "0000000" else	-- add
    "0001" when ULAop = R and funct3 = "000" and funct7 = "0100000" else 	-- sub
    "0010" when ULAop = R and funct3 = "111" and funct7 = "0000000" else  -- and
    "0011" when ULAop = R and funct3 = "110" and funct7 = "0000000" else  -- or
    "0100" when ULAop = R and funct3 = "100" and funct7 = "0000000" else  -- xor
    "1000" when ULAop = R and funct3 = "010" and funct7 = "0000000" else  -- slt
    -- sll???
    "1100" when ULAop = B and funct3 = "000" else  -- seq pro BEQ
    "1101" when ULAop = B and funct3 = "001" else  -- sne pro BNE

    "0000" when ULAop = I and funct3 = "000" else -- addi
    "0000" when ULAop = I and funct3 = "100" else -- xori == not pra nand e nor
    "0000" when ULAop = I_2 and funct3 = "010" else -- lw
    "0000" when ULAop = I_3 and funct3 = "000" else -- jalr
    "0000" when ULAop = J else -- jal
    "0101" when ULAop = U else -- lui
    -- "0000" when ULAop = "0010111" else -- auipc ? addi pc, lui(imm)

    "0000" when ULAop = S and funct3 = "010"; -- sw
  end CTL_ULA_arch;


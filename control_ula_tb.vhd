library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity CTL_ULA_tb is
  generic (WSIZE : natural := 32);
end CTL_ULA_tb;

architecture testbench of CTL_ULA_tb is
  constant T : time := 4 ns;

  signal ULAop, funct7 : std_logic_vector(6 downto 0) := (others => '0');
  signal funct3 : std_logic_vector(2 downto 0) := (others => '0');
  signal op : std_logic_vector(3 downto 0) := "0000";
begin
  e_ctl_ula: CTL_ULA port map(
    ULAop => ULAop,
    funct3 => funct3,
    funct7 => funct7,
    op => op
  );

  process is
  begin
    ULAop <= "0110011";
    funct3 <= "000";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0000") report "==========ERROR (A)==========" severity error;

    ULAop <= "0110011";
    funct3 <= "000";
    funct7 <= "0100000";
    wait for T;
    assert(op = "0001") report "==========ERROR (B)==========" severity error;

    ULAop <= "0110011";
    funct3 <= "111";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0010") report "==========ERROR (C)==========" severity error;

    ULAop <= "0110011";
    funct3 <= "110";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0011") report "==========ERROR (D)==========" severity error;

    ULAop <= "0110011";
    funct3 <= "100";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0100") report "==========ERROR (E)==========" severity error;

    ULAop <= "0110011";
    funct3 <= "010";
    funct7 <= "0000000";
    wait for T;
    assert(op = "1000") report "==========ERROR (F)==========" severity error;

    ULAop <= "1100011";
    funct3 <= "000";
    wait for T;
    assert(op = "1100") report "==========ERROR (G)==========" severity error;

    ULAop <= "1100011";
    funct3 <= "001";
    wait for T;
    assert(op = "1101") report "==========ERROR (H)==========" severity error;

    ULAop <= "0010011";
    funct3 <= "000";
    wait for T;
    assert(op = "0000") report "==========ERROR (I)==========" severity error;

    ULAop <= "0010011";
    funct3 <= "100";
    wait for T;
    assert(op = "0000") report "==========ERROR (J)==========" severity error;

    ULAop <= "0000011";
    funct3 <= "010";
    wait for T;
    assert(op = "0000") report "==========ERROR (K)==========" severity error;

    ULAop <= "1100111";
    funct3 <= "000";
    wait for T;
    assert(op = "0000") report "==========ERROR (L)==========" severity error;

    ULAop <= "1101111";
    wait for T;
    assert(op = "0000") report "==========ERROR (M)==========" severity error;

    ULAop <= "0110111";
    wait for T;
    assert(op = "0101") report "==========ERROR (N)==========" severity error;

    ULAop <= "0100011";
    funct3 <= "010";
    wait for T;
    assert(op = "0000") report "==========ERROR (O)==========" severity error;

    wait;
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity CTL_ULA_tb is
end CTL_ULA_tb;

architecture testbench of CTL_ULA_tb is
  signal ULAop, funct7 : std_logic_vector(6 downto 0) := (others => '0');
  signal current_ctl_state, funct3 : std_logic_vector(2 downto 0) := (others => '0');
  signal op : std_logic_vector(3 downto 0) := "0000";
begin
  e_ctl_ula: CTL_ULA port map(
    ULAop => ULAop,
    current_ctl_state => current_ctl_state,
    funct3 => funct3,
    funct7 => funct7,
    op => op
  );

  process is
  begin
    -- TESTING CTL STATE ULAOP OVERRIDE
    current_ctl_state <= "000";
    ULAop <= R_TYPE;
    funct3 <= "111";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0000") report "==========ERROR CTL STATE (A)==========" severity error;

    current_ctl_state <= "000";
    ULAop <= I_TYPE;
    funct3 <= "111";
    wait for T;
    assert(op = "0000") report "==========ERROR CTL STATE (B)==========" severity error;

    current_ctl_state <= "000";
    ULAop <= R_TYPE;
    funct3 <= "000";
    funct7 <= "0100000";
    wait for T;
    assert(op = "0000") report "==========ERROR CTL STATE (C)==========" severity error;
    -- END CTL STATE ULAOP OVERRIDE TEST

    current_ctl_state <= "001";

    ULAop <= R_TYPE;
    funct3 <= "000";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0000") report "==========ERROR (A)==========" severity error;

    ULAop <= R_TYPE;
    funct3 <= "000";
    funct7 <= "0100000";
    wait for T;
    assert(op = "0001") report "==========ERROR (B)==========" severity error;

    ULAop <= R_TYPE;
    funct3 <= "111";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0010") report "==========ERROR (C)==========" severity error;

    ULAop <= R_TYPE;
    funct3 <= "110";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0011") report "==========ERROR (D)==========" severity error;

    ULAop <= R_TYPE;
    funct3 <= "100";
    funct7 <= "0000000";
    wait for T;
    assert(op = "0100") report "==========ERROR (E)==========" severity error;

    ULAop <= R_TYPE;
    funct3 <= "010";
    funct7 <= "0000000";
    wait for T;
    assert(op = "1000") report "==========ERROR (F)==========" severity error;

    ULAop <= B_TYPE;
    funct3 <= "000";
    wait for T;
    assert(op = "1100") report "==========ERROR (G)==========" severity error;

    ULAop <= B_TYPE;
    funct3 <= "001";
    wait for T;
    assert(op = "1101") report "==========ERROR (H)==========" severity error;

    ULAop <= I_TYPE;
    funct3 <= "000";
    wait for T;
    assert(op = "0000") report "==========ERROR (I)==========" severity error;

    ULAop <= I_TYPE;
    funct3 <= "100";
    wait for T;
    assert(op = "0100") report "==========ERROR (J)==========" severity error;

    ULAop <= I_2_TYPE;
    funct3 <= "010";
    wait for T;
    assert(op = "0000") report "==========ERROR (K)==========" severity error;

    ULAop <= I_3_TYPE;
    funct3 <= "000";
    wait for T;
    assert(op = "0000") report "==========ERROR (L)==========" severity error;

    ULAop <= J_TYPE;
    wait for T;
    assert(op = "0000") report "==========ERROR (M)==========" severity error;

    ULAop <= U_TYPE;
    wait for T;
    assert(op = "0000") report "==========ERROR (N)==========" severity error;

    ULAop <= S_TYPE;
    funct3 <= "010";
    wait for T;
    assert(op = "0000") report "==========ERROR (O)==========" severity error;

    ULAop <= I_TYPE;
    funct3 <= "110";
    wait for T;
    assert(op = "0011") report "==========ERROR (P)==========" severity error;

    ULAop <= I_TYPE;
    funct3 <= "111";
    wait for T;
    assert(op = "0010") report "==========ERROR (Q)==========" severity error;

    wait;
  end process;
end architecture;


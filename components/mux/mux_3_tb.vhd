library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX3_tb is
end MUX3_tb;

architecture testbench of MUX3_tb is
  signal mux_A, mux_B, mux_C, mux_out : std_logic_vector(WSIZE-1 downto 0);
  signal sel : std_logic_vector(1 downto 0);
begin
  e_mux: MUX3 port map(
    mux_A => mux_A,
    mux_B => mux_B,
    mux_C => mux_C,
    sel => sel,
    mux_out => mux_out
  );
  process is
  begin
    mux_A <= x"AAAAAAAA";
    mux_B <= x"BBBBBBBB";
    mux_C <= x"CCCCCCCC";
    sel <= "01";
    wait for T;
    assert(mux_out = x"BBBBBBBB") report "!===========ERROR MUX3 (A)===========!" severity error;

    sel <= "00";
    wait for T;
    assert(mux_out = x"AAAAAAAA") report "!===========ERROR MUX3 (B)===========!" severity error;

    sel <= "10";
    wait for T;
    assert(mux_out = x"CCCCCCCC") report "!===========ERROR MUX3 (C)===========!" severity error;

    wait;
  end process;
end architecture;


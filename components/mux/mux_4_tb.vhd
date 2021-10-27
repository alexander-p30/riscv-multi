library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX4_tb is
end MUX4_tb;

architecture testbench of MUX4_tb is
  signal mux_A, mux_B, mux_C, mux_D, mux_out : std_logic_vector(WSIZE-1 downto 0);
  signal sel : std_logic_vector(1 downto 0);
begin
  e_mux: MUX4 port map(
    mux_A => mux_A,
    mux_B => mux_B,
    mux_C => mux_C,
    mux_D => mux_D,
    sel => sel,
    mux_out => mux_out
  );
  process is
  begin
    mux_A <= x"AAAAAAAA";
    mux_B <= x"BBBBBBBB";
    mux_C <= x"CCCCCCCC";
    mux_D <= x"DDDDDDDD";

    sel <= "01";
    wait for T;
    assert(mux_out = x"BBBBBBBB") report "!===========ERROR MUX4 (A)===========!" severity error;

    sel <= "00";
    wait for T;
    assert(mux_out = x"AAAAAAAA") report "!===========ERROR MUX4 (B)===========!" severity error;

    sel <= "11";
    wait for T;
    assert(mux_out = x"DDDDDDDD") report "!===========ERROR MUX4 (C)===========!" severity error;

    sel <= "10";
    wait for T;
    assert(mux_out = x"CCCCCCCC") report "!===========ERROR MUX4 (D)===========!" severity error;

    wait;
  end process;
end architecture;


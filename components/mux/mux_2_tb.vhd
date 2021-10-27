library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX2_tb is
end MUX2_tb;

architecture testbench of MUX2_tb is
  signal mux_A, mux_B, mux_out : std_logic_vector(WSIZE-1 downto 0);
  signal sel : std_logic;
begin
  e_mux: MUX2 port map(
    mux_A => mux_A,
    mux_B => mux_B,
    sel => sel,
    mux_out => mux_out
  );
  process is
  begin
    mux_A <= x"12345678";
    mux_B <= x"AAAAAAAA";
    sel <= '1';
    wait for T;
    assert(mux_out = x"AAAAAAAA") report "!===========ERROR MUX2 (B)===========!" severity error;

    sel <= '0';
    wait for T;
    assert(mux_out = x"12345678") report "!===========ERROR MUX2 (C)===========!" severity error;

    sel <= '1';
    wait for T;
    assert(mux_out = x"AAAAAAAA") report "!===========ERROR MUX2 (D)===========!" severity error;

    wait;
  end process;
end architecture;


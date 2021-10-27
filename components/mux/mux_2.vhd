library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX2 is
  port (
    mux_A, mux_B : in std_logic_vector(WSIZE-1 downto 0);
    sel : in std_logic;
    mux_out: out std_logic_vector(WSIZE-1 downto 0) := ZERO32
  );
end entity MUX2;

architecture MUX2_arch of MUX2 is
begin
  mux_out <= mux_A when sel = '0' else mux_B;
end MUX2_arch;


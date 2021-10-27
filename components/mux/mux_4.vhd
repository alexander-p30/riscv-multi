library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX4 is
  port (
    mux_A, mux_B, mux_C, mux_D : in std_logic_vector(WSIZE-1 downto 0);
    sel : in std_logic_vector(1 downto 0);
    mux_out: out std_logic_vector(WSIZE-1 downto 0)
  );
end entity MUX4;

architecture MUX4_arch of MUX4 is
begin
  mux_out <= mux_A when sel = "00" else
             mux_B when sel = "01" else
             mux_C when sel = "10" else
             mux_D;
end MUX4_arch;


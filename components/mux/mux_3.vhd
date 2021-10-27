library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MUX3 is
  port (
    mux_A, mux_B, mux_C : in std_logic_vector(WSIZE-1 downto 0);
    sel : in std_logic_vector(1 downto 0);
    mux_out: out std_logic_vector(WSIZE-1 downto 0)
  );
end entity MUX3;

architecture MUX3_arch of MUX3 is
begin
  mux_out <= mux_A when sel = "00" else mux_B when sel = "01" else mux_C;
end MUX3_arch;


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity GENERIC_REG is
  port (
    clk: in std_logic;
    we: in std_logic;
    reg_in: in std_logic_vector(31 downto 0);
    reg_out: out std_logic_vector(31 downto 0) := x"00000000"
  );
end entity GENERIC_REG;

architecture RTL of GENERIC_REG is
begin
  process(clk) is
  begin
    if (rising_edge(clk) and we = '1') then
      reg_out <= reg_in;
    end if;
  end process;
end RTL;



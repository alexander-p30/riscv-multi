library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
  port (
    clk: in std_logic;
    we: in std_logic;
    pc_in: in std_logic_vector(31 downto 0);
    pc_out: out std_logic_vector(31 downto 0) := x"00000000"
  );
end entity PC;

architecture PC_arch of PC is
begin
  process(clk) is
  begin
    if (rising_edge(clk) and we = '1') then
      pc_out <= pc_in;
    end if;
  end process;
end PC_arch;


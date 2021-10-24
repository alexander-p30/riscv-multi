library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package all_components is
  component ulaRV is
    generic (WSIZE : natural := 32);
    port (
      opcode : in std_logic_vector(3 downto 0);
      A, B : in std_logic_vector(WSIZE-1 downto 0);
      Z : out std_logic_vector(WSIZE-1 downto 0);
      cond : out std_logic
    );
  end component ulaRV;

  component PC is
    generic (WSIZE : natural := 32);
    port (
      clk: in std_logic;
      we: in std_logic;
      pc_in: in std_logic_vector(WSIZE-1 downto 0);
      pc_out: out std_logic_vector(WSIZE-1 downto 0)
    );
  end component PC;

  component CTL_ULA is
    port (
      ULAop : in std_logic_vector(6 downto 0);
      funct3 : in std_logic_vector(2 downto 0);
      funct7 : in std_logic_vector(6 downto 0);
      op : out std_logic_vector(3 downto 0)
    );
  end component CTL_ULA;
end package all_components;

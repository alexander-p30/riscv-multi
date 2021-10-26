library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CTL is
  generic (
    R : std_logic_vector(6 downto 0) := "0110011";
    B : std_logic_vector(6 downto 0) := "1100011";
    I : std_logic_vector(6 downto 0) := "0010011";
    I_2 : std_logic_vector(6 downto 0) := "0000011";
    I_3 : std_logic_vector(6 downto 0) := "1100111";
    J : std_logic_vector(6 downto 0) := "1101111";
    U : std_logic_vector(6 downto 0) := "0110111";
    S : std_logic_vector(6 downto 0) := "0100011"
  );

  port (
    opcode : in std_logic_vector(6 downto 0);

    -- PC
    EscrevePCB, EscrevePC, IouD, OrigPC : out std_logic;

    -- MEM/IR
    LeMem : out std_logic;
    EscreveIR : out std_logic;

    -- ULA
    OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    ULAop : out std_logic_vector(3 downto 0);
  );
end entity CTL;

architecture CTL_arch of CTL is
begin
  process is
    case opcode is
      when "0010111" =>
        EscrevePCB <= '0';
        EscrevePC <= '0';
        ULAop <= "0110111"
        wait for
      when "0010111" =>
    end case;
  end process;
end CTL_arch;

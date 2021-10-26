library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CTL is
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

    -- state-machine
    current_state : in std_logic_vector(2 downto 0) := "000";
    next_state : out std_logic_vector(2 downto 0) := "000"
  );
end entity CTL;

architecture CTL_arch of CTL is
  procedure fetch(
    signal EscrevePCB, EscrevePC, EscreveIR, IouD, OrigPC, LeMem : out std_logic;
    signal ULAop : out std_logic_vector(3 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    IouD <= '0';
    LeMem <= '1';
    EscreveIR <= '1';
    OrigULA_A <= "01";
    OrigULA_B <= "01";
    ULAop <= "0000";
    OrigPC <= '0';
    EscrevePC <= '1';
    EscrevePCB <= '1';
    next_state <= "001";
  end fetch;

begin
  process(current_state) is
  begin
    case current_state is
      when "000" =>
        fetch(
        EscrevePCB => EscrevePCB,
        EscrevePC => EscrevePC,
        EscreveIR => EscreveIR,
        IouD => IouD,
        OrigPC => OrigPC,
        LeMem => LeMem,
        ULAop => ULAop,
        OrigULA_A => OrigULA_A,
        OrigULA_B => OrigULA_B,
        next_state => next_state);
      when others => NULL;
     -- when "001" => decode();
     -- when "010" => do();
     -- when "011" => do_2();
     -- when "100" => ultimo();
    end case;
  end process;

end CTL_arch;

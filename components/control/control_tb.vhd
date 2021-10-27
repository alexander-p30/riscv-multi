library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity CTL_tb is
end CTL_tb;

architecture testbench of CTL_tb is
    signal EscrevePCB, EscrevePC, IouD, OrigPC : std_logic;
    signal LeMem : std_logic;
    signal EscreveIR : std_logic;
    signal OrigULA_A, OrigULA_B : std_logic_vector(1 downto 0);
    signal ULAop : std_logic_vector(6 downto 0);
    signal current_state : std_logic_vector(2 downto 0) := "000";
    signal next_state : std_logic_vector(2 downto 0) := "000";
begin
  e_ctl: CTL port map(
    opcode => "0000000",
    EscrevePCB => EscrevePCB,
    EscrevePC => EscrevePC,
    IouD => IouD,
    OrigPC => OrigPC,
    LeMem => LeMem,
    EscreveIR => EscreveIR,
    OrigULA_A => OrigULA_A,
    OrigULA_B => OrigULA_B,
    ULAop => ULAop,
    current_state => current_state,
    next_state => next_state
  );

  process is
  begin
    wait for T;

    assert(next_state = "001") report "==========ERROR FETCH (A)==========" severity error;
    assert(IouD = '0') report "===========ERROR FETCH (B)===========" severity error;
    assert(LeMem = '1') report "===========ERROR FETCH (C)===========" severity error;
    assert(EscreveIR = '1') report "===========ERROR FETCH (D)===========" severity error;
    assert(OrigULA_A = "01") report "===========ERROR FETCH (E)===========" severity error;
    assert(OrigULA_B = "01") report "===========ERROR FETCH (F)===========" severity error;
    assert(ULAop = R_TYPE) report "===========ERROR FETCH (G)===========" severity error;
    assert(OrigPC = '0') report "===========ERROR FETCH (H)===========" severity error;
    assert(EscrevePC = '1') report "===========ERROR FETCH (I)===========" severity error;
    assert(EscrevePCB = '1') report "===========ERROR FETCH (J)===========" severity error;

    wait;
  end process;
end architecture;


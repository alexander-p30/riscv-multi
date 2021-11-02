library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity CTL_tb is
end CTL_tb;

architecture testbench of CTL_tb is
    signal clk : std_logic := '0';
    signal ongoing_test : std_logic := '1';

    signal EscrevePCB, EscrevePC, IouD, OrigPC : std_logic;
    signal LeMem : std_logic;
    signal EscreveIR : std_logic;
    signal EscreveReg : std_logic;
    signal OrigULA_A, OrigULA_B : std_logic_vector(1 downto 0);
    signal ULAop : std_logic_vector(6 downto 0);
    signal current_state : std_logic_vector(2 downto 0) := STATE_0;
    signal next_state : std_logic_vector(2 downto 0) := STATE_0;
    signal Mem2Reg : std_logic_vector(1 downto 0);
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';
  e_ctl: CTL port map(
    opcode => "0000000",
    EscrevePCB => EscrevePCB,
    EscrevePC => EscrevePC,
    IouD => IouD,
    OrigPC => OrigPC,
    Mem2Reg => Mem2Reg,
    EscreveReg => EscreveReg,
    LeMem => LeMem,
    EscreveIR => EscreveIR,
    OrigULA_A => OrigULA_A,
    OrigULA_B => OrigULA_B,
    ULAop => ULAop,
    current_state => current_state,
    next_state => next_state
  );

  e_ctl_state_reg : CTL_STATE_REGISTER port map(
      clk => clk,
      state_in => next_state,
      state_out => current_state
    );

  process is
  begin
    wait for T/4;
    assert(current_state = STATE_0) report "==========ERROR FETCH (0)==========" severity error;
    assert(next_state = STATE_1) report "==========ERROR FETCH (A)==========" severity error;
    assert(IouD = '0') report "===========ERROR FETCH (B)===========" severity error;
    assert(LeMem = '1') report "===========ERROR FETCH (C)===========" severity error;
    assert(EscreveIR = '1') report "===========ERROR FETCH (D)===========" severity error;
    assert(OrigULA_A = "01") report "===========ERROR FETCH (E)===========" severity error;
    assert(OrigULA_B = "01") report "===========ERROR FETCH (F)===========" severity error;
    assert(ULAop = R_TYPE) report "===========ERROR FETCH (G)===========" severity error;
    assert(OrigPC = '0') report "===========ERROR FETCH (H)===========" severity error;
    assert(EscrevePC = '1') report "===========ERROR FETCH (I)===========" severity error;
    assert(EscrevePCB = '1') report "===========ERROR FETCH (J)===========" severity error;
    wait for T;

    assert(current_state = STATE_1) report "==========ERROR DECODE (0)==========" severity error;
    assert(next_state = "010") report "==========ERROR DECODE (A)==========" severity error;
    assert(OrigULA_A = "10") report "===========ERROR DECODE (E)===========" severity error;
    assert(OrigULA_B = "11") report "===========ERROR DECODE (F)===========" severity error;
    assert(ULAop = R_TYPE) report "===========ERROR DECODE (G)===========" severity error;
    wait for T;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;


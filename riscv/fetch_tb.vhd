library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity fetch_tb is
  generic (WSIZE : natural := 32);
end fetch_tb;

architecture testbench of fetch_tb is
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';

  -- PC/PCBack
  signal pc_we, pcb_we: std_logic := '1';
  signal pc_in: std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal pc_out, pcb_out: std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- ULA
  signal ula_A, ula_B : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal ula_Z : std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- CTL
  signal opcode : std_logic_vector(6 downto 0) := R_TYPE;
  signal EscrevePCB, EscrevePC, IouD, OrigPC : std_logic;
  signal LeMem : std_logic;
  signal EscreveIR : std_logic;
  signal OrigULA_A, OrigULA_B : std_logic_vector(1 downto 0);
  signal ULAop : std_logic_vector(6 downto 0);
  signal current_state : std_logic_vector(2 downto 0) := "000";
  signal next_state : std_logic_vector(2 downto 0);

  -- CTL_ULA
  signal ctl_ula_op : std_logic_vector(3 downto 0);
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';
  next_state <= "000";

  mux_pc : MUX2 port map(
    mux_A => ula_Z,
    mux_B => x"FFFFFFFF",
    sel => OrigPC,
    mux_out => pc_in
  );

  e_pc: PC port map(
    clk => clk,
    we => EscrevePC,
    pc_in => pc_in,
    pc_out => pc_out
  );

  e_pcb: PC port map(
    clk => clk,
    we => EscrevePCB,
    pc_in => pc_out,
    pc_out => pcb_out
  );

  e_ula: ulaRV port map(
    opcode => ctl_ula_op,
    A => ula_A,
    B => ula_B,
    Z => ula_Z,
    cond => open
  );

  mux_ula_a : MUX3 port map(
    mux_A => x"FFFFFFFF",
    mux_B => pc_out,
    mux_C => x"FFFFFFFF",
    sel => OrigULA_A,
    mux_out => ula_A
  );

  mux_ula_b : MUX4 port map(
    mux_A => x"FFFFFFFF",
    mux_B => std_logic_vector(to_unsigned(4, 32)),
    mux_C => x"FFFFFFFF",
    mux_D => x"FFFFFFFF",
    sel => OrigULA_B,
    mux_out => ula_B
  );

  e_ctl: CTL port map(
      opcode => opcode,
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
      next_state => open
   );

  e_ctl_ula : CTL_ULA port map(
      ULAop => ULAop,
      funct3 => "000",
      funct7 => "0000000",
      op => ctl_ula_op
    );

  process is
  begin
    wait for T/4;
    assert(ula_Z = x"00000004") report "!===========ERROR FETCH (A)===========!" severity error;
    assert(pc_out = x"00000000") report "!===========ERROR FETCH (B)===========!" severity error;
    wait for 3*T/4;

    assert(ula_Z = x"00000008") report "!===========ERROR FETCH (C)===========!" severity error;
    assert(pc_out = x"00000004") report "!===========ERROR FETCH (D)===========!" severity error;
    assert(pcb_out = x"00000000") report "!===========ERROR FETCH (E)===========!" severity error;
    wait for T;

    assert(ula_Z = x"0000000C") report "!===========ERROR FETCH (F)===========!" severity error;
    assert(pc_out = x"00000008") report "!===========ERROR FETCH (G)===========!" severity error;
    assert(pcb_out = x"00000004") report "!===========ERROR FETCH (H)===========!" severity error;
    wait for T;

    assert(ula_Z = x"00000010") report "!===========ERROR FETCH (I)===========!" severity error;
    assert(pc_out = x"0000000C") report "!===========ERROR FETCH (J)===========!" severity error;
    assert(pcb_out = x"00000008") report "!===========ERROR FETCH (K)===========!" severity error;
    wait for T;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;


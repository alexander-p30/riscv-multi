library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity ex_j_type_tb is
end ex_j_type_tb;

architecture testbench of ex_j_type_tb is
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';

  -- IR
  signal ir_out : std_logic_vector(WSIZE-1 downto 0);
  signal ir_in : std_logic_vector(WSIZE-1 downto 0);

  -- PC/PCBack
  signal pc_we : std_logic;
  signal pc_in: std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal pc_out, pcb_out: std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- MEM
  signal mem_address : std_logic_vector(WSIZE-1 downto 0);

  -- ULA
  signal ula_cond : std_logic;
  signal ula_A, ula_B : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal ula_Z : std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- CTL
  signal opcode : std_logic_vector(6 downto 0);
  signal EscreveMEM, EscrevePCB, EscrevePC, IouD, OrigPC, Branch : std_logic;
  signal LeMem : std_logic;
  signal EscreveIR : std_logic;
  signal EscreveReg : std_logic;
  signal OrigULA_A, OrigULA_B : std_logic_vector(1 downto 0);
  signal ULAop : std_logic_vector(6 downto 0);
  signal current_state : std_logic_vector(2 downto 0) := "000";
  signal next_state : std_logic_vector(2 downto 0);
  signal Mem2Reg : std_logic_vector(1 downto 0);

  -- CTL_ULA
  signal ctl_ula_op : std_logic_vector(3 downto 0);

  -- genImm
  signal gen_imm_out : signed(WSIZE-1 downto 0);
  signal aux_gen_imm_out : std_logic_vector(WSIZE-1 downto 0);

  -- XREGS
  signal xregs_datain, xregs_out_A, xregs_out_B : std_logic_vector(WSIZE-1 downto 0);

  -- XREGS regs
  signal reg_A_out, reg_B_out : std_logic_vector(WSIZE-1 downto 0);

  -- ULA reg
  signal reg_ULA_Z_out : std_logic_vector(WSIZE-1 downto 0);

  -- DATA reg
  signal data_reg_out : std_logic_vector(WSIZE-1 downto 0);
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';
  aux_gen_imm_out <= std_logic_vector(shift_left(gen_imm_out, 0));
  opcode <= ir_out(6 downto 0);
  pc_we <= EscrevePC or (Branch and ula_cond);

  mux_pc : MUX2 port map(
    mux_A => ula_Z,
    mux_B => reg_ULA_Z_out,
    sel => OrigPC,
    mux_out => pc_in
  );

  e_pc: PC port map(
    clk => clk,
    we => pc_we,
    pc_in => pc_in,
    pc_out => pc_out
  );

  e_pcb: PC port map(
    clk => clk,
    we => EscrevePCB,
    pc_in => pc_out,
    pc_out => pcb_out
  );

  e_reg_ir: GENERIC_REG port map(
    clk => clk,
    we => EscreveIR,
    reg_in => ir_in,
    reg_out => ir_out
  );

  mux_mem : MUX2 port map(
    mux_A => pc_out,
    mux_B => reg_ULA_Z_out,
    sel => IouD,
    mux_out => mem_address
  );

  e_mem : MEM_RV port map(
    clk => clk,
    we => EscreveMEM,
    address => mem_address(11 downto 0),
    datain => reg_B_out,
    dataout => ir_in
  );

  e_ula: ulaRV port map(
    opcode => ctl_ula_op,
    A => ula_A,
    B => ula_B,
    Z => ula_Z,
    cond => ula_cond
  );

  mux_ula_a : MUX3 port map(
    mux_A => reg_A_out,
    mux_B => pc_out,
    mux_C => pcb_out,
    sel => OrigULA_A,
    mux_out => ula_A
  );

  mux_ula_b : MUX4 port map(
    mux_A => reg_B_out,
    mux_B => std_logic_vector(to_unsigned(4, 32)),
    mux_C => std_logic_vector(gen_imm_out),
    mux_D => aux_gen_imm_out,
    sel => OrigULA_B,
    mux_out => ula_B
  );

  e_ctl: CTL port map(
      opcode => opcode,
      EscreveMEM => EscreveMEM,
      EscrevePCB => EscrevePCB,
      EscrevePC => EscrevePC,
      IouD => IouD,
      OrigPC => OrigPC,
      Branch => Branch,
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

  e_ctl_state_register: CTL_STATE_REGISTER port map(
    clk => clk,
    state_in => next_state,
    state_out => current_state
  );

  e_ctl_ula : CTL_ULA port map(
      ULAop => ULAop,
      current_ctl_state => current_state,
      funct3 => ir_out(14 downto 12),
      funct7 => ir_out(31 downto 25),
      op => ctl_ula_op
    );

  e_gen_imm : genImm32 port map(
    instr => ir_out,
    imm32 => gen_imm_out
  );

  e_mux_xregs : MUX3 port map(
    mux_A => reg_ULA_Z_out,
    mux_B => pc_out,
    mux_C => data_reg_out,
    sel => Mem2Reg,
    mux_out => xregs_datain
  );

  e_xregs : XREGS port map (
    clk => clk,
    wren => EscreveReg,
    rst => '0',
    rs1 => ir_out(19 downto 15),
    rs2 => ir_out(24 downto 20),
    rd => ir_out(11 downto 7),
    data => xregs_datain,
    ro1 => xregs_out_A,
    ro2 => xregs_out_B
  );

  reg_A : GENERIC_REG port map (
      clk => clk,
      we => '1',
      reg_in => xregs_out_A,
      reg_out => reg_A_out
   );

  reg_B : GENERIC_REG port map (
      clk => clk,
      we => '1',
      reg_in => xregs_out_B,
      reg_out => reg_B_out
   );

  reg_ULA_Z : GENERIC_REG port map (
      clk => clk,
      we => '1',
      reg_in => ula_Z,
      reg_out => reg_ULA_Z_out
   );

  reg_data : GENERIC_REG port map(
    clk => clk,
    we => '1',
    reg_in => ir_in,
    reg_out => data_reg_out
  );

  process is
   begin
    wait for 43*T;

    wait for T/4;

    assert(ir_in = x"008004ef") report "!===========ERROR FETCH (1)===========!" severity error;

    wait for 3*T/4; -- end fetch

    assert(ir_out = x"008004ef") report "!===========ERROR DECODE (1)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(xregs_datain = pc_out) report "!===========ERROR EX_S (1)===========!" severity error;
    assert(ir_out(11 downto 7) = "01001") report "!===========ERROR EX_S (2)===========!" severity error;
    assert(EscrevePC = '1') report "!===========ERROR EX_S (3)===========!" severity error;
    assert(EscreveReg = '1') report "!===========ERROR EX_S (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR EX_S (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute
    ---------------------------------------- END FIRST INSTRUCTION
    wait for T/4;

    assert(ir_in = x"07b00293") report "!===========ERROR 2 FETCH (1)===========!" severity error;

    wait for 3*T/4; -- end fetch

    ongoing_test <= '0';
    wait;
  end process;
end architecture;


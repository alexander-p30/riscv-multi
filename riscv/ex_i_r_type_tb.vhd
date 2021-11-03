library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity ex_i_r_type_tb is
end ex_i_r_type_tb;

architecture testbench of ex_i_r_type_tb is
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';

  -- IR
  signal ir_out : std_logic_vector(WSIZE-1 downto 0);
  signal ir_in : std_logic_vector(WSIZE-1 downto 0);

  -- PC/PCBack
  signal pc_in: std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal pc_out, pcb_out: std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- MEM
  signal mem_we : std_logic;
  signal mem_address : std_logic_vector(WSIZE-1 downto 0);

  -- ULA
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
  aux_gen_imm_out <= std_logic_vector(signed(gen_imm_out) sll 1);
  opcode <= ir_out(6 downto 0);

  mux_pc : MUX2 port map(
    mux_A => ula_Z,
    mux_B => reg_ULA_Z_out,
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
    cond => open
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
    -- addi t0, zero, 400
    wait for T/4;

    assert(ir_in = x"19000293") report "!===========ERROR FETCH (1)===========!" severity error;

    wait for 3*T/4; -- end fetch

    assert(gen_imm_out = x"00000190") report "!===========ERROR DECODE (1)===========!" severity error;
    assert(ir_out = x"19000293") report "!===========ERROR DECODE (2)===========!" severity error;
    assert(aux_gen_imm_out = x"00000320") report "!===========ERROR DECODE (3)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000000") report "!===========ERROR EX_I (1)===========!" severity error;
    assert(ula_B = x"00000190") report "!===========ERROR EX_I (2)===========!" severity error;
    assert(ula_Z = x"00000190") report "!===========ERROR EX_I (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR EX_I (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR EX_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"00000190") report "!===========ERROR WB_I (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR WB_I (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR WB_I (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00101") report "!===========ERROR WB_I (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR WB_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END FIRST INSTRUCTION
    -- addi t1, zero, 255

    assert(ir_in = x"0ff00313") report "!===========ERROR 2 FETCH (1)===========!" severity error;

    wait for T; -- end fetch

    assert(gen_imm_out = x"000000ff") report "!===========ERROR 2 DECODE (1)===========!" severity error;
    assert(ir_out = x"0ff00313") report "!===========ERROR 2 DECODE (2)===========!" severity error;
    assert(aux_gen_imm_out = x"000001fe") report "!===========ERROR 2 DECODE (3)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR 2 DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000000") report "!===========ERROR 2 EX_I (1)===========!" severity error;
    assert(ula_B = x"000000ff") report "!===========ERROR 2 EX_I (2)===========!" severity error;
    assert(ula_Z = x"000000ff") report "!===========ERROR 2 EX_I (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR 2 EX_I (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR 2 EX_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"000000ff") report "!===========ERROR 2 WB_I (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR 2 WB_I (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR 2 WB_I (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00110") report "!===========ERROR 2 WB_I (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR 2 WB_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END SECOND INSTRUCTION
    -- sub t2, t0, t1

    assert(ir_in = x"406283b3") report "!===========ERROR 3 FETCH (1)===========!" severity error;

    wait for T; -- end fetch

    assert(ir_out = x"406283b3") report "!===========ERROR 3 DECODE (1)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR 3 DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000190") report "!===========ERROR 3 EX_R (1)===========!" severity error;
    assert(ula_B = x"000000ff") report "!===========ERROR 3 EX_R (2)===========!" severity error;
    assert(ula_Z = x"00000091") report "!===========ERROR 3 EX_R (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR 3 EX_R (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR 3 EX_R (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"00000091") report "!===========ERROR 3 WB_R (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR 3 WB_R (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR 3 WB_R (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00111") report "!===========ERROR 3 WB_R (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR 3 WB_R (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END THIRD INSTRUCTION
    -- andi t2, t0, 1094
    assert(ir_in = x"4462f393") report "!===========ERROR 4 FETCH (1)===========!" severity error;

    wait for T; -- end fetch

    assert(ir_out = x"4462f393") report "!===========ERROR 4 DECODE (1)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR 4 DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000190") report "!===========ERROR 4 EX_I (1)===========!" severity error;
    assert(ula_B = x"00000446") report "!===========ERROR 4 EX_I (2)===========!" severity error;
    assert(ula_Z = x"00000000") report "!===========ERROR 4 EX_I (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR 4 EX_I (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR 4 EX_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"00000000") report "!===========ERROR 4 WB_I (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR 4 WB_I (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR 4 WB_I (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00111") report "!===========ERROR 4 WB_I (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR 4 WB_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END FOURTH INSTRUCTION
    -- ori t2, t0, 1094
    assert(ir_in = x"4462e393") report "!===========ERROR 5 FETCH (1)===========!" severity error;

    wait for T; -- end fetch

    assert(ir_out = x"4462e393") report "!===========ERROR 5 DECODE (1)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR 5 DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000190") report "!===========ERROR 5 EX_I (1)===========!" severity error;
    assert(ula_B = x"00000446") report "!===========ERROR 5 EX_I (2)===========!" severity error;
    assert(ula_Z = x"000005D6") report "!===========ERROR 5 EX_I (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR 5 EX_I (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR 5 EX_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"000005D6") report "!===========ERROR 5 WB_I (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR 5 WB_I (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR 5 WB_I (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00111") report "!===========ERROR 5 WB_I (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR 5 WB_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END FIFTH INSTRUCTION
    -- xori t2, t0, 1094
    assert(ir_in = x"4462c393") report "!===========ERROR 6 FETCH (1)===========!" severity error;

    wait for T; -- end fetch

    assert(ir_out = x"4462c393") report "!===========ERROR 6 DECODE (1)===========!" severity error;
    assert(next_state = "010") report "!===========ERROR 6 DECODE (NEXT_STATE)===========!" severity error;

    wait for T; -- end decode

    assert(ula_A = x"00000190") report "!===========ERROR 6 EX_I (1)===========!" severity error;
    assert(ula_B = x"00000446") report "!===========ERROR 6 EX_I (2)===========!" severity error;
    assert(ula_Z = x"000005D6") report "!===========ERROR 6 EX_I (3)===========!" severity error;
    assert(reg_ULA_Z_out /= ula_Z) report "!===========ERROR 6 EX_I (4)===========!" severity error;
    assert(next_state = "011") report "!===========ERROR 6 EX_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end execute

    assert(reg_ULA_Z_out = x"000005D6") report "!===========ERROR 6 WB_I (1)===========!" severity error;
    assert(Mem2Reg = "00") report "!===========ERROR 6 WB_I (2)===========!" severity error;
    assert(xregs_datain = reg_ULA_Z_out) report "!===========ERROR 6 WB_I (3)===========!" severity error;
    assert(ir_out(11 downto 7) = "00111") report "!===========ERROR 6 WB_I (4)===========!" severity error;
    assert(next_state = "000") report "!===========ERROR 6 WB_I (NEXT_STATE)===========!" severity error;

    wait for T; -- end write back
    ---------------------------------------- END SIXTH INSTRUCTION

    ongoing_test <= '0';
    wait;
  end process;
end architecture;


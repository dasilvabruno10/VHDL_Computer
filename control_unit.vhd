library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is 
	port ( clock	: in std_logic;
	reset		: in std_logic; 
	IR_Load		: out std_logic;
	IR		: in std_logic_vector (7 downto 0);
	MAR_Load	: out std_logic;
	PC_Load		: out std_logic;
	PC_Inc		: out std_logic;
	A_Load		: out std_logic;
	B_Load		: out std_logic;
	ALU_Sel		: out std_logic_vector (2 downto 0);
	CCR_Result	: in  std_logic_vector (3 downto 0);
	CCR_Load	: out std_logic;
	Bus2_Sel	: out std_logic_vector (1 downto 0);
	Bus1_Sel	: out std_logic_vector (1 downto 0);
	write		: out std_logic);
end entity; 

architecture control_unit_arch of control_unit is 


constant LDA_IMM	: std_logic_vector (7 downto 0) := x"86";
constant LDA_DIR	: std_logic_vector (7 downto 0) := x"87";
constant LDB_IMM	: std_logic_vector (7 downto 0) := x"88";
constant LDB_DIR	: std_logic_vector (7 downto 0) := x"89";
constant STA_DIR	: std_logic_vector (7 downto 0) := x"96";	
constant STB_DIR	: std_logic_vector (7 downto 0) := x"97";
constant ADD_AB		: std_logic_vector (7 downto 0) := x"42";
constant SUB_AB		: std_logic_vector (7 downto 0) := x"43";
constant AND_AB		: std_logic_vector (7 downto 0) := x"44";
constant OR_AB		: std_logic_vector (7 downto 0) := x"45";
constant INCA		: std_logic_vector (7 downto 0) := x"46";
constant INCB		: std_logic_vector (7 downto 0) := x"47";
constant DECA		: std_logic_vector (7 downto 0) := x"48";
constant DECB		: std_logic_vector (7 downto 0) := x"49";	
constant BRA		: std_logic_vector (7 downto 0) := x"20";
constant BMI		: std_logic_vector (7 downto 0) := x"21";
constant BPL		: std_logic_vector (7 downto 0) := x"22";
constant BEQ		: std_logic_vector (7 downto 0) := x"23";
constant BNE		: std_logic_vector (7 downto 0) := x"24";
constant BVS		: std_logic_vector (7 downto 0) := x"25";
constant BVC		: std_logic_vector (7 downto 0) := x"26";
constant BCS		: std_logic_vector (7 downto 0) := x"27";
constant BCC		: std_logic_vector (7 downto 0) := x"28";


type state_type is 

(S_FETCH_0, S_FETCH_1, S_FETCH_2, 
S_DECODE_3, 
S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6, 
S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7, 
S_ADD_AB_4, 
S_BRA_4, S_BRA_5, S_BRA_6,
S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7);

signal current_state : state_type; 
signal next_state    : state_type; 


begin

STATE_MEMORY : process (clock, reset)

begin 

if (reset = '0') then 
	current_state <= S_FETCH_0; 
elsif (clock'event and clock = '1') then 
	current_state <= next_state; 
end if; 

end process; 


NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)

begin 

	if(current_state = S_FETCH_0) then
		next_state <= S_FETCH_1;
	elsif(current_state = S_FETCH_1) then
		next_state <= S_FETCH_2;
	elsif(current_state = S_FETCH_2) then
		next_state <= S_DECODE_3;
	elsif(current_state = S_DECODE_3) then
	if (IR = LDA_IMM) then
	  	next_state <= S_LDA_IMM_4;
	elsif (IR = LDA_DIR) then
	  	next_state <= S_LDA_DIR_4;
	elsif (IR = STA_DIR) then
	  	next_state <= S_STA_DIR_4;
	elsif (IR = ADD_AB) then
	  	next_state <= S_ADD_AB_4;
	elsif (IR = BRA) then
	  	next_state <= S_BRA_4;
	elsif (IR = BEQ and CCR_RESULT(2) = '1') then
	  	next_state <= S_BEQ_4;
	elsif (IR = BEQ and CCR_RESULT(2) = '0') then
	  	next_state <= S_BEQ_7;
	else
	  	next_state <= S_FETCH_0;
	end if;
	elsif(current_state = S_LDA_IMM_4) then
		next_state <= S_LDA_IMM_5;
	elsif(current_state = S_LDA_IMM_5) then
		next_state <= S_LDA_IMM_6;
	elsif(current_state = S_LDA_IMM_6) then
		next_state <= S_FETCH_0;
	elsif(current_state = S_LDA_DIR_4) then
		next_state <= S_LDA_DIR_5;
	elsif(current_state = S_LDA_DIR_5) then
		next_state <= S_LDA_DIR_6;
	elsif(current_state = S_LDA_DIR_6) then
		next_state <= S_LDA_DIR_7;
	elsif(current_state = S_LDA_DIR_7) then
		next_state <= S_LDA_DIR_8;
	elsif(current_state = S_LDA_DIR_8) then
		next_state <= S_FETCH_0;
	elsif(current_state = S_STA_DIR_4) then
		next_state <= S_STA_DIR_5;
	elsif(current_state = S_STA_DIR_5) then
		next_state <= S_STA_DIR_6;
	elsif(current_state = S_STA_DIR_6) then
		next_state <= S_STA_DIR_7;
	elsif(current_state = S_STA_DIR_7) then
		next_state <= S_FETCH_0;
	elsif(current_state = S_ADD_AB_4) then
		next_state <= S_FETCH_0;
	elsif(current_state = S_BRA_4) then
		next_state <= S_BRA_5;
	elsif(current_state = S_BRA_5) then
		next_state <= S_BRA_6;
	elsif(current_state = S_BRA_6) then
		next_state <= S_FETCH_0;
	elsif(current_state = S_BEQ_4) then
		next_state <= S_BEQ_5;
	elsif(current_state = S_BEQ_5) then
		next_state <= S_BEQ_6;
	elsif(current_state = S_BEQ_6) then
		next_state <= S_BEQ_7;
	elsif(current_state = S_BEQ_7) then
		next_state <= S_FETCH_0;
	end if;

end process; 


OUTPUT_LOGIC : process (current_state)

begin 

case (current_state) is 

      when S_FETCH_0 => -- Put PC onto MAR to read Opcode 
	IR_Load  <= '0'; 
	MAR_Load <= '1'; 
	PC_Load  <= '0'; 
	PC_Inc   <= '0'; 
	A_Load   <= '0'; 
	B_Load   <= '0'; 
	ALU_Sel  <= "000"; 
	CCR_Load <= '0';
	Bus1_Sel <= "00"; 
	Bus2_Sel <= "01"; 
	write    <= '0'; 

      when S_FETCH_1 => -- Increment PC 
	IR_Load  <= '0'; 
	MAR_Load <= '0'; 
	PC_Load  <= '0'; 
	PC_Inc   <= '1'; 
	A_Load   <= '0'; 
	B_Load   <= '0'; 
	ALU_Sel  <= "000"; 
	CCR_Load <= '0';
	Bus1_Sel <= "00"; 
	Bus2_Sel <= "00"; 
	write    <= '0'; 

      when S_FETCH_2 =>
	IR_Load   <= '1';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_DECODE_3 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_LDA_IMM_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';

      when S_LDA_IMM_5 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '1';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';

      when S_LDA_IMM_6 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '1';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_LDA_DIR_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';
	
      when S_LDA_DIR_5 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '1';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';
 
      when S_LDA_DIR_6 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_LDA_DIR_7 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_LDA_DIR_8 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '1';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_STA_DIR_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';

      when S_STA_DIR_5 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '1';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_STA_DIR_6 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_STA_DIR_7 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "01"; 
	Bus2_Sel  <= "00";
	write     <= '1';

      when S_ADD_AB_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '1';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '1';
	Bus1_Sel  <= "01"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_BRA_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';

      when S_BRA_5 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_BRA_6 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '1';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_BEQ_4 =>
	IR_Load   <= '0';
	MAR_Load  <= '1';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "01";
	write     <= '0';

      when S_BEQ_5 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';

      when S_BEQ_6 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '1';
	PC_Inc    <= '0';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "10";
	write     <= '0';

      when S_BEQ_7 =>
	IR_Load   <= '0';
	MAR_Load  <= '0';
	PC_Load   <= '0';
	PC_Inc    <= '1';
	A_Load    <= '0';
	B_Load	  <= '0';
	ALU_Sel   <= "000";
	CCR_Load  <= '0';
	Bus1_Sel  <= "00"; 
	Bus2_Sel  <= "00";
	write     <= '0';



	end case; 

	end process; 



end architecture; 

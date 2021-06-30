--entity given in lab handout
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity registers_min_max is
port( din   : in std_logic_vector(3 downto 0);
      reset : in std_logic;
      clk   : in std_logic;
      sel   : in std_logic_vector(1 downto 0);
      max_out : out std_logic_vector(3 downto 0);
      min_out : out std_logic_vector(3 downto 0);
      reg_out : out std_logic_vector(3 downto 0));
end registers_min_max ;

architecture registers_min_max_architecture of registers_min_max is

type Reg_Array is array (3 downto 0) of std_logic_vector(3 downto 0);
signal max_reg, min_reg, max, min: std_logic_vector(3 downto 0);
signal reg: Reg_Array;

--max min for comb logic
--max_reg and min_reg and next state = max and min from comb logic


--beginning of architecture
begin

--process for multiplexer
process(sel, reg)
begin
case sel is
when "00" => reg_out <= reg(0);
when "01" => reg_out <= reg(1);
when "10" => reg_out <= reg(2);
when "11" => reg_out <= reg(3);
when others => reg_out <= "0000";
end case;
end process;

--process for max/min comb logic
process(reg)
variable maxtmp, mintmp: std_logic_vector(3 downto 0);
begin
maxtmp := "0000";
mintmp := "1111";
for i in 0 to 3 loop
	if (maxtmp < reg(i)) then
	maxtmp := reg(i);
	end if;
	if (mintmp > reg(i)) then
	mintmp := reg(i);
	end if;
end loop;
max <= maxtmp;
min <= mintmp;
end process;

process(max, min, clk, reset)
--process for out registers
begin
	if(reset = '1') then
	max_reg <= "0000";
	min_reg <= "1111";
	elsif(clk'event and clk = '1') then
		if(max > max_reg) then
		max_reg <= max;
		end if;
	
		if(min < min_reg) then
		min_reg <= min;
		end if;
	end if;

end process;


process(clk, reset, din)
--process for registers
begin
if(reset = '1') then
for i in 0 to 3 loop
 reg(i) <= "1000";
end loop;
elsif (clk'event and clk = '1') then
	reg(0) <= din;
	reg(1) <= reg(0);
	reg(2) <= reg(1);
	reg(3) <= reg(2);
end if;
end process;

max_out <= max_reg;
min_out <= min_reg;


end registers_min_max_architecture;


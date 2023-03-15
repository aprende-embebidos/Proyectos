library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity gesture_display is
	port(clk      : in  std_logic;							--reloj de la tarjeta
		  filas    : out std_logic_vector(7 downto 0);	--filas encendidas de la matriz
		  columnas : out std_logic_vector(7 downto 0);	--columnas encendidas de la matriz
		  gesture  : in  std_logic_vector(1 downto 0);  --numero binario recibido desde el Raspberry
		  IO_SDA_PI,IO_SDA_SLAVE: in std_logic;
		  IO_SCL_PI,IO_SCL_SLAVE: in std_logic);
end gesture_display;

architecture logic of gesture_display is
	signal cuenta   : integer range 0 to 50000;		--contador para multiplexar las filas de la matriz
	signal sel      : std_logic_vector(2 downto 0);	--selector de filas de la matriz
	
	signal columna_0 : std_logic_vector(7 downto 0);
	signal columna_1 : std_logic_vector(7 downto 0);
	signal columna_2 : std_logic_vector(7 downto 0);
	signal columna_3 : std_logic_vector(7 downto 0);
	signal columna_4 : std_logic_vector(7 downto 0);
	signal columna_5 : std_logic_vector(7 downto 0);
	signal columna_6 : std_logic_vector(7 downto 0);
	signal columna_7 : std_logic_vector(7 downto 0);
begin
	--Multiplexador-------------------------------------------------------
	process(clk)
   begin
		if rising_edge(clk) then
			cuenta <= cuenta + 1;
			if cuenta = 50000 then
				cuenta <= 0;
				sel <= sel+1;
			end if;
		end if;
	end process;
	
	with SEL select filas <=	"01111111" when "000",
										"10111111" when "001",
										"11011111" when "010",
										"11101111" when "011",
										"11110111" when "100",
										"11111011" when "101",
										"11111101" when "110",
										"11111110" when "111",
										"11111111" when others;
	
	with SEL select columnas  <=  columna_0 when "000",
											columna_1 when "001",
											columna_2 when "010",
											columna_3 when "011",
											columna_4 when "100",
											columna_5 when "101",
											columna_6 when "110",
											columna_7 when "111",
											"11111111"when others;
	------------------------------------------------------------------------
	
	--Lista de letras-------------------------------------------------------
	process(gesture)
		begin
			if gesture = "00" then --for_back
				columna_0 <= "11011111";
				columna_1 <= "10011011";
				columna_2 <= "00011011";
				columna_3 <= "11011011";
				columna_4 <= "11011011";
				columna_5 <= "11011000";
				columna_6 <= "11011001";
				columna_7 <= "11111011";
			elsif gesture = "01" then --left_right
            columna_0 <= "11111011";
				columna_1 <= "11111001";
				columna_2 <= "00000000";
				columna_3 <= "11111111";
				columna_4 <= "11111111";
				columna_5 <= "00000000";
				columna_6 <= "10011111";
				columna_7 <= "11011111";
			elsif gesture = "10" then --resting
            columna_0 <= "11111111";
				columna_1 <= "11100111";
				columna_2 <= "11011011";
				columna_3 <= "10111101";
				columna_4 <= "10111101";
				columna_5 <= "11011011";
				columna_6 <= "11100111";
				columna_7 <= "11111111";
			elsif gesture = "11" then --up_down
            columna_0 <= "11111111";
				columna_1 <= "10111101";
				columna_2 <= "11011011";
				columna_3 <= "11100111";
				columna_4 <= "11100111";
				columna_5 <= "11011011";
				columna_6 <= "10111101";
				columna_7 <= "11111111";
			end if;
	end process;
	------------------------------------------------------------------------
end logic;
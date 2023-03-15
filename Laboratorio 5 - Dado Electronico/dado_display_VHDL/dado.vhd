library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dado is
	port(	clk				: in 	std_logic; -- reloj del sistema
			roll_in, T		: in 	std_logic; -- boton de tirar dados y boton de cambiar numero de dados
			roll_out		: out 	std_logic; -- salida hacia el RP Pico indicando lanzar los dados
			dado_1, dado_2	: in 	std_logic_vector(2 downto 0); -- Valores de los dados enviados por el RP Pico
			display			: out 	std_logic_vector(7 downto 0); -- Digitos del display
			segmentos		: out 	std_logic_vector(7 downto 0)); -- Segmentos encendidos de cada digito
end dado;

architecture wiring of dado is
	signal EM0,EM1,EM2,EM3,EM4,EM5,EM6,EM7,SM: std_logic_vector(2 downto 0);	-- Valores que debe mostrar cada digito
	signal SEL: std_logic_vector(2 downto 0); 									-- Selector
	signal CONTADOR: integer range 0 to 50000;									-- Contador para el Multiplexor
	signal CONTADOR_T: integer range 0 to 5000000;								-- Contador para el cambio de numero de dados
	signal CLK_T: std_logic;													-- Reloj para el T-FlipFlop que intercambia el numero de dados
	signal TMP: std_logic;														-- Salida del T-FlipFlop
begin
	
	roll_out <= not roll_in;									-- Conectamos el boton con el pin que va hacia el RP Pico
	
	--Contador-T---------------------------------------
	process(clk)
	begin
		if rising_edge(clk) then
			CONTADOR_T <= CONTADOR_T+1;
			if CONTADOR_T = 5000000 then
				CONTADOR_T <= 0;
				CLK_T <= not CLK_T;
			end if;
		end if;
	end process;	
	--------------------------------------------------
	
	--Intercambiar numero de dados entre 1 y 2-------
	process(CLK_T)
	begin
		--T-FlipFlop---------------
		if rising_edge(CLK_T) then
			if T = '1' then
				TMP <= TMP;
			elsif T = '0' then
				TMP <= not TMP;
			end if;
		end if;
		---------------------------
		if TMP = '0' then
			EM0 <= "111";
			EM1 <= "111";
			EM2 <= "111";
			EM3 <= dado_1; --si la salida del TFF es 0 asignamos el valor del DADO 1 al digito 3
			EM4 <= "111";
			EM5 <= "111";
			EM6 <= "111";
			EM7 <= dado_2; --si la salida del TFF es 0 asignamos el valor del DADO 2 al digito 7
		elsif TMP = '1' then
			EM0 <= "111";
			EM1 <= "111";
			EM2 <= "111";
			EM3 <= dado_1; --si la salida del TFF es 1 asignamos el valor del DADO 1 al digito 3
			EM4 <= "111";
			EM5 <= "111";
			EM6 <= "111";
			EM7 <= "111";
		end if;
			
	end process;
	--------------------------------------------------

	--Contador----------------------------------------
	process(clk)
	begin
		if rising_edge(clk) then
			CONTADOR <= CONTADOR+1;
			if CONTADOR = 50000 then
				CONTADOR <= 0;
				SEL <= SEL+1;
			end if;
		end if;
	end process;	
	--------------------------------------------------
	--Multiplexador-----------------------------------
	with SEL Select display <= 	"11111110" when "000",
								"11111101" when "001",
								"11111011" when "010",
								"11110111" when "011",
								"11101111" when "100",
								"11011111" when "101",
								"10111111" when "110",
								"01111111" when others;
	--------------------------------------------------
	--SELector de numero/simbolo----------------------
	with SEL Select SM	<=	EM0 when "000",
							EM1 when "001",
							EM2 when "010",
							EM3 when "011",
							EM4 when "100",
							EM5 when "101",
							EM6 when "110",
							EM7 when others;
	--------------------------------------------------
 
	--Lista de numeros/simbolos-----------------------------------
	with SM Select segmentos <=	"10111111" when "000", --
								"11111001" when "001", --1
								"10100100" when "010", --2
								"10110000" when "011", --3
								"10011001" when "100", --4
								"10010010" when "101", --5
								"10000010" when "110", --6
								"11111111" when others; --
	-------------------------------------------------------------
		
end wiring;
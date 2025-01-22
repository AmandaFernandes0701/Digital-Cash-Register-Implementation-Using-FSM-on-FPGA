library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Sinalizador is
-- Nenhuma porta necessária para um testbench
end tb_Sinalizador;

architecture Behavioral of tb_Sinalizador is

    -- Componentes para instanciar o Sinalizador
    component Sinalizador
        port (
            clk             : in std_logic;
            reset           : in std_logic;
            valor_inserido  : in std_logic_vector(3 downto 0);
            operador : in std_logic;
            button_pressed  : in std_logic;
            button_operator_pressed : in std_logic;
            display_unidades : out std_logic_vector(6 downto 0);
            display_dezenas  : out std_logic_vector(6 downto 0);
            resultado        : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Sinais locais para conectar com o DUT (Design Under Test)
    signal clk             : std_logic := '0';
    signal reset           : std_logic := '0';
    signal valor_inserido  : std_logic_vector(3 downto 0) := (others => '0');
    signal operador : std_logic := '0';
    signal button_pressed  : std_logic := '0';
    signal button_operator_pressed : std_logic := '0';
    signal display_unidades : std_logic_vector(6 downto 0);
    signal display_dezenas  : std_logic_vector(6 downto 0);
    signal resultado        : std_logic_vector(3 downto 0);

    -- Constante para o período do clock
    constant clk_period : time := 10 ns;

begin

    -- Instância do módulo Sinalizador
    DUT: Sinalizador
        port map (
            clk => clk,
            reset => reset,
            valor_inserido => valor_inserido,
            operador => operador,
            button_pressed => button_pressed,
            button_operator_pressed => button_operator_pressed,
            display_unidades => display_unidades,
            display_dezenas => display_dezenas,
            resultado => resultado
        );

    -- Geração do clock
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Estímulos de teste
    stim_proc: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        button_pressed <= '0';
        button_operator_pressed <= '0';

        -- Teste 1: 0 + 2 = 2
        valor_inserido <= "0010"; -- 2
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 2: 2 + 1 = 3
        valor_inserido <= "0001"; -- 1
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 3: 3 + 2 = 5
        valor_inserido <= "0010"; -- 2
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 4: 5 - 2 = 3
        valor_inserido <= "0010"; -- 2
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '1'; -- SUBTRAÇÃO
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 5: 3 - 3 = 0
        valor_inserido <= "0011"; -- 3
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '1'; -- SUBTRAÇÃO
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 6: 0 + 4 = 4
        valor_inserido <= "0100"; -- 4
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 7: 4 + 5 = 9
        valor_inserido <= "0101"; -- 5
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 8: 9 - 3 = 6
        valor_inserido <= "0011"; -- 3
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '1'; -- SUBTRAÇÃO
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 9: 6 + 7 = 13
        valor_inserido <= "0111"; -- 7
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '0'; -- SOMA
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Teste 10: 13 - 3 = 10
        valor_inserido <= "0011"; -- 3
        button_pressed <= '1';
        wait for clk_period;
        button_pressed <= '0';
        operador <= '1'; -- SUBTRAÇÃO
        wait for clk_period;

        button_operator_pressed <= '1';
        wait for clk_period;
        button_operator_pressed <= '0';
        wait for clk_period;

        -- Finalizar simulação
        wait;
    end process;

end Behavioral;

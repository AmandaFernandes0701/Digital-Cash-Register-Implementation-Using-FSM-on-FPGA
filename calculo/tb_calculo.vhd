library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_calculo is
-- Entidade sem portas, apenas para simulação
end tb_calculo;

architecture sim of tb_calculo is

    -- Parâmetro genérico
    constant W : integer := 4;

    -- Sinais para conectar à DUT (Device Under Test)
    signal CLK       : std_logic := '0';
    signal RESET     : std_logic := '0';
    signal INPUT     : std_logic_vector(W-1 downto 0) := (others => '0');
    signal OPERATION : std_logic := '0';
    signal OUTPUT    : std_logic_vector(W-1 downto 0);

    -- Período do relógio
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia a unidade em teste (DUT)
    DUT: entity work.calculo
        generic map (
            W => W
        )
        port map (
            CLK       => CLK,
            RESET     => RESET,
            INPUT     => INPUT,
            OPERATION => OPERATION,
            OUTPUT    => OUTPUT
        );

    -- Geração do relógio
    CLK_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de teste
    stim_proc: process
    begin
        -- Teste 1: Reset
        RESET <= '1';
        wait for CLK_PERIOD;
        RESET <= '0';

        -- Teste 2: Soma (INPUT = 3, depois 2)
        INPUT <= "0011"; -- 3 em binário
        OPERATION <= '0'; -- Soma
        wait for CLK_PERIOD/3;

        INPUT <= "0010"; -- 2 em binário
        wait for CLK_PERIOD/2;

        -- Teste 3: Subtração (INPUT = 1)
        INPUT <= "0001"; -- 1 em binário
        OPERATION <= '1'; -- Subtração
        wait for CLK_PERIOD;

        -- Teste 4: Soma (INPUT = 4)
        INPUT <= "0100"; -- 4 em binário
        OPERATION <= '0'; -- Soma
        wait for CLK_PERIOD;

        -- Finaliza a simulação
        wait for 50 ns;
        assert false report "Fim da simulação" severity note;
        wait;
    end process;

end sim;

-- Biblioteca utilizada
library ieee;
use ieee.std_logic_1164.all;

-- Testbench do Datapath
entity tb_Datapath is
end tb_Datapath;

architecture teste of tb_Datapath is 

    -- Componente Datapath correspondente ao design principal
    component datapath is
        generic (
            W : integer := 4
        );
        port (
            clk                : in  std_logic;
            reset              : in  std_logic;
            BUTTON_PRESSED     : in  std_logic;
            valor_inserido     : in  std_logic_vector(W-1 downto 0);
            operador           : in  std_logic; -- 0 para soma, 1 para subtração
            display_unidades   : out std_logic_vector(6 downto 0);
            display_dezenas    : out std_logic_vector(6 downto 0);
            resultado          : out std_logic_vector(W-1 downto 0)
        );
    end component;

    -- Sinais do testbench
    signal clk_tb                : std_logic := '0';
    signal reset_tb              : std_logic := '0';
    signal BUTTON_PRESSED_tb     : std_logic := '0';
    signal valor_inserido_tb     : std_logic_vector(3 downto 0) := "0000";
    signal operador_tb           : std_logic := '0';
    signal display_unidades_tb   : std_logic_vector(6 downto 0);
    signal display_dezenas_tb    : std_logic_vector(6 downto 0);
    signal resultado_tb          : std_logic_vector(3 downto 0);

begin 
    -- Instância do Datapath
    instancia_Datapath: datapath
        generic map (
            W => 4
        )
        port map (
            clk => clk_tb,
            reset => reset_tb,
            BUTTON_PRESSED => BUTTON_PRESSED_tb,
            valor_inserido => valor_inserido_tb,
            operador => operador_tb,
            display_unidades => display_unidades_tb,
            display_dezenas => display_dezenas_tb,
            resultado => resultado_tb
        );

    -- Geração do clock
    clk_tb <= not clk_tb after 5 ns;

    -- Estímulos do testbench
    process
    begin
        -- Inicialização
        reset_tb <= '1';
        wait for 10 ns;
        reset_tb <= '0';

        -- Inserção de valores e operação de soma
        BUTTON_PRESSED_tb <= '1';
        valor_inserido_tb <= "0011";  -- Valor 3
        operador_tb <= '0';           -- Operação de soma
        wait for 10 ns;
        BUTTON_PRESSED_tb <= '0';
        wait for 10 ns;

        -- Inserção de valores e operação de subtração
        BUTTON_PRESSED_tb <= '1';
        valor_inserido_tb <= "0001";  -- Valor 1
        operador_tb <= '1';           -- Operação de subtração
        wait for 10 ns;
        BUTTON_PRESSED_tb <= '0';
        wait for 10 ns;

        -- Fim da simulação
        wait for 50 ns;
        wait;
    end process;

end teste;

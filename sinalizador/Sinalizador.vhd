library ieee;
use ieee.std_logic_1164.all;

entity Sinalizador is
    port (
        clk             : in std_logic;  -- Relógio
        reset           : in std_logic;  -- Sinal de reset
        valor_inserido  : in std_logic_vector(3 downto 0);  -- Valor de entrada
        operador : in std_logic;
        button_pressed  : in std_logic;  -- Botão pressionado (confirma valor do número)
		  button_operator_pressed  : in std_logic;  -- Botão pressionado (confirma valor do operador)
        display_unidades : out std_logic_vector(6 downto 0);  -- Saída do display das unidades
        display_dezenas  : out std_logic_vector(6 downto 0);  -- Saída do display das dezenas
        resultado        : out std_logic_vector(3 downto 0)   -- Resultado da operação
    );
end Sinalizador;

architecture Structural of Sinalizador is

    -- Sinais internos para comunicação entre a controladora e o datapath
    signal enable_reg     : std_logic;
    signal enable_calc    : std_logic;
    signal enable_display : std_logic;
    signal q_reg          : std_logic_vector(3 downto 0);
    signal resultado_internal : std_logic_vector(3 downto 0);

    -- Instanciando os componentes
    component datapath
        generic (
            W : integer := 4
        );
        port (
            clk                : in std_logic;
            reset              : in std_logic;
            BUTTON_OPERATOR_PRESSED     : in std_logic;
				BUTTON_PRESSED     : in std_logic;
            valor_inserido     : in std_logic_vector(W-1 downto 0);
            operador    : in std_logic;
            display_unidades   : out std_logic_vector(6 downto 0);
            display_dezenas    : out std_logic_vector(6 downto 0);
            resultado          : out std_logic_vector(W-1 downto 0)
        );
    end component;

    component controladora
        port (
            CLK            : in std_logic;
            RESET          : in std_logic;
            INPUT          : in std_logic_vector(3 downto 0);
            OPERATION      : in std_logic;
            BUTTON_PRESSED : in std_logic;
				BUTTON_OPERATOR_PRESSED : in std_logic;
            ENABLE_REG     : out std_logic;
            ENABLE_CALC    : out std_logic;
            ENABLE_DISPLAY : out std_logic;
            Q_REG          : in std_logic_vector(3 downto 0);
            OUTPUT         : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- Instanciando o Datapath
    datapath_inst : datapath
        generic map (
            W => 4
        )
        port map (
            clk => clk,
            reset => reset,
            BUTTON_PRESSED => button_pressed,
				BUTTON_OPERATOR_PRESSED => button_operator_pressed,
            valor_inserido => valor_inserido,
            operador => operador,
            display_unidades => display_unidades,
            display_dezenas => display_dezenas,
            resultado => resultado_internal
        );

    -- Instanciando a Controladora
    controladora_inst : controladora
        port map (
            CLK => clk,
            RESET => reset,
            INPUT => valor_inserido,
            OPERATION => operador,  
            BUTTON_PRESSED => button_pressed,
				BUTTON_OPERATOR_PRESSED => button_operator_pressed,
            ENABLE_REG => enable_reg,
            ENABLE_CALC => enable_calc,
            ENABLE_DISPLAY => enable_display,
            Q_REG => resultado_internal,
            OUTPUT => resultado
        );

end Structural;

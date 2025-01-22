library ieee;
use ieee.std_logic_1164.all;

entity tb_RegW is
end tb_RegW;

architecture comportamental of tb_RegW is

    -- Instanciando o componente RegW
    component RegW
        generic( w: integer := 4 );
        port(
            clk, enable, reset : in std_logic;
            D : in std_logic_vector(w-1 downto 0);
            Q : out std_logic_vector(w-1 downto 0)
        );
    end component;

    -- Sinais para os testes
    signal meu_clock, enable, reset : std_logic := '0';
    signal D : std_logic_vector(3 downto 0) := (others => '0');
    signal Q : std_logic_vector(3 downto 0);  -- Q será atualizado pelo componente RegW

begin

    -- Instância do componente RegW
    uut: RegW
        generic map (w => 4)  -- Passando o valor do generic w
        port map (
            clk => meu_clock,   -- Conectando o sinal de clock
            enable => enable,   -- Conectando o sinal enable
            reset => reset,     -- Conectando o sinal reset
            D => D,             -- Conectando o sinal D
            Q => Q              -- Conectando o sinal Q
        );

    -- Processo do clock (alternando de forma contínua)
    clk_process: process
    begin
        -- Gerando o clock com período de 10ns (5ns high, 5ns low)
        while true loop
            meu_clock <= '0';
            wait for 5 ns;
            meu_clock <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Processo de estímulo (stimuli)
    stim_proc: process
    begin
        -- Teste 0: Inicializando o reset
        reset <= '1';  -- Ativa o reset
        wait for 10 ns;  -- Aguarda o reset ser aplicado
        reset <= '0';  -- Desativa o reset
        wait for 10 ns;  -- Aguarda para estabilizar o sinal

        -- Teste 1: Inicializando valores
        D <= "1010";  -- Atribui valor de D
        enable <= '0';  -- Inicializa com enable em '0', Q não deve mudar
        wait for 10 ns;

        -- Teste 2: Ativa enable e altera D
        enable <= '1';  -- Ativa enable, Q deve ser atualizado com D
        wait for 10 ns;  -- Espera 1 ciclo de clock para garantir que Q foi atualizado
        D <= "1100";  -- Novo valor para D
        wait for 10 ns;  -- Espera para ver a mudança em Q

        -- Teste 3: Desativa enable e altera D
        enable <= '0';  -- Desativa enable, Q não deve mudar
        wait for 10 ns;
        D <= "0011";  -- Novo valor para D
        wait for 10 ns;

        -- Teste 4: Ativa enable novamente e altera D
        enable <= '1';  -- Ativa enable, Q deve ser atualizado com D
        wait for 10 ns;
        D <= "1111";  -- Novo valor para D
        wait for 10 ns;

        -- Teste 5: Desativa enable e altera D
        enable <= '0';  -- Desativa enable, Q não deve mudar
        wait for 10 ns;
        D <= "0101";  -- Novo valor para D
        wait for 10 ns;

        -- Teste 6: Alternando enable e alterando D
        enable <= '1';  -- Ativa enable novamente, Q deve ser atualizado com D
        D <= "1011";  -- Novo valor para D
        wait for 10 ns;
        
        enable <= '0';  -- Desativa enable, Q não deve mudar
        D <= "1101";  -- Novo valor para D
        wait for 10 ns;
        
        enable <= '1';  -- Ativa enable novamente, Q deve ser atualizado com D
        D <= "0010";  -- Novo valor para D
        wait for 10 ns;

        -- Finalização do processo
        wait for 20 ns;  -- Esperar mais 20ns para observar o comportamento

        -- Final da simulação
        wait;
    end process;

end comportamental;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.RAM_definitions_PK.all;


entity read_send_tb is
--  Port ( );
end read_send_tb;

architecture Behavioral of read_send_tb is
    constant C_CLK_PERIOD: time := 8 ns;
    
    component read_send is
    generic (
        G_DATAWIDTH : natural := 8;
        G_DATADEPTH : natural := 256*256;
        CLK_FR : integer := 125;
        SER_FR	: integer := 115200
    );
    port (
        clk : in  std_logic;
        reset: in std_logic;
        button: in std_logic;
        dataout: out std_logic
     );
    end component;
    
    signal clk : std_logic := '1';
    signal reset : std_logic;
    signal button : std_logic;
    signal dataout : std_logic;
    constant G_DATAWIDTH : natural := 8;
    constant G_DATADEPTH : natural := 256*256;
    constant CLK_FR : integer := 125;
    constant SER_FR	: integer := 115200;
    
begin
    
    DUT: read_send
        generic map (
            G_DATADEPTH => G_DATADEPTH,
            G_DATAWIDTH => G_DATAWIDTH,
            CLK_FR => CLK_FR,
            SER_FR => SER_FR
        )
        port map(
            clk => clk,
            reset => reset,
            button => button,
            dataout => dataout
        );
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    
    STIMULUS: process is
    begin
        reset <= '1';
        button <= '0';
        wait for 54*C_CLK_PERIOD;
        reset <= '0';
        wait for 100000*C_CLK_PERIOD;
        button <= '1';
        --button <= '1';
        wait for 7*C_CLK_PERIOD;
        button <='0';
        wait;
        
    end process STIMULUS;
    
end Behavioral;

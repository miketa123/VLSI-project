library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_reg_tb is
--  Port ( );
end shift_reg_tb;

architecture Behavioral of shift_reg_tb is
    constant C_CLK_PERIOD: time := 8 ns;
    
    component shift_reg is
    generic(
        GREGDEPTH : natural := 515;   --10;
        GDATAWIDTH : natural := 8
    );
    port(
        enable : in std_logic;
        clk : in std_logic;
        reset : in std_logic; 
        data_in : in std_logic_vector(GDATAWIDTH - 1 downto 0);
        data_out : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel0 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel1 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel2 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel3 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel4 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel5 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel6 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel7 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel8 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        reg_full : out std_logic;
        data_valid : out std_logic
    );
    end component;
    
    constant GREGDEPTH : natural := 515;
    constant GDATAWIDTH : natural := 8;
    signal clk : std_logic := '1';
    signal reset : std_logic;
    signal data_in : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal data_out : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal reg_full : std_logic;
    signal enable : std_logic;
    signal data_valid : std_logic;
    signal pixel0 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel1 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel2 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel3 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel4 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel5 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel6 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel7 : std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal pixel8 : std_logic_vector(GDATAWIDTH - 1 downto 0);
begin
    DUT: shift_reg
        generic map(
            GREGDEPTH => GREGDEPTH,
            GDATAWIDTH => GDATAWIDTH
        )
        port map(
            enable => enable,
            clk => clk,
            reset => reset,
            data_in => data_in,
            data_out => data_out,
            reg_full => reg_full,
            data_valid => data_valid,
            pixel0 => pixel0,
            pixel1 => pixel1,
            pixel2 => pixel2,
            pixel3 => pixel3,
            pixel4 => pixel4,
            pixel5 => pixel5,
            pixel6 => pixel6,
            pixel7 => pixel7,
            pixel8 => pixel8
        );
        
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process is 
    begin
        reset <= '1';
        enable <= '0';
        data_in <= (others => '0');
        wait for C_CLK_PERIOD*5;
        
        reset <= '0';
        wait for C_CLK_PERIOD;
        enable <= '1';
        data_in <= "00000001";
        wait for C_CLK_PERIOD*35;
        
        data_in <= "00000011";
        wait for C_CLK_PERIOD*100;
        --enable <= '0';
        data_in <= "00000111";
        wait for C_CLK_PERIOD*100;
        data_in <= "11000111";
        wait for C_CLK_PERIOD*100;
        data_in <= "11010111";
        wait for C_CLK_PERIOD*100;
        data_in <= "01000111";
        wait for C_CLK_PERIOD*100;
        data_in <= "00000001";
        wait for C_CLK_PERIOD*100;
        enable <= '0';
        wait;
    end process STIMULUS;
end Behavioral;

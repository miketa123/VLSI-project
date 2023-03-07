library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity odd_even_merge_tb is
--  Port ( );
end odd_even_merge_tb;

architecture Behavioral of odd_even_merge_tb is
    constant C_CLK_PERIOD: time := 8 ns;
    
    component odd_even_merge is
    port(
        reset : in std_logic;
        enable : in std_logic;
        clk : in std_logic;
        pixel0 : in std_logic_vector(7 downto 0);
        pixel1 : in std_logic_vector(7 downto 0);
        pixel2 : in std_logic_vector(7 downto 0);
        pixel3 : in std_logic_vector(7 downto 0);
        pixel4 : in std_logic_vector(7 downto 0);
        pixel5 : in std_logic_vector(7 downto 0);
        pixel6 : in std_logic_vector(7 downto 0);
        pixel7 : in std_logic_vector(7 downto 0);
        pixel8 : in std_logic_vector(7 downto 0);
        pixel_out : out std_logic_vector(7 downto 0);
        output_valid : out std_logic
    );
    end component;
    
    signal enable : std_logic;
    signal clk : std_logic := '1';
    signal reset : std_logic;
    signal pixel0 : std_logic_vector(7 downto 0);
    signal pixel1 : std_logic_vector(7 downto 0);
    signal pixel2 : std_logic_vector(7 downto 0);
    signal pixel3 : std_logic_vector(7 downto 0);
    signal pixel4 : std_logic_vector(7 downto 0);
    signal pixel5 : std_logic_vector(7 downto 0);
    signal pixel6 : std_logic_vector(7 downto 0);
    signal pixel7 : std_logic_vector(7 downto 0);
    signal pixel8 : std_logic_vector(7 downto 0);
    signal pixel_out : std_logic_vector(7 downto 0);
    signal output_valid : std_logic;
    
begin
    
    DUT: odd_even_merge
        port map(
            clk => clk,
            reset => reset,
            enable => enable,
            pixel0 => pixel0,
            pixel1 => pixel1,
            pixel2 => pixel2,
            pixel3 => pixel3,
            pixel4 => pixel4,
            pixel5 => pixel5,
            pixel6 => pixel6,
            pixel7 => pixel7,
            pixel8 => pixel8,
            pixel_out => pixel_out,
            output_valid => output_valid
        );
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process is
    begin
        reset <= '1';
        enable <= '0';
        pixel0 <= "00000001"; --1
        pixel1 <= "00000000"; --0
        pixel2 <= "00000101"; --5
        pixel3 <= "00001000"; --8
        pixel4 <= "00000010"; --2
        pixel5 <= "00000111"; --7
        pixel6 <= "00000011"; --3
        pixel7 <= "00000100"; --4
        pixel8 <= "00000110"; --6
        wait for 7*C_CLK_PERIOD;
        reset <= '0';
        wait for 7*C_CLK_PERIOD;
        enable <= '1';
        wait;
    end process STIMULUS;

end Behavioral;

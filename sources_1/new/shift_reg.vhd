library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity shift_reg is
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
        reg_full : out std_logic; 
        data_valid: out std_logic;
        pixel0 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel1 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel2 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel3 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel4 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel5 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel6 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel7 : out std_logic_vector(GDATAWIDTH - 1 downto 0);
        pixel8 : out std_logic_vector(GDATAWIDTH - 1 downto 0)
    );
end shift_reg;

architecture Behavioral of shift_reg is
    type niz is array (0 to GREGDEPTH - 1) of std_logic_vector(GDATAWIDTH - 1 downto 0);
    signal shift_reg : niz := (others => (others => '0'));
    signal brojac : integer := 0;
    signal br : integer := 0;
    signal brojac_stop : std_logic;
begin
    P_SHIFT_REG: process(reset, clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                shift_reg <= (others => (others => '0'));               
                data_out <= (others => '0');
                reg_full <= '0';
                pixel0 <= (others => '0');
                pixel1 <= (others => '0');
                pixel2 <= (others => '0');
                pixel3 <= (others => '0');
                pixel4 <= (others => '0');
                pixel5 <= (others => '0');
                pixel6 <= (others => '0');
                pixel7 <= (others => '0');
                pixel8 <= (others => '0');             
            else
                pixel0 <= shift_reg(0);
                pixel1 <= shift_reg(1);
                pixel2 <= shift_reg(2);
                pixel3 <= shift_reg(256);
                pixel4 <= shift_reg(257);
                pixel5 <= shift_reg(258);
                pixel6 <= shift_reg(512);
                pixel7 <= shift_reg(513);
                pixel8 <= shift_reg(514);
                if enable = '1' then
                    for i in GREGDEPTH - 1 downto 1 loop
                        shift_reg(i) <= shift_reg(i-1);
                    end loop;
                    shift_reg(0) <= data_in;
                end if;
                if brojac = GREGDEPTH-1 then
                    reg_full <= '1';
                else
                    reg_full <= '0';
                end if;
                
                data_out <= shift_reg(GREGDEPTH - 1);        
            end if;
        end if;
    end process P_SHIFT_REG;
    
    P_BROJAC: process(reset, clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                brojac <= 0;                
            else
                if enable = '1' then
                    if brojac = GREGDEPTH-1 then
                        brojac <= GREGDEPTH-1; 
                    else
                        brojac <= brojac + 1;
                    end if;
                end if;
                
            end if;
        end if;
    end process P_BROJAC;
    
    P_FULL: process(reset, clk) is 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_valid <= '0';            
            else
                if brojac = GREGDEPTH-1 then
                    if br > 0 then
                        br <= 1;
                        data_valid <= '1';
                    else
                        br <= br + 1;
                        data_valid <= '0';
                    end if;
                else
                    br <= 0;
                end if;
            end if;
        end if;
    end process P_FULL;
    
end Behavioral;

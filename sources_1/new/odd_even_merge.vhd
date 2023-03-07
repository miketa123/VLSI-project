library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity odd_even_merge is
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
end odd_even_merge;

architecture Behavioral of odd_even_merge is
    
    signal reg0 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg1 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg2 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg3 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg4 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg5 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg6 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg7 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg8 : std_logic_vector(7 downto 0) := (others => '0');
    signal output_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal output_valid_reg : std_logic := '0';
    
    signal min : std_logic_vector(7 downto 0) := (others => '0');
    signal max : std_logic_vector(7 downto 0) := (others => '0');
    type state is (idle, sort0, sort1, sort2, sort3, sort4, sort5, sort6, sort7, sort8, output);
    signal current_state : state;
    signal next_state : state;
    signal sort_finish : std_logic := '0';
    
begin
    
    STATE_TRANSITION: process (clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= idle;
            else
                current_state <= next_state;
            end if;
        end if;
    end process STATE_TRANSITION; 
    
    SORTING: process(reset, clk)
    variable pomocna : std_logic_vector(7 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            if reset = '1' then
                next_state <= idle;
                reg0 <= (others => '0');
                reg1 <= (others => '0');
                reg2 <= (others => '0');
                reg3 <= (others => '0');
                reg4 <= (others => '0');
                reg5 <= (others => '0');
                reg6 <= (others => '0');
                reg7 <= (others => '0');
                reg8 <= (others => '0');
                pomocna := (others => '0');
                pixel_out <= (others =>'0');
                output_valid <= '0';
            else
                if current_state = idle then
                    if enable = '1' then
                        next_state <= sort0;
                    else
                        next_state <= idle;
                    end if;
                    reg0 <= pixel0;
                    reg1 <= pixel1;
                    reg2 <= pixel2;
                    reg3 <= pixel3;
                    reg4 <= pixel4;
                    reg5 <= pixel5;
                    reg6 <= pixel6;
                    reg7 <= pixel7;
                    reg8 <= pixel8;
                    pomocna := (others => '0');
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                end if;
                
                if current_state = sort0 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg0) > unsigned(reg1) then
                        pomocna := reg0;
                        reg0 <= reg1; 
                        reg1 <= pomocna;
                    end if;
                    if unsigned(reg2) > unsigned(reg3) then
                        pomocna := reg2;
                        reg2 <= reg3; 
                        reg3 <= pomocna;
                    end if;
                    if unsigned(reg4) > unsigned(reg5) then
                        pomocna := reg4;
                        reg4 <= reg5; 
                        reg5 <= pomocna;
                    end if;
                    if unsigned(reg6) > unsigned(reg7) then
                        pomocna := reg6;
                        reg6 <= reg7; 
                        reg7 <= pomocna;
                    end if;
                    next_state <= sort1;                    
                end if;
                
                if current_state = sort1 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg0) > unsigned(reg2) then
                        pomocna := reg0;
                        reg0 <= reg2; 
                        reg2 <= pomocna;
                    end if;
                    if unsigned(reg1) > unsigned(reg3) then
                        pomocna := reg1;
                        reg1 <= reg3; 
                        reg3 <= pomocna;
                    end if;
                    if unsigned(reg4) > unsigned(reg6) then
                        pomocna := reg4;
                        reg4 <= reg6; 
                        reg6 <= pomocna;
                    end if;
                    if unsigned(reg5) > unsigned(reg7) then
                        pomocna := reg5;
                        reg5 <= reg7; 
                        reg7 <= pomocna;
                    end if;
                    next_state <= sort2;
                end if;
                
                if current_state = sort2 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    
                    if unsigned(reg1) > unsigned(reg2) then
                        pomocna := reg1;
                        reg1 <= reg2; 
                        reg2 <= pomocna;
                    end if;
                    if unsigned(reg5) > unsigned(reg6) then
                        pomocna := reg5;
                        reg5 <= reg6; 
                        reg6 <= pomocna;
                    end if;
                    next_state <= sort3;
                end if;
                
                if current_state = sort3 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg0) > unsigned(reg4) then
                        pomocna := reg0;
                        reg0 <= reg4; 
                        reg4 <= pomocna;
                    end if;
                    if unsigned(reg1) > unsigned(reg5) then
                        pomocna := reg1;
                        reg1 <= reg5; 
                        reg5 <= pomocna;
                    end if;
                    if unsigned(reg2) > unsigned(reg6) then
                        pomocna := reg2;
                        reg2 <= reg6; 
                        reg6 <= pomocna;
                    end if;
                    if unsigned(reg3) > unsigned(reg7) then
                        pomocna := reg3;
                        reg3 <= reg7; 
                        reg7 <= pomocna;
                    end if;
                    next_state <= sort4;
                end if;
                
                if current_state = sort4 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg2) > unsigned(reg4) then
                        pomocna := reg2;
                        reg2 <= reg4; 
                        reg4 <= pomocna;
                    end if;
                    if unsigned(reg3) > unsigned(reg5) then
                        pomocna := reg3;
                        reg3 <= reg5; 
                        reg5 <= pomocna;
                    end if;
                    next_state <= sort5;
                end if;
                
                if current_state = sort5 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg1) > unsigned(reg2) then
                        pomocna := reg1;
                        reg1 <= reg2; 
                        reg2 <= pomocna;
                    end if;
                    if unsigned(reg3) > unsigned(reg4) then
                        pomocna := reg3;
                        reg3 <= reg4; 
                        reg4 <= pomocna;
                    end if;
                    if unsigned(reg5) > unsigned(reg6) then
                        pomocna := reg5;
                        reg5 <= reg6; 
                        reg6 <= pomocna;
                    end if;
                    if unsigned(reg0) > unsigned(reg8) then
                        pomocna := reg0;
                        reg0 <= reg8; 
                        reg8 <= pomocna;
                    end if;
                    next_state <= sort6;
                end if;
                
                if current_state = sort6 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg4) > unsigned(reg8) then
                        pomocna := reg4;
                        reg4 <= reg8; 
                        reg8 <= pomocna;
                    end if;
                    next_state <= sort7;
                end if;
                
                if current_state = sort7 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg2) > unsigned(reg4) then
                        pomocna := reg2;
                        reg2 <= reg4; 
                        reg4 <= pomocna;
                    end if;
                    if unsigned(reg3) > unsigned(reg5) then
                        pomocna := reg3;
                        reg3 <= reg5; 
                        reg5 <= pomocna;
                    end if;
                    next_state <= sort8;
                end if;
                
                if current_state = sort8 then
                    pixel_out <= (others =>'0');
                    output_valid <= '0';
                    if unsigned(reg3) > unsigned(reg4) then
                        pomocna := reg3;
                        reg3 <= reg4; 
                        reg4 <= pomocna;
                    end if;
                    next_state <= output;
                end if;
                
                if current_state = output then
                    pixel_out <= reg4;
                    output_valid <= '1';
                    next_state <= idle;
                end if;
                
            end if; 
        end if;
    end process SORTING;
    
    
    
    
    
   

end Behavioral;

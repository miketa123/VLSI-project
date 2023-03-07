library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity my_falling_edge is
    port ( 
        clk : in std_logic;
        reset : in std_logic;
        in_signal : in std_logic;
        edge : out std_logic
    );
end my_falling_edge;

architecture Behavioral of my_falling_edge is
    type State_t is (stIdle, stEdge, stWait, stFEdge);
    signal state_reg, next_state : State_t;
begin
    
    STATE_TRANSITION: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= stIdle;
            else
                state_reg <= next_state;            
            end if;
        end if;
    end process STATE_TRANSITION;
    
    NEXT_STATE_LOGIC: process (in_signal, state_reg) is
    begin
        case state_reg is
            when stIdle =>
                if in_signal = '0' then
                    next_state <= stIdle;
                else
                    next_state <= stEdge;
                end if;
            when stEdge =>
                if in_signal = '0' then
                    next_state <= stIdle;
                else
                    next_state <= stWait;
                end if;            
            when stWait =>
                if in_signal = '0' then
                    next_state <= stFEdge;
                else
                    next_state <= stWait;
                end if;
            when stFEdge => 
                next_state <= stIdle;
        end case;
    end process NEXT_STATE_LOGIC;
    
    OUTPUT_LOGIC: process (state_reg) is
    begin
        if state_reg = stFEdge then
            edge <= '1';
        else
            edge <= '0';
        end if;
    end process OUTPUT_LOGIC;
    
end Behavioral;

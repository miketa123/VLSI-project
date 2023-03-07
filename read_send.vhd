library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.RAM_definitions_PK.all;
    
entity read_send is
    generic (
        G_DATAWIDTH : natural := 8;
        G_DATADEPTH : natural := 256*256;
        CLK_FR : integer := 175;
        SER_FR	: integer := 115200
    );
    port (
        clk_in : in  std_logic;
        reset: in std_logic;
        button: in std_logic;
        dataout: out std_logic
     );
end read_send;


architecture Behavioral of read_send is
    signal addr_wr : std_logic_vector(clogb2(G_DATADEPTH)-1 downto 0);
    signal addr_rd : std_logic_vector(clogb2(G_DATADEPTH)-1 downto 0);
    signal d : std_logic_vector(G_DATAWIDTH-1 downto 0) := (others => '0');
    signal dvalid : std_logic := '1';
    signal busy : std_logic := '1';
    signal dataram : std_logic_vector(G_DATAWIDTH-1 downto 0) := (others=> '0');
    signal readen: std_logic;
    signal press : std_logic;
    signal counter : integer;
    constant MAX_ADDR : integer := 256*256-1; 
    --constant MAX_ADDR : integer := 563;-- za simulaciju
    constant MIN_ADDR : integer := 256*256-16; -- za simulaciju
    signal btn : std_logic;
    signal txout : std_logic := '0';
    type state is (idle, start, median, write, readreg, addrreset, read, incaddress ,send);
    signal current_state : state;
    signal next_state : state;
    signal cnt	:	integer range 0 to 1084;
    signal pomoc : std_logic;
    signal tx_clk_en : std_logic;
    signal brojac : integer;
    signal kraj : std_logic;
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
    signal shift_reg_input : std_logic_vector(7 downto 0);
    signal shift_reg_enable : std_logic;
    signal shift_reg_full : std_logic;
    signal shift_reg_valid : std_logic;
    signal write_en : std_logic;
    signal enable_sort : std_logic;
    
    component clk_wiz_0
    port
    (
        clk_out          : out    std_logic;
        reset            : in     std_logic;
        clk_in           : in     std_logic
    );
    end component;
    signal clk : std_logic;    
    
begin
   
   CLK_GEN : clk_wiz_0
       port map ( 
       clk_out => clk,               
       reset => reset,
       clk_in => clk_in
     );
    
    ----------------------------------------------------------------------

    RAM: entity work.im_ram(Behavioral)
        generic map(
            G_RAM_WIDTH => G_DATAWIDTH,
            G_RAM_DEPTH => G_DATADEPTH,
            G_RAM_PERFORMANCE => "LOW_LATENCY"
        )
        port map (
            addra => addr_wr,
            addrb => addr_rd,
            dina  => pixel_out,
            clka  => clk,
            wea   => write_en,
            enb   => readen,
            rstb  => reset,
            regceb=> '0',
            doutb => dataram
        );
        
    ----------------------------------------------------------------------
    
    UART: entity work.uart_tx(Behavioral)
        generic map (
            CLK_FREQ => CLK_FR,
            SER_FREQ => SER_FR
        )
        port map(
            clk => clk,
            rst => reset,
            par_en => '0',
            tx_dvalid => dvalid,
            tx_data => dataram,--regdata,
            tx => txout,
            tx_busy => busy   
        );
    
    ----------------------------------------------------------------------
    
    EDGE: entity work.edge_detector(Behavioral)
        port map(
            clk => clk,
            reset => reset,
            in_signal => button,
            edge => btn
        );
    
    ----------------------------------------------------------------------
    
    ODD_EVEN: entity work.odd_even_merge(Behavioral)
        port map(
            clk => clk,
            reset => reset, 
            enable => enable_sort,
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
    
    ----------------------------------------------------------------------
    
    SHIFT: entity work.shift_reg(Behavioral)
        port map(
            clk => clk,
            reset => reset,
            enable => shift_reg_enable,
            data_in => dataram, --shift_reg_input,
            data_out => open,
            data_valid => shift_reg_valid,
            reg_full => shift_reg_full,
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
    
    ----------------------------------------------------------------------
    
    STATE_TRANSITION:process (clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= idle;
            else
                current_state <= next_state;
            end if;
        end if;
    end process STATE_TRANSITION; 
    
    ----------------------------------------------------------------------
    
    NEXT_STATE_LOGIC: process (current_state, reset, press, busy, addr_rd, counter, shift_reg_full, shift_reg_valid, addr_wr, txout, output_valid)
    begin
        dataout <= txout;
        if reset = '1' then
            enable_sort <= '0';
            readen <= '0';
            dvalid <= '0';
            write_en <= '0';
            next_state <= idle;
            shift_reg_enable <= '0';
        else
            case current_state is 
                when idle =>
                    enable_sort <= '0';
                    readen <= '0';
                    dvalid <= '0';
                    shift_reg_enable <= '0';
                    write_en <= '0';
                    --shift_reg_input <= (others => '0');
                    if press = '1' then
                        next_state <= start;
                    else
                        next_state <= idle;
                    end if;
                
                when start =>
                    readen <= '1';
                    enable_sort <= '0';
                    dvalid <= '0';
                    write_en <= '0';
                    shift_reg_enable <= '1';
                    --shift_reg_input <= dataram;
                    if shift_reg_full = '0' then
                        next_state <= start;
                    else
                        next_state <= median;
                    end if;
                    
                when median => 
                    readen<= '0';
                    enable_sort <= '1';
                    dvalid <= '0';
                    shift_reg_enable <= '0';
                    write_en <= '0';
                    if output_valid = '1' then
                        next_state <= write;
                    else
                        next_state <= median;
                    end if;
                
                when write =>
                    readen<= '0';
                    dvalid <= '0';
                    shift_reg_enable <= '0';
                    enable_sort <= '0';
                    
                    if shift_reg_valid = '1' then
                        write_en <= '1'; 
                        if addr_rd = std_logic_vector(to_unsigned(MIN_ADDR, addr_rd'length)) then
                            next_state <= addrreset;
                        else
                            next_state <= readreg;
                        end if;
                    else
                        write_en <= '0';
                        next_state <= write;
                    end if;
                
                when readreg =>
                    enable_sort <= '0';
                    readen<= '1';
                    dvalid <= '0';
                    write_en <= '0';
                    shift_reg_enable <= '1';
                    next_state <= median;
                
                when addrreset => 
                    enable_sort <= '0';
                    dvalid <= '0';
                    write_en <= '0';
                    shift_reg_enable <= '0';
                    readen<= '0';
                    next_state <= read;
                    
                when read => 
                    enable_sort <= '0';
                    readen <= '1';
                    next_state <= send;
                    dvalid <= '0';
                    shift_reg_enable <= '0';
                    write_en <= '0';
                    
                when send => 
                    enable_sort <= '0';
                    readen <= '0';
                    dvalid <= '1';
                    shift_reg_enable <= '0';
                    write_en <= '0';
                    
                    if busy = '0' and counter > 2*(CLK_FR*1_000_000)/SER_FR-1 then
                        if addr_rd = std_logic_vector(to_unsigned(MAX_ADDR, addr_rd'length)) then
                            next_state <= idle;
                        else
                        next_state <= incaddress;
                        end if;
                    else
                        next_state <= send;
                    end if;
                    
                when incaddress =>
                    enable_sort <= '0';
                    readen <= '0';
                    next_state <= read;
                    dvalid <= '0';
                    shift_reg_enable <= '0';
                    write_en <= '0';
                    
                       
            end case;
            
        end if;
    end process NEXT_STATE_LOGIC;
    
    ----------------------------------------------------------------------
    
    ADDRES_REG: process(clk, reset) is
    begin
        
               
        if rising_edge(clk) then
            if reset = '1' then --or current_state = idle then
                pomoc <= '0';
                addr_rd <= (others => '0');
                addr_wr <= (others => '0');
                --addr_rd <= std_logic_vector(to_unsigned(MIN_ADDR, addr_rd'length)); 
            else 
                
                if current_state = start then
                    pomoc <= '0';
                    addr_rd <= std_logic_vector(unsigned(addr_rd) + 1);
                    addr_wr <= std_logic_vector(to_unsigned(257, addr_wr'length));
                end if;
                if current_state = write then
                    pomoc <= '0';
                    addr_rd <= std_logic_vector(unsigned(addr_rd) + 1);
                end if;
                if current_state = readreg then
                    pomoc <= '0';
                    addr_wr <= std_logic_vector(unsigned(addr_wr) + 1);
                end if;
                if current_state = addrreset then
                    addr_rd <= (others => '0');
                    addr_wr <= (others => '0');
                    pomoc <= '0';
                end if;
                
                if current_state = read then
                    pomoc <= '0';
                end if;
                if current_state = idle then
                    addr_rd <= (others => '0');
                    pomoc <= '0';
                    --addr_rd <= std_logic_vector(to_unsigned(MIN_ADDR, addr_rd'length));
                elsif current_state = incaddress then  --and pomoc = '0' then
                    addr_rd <= std_logic_vector(unsigned(addr_rd) + 1);
                    pomoc <= '1';
                end if;
            end if;
        end if;
    end process ADDRES_REG;
    
    ----------------------------------------------------------------------
    
    PRESS_BUTTON: process (btn, current_state, reset)
    begin
    if reset = '1' then
        press <= '0';
    else
        if btn = '1' and current_state = idle then
            press <= '1';
        else
            press <= '0';
        end if;
    end if;
    end process PRESS_BUTTON;
    
    ----------------------------------------------------------------------
    
    tx_clk_gen:process(clk)
	begin
	   if clk'event and clk = '1' then
			-- Normal Operation
		   if current_state = send then
	           counter <= counter + 1;
	       else
	           counter <= 0;
	       end if;
			if reset = '1' then
				tx_clk_en	<=	'0';
				counter		<=	0;
			end if;
		end if;
	end process;
	
	

end Behavioral;

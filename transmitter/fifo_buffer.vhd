library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic (
        data_w      : integer := 8;
        depth       : integer := 16
    );

    port(
        clk         : in std_logic;
        nReset      : in std_logic;
        write_en    : in std_logic;
        rd_en       : in std_logic;
        data_in     : in std_logic_vector(data_w downto 0);
        data_out    : out std_logic_vector(data_w downto 0);
        empty       : out std_logic;
        full        : out std_logic
    );

end fifo;


architecture fifo_arch of fifo is

    type memory_type is array (0 to depth - 1) of std_logic_vector(data_w downto 0);
    signal mem      : memory_type := (others => (others => '0'));
    signal rd_ptr   : integer range 0 to depth - 1 := 0;
    signal wr_ptr   : integer range 0 to depth - 1 := 0;
    signal count    : integer range 0 to depth := 0;


    begin
        
        if count = 0 then
            empty <= '1';
            else
            empty <= '0';
        end if;

        if count = depth then
            full <= '1';
            else
            full <= '0';
        end if;

        process(clk, nReset)
        begin
            
            if nReset = '0' then
                rd_ptr      <= '0';
                wr_ptr      <= '0';
                count       <= '0';
                data_out    <= (others => '0');
            
            elsif (clk'event and clk = '1') then
                if wr_en = '1' and full = '0' then
                    mem(wr_ptr) <= data_in;
                    wr_ptr <= (wr_ptr + 1) mod depth;
                    count <= count + 1;
                end if;

                if rd_en = '1' and empty = '0' then
                    data_out <= mem(rd_ptr);
                    rd_ptr <= (rd_ptr + 1) mod depth;
                    count <= count - 1;
                end if;
            end if;
        end process;

end fifo_arch;

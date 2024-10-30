library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity usb_uart_tx is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        usb_data    : in std_logic_vector(7 downto 0);
        usb_send    : in std_logic;
        uart_tx     : out std_logic;
        uart_busy   : out std_logic

    );

end usb_uart_tx;

architecture usb_uart_tx_arch of usb_uart_tx is
    signal fifo_data_out    : std_logic_vector(7 downto 0);
    signal fifo_empty       : std_logic;
    signal fifo_full        : std_logic;
    signal fifo_rd_en       : std_logic;


    component fifo is
        generic(
            data_w : integer := 8;
            data_d : integer := 16
        );

        port(
            clk         : in std_logic;
            nReset      : in std_logic;
            wr_en       : in std_logic;
            rd_en       : in std_logic;
            data_in     : in std_logic_vector(7 downto 0);
            data_out    : out std_logic_vector(7 downto 0);
            empty       : out std_logic;
            full        : out std_logic;
        )
    end component;

    component uart_tx is 
        generic(
            clk_frq         : integer := 50000000;
            baud_rt         : integer := 115200
        );

        port(
            clk         : in std_logic;
            nReset      : in std_logic;
            datain      : in std_logic_vector(7 downto 0);
            send        : in std_logic;
            tx          : out std_logic;
            busy        : out std_logic
        );
    end component;


    fifo_instantiate : fifo

    generic map (
        data_w => 8;
        data_d => 16
    );

    port map (
        clk         => clk,
        nReset      => nReset,
        wr_en       => usb_send,
        rd_en       => fifo_rd_en,
        data_in     => usb_data,
        data_out    => fifo_data_out;
        empty       => fifo_empty;
        full        => fifo_full
    );

uart_tx_instantiate : uart_tx
        generic(
            clk_frq => 50000000;
            baud_rt => 115200
        );

        port map(
            clk => clk,
            rst => rst,
            datain => fifo_data_out,
            send_data => fifo_rd_en,
            tx => uart_tx,
            busy => uart_busy
        );


end usb_uart_tx_arch;
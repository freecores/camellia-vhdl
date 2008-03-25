
--------------------------------------------------------------------------------
-- Designer:      Paolo Fulgoni <pfulgoni@opencores.org>
--
-- Create Date:   02/19/2008
-- Last Update:   03/06/2008
-- Project Name:  camellia-vhdl
-- Description:   VHDL Test Bench for module camellia
--
-- Copyright (C) 2008  Paolo Fulgoni
-- This file is part of camellia-vhdl.
-- camellia-vhdl is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
-- camellia-vhdl is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- The Camellia cipher algorithm is 128 bit cipher developed by NTT and
-- Mitsubishi Electric researchers.
-- http://info.isl.ntt.co.jp/crypt/eng/camellia/
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity camellia_tb is

end camellia_tb;

architecture RTL of camellia_tb is

    component camellia is
        port    (
                clk        : in  STD_LOGIC;
                reset      : in  STD_LOGIC;
                data_in    : in  STD_LOGIC_VECTOR (0 to 127);
                key        : in  STD_LOGIC_VECTOR (0 to 255);
                k_len      : in  STD_LOGIC_VECTOR (0 to 1);
                new_key    : in  STD_LOGIC;
                enc_dec    : in  STD_LOGIC;
                input_rdy  : in  STD_LOGIC;
                data_out   : out STD_LOGIC_VECTOR (0 to 127)
                );
    end component;

    signal    clk        :  STD_LOGIC;
    signal    reset      :  STD_LOGIC;
    signal    data_in    :  STD_LOGIC_VECTOR (0 to 127);
    signal    key        :  STD_LOGIC_VECTOR (0 to 255);
    signal    k_len      :  STD_LOGIC_VECTOR (0 to 1);
    signal    new_key    :  STD_LOGIC;
    signal    enc_dec    :  STD_LOGIC;
    signal    input_rdy  :  STD_LOGIC;
    signal    data_out   :  STD_LOGIC_VECTOR (0 to 127);

    -- constants
    constant KLEN_128    : STD_LOGIC_VECTOR (0 to 1) := "00";
    constant KLEN_192    : STD_LOGIC_VECTOR (0 to 1) := "01";
    constant KLEN_256    : STD_LOGIC_VECTOR (0 to 1) := "10";
    constant ENC         : STD_LOGIC := '0';
    constant DEC         : STD_LOGIC := '1';
    constant CLK_PERIOD  : TIME := 20 ns;

begin

    uut   : camellia
        port map(clk, reset, data_in, key, k_len, new_key,
                 enc_dec, input_rdy, data_out);

    tb    : process
    begin
        reset <= '1';
        wait for 15 ns;
        reset <= '0';
        data_in   <= X"0123456789abcdeffedcba9876543210";
        key       <= X"0123456789abcdeffedcba987654321000112233445566778899aabbccddeeff";
        k_len     <= KLEN_128;
        new_key   <= '1';
        enc_dec   <= '0';
        input_rdy <= '1';
        wait for 494 ns;
        data_in   <= X"67673138549669730857065648eabe43";
        key       <= X"0123456789abcdeffedcba987654321000112233445566778899aabbccddeeff";
        k_len     <= KLEN_128;
        new_key   <= '0';
        enc_dec   <= '1';
        input_rdy <= '1';
        wait;
    end process;

    clk_gen  : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

end RTL;

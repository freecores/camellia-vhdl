
--------------------------------------------------------------------------------
-- Designer:      Paolo Fulgoni <pfulgoni@opencores.org>
--
-- Create Date:   09/14/2007
-- Last Update:   04/09/2008
-- Project Name:  camellia-vhdl
-- Description:   VHDL Test Bench for module CAMELLIA128
--
-- Copyright (C) 2007  Paolo Fulgoni
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

entity camellia128_tb is
end camellia128_tb;

ARCHITECTURE behavior of camellia128_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component CAMELLIA128 is
        port(
                reset      : in  STD_LOGIC;
                clk        : in  STD_LOGIC;
                input      : in  STD_LOGIC_VECTOR (0 to 127);
                input_en   : in  STD_LOGIC;
                key        : in  STD_LOGIC_VECTOR (0 to 127);
                enc_dec    : in  STD_LOGIC;
                output     : out STD_LOGIC_VECTOR (0 to 127);
                output_rdy : out STD_LOGIC
                );
    end component;

    --Inputs
    signal reset    : STD_LOGIC;
    signal clk      : STD_LOGIC;
    signal input    : STD_LOGIC_VECTOR(0 to 127) := (others=>'0');
    signal input_en : STD_LOGIC := '0';
    signal key      : STD_LOGIC_VECTOR(0 to 127) := (others=>'0');
    signal enc_dec  : STD_LOGIC;

    --Output
    signal output     : STD_LOGIC_VECTOR(0 to 127);
    signal output_rdy : STD_LOGIC;

    -- Time constants
    constant ClockPeriod : TIME := 5 ns;


begin

    -- Instantiate the Unit Under Test (UUT)
    uut: CAMELLIA128
    port map(
        reset      => reset,
        clk        => clk,
        input      => input,
        input_en   => input_en,
        key        => key,
        enc_dec    => enc_dec,
        output     => output,
        output_rdy => output_rdy
    );

    ck  : process
    begin
        clk <= '0';
        wait for ClockPeriod / 2;
        clk <= '1';
        wait for ClockPeriod / 2;
    end process;

    process
    begin
        reset <= '1';
        wait for ClockPeriod*2; --falling clock edge
        reset <= '0';
        wait until clk = '1';
        input     <= X"0123456789ABCDEFFEDCBA9876543210";
        key       <= X"0123456789ABCDEFFEDCBA9876543210";
        enc_dec   <= '0';
        input_en  <= '1';
        wait until clk = '1';
        input     <= X"17E02528D6655CEA7BE6B8548FC2DA65";
        key       <= X"FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE";
        enc_dec   <= '1';
        wait until clk = '1';
        input     <= X"67673138549669730857065648EABE43";
        key       <= X"0123456789ABCDEFFEDCBA9876543210";
        enc_dec   <= '1';
        wait until clk = '1';
        input_en  <= '0'; 
        wait;
    end process;

end;

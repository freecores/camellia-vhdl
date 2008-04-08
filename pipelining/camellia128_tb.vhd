
--------------------------------------------------------------------------------
-- Designer:      Paolo Fulgoni <pfulgoni@opencores.org>
--
-- Create Date:   09/14/2007
-- Last Update:   01/16/2008
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
                reset : in STD_LOGIC;
                clk   : in STD_LOGIC;
                m     : in STD_LOGIC_VECTOR (0 to 127);
                k     : in STD_LOGIC_VECTOR (0 to 127);
                dec   : in STD_LOGIC;
                c     : out STD_LOGIC_VECTOR (0 to 127)
                );
    end component;

    --Inputs
    signal reset : STD_LOGIC;
    signal clk   : STD_LOGIC;
    signal m     : STD_LOGIC_VECTOR(0 to 127) := (others=>'0');
    signal k     : STD_LOGIC_VECTOR(0 to 127) := (others=>'0');
    signal dec   : STD_LOGIC;

    --Output
    signal c     : STD_LOGIC_VECTOR(0 to 127);

    -- Time constants
    constant ClockPeriod : TIME := 5 ns;

    -- Misc
    signal clk_count : INTEGER range 0 to 30;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: CAMELLIA128
    port map(
        reset => reset,
        clk   => clk,
        m     => m,
        k     => k,
        dec   => dec,
        c     => c
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
        clk_count <= 0;
        wait for ClockPeriod*2; --falling clock edge
        reset <= '0';
        wait until clk = '1';
        m     <= X"0123456789ABCDEFFEDCBA9876543210";
        k     <= X"0123456789ABCDEFFEDCBA9876543210";
        dec   <= '0';
        wait until clk = '1';
        m     <= X"17E02528D6655CEA7BE6B8548FC2DA65";
        k     <= X"FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE";
        dec   <= '1';
        clk_count <= clk_count + 1;
        wait until clk = '1';
        m     <= X"67673138549669730857065648EABE43";
        k     <= X"0123456789ABCDEFFEDCBA9876543210";
        dec   <= '1';
        clk_count <= clk_count + 1;
        for I in 0 to 26 loop
            wait until clk = '1';
            clk_count <= clk_count + 1;
        end loop;
        
        wait;
    end process;

end;

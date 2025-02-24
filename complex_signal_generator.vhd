library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity complex_signal_generator is
    generic (
        FFT_Size : integer := 1024;
        FUNC_TYPE : integer := 0  -- 0: exp(j*theta), 1: sinc, 2: rectangular
    );
    port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        real_out     : out STD_LOGIC_VECTOR(15 downto 0);
        imagery_out  : out STD_LOGIC_VECTOR(15 downto 0);
        tvalid       : out STD_LOGIC;
        tlast        : out STD_LOGIC
    );
end entity complex_signal_generator;

architecture Behavioral of complex_signal_generator is
    type LUT_TYPE is array (0 to FFT_Size-1) of integer range -32768 to 32767;
    signal cos_LUT, sin_LUT, sinc_LUT, rect_LUT : LUT_TYPE;
    signal theta_index      : integer range 0 to FFT_Size-1 := 0;
    signal real_temp, imag_temp : integer range -32768 to 32767;

begin
    -- Generate LUT values at elaboration time
    process
        variable angle : real;
        variable center : integer := FFT_Size / 2;
    begin
        for i in 0 to FFT_Size-1 loop
            angle := (8*2.0 * MATH_PI * real(i)) / real(FFT_Size);
            cos_LUT(i) <= integer(round(32767.0 * cos(angle)));
            sin_LUT(i) <= integer(round(32767.0 * sin(angle)));
            
            if i = 0 then
                sinc_LUT(i) <= 0;
            else
                sinc_LUT(i) <= integer(round(32767.0 * sin(angle-4.0*2.0*3.14) / (angle-4.0*2.0*3.14)));
            end if;
            
            if i > (FFT_Size / 2)-3 and  i < (FFT_Size / 2)+3 then
                rect_LUT(i) <= 32767;
            else
                rect_LUT(i) <= 0;
            end if;
        end loop;
        wait;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                theta_index <= 0;
                real_temp <= 0;
                imag_temp <= 0;
                tvalid <= '0';
                tlast <= '0';
            else
                theta_index <= (theta_index + 1) mod FFT_Size;
                tvalid <= '1'; -- Always valid unless reset
                
                if theta_index = FFT_Size - 1 then
                    tlast <= '1'; -- Assert tlast on the last sample
                else
                    tlast <= '0';
                end if;
                
                case FUNC_TYPE is
                    when 0 =>
                        real_temp <= cos_LUT(theta_index);
                        imag_temp <= sin_LUT(theta_index);
                    when 1 =>
                        real_temp <= sinc_LUT(theta_index);
                        imag_temp <= sinc_LUT(theta_index);
                    when 2 =>
                        real_temp <= rect_LUT(theta_index);
                        imag_temp <= rect_LUT(theta_index);
                    when others =>
                        real_temp <= 0;
                        imag_temp <= 0;
                end case;
            end if;
        end if;
    end process;

    real_out <= std_logic_vector(to_signed(real_temp, 16));
    imagery_out <= std_logic_vector(to_signed(imag_temp, 16));

end Behavioral;

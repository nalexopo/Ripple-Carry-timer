module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
	 output[6:0]abcdefg,
	 output en0, en1, en2,en3,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy // AVR Rx buffer full
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;
assign led[6:0]=7'd0;

wire [3:0] cnt0, cnt1, cnt2, cnt3;
wire secpulse,sectenpulse,minpulse,mintenpulse,hourpulse;

/////////////////RIPPLE CARRY TIMER///////////////////////////////////////
secclk secclk(
.clk(clk),
.rst(rst),       //creates  a pulse every second 
.nclk(secpulse)
);

countonine cnt9(
.inpulse(secpulse),    //creates  a pulse every 10 sec gives seconds digit  
.rst(rst),
.cnt(cnt0),
.outpulse(sectenpulse)
);

counton6 cnt6(
.inpulse(sectenpulse),
.rst(rst),          //creates  a pulse every minute gives 10s of seconds digit
.cnt(cnt1),
.outpulse(minpulse)
);

countonine cntmin9(
.inpulse(minpulse),
.rst(rst),				//creates  a pulse every 10 mins  gives minutes digit
.cnt(cnt2),
.outpulse(mintenpulse)
);

counton6 cntmin6(
.inpulse(mintenpulse),  //creates a pulse every Hour gives 10s of minutes digit
.rst(rst),
.cnt(cnt3),
.outpulse(hourpulse)
);

assign led[7]=~secpulse;   //test signal works only for clocks of big periods you can ignore it

top4digit7seg top4(
.clk(clk),
.rst(rst),
.dig0(cnt3),
.dig1(cnt2),
.dig2(cnt1),              //BCD to 4digit7segled
.dig3(cnt0),
.abcdefg(abcdefg),
.en0(en0), 
.en1(en1), 
.en2(en2), 
.en3(en3)
); 





endmodule

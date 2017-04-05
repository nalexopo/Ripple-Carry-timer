module secclk(
input clk,
input rst,
output reg nclk
);

reg [25:0] count_q,count_d;  // implementing d_flip flop as q=output d=input.      

//Feedback operation of flip flop ouput to increment to flip flop input is assumed
always @(count_q) begin
   if (count_q==26'd50_000_000) begin count_d=26'd0; nclk = 1'b1; end // counts up to 50million pulses = 1sec on 50Mhz and creates a pulse of 1 clock period to output
	else begin count_d=count_q + 1'b1; nclk=1'b0; end  // rest of the time counter is incremented by one and ouput
end

always @(posedge clk) begin
	if (rst) count_q<=26'd0;            //rst clears q output of flip flop
	else	count_q<=count_d;             // proper operation is passing flip flop input to flip flop output @ posedge clock
end





endmodule

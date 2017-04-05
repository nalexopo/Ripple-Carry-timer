module countonine (
input inpulse,
input rst,
output [3:0]cnt,
output reg outpulse
    );

reg [3:0]count_q, count_d;
assign cnt=count_q; //output to BCD digit

//Feedback operation of flip flop ouput to increment to flip flop input is assumed
always @(count_q) begin
if (count_q == 4'd9) begin count_d=4'd0; outpulse=1'b0; end //this counts to nine, zeroes input of register and drops a zero pulse out until the next posedge of input pulse
else begin count_d=count_q + 1'b1; outpulse=1'b1; end //this is normal operation ouput is inactive and constant at 1, while register input is incremented
end

always @(posedge inpulse) begin
	if (rst) count_q<=4'b0; //rst condition count_q is cleared
	else	count_q<=count_d; //usual operation of register input passes to ouput @posedge of 1sec pulse
end


endmodule

module counton6(
input inpulse,
input rst,
output [3:0]cnt,
output reg outpulse
    );
//THIS IS SIMILAR TO counton9 just counts up to 6 and inputs a 1-->0 pulse
reg [3:0]count_q, count_d;
assign cnt=count_q;


always @(count_q) begin
if (count_q == 4'd5) begin count_d=4'd0; outpulse=1'b0; end
else begin count_d=count_q + 1'b1; outpulse=1'b1; end 
end

always @(posedge inpulse) begin
	if (rst) count_q<=4'b0;
	else	count_q<=count_d;
end

endmodule

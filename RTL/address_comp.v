module address_comp (SCL, RST, slave_addr, address_match, data_out);
	parameter WIDTH = 7;
	input [WIDTH-1:0] slave_addr;
	input [7:0] data_out;
	input SCL, RST;
	output reg address_match;

	always @(posedge SCL) begin
		if (!RST)
		address_match <= 0;
		else if ( data_out[WIDTH:1] == slave_addr) begin 
			address_match <= 1;
		end
	end 
endmodule 


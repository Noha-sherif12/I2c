module slave_to_master(SDA, data_in, SCL, RST, start, stop, ACK, MACK, address_match, RX);
parameter WIDTH = 8;
input  [WIDTH-1:0] data_in;
input SCL, RST,start, address_match, RX, ACK, MACK, stop ;
inout SDA;
reg [WIDTH-1:0] tmp_data;


//shift data 
always @(posedge SCL)
begin
	if(!RST)begin
		tmp_data <= 8'b0;
end
if (start && address_match && RX && ACK)
begin 
	tmp_data <= {tmp_data[6:0], data_in}; //shift in the serial data
end 
	else if (MACK)
begin
	tmp_data <= {tmp_data[6:0], data_in};
end
	else if (!MACK && stop) 
begin
	tmp_data <= 8'b0;
end
end
assign SDA = tmp_data;
endmodule
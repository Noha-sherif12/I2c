module master_to_slave(SCL, SDA, RST, bit_count, data_out, RX); 
input RST, SCL, RX;
input  bit_count;
output [7:0] data_out; //parallel output
inout SDA;
reg [7:0] shift_reg; //8-bit shift register 

always @(posedge SCL)
begin 
if(!RST)
begin 
	shift_reg <= 8'b0;
end
else if (bit_count == 'b1)
begin 
	shift_reg <= {SDA, shift_reg[7:1]}; 
end
end

assign data_out = shift_reg; //assign the output to the shift register 

endmodule 

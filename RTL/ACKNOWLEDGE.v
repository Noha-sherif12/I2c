module ACKNOWLEDGE(SCL, RST, ACK_enable, ACK);
	input SCL, RST, ACK_enable;
	output reg ACK;
	
	
	//slave acknowledge 
	always @(posedge SCL) begin
		if(!RST)  
			ACK <= 0;
			else if (ACK_enable) 
			#2 
				ACK <= 1;
			
		end


endmodule 


				


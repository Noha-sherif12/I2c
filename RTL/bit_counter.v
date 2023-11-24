module bit_counter(SCL, RST, bit_count, bit_count_enable);
input 	SCL, RST, bit_count_enable;
output reg bit_count; 
reg [2:0]  counter = 3'b0;
  



//initail counter 
always @ (posedge SCL)
 begin
  if(!RST)
   begin
    bit_count <= 'b0 ;
   end
  else if(bit_count_enable)
   begin
      counter <= counter + 'b1 ;
	 end	 
  else
   begin
    counter <= 'b0 ;
   end   

 
assign bit_count = (counter == 'b1000) ? 1'b1 : 1'b0 ; 
end
endmodule

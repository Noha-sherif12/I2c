module Read_write (
inout SDA,
input SCL,
input RST, 
output reg RX,
output reg TX
);


always @(posedge SCL)
begin 
if(!RST)
RX <= 0;
TX <= 0;
if(!SDA && SCL) 
RX <= 1;
else if (SDA && SCL)
  TX <= 1;
end 
endmodule

module I2C_slave_TB;



// Inputs
reg SCL;
reg [7:0] data_in;
reg RST;
reg [6:0] slave_addr;
reg data_valid;
reg sda_out;
reg sda_in;

reg TX;
reg ACK_enable;
reg MACK;
reg TX_RX_enable;
reg ACK;
reg TX_valid;
reg address_out;
wire SDA;

// Instantiate the module
I2C_slave dut (SCL, data_in, RST, slave_addr, data_valid, SDA);

// Clock generation
initial begin
  SCL = 0;
  forever
  #1 SCL = ~SCL;
 end



// Reset
initial begin
  RST = 0;
  #5;
  RST = 1;
// check start 
  sda_in = 0;
  #4
  slave_addr = 7'b1011001; //checking the address
  #4
  address_out = 7'b1011001; 
  #2
  //transmit data 
  TX = 1;
  #2
  data_valid = 1; 

  data_in = 8'b01010101; // Send the data 
  
  #10;
  ACK_enable = 1;
  MACK = 0;

  
  #10;

  // Stop condition
  sda_in = 1;
  #10;
  
end

// Receive data 
initial begin

  RST = 0;
  #5;
  RST = 1;
// check start 
  sda_in = 0;
  #4
  address_enable = 1;
  slave_addr = 7'b1011001; //checking the address
  #4
  address_out = 7'b1011001; 
  #2 
  RX = 1;
 
  #50
  sda_in = 1;
  sda_in = 0;
  sda_in = 0;
  sda_in = 1;
  sda_in = 0;
  sda_in = 1;
  sda_in = 0;
  sda_in = 1;
  
  #50;

 //check sda_in
  sda_in = 10101001;
  
 ACK_enable = 1;

 #50 
 $Stop;

  

end

endmodule
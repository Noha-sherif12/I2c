module I2C_slave_TB;



// Inputs
reg SCL;
reg [7:0] data_in;
reg RST;
reg [6:0] slave_addr;
reg data_valid;
reg sda_out;
reg sda_in;
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
end

// Write test
initial begin
  // Address phase
  sda_in = 1;
  data_in = 8'b01010101; // Set slave address to 0xA0
  slave_addr = 7'b1011011; // Write to register at address 0x10
  data_valid = 1;
  #10;

  // Data phase
 sda_in = 0;
  data_in = 8'b11010101; // Write data
  data_valid = 1;
  #10;

  // Stop condition
  sda_in = 0;
  data_valid = 0;
  #10;
  sda_in = 1;
end

// Read test
initial begin
  // Address phase
  sda_in = 1;
  data_in = 8'hA0; // Set slave address to 0xA0
  slave_addr = 7'h20; // Read from register at address 0x20
  data_valid = 1;
  #50;

  // Data phase
  sda_in = 0;
  data_valid = 1;
  #50;
  sda_in = 1;
  data_valid = 1;
  #50;
 sda_out = 0; // Send ACK
  data_valid = 1;
  #50;
  sda_in = 1; // Stop condition
  data_valid = 0;
  #50;
 $Stop;
end

endmodule
module I2C_slave(SCL, data_in, RST, slave_addr, data_valid, SDA);



//interface signals 
input           RST, SCL, data_valid;
input  [7:0]    data_in;
input  [6:0]    slave_addr;
inout           SDA;
wire            sda_out, sda_in, TX_RX_enable, TX, RX, TX_valid, ACK_enable, ACK, MACK, address_enable, address_match, bit_count, bit_count_enable, address_valid, RX_valid, ENABLE;
wire   [6:0]      address_out;
wire   [7:0]      data_out;



FSM dut0 (SCL, RST, ACK_enable, ACK, MACK, TX_valid, SDA, RX, TX, TX_RX_enable, RX_valid, address_valid, bit_count_enable, bit_count, address_enable, address_match, ENABLE);
ACKNOWLEDGE dut1 (SCL, RST, bit_count, bit_count_enable);
Read_write dut2 (SCL, RST, SDA, TX_RX_enable, TX, RX);
slave_to_master dut3 (TX_valid, data_valid, data_in, sda_out, SCL, RST);
bit_counter dut4 (SCL, RST, bit_count, bit_count_enable);
address_comp dut5 (slave_addr, address_out, RST, SCL, address_match, address_enable);
master_to_slave dut6 (SCL, sda_in, RST, RX_valid, address_out, data_out);


//assigning SDA 
assign SDA = (TX == 1)? sda_out : 1'bz ;
assign sda_in = (RX ==1)? SDA : 1'bz ;


endmodule 

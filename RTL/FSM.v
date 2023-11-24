module FSM(sda_in, SCL, RST, bit_count, WAIT, WAIT_T1, WAIT_R1, address_match, address_enable, ACK_enable, bit_count_enable, TX_valid,  RX_valid, ENABLE,  address_valid); 
input SCL, RST, bit_count, WAIT, WAIT_T1, address_match, sda_in;
output reg address_enable, ACK_enable,   WAIT_R1, bit_count_enable, ENABLE, TX_valid,  RX_valid,  address_valid;


reg [2:0] current_state, next_state;

//I2C state machine states
parameter IDLE = 3'b000;
parameter START_STATE = 3'b001;
parameter ADDR_MATCH = 3'b010;
parameter ACK_STATE = 3'b011;
parameter DATA_TX = 3'b100;
parameter DATA_RX = 3'b101;
parameter WAIT_RX = 3'b110;
parameter WAIT_TX = 3'b111;


//state transiton 
always @(posedge SCL)
 begin
  if(!RST)
    current_state <= IDLE ;
  else
    current_state <= next_state ;
   end

 //next state logic
 always @(posedge SCL)
 begin 
 	case(current_state)
 		IDLE : begin 
 			if(!sda_in && SCL)
 				next_state = START_STATE;
 			else 
 				next_state = IDLE;
 		end 
 		START_STATE : begin
 			if(address_match)
 				next_state = ADDR_MATCH;
 			else 
 				next_state = START_STATE;
 		end 
 		ADDR_MATCH : begin 
 			if(sda_in | !sda_in)
 				next_state = ACK_STATE;
 			else 
 				next_state = ADDR_MATCH;
 		end 
 		ACK_STATE : begin 
 			if(sda_in && SCL)
 				next_state = DATA_TX;
 			else if (!sda_in && SCL) 
 				next_state = DATA_RX;
 			else 
 				next_state = IDLE;
 			
 		end 
 		DATA_TX : begin
 			if(WAIT_TX)
 				next_state = WAIT_TX;
 			else if(sda_in)
 				next_state = IDLE;
 		end
 		
 		WAIT_TX : begin 
 		  if (bit_count)
    	next_state = IDLE;
 			else 
 			  next_state = DATA_TX;
 			  end
 		DATA_RX : begin 
 			if(WAIT)
 				next_state = WAIT_RX;
 			else 
 				next_state = IDLE;
 				end 
 				
  WAIT_RX : begin 
  if (bit_count)
    	next_state = ACK_STATE;
 			else 
 				next_state = DATA_RX;
 				end 
    
 		
 		default: begin
			 next_state = IDLE ; 
           end	
  endcase                 	   
 end 

//output logic
always @(current_state)
begin 
         
	case(current_state)
		IDLE : begin
		  address_enable = 1'b0;
		   address_valid = 1'b0;
		   WAIT_R1 = 1'b0;
      ACK_enable = 1'b0;
      bit_count_enable = 1'b0;
      TX_valid = 1'b0;
      RX_valid = 1'b0;
      ENABLE =  1'b0;
    end 
      
	START_STATE : begin 
		  address_enable = 1'b1;
		  address_valid = 1'b1;
		   WAIT_R1 = 1'b0;
          ACK_enable = 1'b0;
          bit_count_enable = 1'b0;
          TX_valid = 1'b0;
          RX_valid = 1'b0;
            ENABLE =  1'b0;

        end 
		
		
	ADDR_MATCH : begin 
		  address_enable = 1'b0;
		  address_valid = 1'b0;
		      WAIT_R1 = 1'b0;
          ACK_enable = 1'b0;
          bit_count_enable = 1'b0;
          TX_valid = 1'b0;
          RX_valid = 1'b0;		
            ENABLE =  1'b0;
      end 
	ACK_STATE : begin 
	
		  address_enable = 1'b0;
		  address_valid = 1'b0;
		 
          ACK_enable = 1'b1;
          bit_count_enable = 1'b0;
          TX_valid = 1'b0;
           WAIT_R1 = 1'b0;
          RX_valid = 1'b0;
            ENABLE =  1'b1;
	
	end 
	DATA_TX : begin 
		  address_enable = 1'b0;
		  address_valid = 1'b0;
		
          ACK_enable = 1'b0;
          bit_count_enable = 1'b1;
          TX_valid = 1'b1;
             WAIT_R1 = 1'b0;
          RX_valid = 1'b0;
            ENABLE =  1'b1;
        end 
      
    DATA_RX :  begin
    	  address_enable = 1'b0;
    	  address_valid = 1'b0;
    	  
          ACK_enable = 1'b0;
          bit_count_enable = 1'b1;
          TX_valid = 1'b0;
          RX_valid = 1'b1;
            ENABLE =  1'b0;
         WAIT_R1 = 1'b1;
     end 
	endcase
end

endmodule


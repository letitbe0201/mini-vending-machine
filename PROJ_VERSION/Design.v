//`timescale 1ms / 1ms
module ee271_final_proj_vendingmachine (clk, cancel, continue_, item_sel, amt_sel, pad_Row, col_seven_1, col_seven_2, col_seven_3, ch_seven_1, ch_seven_2, ch_seven_3, item_LED, amt_LED, pad_Col);


/*
PORTS, REGISTERS AND PARAMETERS
*/
	// CANCEL: Cancel the transaction and return the collected money
	// CONTINUE_: Continue to another purchase
	// COLLECTED: Keep record on collected money
	input			clk, cancel, continue_;
	input	   [4:0]	item_sel;
	input	   [2:0]	amt_sel;
	input	   [3:0]	pad_Row;
	// Display COLLECTED, CHANGE, ITEM, AMOUNT
	output reg [7:0]	col_seven_1;
	output reg [7:0]	col_seven_2;
	output reg [7:0]	col_seven_3;
	output reg [7:0]	ch_seven_1;
	output reg [7:0]	ch_seven_2;
	output reg [7:0]	ch_seven_3;
	output reg [4:0]	item_LED;
	output reg [2:0]	amt_LED;
	output reg [3:0]	pad_Col;

	reg [2:0] COIN;
	reg [2:0] state, next_state;
	// CLOCK for STATE MACHINE
	reg sclk;
	reg	[31:0] count;
	reg	[23:0] count_pad;
	// When 0: Disable inserting coins
	reg	insert_en;
	// Display collected money on Seven segment LED
	reg	col_finish;
	reg	col_rst;
	reg	[31:0] collected;
	reg	[31:0] col_temp;
	reg	[31:0] col_mod;
	// Display change on seven segment LED
	reg	[31:0] change;
	reg	[31:0] ch_temp;
	reg	[31:0] ch_mod;
	// Store value of ITEM and AMOUNT
	reg	[2:0] item;
	reg	[1:0] amt;
	
	// ITEMS
	parameter  [3:0]	A = 4'b0001;
	parameter  [3:0]	B = 4'b0010;
	parameter  [3:0]	C = 4'b0011;
	parameter  [3:0]	D = 4'b0100;
	parameter  [3:0]	E = 4'b0101;
	
	// PRICE of products (cent)
	parameter	price_A = 10'd50;
	parameter	price_B = 10'd80;
	parameter	price_C = 10'd100;
	parameter	price_D = 10'd120;
	parameter	price_E = 10'd150;
	
	// STATES
	parameter  [2:0] S0 = 0;	// IDLE STATE
	parameter  [2:0] S1 = 1;	// A PURCHASE
	parameter  [2:0] S2 = 2;	// B
	parameter  [2:0] S3 = 3;	// C
	parameter  [2:0] S4 = 4;	// D
	parameter  [2:0] S5 = 5;	// E
	parameter  [2:0] S6 = 6;	// RESULTS (including CHANGE)

	
/*
INITIALIZE EVERYTHING
*/
	initial begin
		col_seven_1 = 8'b01000000;  // 0.
		col_seven_2	= 8'b11000000;  // 0
		col_seven_3	= 8'b11000000;  // 0
		ch_seven_1 = 8'b01000000;   // 0.
		ch_seven_2 = 8'b11000000;   // 0
		ch_seven_3 = 8'b11000000;   // 0
		amt_LED	= 3'b001;           // Default amount: 1
		item_LED = 5'b0;
		COIN = 3'b111;
		state = S0;
		sclk = 0;
		count = 0;
		count_pad = 20'b0;
		insert_en = 0;
		col_finish = 0;
		col_rst = 0;
	 	collected = 32'b0;
		col_temp = 0;
		col_mod	= 0;
		change = 32'b0;
		ch_temp	= 0;
		ch_mod = 0;
		item = 3'b0;
		amt	= 2'b01;
	end
	
	
/*
CLOCK AND STATE REGISTER
*/
	// State machine driven by sclk: ''Hz
	always @ (posedge sclk)
	begin
		state <= next_state;
	end
	
	// SLOW CLOCK (sclk) ''Hz created by 50 MHz clock
	always @ (posedge clk)
	begin
		if (count != 32'b00000000001001100010010110100000)
			count = count + 1;
		else
		begin
			count = 32'b0;
			sclk = ~sclk;
		end
	end
	

/*
MONEY CALCULATION
*/
	// Calculating the COLLECTED amount of money
	always @ (posedge clk or posedge col_rst)
	begin
		if (col_rst) collected <= 0;
		else
		begin
			if(insert_en)
			begin
				if (~COIN[0])
					collected <= collected + 10;
				else if(~COIN[1])
					collected <= collected + 25;
				else if (~COIN[2])
					collected <= collected + 100;
			end
		end
	end

	// TASK for Comparing the price to COLLECTED money & CHANGE calculation
	task comp;
	begin
		col_finish = 0;
			case (item)
				A:
				begin
					if (collected >= (price_A*amt))
					begin
						change = collected - (price_A*amt);
						col_finish = 1;
					end
					else
					begin
						change = 0;
						col_finish = 0;
					end
				end
				B:
				begin
					if (collected >= (price_B*amt))
					begin
						change = collected - (price_B*amt);
						col_finish = 1;
					end
					else
					begin
						change = 0;
						col_finish = 0;
					end
				end
				C:
				begin
					if (collected >= (price_C*amt))
					begin
						change = collected - (price_C*amt);
						col_finish = 1;
					end
					else
					begin
						change = 0;
						col_finish = 0;
					end
				end
				D:
				begin
					if (collected >= (price_D*amt))
					begin
						change = collected - (price_D*amt);
						col_finish = 1;
					end
					else
					begin
						change = 0;
						col_finish = 0;
					end
				end
				E:
				begin
					if (collected >= (price_E*amt))
					begin
						change = collected - (price_E*amt);
						col_finish = 1;
					end
					else
					begin
						change = 0;
						col_finish = 0;
					end
				end
				default:
				begin
					col_finish = 0;
				end
			endcase
	end
	endtask
	
	// Output COLLECTED money on seven segment LED
	always @ (collected)
	begin
		col_temp = collected;
		// col_seven_3
		col_mod = col_temp % 10;
		case (col_mod)
			0: col_seven_3 = 8'b11000000;
			1: col_seven_3 = 8'b11111001;
			2: col_seven_3 = 8'b10100100;
			3: col_seven_3 = 8'b10110000;
			4: col_seven_3 = 8'b10011001;
			5: col_seven_3 = 8'b10010010;
			6: col_seven_3 = 8'b10000010;
			7: col_seven_3 = 8'b11111000;
			8: col_seven_3 = 8'b10000000;
			9: col_seven_3 = 8'b10010000;
			default: col_seven_3 = 8'b11000000;
		endcase
		// col_seven_2
		col_temp = col_temp / 10;
		col_mod = col_temp % 10;
		case (col_mod)
			0: col_seven_2 = 8'b11000000;
			1: col_seven_2 = 8'b11111001;
			2: col_seven_2 = 8'b10100100;
			3: col_seven_2 = 8'b10110000;
			4: col_seven_2 = 8'b10011001;
			5: col_seven_2 = 8'b10010010;
			6: col_seven_2 = 8'b10000010;
			7: col_seven_2 = 8'b11111000;
			8: col_seven_2 = 8'b10000000;
			9: col_seven_2 = 8'b10010000;
			default: col_seven_2 = 8'b11000000;
		endcase
		// col_seven_1
		col_temp = col_temp / 10;
		col_mod = col_temp % 10;
		case (col_mod)
			0: col_seven_1 = 8'b01000000;
			1: col_seven_1 = 8'b01111001;
			2: col_seven_1 = 8'b00100100;
			3: col_seven_1 = 8'b00110000;
			4: col_seven_1 = 8'b00011001;
			5: col_seven_1 = 8'b00010010;
			6: col_seven_1 = 8'b00000010;
			7: col_seven_1 = 8'b01111000;
			8: col_seven_1 = 8'b00000000;
			9: col_seven_1 = 8'b00010000;
			default: col_seven_1 = 8'b01000000;
		endcase
	end

	// Output CHANGE on seven segment LED
	always @ (change)
	begin
		ch_temp = change;
		// ch_seven_3
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_3 = 8'b11000000;
			1: ch_seven_3 = 8'b11111001;
			2: ch_seven_3 = 8'b10100100;
			3: ch_seven_3 = 8'b10110000;
			4: ch_seven_3 = 8'b10011001;
			5: ch_seven_3 = 8'b10010010;
			6: ch_seven_3 = 8'b10000010;
			7: ch_seven_3 = 8'b11111000;
			8: ch_seven_3 = 8'b10000000;
			9: ch_seven_3 = 8'b10010000;
			default: ch_seven_3 = 8'b11000000;
		endcase
		// ch_seven_2
		ch_temp = ch_temp / 10;
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_2 = 8'b11000000;
			1: ch_seven_2 = 8'b11111001;
			2: ch_seven_2 = 8'b10100100;
			3: ch_seven_2 = 8'b10110000;
			4: ch_seven_2 = 8'b10011001;
			5: ch_seven_2 = 8'b10010010;
			6: ch_seven_2 = 8'b10000010;
			7: ch_seven_2 = 8'b11111000;
			8: ch_seven_2 = 8'b10000000;
			9: ch_seven_2 = 8'b10010000;
			default: ch_seven_2 = 8'b11000000;
		endcase
		// ch_seven_1
		ch_temp = ch_temp / 10;
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_1 = 8'b01000000;
			1: ch_seven_1 = 8'b01111001;
			2: ch_seven_1 = 8'b00100100;
			3: ch_seven_1 = 8'b00110000;
			4: ch_seven_1 = 8'b00011001;
			5: ch_seven_1 = 8'b00010010;
			6: ch_seven_1 = 8'b00000010;
			7: ch_seven_1 = 8'b01111000;
			8: ch_seven_1 = 8'b00000000;
			9: ch_seven_1 = 8'b00010000;
			default: ch_seven_1 = 8'b01000000;
		endcase
	end
	
	
/*
KEYPAD INTERFACE	
*/
  always @ (posedge clk)
  begin
		COIN <= 3'b111;
		
		// Scanning the keypad COLUMN by COLUMN
	   if (count_pad == 24'b0111001001110000111000000)
		begin
				// Column 1
				pad_Col <= 4'b0111;		
				count_pad <= count_pad + 1'b1;
		end
			
		else if(count_pad == 24'b01110010011100001110000000)
		begin
			// Row 1
			if (pad_Row == 4'b0111)
			begin
				// Assign 1 DOLLAR
				COIN <= 3'b101;
				count_pad <= 24'b0;
			end
			count_pad <= count_pad + 1'b1;
		end

		else if(count_pad == 24'b010101011101010010101000000)
		begin
			// COLUMN 2
			pad_Col<= 4'b1011;
			count_pad <= count_pad + 1'b1;
		end
		else if(count_pad == 24'b011100100111000011100000000)
		begin
			if (pad_Row == 4'b0111)
			begin
				// Assign 1 QUATER
				COIN <= 4'b110;
				count_pad <= 24'b0;
			end
			count_pad <= count_pad + 1'b1;
		end

		else if(count_pad == 24'b0100011110000110100011000000)
		begin
			// COLUMN 3
			pad_Col <= 4'b1101;
			count_pad <= count_pad + 1'b1;
		end
		else if(count_pad == 24'b0101010111010100101010000000)
		begin
			// ROW 1
			if(pad_Row == 4'b0111)
			begin
				// Assign 1 DIME
				COIN <= 3'b011;
				count_pad <= 24'b0;				
			end
			count_pad <= count_pad + 1'b1;
		end

		else
			count_pad <= count_pad + 1'b1;
   end	


/*
ITEM AND AMOUNT DISPLAY
*/
	always @ (item)
	begin
		case(item)
			0:
			begin
				item_LED = 5'b0;
			end
			A: item_LED = 5'b00001;
			B: item_LED = 5'b00010;
			C: item_LED = 5'b00100;
			D: item_LED = 5'b01000;
			E: item_LED = 5'b10000;
			default: item_LED = 5'b0;

		endcase
	end

	always @ (amt)
	begin
		case(amt)
			1: amt_LED = 3'b001;
			2: amt_LED = 3'b010; 
			3: amt_LED = 3'b100;
			default: amt_LED = 3'b001;
		endcase
	end
	

/*
SEVEN-STATES STATE MACHINE
*/
	always @ (*)
	begin		
		// If the CANCEL is pressed during the purchase, return the money
		if (!cancel && (state != S6))
		begin
			insert_en = 0;
			item = 0;
			amt = 1;
			// If the users has already inserted coins, jump to State 6 to return money; otherwise, stay at S0.
			if (collected)
			begin	
				change = collected;
				next_state = S6;
			end
			else
			begin	
				change = 0;
				next_state = S0;
			end
		end
		else
			case (state)
			
				S0:
				begin
					// RESET everything
					col_rst = 1;
					insert_en = 0;
					change = 0;
					item = 0;
					amt = 1;
					// Triggered when an item is selected (assign the input to item)
					case (item_sel)
						5'b00001: item = A;
						5'b00010: item = B;
						5'b00100: item = C;
						5'b01000: item = D;
						5'b10000: item = E;
						default:;
					endcase
					// Jump to the selected STATE
					case (item)
						A: next_state = S1;
						B: next_state = S2;
						C: next_state = S3;
						D: next_state = S4;
						E: next_state = S5;
						default: next_state = S0;
					endcase
				end
				
				S1:
				begin
					col_rst = 0;
					// Enable inserting COINS
					insert_en = 1;
					// Item A is selected, default amount: 1
					item = A;
					// Assign amount if the user select an AMT
					if (amt_sel)
					begin
						case (amt_sel)
							3'b001: amt = 1;
							3'b010: amt = 2;
							3'b100: amt = 3;
							default:;
						endcase
					end
					// TASK comparing the price to COLLECTED
					comp();
					// If the collected money exceeds the price, jump to S6
					if (col_finish) next_state = S6;
					else next_state = S1;
				end
				
				S2:
				begin
					col_rst = 0;
					insert_en = 1;
					item = B;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b001: amt = 1;
							3'b010: amt = 2;
							3'b100: amt = 3;
							default:;
						endcase
					end
					comp();
					if (col_finish) next_state = S6;
					else next_state = S2;
				end
				
				S3:
				begin
					col_rst = 0;
					insert_en = 1;
					item = C;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b001: amt = 1;
							3'b010: amt = 2;
							3'b100: amt = 3;
							default:;
						endcase
					end
					comp();
					if (col_finish) next_state = S6;
					else next_state = S3;
				end
				
				S4:
				begin
					col_rst = 0;
					insert_en = 1;
					item = D;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b001: amt = 1;
							3'b010: amt = 2;
							3'b100: amt = 3;
							default:;
						endcase
					end
					comp();
					if (col_finish) next_state = S6;
					else next_state = S4;
				end
				
				S5:
				begin
					col_rst = 0;
					insert_en = 1;
					item = E;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b001: amt = 1;
							3'b010: amt = 2;
							3'b100: amt = 3;
							default:;
						endcase
					end
					comp();
					if (col_finish) next_state = S6;
					else next_state = S5;
				end
				
				// Displaying the detail of purchase; waiting for the CONTINUE button to be pressed
				S6:
				begin
					// Disable inserting coins
					insert_en = 0;
					// Proceed to another purchase if the user press CONTINUE button, otherwise, stay at S6
					if (!continue_)
					begin
						next_state = S0;
						insert_en = 0;
						change = 0;
						item = 0;
						amt = 1;
					end
					else
						next_state = S6;
				end
				default:
				begin
					change = 0;
					amt = 1;
					item = 0;
				end
			endcase
		end

		
endmodule

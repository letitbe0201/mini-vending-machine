module ee271_final_proj_v2_9 (clk, cancel, continue_, item_sel, amt_sel, DIME, QUATER, DOLLAR, col_seven_1, col_seven_2, col_seven_3, ch_seven_1, ch_seven_2, ch_seven_3, item_A, item_B, item_C, item_D, amt_out);

	// Should be okay if fix the problem of fast clock over collected and change calculations
	
	// cancel: cancel the transaction and return the collected money
	// continue: reset everything after one purchase has been done
	// collected: signal the system that the required amount of money has been inserted
	input       clk, cancel, continue_;
	input [3:0] item_sel;
	input [2:0] amt_sel;
	input       DIME;
	input       QUATER;
	input       DOLLAR;

			 reg sclk;
			 reg [19:0] count;
	       reg [2:0] state, next_state;
	       reg [2:0] delivery;
	// when 0: unable to insert coin;
	       reg       insert_en;
	// Display collected money on Seven segment LED
	       reg [31:0]collected;
	       reg [31:0]col_temp;
	       reg [31:0]col_mod;
	output reg [7:0] col_seven_1;   // 0.
	output reg [7:0] col_seven_2;   // 0
	output reg [7:0] col_seven_3;   // 0
	// Display change on seven segment LED
	       reg [31:0]change;
	       reg [31:0]ch_temp;
	       reg [31:0]ch_mod;
	output reg [7:0] ch_seven_1;   // 0.
	output reg [7:0] ch_seven_2;   // 0
	output reg [7:0] ch_seven_3;   // 0
	// Display item
	       reg [2:0] item;
	output reg       item_A;
	output reg       item_B;
	output reg       item_C;
	output reg       item_D;
	       reg       item_E;
	// Display amt selection
	       reg [1:0] amt;
	output reg [2:0] amt_out;
	// TODO Display item delivery

	// Items
	parameter [3:0] A = 4'b0001;
	parameter [3:0] B = 4'b0010;
	parameter [3:0] C = 4'b0011;
	parameter [3:0] D = 4'b0100;
	parameter [3:0] E = 4'b0101;
	
	// Price of products (cent)
	parameter price_A = 50;
	parameter price_B = 80;
	parameter price_C = 100;
	parameter price_D = 120;
	parameter price_E = 150;
	
	// States
	parameter [2:0] S0 = 0;	// Idle state
	parameter [2:0] S1 = 1;	// state for A
	parameter [2:0] S2 = 2;	// B
	parameter [2:0] S3 = 3;	// C
	parameter [2:0] S4 = 4;	// D
	parameter [2:0] S5 = 5;	// E
	parameter [2:0] S6 = 6;	// Show the result of purchase (including change)

	initial begin
		sclk = 0;
		count = 20'b0;
		state = S0;
		delivery = 3'b0;
		// when 0: unable to insert coin;
		insert_en = 0;
		// Display collected money on Seven segment LED
	        collected = 32'b0;
		col_seven_1 = 8'b01000000;   // 0.
		col_seven_2 = 8'b11000000;   // 0
		col_seven_3 = 8'b11000000;   // 0
		// Display change on seven segment LED
		change = 32'b0;
		ch_seven_1 = 8'b01000000;   // 0.
		ch_seven_2 = 8'b11000000;   // 0
		ch_seven_3 = 8'b11000000;   // 0
		// Display item
		item = 3'b0;
		item_A = 0;
		item_B = 0;
		item_C = 0;
		item_D = 0;
		item_E = 0;
		// Display amt selection
		amt = 2'b01;
		amt_out = 3'b001;
	end


	// Calculating the collected amount of money
	always @ (DIME or QUATER or DOLLAR or state)
	begin
		if (insert_en && (state != S0) && (state != S6))
		begin
			if (DIME) collected = collected + 10;
			else if (QUATER) collected = collected + 25;
			else if (DOLLAR) collected = collected + 100;
			//else collected = collected;
		end
		// Reset collected when at S0 and S6
		if ((state == S0) || (state == S6)) collected = 0;
	end


	// Finite (seven) state machine
	always @ (*)
	begin		
		// If the cancel button is pressed, reset everything and return the
		// money; If the state is S6, do nothing
		if (!cancel && (state != S6))
		begin
			insert_en = 0;
			item = 0;
			amt = 1;
			delivery = 0;
			// If the users has already inserted some money, jump to State 6;
			// otherwise, jump to State 0.
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
					// Reset everything
					insert_en = 0;
					change = 0;
					item = 0;
					amt = 1;
					delivery = 0;
					// triggered when an item is selected (assign the input to item)
					// ///////////
					case (item_sel)
						4'b1000: item = A;
						4'b0100: item = B;
						4'b0010: item = C;
						4'b0001: item = D;
						//5'b00001: item = E;
						default:;
					endcase
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
					// enable inserting coins
					insert_en = 1;
					// item A is selected, default amount: 1
					item = A;
					// assign amount if the user select an amount
					if (amt_sel)
					begin
						case (amt_sel)
							3'b100: amt = 3;
							3'b010: amt = 2;
							3'b001: amt = 1;
							default:;
						endcase
					end
					// If the collected money exceeds the price
					if (collected >= price_A * amt)
					begin
						change = collected - price_A * amt;
						next_state = S6;
						delivery = 1;
					end
					else next_state = S1;
				end
				S2:
				begin
					insert_en = 1;
					item = B;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b100: amt = 3;
							3'b010: amt = 2;
							3'b001: amt = 1;
							default:;
						endcase
					end
					if (collected >= price_B * amt)
					begin
						change = collected - price_B * amt;
						next_state = S6;
						delivery = 2;
					end
					else next_state = S2;
				end
				S3:
				begin
					insert_en = 1;
					item = C;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b100: amt = 3;
							3'b010: amt = 2;
							3'b001: amt = 1;
							default:;
						endcase
					end
					if (collected >= price_C * amt)
					begin
						change = collected - price_C * amt;
						next_state = S6;
						delivery = 3;
					end
					else next_state = S3;
				end
				S4:
				begin
					insert_en = 1;
					item = D;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b100: amt = 3;
							3'b010: amt = 2;
							3'b001: amt = 1;
							default:;
						endcase
					end
					if (collected >= price_D * amt)
					begin
						change = collected - price_D * amt;
						next_state = S6;
						delivery = 4;
					end
					else next_state = S4;
				end
				S5:
				begin
					insert_en = 1;
					item = E;
					if (amt_sel)
					begin
						case (amt_sel)
							3'b100: amt = 3;
							3'b010: amt = 2;
							3'b001: amt = 1;
							default:;
						endcase
					end
					if (collected >= price_E * amt)
					begin
						change = collected - price_E * amt;
						next_state = S6;
						delivery = 5;
					end
					else next_state = S5;
				end
				// Displaying the detail of purchase; waiting for the continue button to be pressed
				S6:
				begin
					// Disenable inserting coins
					insert_en = 0;
					// proceed to another purchase if the user press continue button (build a clock???)
					if (!continue_)
					begin
						next_state = S0;
						insert_en = 0;
						change = 0;
						item = 0;
						amt = 1;
						delivery = 0;
					end
					else
						// TODO KEEP THE NEXT STATE EVEN AFTER 'CONTINUE' 1 -> 0
						next_state = S6;
				end
				default:
				begin
					change = 0;
					delivery = 0;
					amt = 1;
					item = 0;
				end
			endcase
		end
	
	// Output collected money on seven segment LED
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

	// Output change on seven segment LED
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

	// Display item delivery
	always @ (item)
	begin
		case(item)
			0:
			begin
				item_A = 0;
				item_B = 0;
				item_C = 0;
				item_D = 0;
				item_E = 0;
			end
			A: item_A = 1;
			B: item_B = 1;
			C: item_C = 1;
			D: item_D = 1;
			E: item_E = 1;
			default:
			begin
				item_A = 0;
				item_B = 0;
				item_C = 0;
				item_D = 0;
				item_E = 0;
			end

		endcase
	end

	// Display amount selection
	always @ (amt)
	begin
		case(amt)
			1: amt_out = 3'b001;
			2: amt_out = 3'b010; 
			3: amt_out = 3'b100;
			default: amt_out = 3'b001;
		endcase
	end
	
	// TODO Display the delivery of item (blinking item LED)
		
	// State machine drived by 100 Hz Clock
	always @ (posedge sclk)
	begin
		state <= next_state;
	end
	
	// 50 MHz clock
	always @ (posedge clk)
	begin
		if (count != 20'b01111010000100100000)
			count = count + 1;
		else
		begin
			count = 20'b0;
			sclk = ~sclk;
		end
	end
	
		
endmodule
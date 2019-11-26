module ee271_final_proj_v2_5 (clk, cancel, continue_, item_sel, amt_sel, DIME, QUATER, DOLLAR, col_seven_1, col_seven_2, col_seven_3, ch_seven_1, ch_seven_2, ch_seven_3, item_A, item_B, item_C, item_D, item_E, amt_1, amt_2, amt_3);

	// cancel: cancel the transaction and return the collected money
	// continue: reset everything after one purchase has been done
	// collected: signal the system that the required amount of money has been inserted
	input       clk, cancel, continue_;
	input [4:0] item_sel;
	input [2:0] amt_sel;
	input       DIME;
	input       QUATER;
	input       DOLLAR;

	       reg [2:0] state = 0, next_state;
	       reg [2:0] delivery = 0;
	// when 0: unable to insert coin;
	       reg       insert_en = 0;
	// Display collected money on Seven segment LED
	       reg [31:0]collected = 0;
	       reg [31:0]col_temp;
	       reg [31:0]col_mod;
	output reg [7:0] col_seven_1 = 8'b00000010;   // 0.
	output reg [7:0] col_seven_2 = 8'b00000011;   // 0
	output reg [7:0] col_seven_3 = 8'b00000011;   // 0
	// Display change on seven segment LED
	       reg [31:0]change = 0;
	       reg [31:0]ch_temp;
	       reg [31:0]ch_mod;
	output reg [7:0] ch_seven_1 = 8'b00000010;   // 0.
	output reg [7:0] ch_seven_2 = 8'b00000011;   // 0
	output reg [7:0] ch_seven_3 = 8'b00000011;   // 0
	// Display item
	       reg [2:0] item = 0;
	output reg       item_A = 0;
	output reg       item_B = 0;
	output reg       item_C = 0;
	output reg       item_D = 0;
	output reg       item_E = 0;
	// Display amt selection
	       reg [1:0] amt = 1;
	output reg       amt_1 = 0;
	output reg       amt_2 = 0;
	output reg       amt_3 = 0;
	// TODO Display item delivery

	// Items
	parameter [2:0] A = 1;
	parameter [2:0] B = 2;
	parameter [2:0] C = 3;
	parameter [2:0] D = 4;
	parameter [2:0] E = 5;
	
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
		if (cancel && (state != S6))
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
						5'b10000: item = A;
						5'b01000: item = B;
						5'b00100: item = C;
						5'b00010: item = D;
						5'b00001: item = E;
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
					case (amt_sel)
						3'b100: amt = 1;
						3'b010: amt = 2;
						3'b001: amt = 3;
						default:;
					endcase
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
					case (amt_sel)
						3'b100: amt = 1;
						3'b010: amt = 2;
						3'b001: amt = 3;
						default:;
					endcase

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
					case (amt_sel)
						3'b100: amt = 1;
						3'b010: amt = 2;
						3'b001: amt = 3;
						default:;
					endcase
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
					case (amt_sel)
						3'b100: amt = 1;
						3'b010: amt = 2;
						3'b001: amt = 3;
						default:;
					endcase
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
					case (amt_sel)
						3'b100: amt = 1;
						3'b010: amt = 2;
						3'b001: amt = 3;
						default:;
					endcase
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
					if (continue_)
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
			0: col_seven_3 = 8'b00000011;
			1: col_seven_3 = 8'b10011111;
			2: col_seven_3 = 8'b00100101;
			3: col_seven_3 = 8'b00001101;
			4: col_seven_3 = 8'b10011001;
			5: col_seven_3 = 8'b01001001;
			6: col_seven_3 = 8'b01000001;
			7: col_seven_3 = 8'b00011111;
			8: col_seven_3 = 8'b00000001;
			9: col_seven_3 = 8'b00001001;
			default: col_seven_3 = 8'b00000011;
		endcase
		// col_seven_2
		col_temp = col_temp / 10;
		col_mod = col_temp % 10;
		case (col_mod)
			0: col_seven_2 = 8'b00000011;
			1: col_seven_2 = 8'b10011111;
			2: col_seven_2 = 8'b00100101;
			3: col_seven_2 = 8'b00001101;
			4: col_seven_2 = 8'b10011001;
			5: col_seven_2 = 8'b01001001;
			6: col_seven_2 = 8'b01000001;
			7: col_seven_2 = 8'b00011111;
			8: col_seven_2 = 8'b00000001;
			9: col_seven_2 = 8'b00001001;
			default: col_seven_2 = 8'b00000011;
		endcase
		// col_seven_1
		col_temp = col_temp / 10;
		col_mod = col_temp % 10;
		case (col_mod)
			0: col_seven_1 = 8'b00000010;
			1: col_seven_1 = 8'b10011110;
			2: col_seven_1 = 8'b00100100;
			3: col_seven_1 = 8'b00001100;
			4: col_seven_1 = 8'b10011000;
			5: col_seven_1 = 8'b01001000;
			6: col_seven_1 = 8'b01000000;
			7: col_seven_1 = 8'b00011110;
			8: col_seven_1 = 8'b00000000;
			9: col_seven_1 = 8'b00001000;
			default: col_seven_1 = 8'b00001000;
		endcase
	end

	// Output change on seven segment LED
	always @ (change)
	begin
		ch_temp = change;
		// ch_seven_3
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_3 = 8'b00000011;
			1: ch_seven_3 = 8'b10011111;
			2: ch_seven_3 = 8'b00100101;
			3: ch_seven_3 = 8'b00001101;
			4: ch_seven_3 = 8'b10011001;
			5: ch_seven_3 = 8'b01001001;
			6: ch_seven_3 = 8'b01000001;
			7: ch_seven_3 = 8'b00011111;
			8: ch_seven_3 = 8'b00000001;
			9: ch_seven_3 = 8'b00001001;
			default: ch_seven_3 = 8'b00000011;
		endcase
		// ch_seven_2
		ch_temp = ch_temp / 10;
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_2 = 8'b00000011;
			1: ch_seven_2 = 8'b10011111;
			2: ch_seven_2 = 8'b00100101;
			3: ch_seven_2 = 8'b00001101;
			4: ch_seven_2 = 8'b10011001;
			5: ch_seven_2 = 8'b01001001;
			6: ch_seven_2 = 8'b01000001;
			7: ch_seven_2 = 8'b00011111;
			8: ch_seven_2 = 8'b00000001;
			9: ch_seven_2 = 8'b00001001;
			default: ch_seven_2 = 8'b00000011;
		endcase
		// ch_seven_1
		ch_temp = ch_temp / 10;
		ch_mod = ch_temp % 10;
		case (ch_mod)
			0: ch_seven_1 = 8'b00000010;
			1: ch_seven_1 = 8'b10011110;
			2: ch_seven_1 = 8'b00100100;
			3: ch_seven_1 = 8'b00001100;
			4: ch_seven_1 = 8'b10011000;
			5: ch_seven_1 = 8'b01001000;
			6: ch_seven_1 = 8'b01000000;
			7: ch_seven_1 = 8'b00011110;
			8: ch_seven_1 = 8'b00000000;
			9: ch_seven_1 = 8'b00001000;
			default: ch_seven_1 = 8'b00001000;
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
			0:
			begin
				amt_1 = 0;
				amt_2 = 0;
				amt_3 = 0;
			end
			1: 
			begin
				amt_1 = 1;
				amt_2 = 0;
				amt_3 = 0;
			end
			2: 
			begin
				amt_1 = 0;
				amt_2 = 1;
				amt_3 = 0;
			end
			3: 
			begin
				amt_1 = 0;
				amt_2 = 0;
				amt_3 = 1;
			end
			default:
			begin
				amt_1 = 0;
				amt_2 = 0;
				amt_3 = 0;
			end
		endcase
	end
	
	// TODO Display the delivery of item (blinking item LED)
		
	// Clock
	always @ (posedge clk)
	begin
		state <= next_state;
	end
		
endmodule

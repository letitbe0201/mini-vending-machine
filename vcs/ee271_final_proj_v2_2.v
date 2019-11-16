module ee271_final_proj_v2_2 (clk, cancel, continue, item_sel, amt_sel, DIME, QUATER, DOLLAR, state, next_state, collected, change, item, amt, delivery, insert_en);

	// cancel: cancel the transaction and return the collected money
	// continue: reset everything after one purchase has been done
	// collected: signal the system that the required amount of money has been inserted
	input       clk, cancel, continue;
	input [2:0] item_sel;
	input [1:0] amt_sel;
	input       DIME;
	input       QUATER;
	input       DOLLAR;

	output reg [2:0] state = 0, next_state;
	output reg [9:0] collected = 0;
	output reg [9:0] change;
	output reg [2:0] item = 0;
	output reg [1:0] amt = 1;
	output reg [2:0] delivery = 0;
	// when 0: unable to insert coin;
	output reg       insert_en = 0;

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
			else collected = collected;
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
					if (item_sel) item = item_sel;
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
					if (amt_sel) amt = amt_sel;
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
					if (amt_sel) amt = amt_sel;
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
					if (amt_sel) amt = amt_sel;
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
					if (amt_sel) amt = amt_sel;
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
					if (amt_sel) amt = amt_sel;
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
					if (continue)
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
			endcase
		end
		
	// Clock
	always @ (posedge clk)
	begin
		state <= next_state;
	end
		
endmodule

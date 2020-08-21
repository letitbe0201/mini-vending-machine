`timescale 1ns/1ns

module ee271_final_proj_vendingmachine #(
	parameter  PRICE_A = 10'd50,
	parameter  PRICE_B = 10'd80,
	parameter  PRICE_C = 10'd100,
	parameter  PRICE_D = 10'd120,
	parameter  PRICE_E = 10'd150)
	(
	// CANCEL: Cancel the transaction and return the collected money
	// CONTINUE_: Continue to another purchase
	// COLLECTED: Keep record on collected money
	input i_clk,
	input i_cancel,
	input i_continue,
	input [4:0] i_item_sel,
	input [2:0] i_amt_sel,
	input [3:0] i_pad_row,
	// Display COLLECTED, CHANGE, ITEM, AMOUNT
	output [7:0] o_col_seven_1,
	output [7:0] o_col_seven_2,
	output [7:0] o_col_seven_3,
	output [7:0] o_ch_seven_1,
	output [7:0] o_ch_seven_2,
	output [7:0] o_ch_seven_3,
	output reg [4:0] o_item_LED,
	output reg [2:0] o_amt_LED,
	output [3:0] o_pad_col
	);


	/*
	REGISTERS AND PARAMETERS
	*/
	reg [2:0] r_state, r_next_state;
	// CLOCK for STATE MACHINE
	reg r_sclk;
	reg	[31:0] r_count;
	// When 0: Disable inserting coins
	reg	r_insert_en;
	// Display collected money on Seven segment LED
	reg	r_col_finish;
	reg	r_col_rst;
	// Display change on seven segment LED
	reg	[31:0] r_change;
	// Store value of ITEM and AMOUNT
	reg	[2:0] r_item;
	reg	[1:0] r_amt;

	wire [2:0] w_coin;
	wire [7:0] w_col_seven_1;
	wire [7:0] w_col_seven_2;
	wire [7:0] w_col_seven_3;
	wire [7:0] w_ch_seven_1;
	wire [7:0] w_ch_seven_2;
	wire [7:0] w_ch_seven_3;
	wire [31:0] w_collected;
	wire [31:0] w_change;
	wire w_col_finish;

	
	// ITEMS
	localparam  [2:0]  A = 3'b001;
	localparam  [2:0]  B = 3'b011;
	localparam  [2:0]  C = 3'b010;
	localparam  [2:0]  D = 3'b110;
	localparam  [2:0]  E = 3'b111;
	
	// STATES
	localparam  [2:0] S0 = 0;	// IDLE STATE
	localparam  [2:0] S1 = 1;	// A PURCHASE
	localparam  [2:0] S2 = 2;	// B
	localparam  [2:0] S3 = 3;	// C
	localparam  [2:0] S4 = 4;	// D
	localparam  [2:0] S5 = 5;	// E
	localparam  [2:0] S6 = 6;	// RESULTS (including CHANGE)


	/*
	INITIALIZE EVERYTHING
	*/
	initial begin
		o_amt_LED	= 3'b001;           // Default amount: 1
		o_item_LED = 5'b0;
		r_state = S0;
		r_sclk = 0;
		r_count = 0;
		r_insert_en = 0;
		r_col_finish = 0;
		r_col_rst = 0;
		r_change = 32'b0;
		r_item = 3'b0;
		r_amt	= 2'b01;
	end
	
	
	/*
	CLOCK AND STATE REGISTER
	*/
	// State machine driven by r_sclk
	always @ (posedge r_sclk)
	begin
		r_state <= r_next_state;
	end
	
	// 50ms at 50MHz
	always @ (posedge i_clk)
	begin
		if (r_count != 32'b00000000001001100010010110100000)
			r_count = r_count + 1;
		else
		begin
			r_count = 32'b0;
			r_sclk = ~r_sclk;
		end
	end
	

	/*
	MONEY CALCULATION
	*/
	Money_Calc #(
		.PRICE_A(PRICE_A),
		.PRICE_B(PRICE_B),
		.PRICE_C(PRICE_C),
		.PRICE_D(PRICE_D),
		.PRICE_E(PRICE_E),
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.E(E)) MC
	(
		.i_clk(i_clk),
		.i_col_rst(r_col_rst),
		.i_insert_en(r_insert_en),
		.i_coin(w_coin),
		.o_collected(w_collected)
	);

		
	/*
	SEVEN SEGMENT LED DISPLAY
	*/	
	Seven_Segment_Display SSD(
		.i_collected(w_collected),
		.i_change(r_change),
		.o_col_seven_1(w_col_seven_1),
		.o_col_seven_2(w_col_seven_2),
		.o_col_seven_3(w_col_seven_3),
		.o_ch_seven_1(w_ch_seven_1),
		.o_ch_seven_2(w_ch_seven_2),
		.o_ch_seven_3(w_ch_seven_3)
	);

	assign o_col_seven_1 = w_col_seven_1;
	assign o_col_seven_2 = w_col_seven_2;
	assign o_col_seven_3 = w_col_seven_3;
	assign o_ch_seven_1 = w_ch_seven_1;
	assign o_ch_seven_2 = w_ch_seven_2;
	assign o_ch_seven_3 = w_ch_seven_3;
		
		
	/*
	KEYPAD INTERFACE	
	*/
	Keypad_Intf KI (
	.i_clk(i_clk),
	.i_pad_row(i_pad_row),
	.o_pad_col(o_pad_col),
	.o_coin(w_coin)
	);



	/*
	ITEM AND AMOUNT DISPLAY
	*/
	always @ (r_item)
	begin
		case(r_item)
			0:
			begin
				o_item_LED = 5'b0;
			end
			A: o_item_LED = 5'b00001;
			B: o_item_LED = 5'b00010;
			C: o_item_LED = 5'b00100;
			D: o_item_LED = 5'b01000;
			E: o_item_LED = 5'b10000;
			default: o_item_LED = 5'b0;

		endcase
	end

	always @ (r_amt)
	begin
		case(r_amt)
			1: o_amt_LED = 3'b001;
			2: o_amt_LED = 3'b010; 
			3: o_amt_LED = 3'b100;
			default: o_amt_LED = 3'b001;
		endcase
	end
	

	/*
	SEVEN-STATES STATE MACHINE
	*/
	always @ (*)
	begin
		r_item = 0;
		r_amt = 1;
		r_change = 0;
		r_col_rst = 0;
		r_col_finish = 0; 
		// If the CANCEL is pressed during the purchase, return the money
		if (!i_cancel && (r_state != S6))
		begin
			r_insert_en = 0;
			r_item = 0;
			r_amt = 1;
			// If the users has already inserted coins, jump to State 6 to return money; otherwise, stay at S0.
			if (w_collected)
			begin	
				r_change = w_collected;
				r_next_state = S6;
			end
			else
			begin	
				r_change = 0;
				r_next_state = S0;
			end
		end
		else
		begin
			case (r_state)
			
				S0:
				begin
					// RESET everything
					r_col_rst = 1;
					r_insert_en = 0;
					r_change = 0;
					r_item = 0;
					r_amt = 1;
					// Triggered when an item is selected (assign the input to item)
					case (i_item_sel)
						5'b00001: r_item = A;
						5'b00010: r_item = B;
						5'b00100: r_item = C;
						5'b01000: r_item = D;
						5'b10000: r_item = E;
						default: r_item = 0;
					endcase
					// Jump to the selected STATE
					case (r_item)
						A: r_next_state = S1;
						B: r_next_state = S2;
						C: r_next_state = S3;
						D: r_next_state = S4;
						E: r_next_state = S5;
						default: r_next_state = S0;
					endcase
				end
				
				S1:
				begin
					r_col_rst = 0;
					r_col_finish = 0;
					// Enable inserting coins
					r_insert_en = 1;
					// Item A is selected, default amount: 1
					r_item = A;
					// Assign amount if the user select an AMT
					if (i_amt_sel)
					begin
						case (i_amt_sel)
							3'b001: r_amt = 1;
							3'b010: r_amt = 2;
							3'b100: r_amt = 3;
							default: r_amt = 1;
						endcase
					end
					// Calc the price versus COLLECTED
					if (w_collected >= (PRICE_A*r_amt))
					begin
						r_change = w_collected - (PRICE_A*r_amt);
						r_col_finish = 1;
					end
					else
					begin
						r_change = 0;
						r_col_finish = 0;
					end
					// If the collected money exceeds the price, jump to S6
					if (r_col_finish)
						r_next_state = S6;
					else
						r_next_state = S1;
				end
				
				S2:
				begin
					r_col_rst = 0;
					r_col_finish = 0;
					r_insert_en = 1;
					r_item = B;
					if (i_amt_sel)
					begin
						case (i_amt_sel)
							3'b001: r_amt = 1;
							3'b010: r_amt = 2;
							3'b100: r_amt = 3;
							default: r_amt = 1;
						endcase
					end
					// Calc the price versus COLLECTED
					if (w_collected >= (PRICE_B*r_amt))
					begin
						r_change = w_collected - (PRICE_B*r_amt);
						r_col_finish = 1;
					end
					else
					begin
						r_change = 0;
						r_col_finish = 0;
					end
					if (r_col_finish) 
						r_next_state = S6;
					else
						r_next_state = S2;
				end
				
				S3:
				begin
					r_col_rst = 0;
					r_col_finish = 0;
					r_insert_en = 1;
					r_item = C;
					if (i_amt_sel)
					begin
						case (i_amt_sel)
							3'b001: r_amt = 1;
							3'b010: r_amt = 2;
							3'b100: r_amt = 3;
							default: r_amt = 1;
						endcase
					end
					// Calc the price versus COLLECTED
					if (w_collected >= (PRICE_C*r_amt))
					begin
						r_change = w_collected - (PRICE_C*r_amt);
						r_col_finish = 1;
					end
					else
					begin
						r_change = 0;
						r_col_finish = 0;
					end
					if (r_col_finish) 
						r_next_state = S6;
					else 
						r_next_state = S3;
				end
				
				S4:
				begin
					r_col_rst = 0;
					r_col_finish = 0;
					r_insert_en = 1;
					r_item = D;
					if (i_amt_sel)
					begin
						case (i_amt_sel)
							3'b001: r_amt = 1;
							3'b010: r_amt = 2;
							3'b100: r_amt = 3;
							default: r_amt = 1;
						endcase
					end
					// Calc the price versus COLLECTED
					if (w_collected >= (PRICE_D*r_amt))
					begin
						r_change = w_collected - (PRICE_D*r_amt);
						r_col_finish = 1;
					end
					else
					begin
						r_change = 0;
						r_col_finish = 0;
					end
					if (r_col_finish)
						r_next_state = S6;
					else
						r_next_state = S4;
				end
				
				S5:
				begin
					r_col_rst = 0;
					r_col_finish = 0;
					r_insert_en = 1;
					r_item = E;
					if (i_amt_sel)
					begin
						case (i_amt_sel)
							3'b001: r_amt = 1;
							3'b010: r_amt = 2;
							3'b100: r_amt = 3;
							default: r_amt = 1;
						endcase
					end
					// Calc the price versus COLLECTED
					if (w_collected >= (PRICE_E*r_amt))
					begin
						r_change = w_collected - (PRICE_E*r_amt);
						r_col_finish = 1;
					end
					else
					begin
						r_change = 0;
						r_col_finish = 0;
					end
					if (r_col_finish)
						r_next_state = S6;
					else
						r_next_state = S5;
				end
				
				// Displaying the detail of purchase; waiting for the CONTINUE button to be pressed
				S6:
				begin
					// Disable inserting coins
					r_insert_en = 0;
					// Proceed to another purchase if the user press CONTINUE button, otherwise, stay at S6
					if (!i_continue)
					begin
						r_next_state = S0;
						r_insert_en = 0;
						r_change = 0;
						r_item = 0;
						r_amt = 1;
					end
					else
						r_next_state = S6;
				end
				default:
				begin
					r_change = 0;
					r_amt = 1;
					r_item = 0;
				end
			endcase
		end
	end
endmodule

// Keypad for assigning COINS
module Keypad_Intf ( 
	input i_clk,
	input [3:0] i_pad_row,
	output reg [3:0] o_pad_col,
	output reg [2:0] o_coin
	);

	reg [23:0] r_count_pad = 24'b0;

	always @ (posedge i_clk)
	begin
		o_coin <= 3'b111;
		
		// Scanning the keypad COLUMN by COLUMN
		if (r_count_pad == 24'b0111001001110000111000000)
		begin
				// Column 1
				o_pad_col <= 4'b0111;		
				r_count_pad <= r_count_pad + 1'b1;
		end
			
		else if(r_count_pad == 24'b01110010011100001110000000)
		begin
			// Row 1
			if (i_pad_row == 4'b0111)
			begin
				// Assign 1 DOLLAR
				o_coin <= 3'b101;
				r_count_pad <= 24'b0;
			end
			r_count_pad <= r_count_pad + 1'b1;
		end

		else if(r_count_pad == 24'b010101011101010010101000000)
		begin
			// COLUMN 2
			o_pad_col<= 4'b1011;
			r_count_pad <= r_count_pad + 1'b1;
		end
		else if(r_count_pad == 24'b011100100111000011100000000)
		begin
			if (i_pad_row == 4'b0111)
			begin
				// Assign 1 QUATER
				o_coin <= 3'b110;
				r_count_pad <= 24'b0;
			end
			r_count_pad <= r_count_pad + 1'b1;
		end

		else if(r_count_pad == 24'b0100011110000110100011000000)
		begin
			// COLUMN 3
			o_pad_col <= 4'b1101;
			r_count_pad <= r_count_pad + 1'b1;
		end
		else if(r_count_pad == 24'b0101010111010100101010000000)
		begin
			// ROW 1
			if(i_pad_row == 4'b0111)
			begin
				// Assign 1 DIME
				o_coin <= 3'b011;
				r_count_pad <= 24'b0;				
			end
			r_count_pad <= r_count_pad + 1'b1;
		end

		else
			r_count_pad <= r_count_pad + 1'b1;
	end
endmodule
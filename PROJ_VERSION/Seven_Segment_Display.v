module Seven_Segment_Display (
	input [31:0] i_collected,
	input [31:0] i_change,
	output reg [7:0] o_col_seven_3,
	output reg [7:0] o_col_seven_2,
	output reg [7:0] o_col_seven_1,
	output reg [7:0] o_ch_seven_3,
	output reg [7:0] o_ch_seven_2,
	output reg [7:0] o_ch_seven_1 
	);

	reg [31:0] r_col_temp = 0;
	reg [31:0] r_col_mod = 0;
	reg [31:0] r_ch_temp = 0;
	reg [31:0] r_ch_mod = 0;

	// Output COLLECTED money on seven segment LED
	always @ (i_collected)
	begin
		r_col_temp = i_collected;
		// col_seven_3
		r_col_mod = r_col_temp % 10;
		case (r_col_mod)
			0: o_col_seven_3 = 8'b11000000;
			1: o_col_seven_3 = 8'b11111001;
			2: o_col_seven_3 = 8'b10100100;
			3: o_col_seven_3 = 8'b10110000;
			4: o_col_seven_3 = 8'b10011001;
			5: o_col_seven_3 = 8'b10010010;
			6: o_col_seven_3 = 8'b10000010;
			7: o_col_seven_3 = 8'b11111000;
			8: o_col_seven_3 = 8'b10000000;
			9: o_col_seven_3 = 8'b10010000;
			default: o_col_seven_3 = 8'b11000000;
		endcase
		// col_seven_2
		r_col_temp = r_col_temp / 10;
		r_col_mod = r_col_temp % 10;
		case (r_col_mod)
			0: o_col_seven_2 = 8'b11000000;
			1: o_col_seven_2 = 8'b11111001;
			2: o_col_seven_2 = 8'b10100100;
			3: o_col_seven_2 = 8'b10110000;
			4: o_col_seven_2 = 8'b10011001;
			5: o_col_seven_2 = 8'b10010010;
			6: o_col_seven_2 = 8'b10000010;
			7: o_col_seven_2 = 8'b11111000;
			8: o_col_seven_2 = 8'b10000000;
			9: o_col_seven_2 = 8'b10010000;
			default: o_col_seven_2 = 8'b11000000;
		endcase
		// col_seven_1
		r_col_temp = r_col_temp / 10;
		r_col_mod = r_col_temp % 10;
		case (r_col_mod)
			0: o_col_seven_1 = 8'b01000000;
			1: o_col_seven_1 = 8'b01111001;
			2: o_col_seven_1 = 8'b00100100;
			3: o_col_seven_1 = 8'b00110000;
			4: o_col_seven_1 = 8'b00011001;
			5: o_col_seven_1 = 8'b00010010;
			6: o_col_seven_1 = 8'b00000010;
			7: o_col_seven_1 = 8'b01111000;
			8: o_col_seven_1 = 8'b00000000;
			9: o_col_seven_1 = 8'b00010000;
			default: o_col_seven_1 = 8'b01000000;
		endcase
	end

	// Output CHANGE on seven segment LED
	always @ (i_change)
	begin
		r_ch_temp = i_change;
		// ch_seven_3
		r_ch_mod = r_ch_temp % 10;
		case (r_ch_mod)
			0: o_ch_seven_3 = 8'b11000000;
			1: o_ch_seven_3 = 8'b11111001;
			2: o_ch_seven_3 = 8'b10100100;
			3: o_ch_seven_3 = 8'b10110000;
			4: o_ch_seven_3 = 8'b10011001;
			5: o_ch_seven_3 = 8'b10010010;
			6: o_ch_seven_3 = 8'b10000010;
			7: o_ch_seven_3 = 8'b11111000;
			8: o_ch_seven_3 = 8'b10000000;
			9: o_ch_seven_3 = 8'b10010000;
			default: o_ch_seven_3 = 8'b11000000;
		endcase
		// ch_seven_2
		r_ch_temp = r_ch_temp / 10;
		r_ch_mod = r_ch_temp % 10;
		case (r_ch_mod)
			0: o_ch_seven_2 = 8'b11000000;
			1: o_ch_seven_2 = 8'b11111001;
			2: o_ch_seven_2 = 8'b10100100;
			3: o_ch_seven_2 = 8'b10110000;
			4: o_ch_seven_2 = 8'b10011001;
			5: o_ch_seven_2 = 8'b10010010;
			6: o_ch_seven_2 = 8'b10000010;
			7: o_ch_seven_2 = 8'b11111000;
			8: o_ch_seven_2 = 8'b10000000;
			9: o_ch_seven_2 = 8'b10010000;
			default: o_ch_seven_2 = 8'b11000000;
		endcase
		// ch_seven_1
		r_ch_temp = r_ch_temp / 10;
		r_ch_mod = r_ch_temp % 10;
		case (r_ch_mod)
			0: o_ch_seven_1 = 8'b01000000;
			1: o_ch_seven_1 = 8'b01111001;
			2: o_ch_seven_1 = 8'b00100100;
			3: o_ch_seven_1 = 8'b00110000;
			4: o_ch_seven_1 = 8'b00011001;
			5: o_ch_seven_1 = 8'b00010010;
			6: o_ch_seven_1 = 8'b00000010;
			7: o_ch_seven_1 = 8'b01111000;
			8: o_ch_seven_1 = 8'b00000000;
			9: o_ch_seven_1 = 8'b00010000;
			default: o_ch_seven_1 = 8'b01000000;
		endcase
	end
endmodule
module Money_Calc #(
	parameter  PRICE_A = 10'd50,
	parameter  PRICE_B = 10'd80,
	parameter  PRICE_C = 10'd100,
	parameter  PRICE_D = 10'd120,
	parameter  PRICE_E = 10'd150,
	parameter [2:0] A = 3'b001;
	parameter [2:0] B = 3'b011;
	parameter [2:0] C = 3'b010;
	parameter [2:0] D = 3'b110;
	parameter [2:0] E = 3'b111)
	(
	input i_clk,
	input i_col_rst,
	input i_insert_en,
	input [2:0] i_coin,
	output reg [31:0] o_collected
	);
	

	// Calculating the COLLECTED amount of money
	always @ (posedge i_clk or posedge i_col_rst)
	begin
		if (i_col_rst) o_collected <= 0;
		else
		begin
			if(i_insert_en)
			begin
				if (~i_coin[0])
					o_collected <= o_collected + 10;
				else if(~i_coin[1])
					o_collected <= o_collected + 25;
				else if (~i_coin[2])
					o_collected <= o_collected + 100;
			end
		end
	end
endmodule
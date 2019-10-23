module ee271_final_proj_vendingmachine(clk, confirm, cancel, coin, item_sel, amt_sel, a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg, item_name, item_amt, change, state, next_state);
  input        clk, confirm, cancel;
  input  [2:0] coin;
  input  [2:0] item_sel;
  input  [1:0] amt_sel;
  output reg [1:0] a_amt, b_amt, c_amt, d_amt, e_amt;
  output reg [5:0] a_chg, b_chg, c_chg, d_chg, e_chg;
  output reg [2:0] item_name;
  output reg [1:0] item_amt;
  output reg [5:0] change;
  output reg [4:0] state, next_state;

  parameter [2:0]     A =  3'b001;
  parameter [2:0]     B =  3'b010;
  parameter [2:0]     C =  3'b011;
  parameter [2:0]     D =  3'b100;
  parameter [2:0]     E =  3'b101;

  parameter [3:0] price_a = 4'b0101;
  parameter [3:0] price_b = 4'b0110;
  parameter [3:0] price_c = 4'b0111;
  parameter [3:0] price_d = 4'b1000;
  parameter [3:0] price_e = 4'b1010;
  
  parameter [4:0]   S00 =  5'b00000;
  parameter [4:0]   S05 =  5'b00101;
  parameter [4:0]   S10 =  5'b01010;
  parameter [4:0]   S15 =  5'b01111;
  parameter [4:0]   S20 =  5'b10100;
  parameter [4:0]   S25 =  5'b11001;
  parameter [4:0]   S30 =  5'b11110;
  parameter [39:0] OC00 = 40'b0000000000000000000000000000000000000000;
  parameter [39:0] OC05 = 40'b0100000000000000000000000000000000000000;
  parameter [39:0] OC10 = 40'b1001010101000000000100000011000010000000;
  parameter [39:0] OC15 = 40'b1110100101000000000011000001000111000101;
  parameter [39:0] OC20 = 40'b1111101010000101000010000110000100000000;
  parameter [39:0] OC25 = 40'b1111111110001010000111000100000001000101;
  parameter [39:0] OC30 = 40'b1111111111001111001100001001000110000000;
  parameter [39:0] OC35 = 40'b1111111111010100010001001110001011000101;
  parameter [39:0] OC40 = 40'b1111111111011001010110010011010000001010;
  parameter [39:0] OC45 = 40'b1111111111011110011011011000010101001111;
  parameter [39:0] OC50 = 40'b1111111111100011100000011101011010010100;
  parameter [39:0] OC55 = 40'b1111111111101000100101100010011111011001;

  always @ (*)
    begin
      next_state = S00;

      case(state)
	S00:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC00;
	      end
	    3'b001:
	      begin
	        next_state = S05;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC05;
	      end
	    3'b010:
	      begin
	        next_state = S10;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC10;
	      end
	    3'b100:
	      begin
	        next_state = S25;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC25;
	      end
	    default:
	      begin
		next_state = S00;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC00;
	      end
	  endcase
	S05:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S05;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC05;
	      end
	    3'b001:
	      begin
	        next_state = S10;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC10;
	      end
	    3'b010:
	      begin
	        next_state = S15;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC15;
	      end
	    3'b100:
	      begin
	        next_state = S30;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC30;
	      end
	    default:
	      begin
		next_state = S05;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC05;
	      end
	  endcase
	S10:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S10;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC10;
	      end
	    3'b001:
	      begin
	        next_state = S15;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC15;
	      end
	    3'b010:
	      begin
	        next_state = S20;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC20;
	      end
	    3'b100:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC35;
	      end
	    default:
	      begin
		next_state = S10;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC10;
	      end
	  endcase
	S15:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S15;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC15;
	      end
	    3'b001:
	      begin
	        next_state = S20;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC20;
	      end
	    3'b010:
	      begin
	        next_state = S25;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC25;
	      end
	    3'b100:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC40;
	      end
	    default:
	      begin
		next_state = S15;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC15;
	      end
	  endcase
	S20:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S20;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC20;
	      end
	    3'b001:
	      begin
	        next_state = S25;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC25;
	      end
	    3'b010:
	      begin
	        next_state = S30;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC30;
	      end
	    3'b100:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC45;
	      end
	    default:
	      begin
		next_state = S20;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC20;
	      end
	  endcase
	S25:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S25;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC25;
	      end
	    3'b001:
	      begin
	        next_state = S30;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC30;
	      end
	    3'b010:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC35;
	      end
	    3'b100:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC50;
	      end
	    default:
	      begin
		next_state = S25;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC25;
	      end
	  endcase
	S30:
	  case(coin)
	    3'b000:
	      begin
	        next_state = S30;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC30;
	      end
	    3'b001:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC35;
	      end
	    3'b010:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC40;
	      end
	    3'b100:
	      begin
	        next_state = S00;
	        {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC55;
	      end
	    default:
	      begin
		next_state = S30;
		{a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC30;
	      end
	endcase
      endcase
    end

    always @ (posedge clk)
      begin
	if (cancel)
	  begin
	    state <= S00;
	    {a_amt, b_amt, c_amt, d_amt, e_amt, a_chg, b_chg, c_chg, d_chg, e_chg} = OC00;
	  end
	else
	  begin
	    state <= next_state;
	    case (item_sel)
	      A:
	        if (a_amt == amt_sel)
		  begin
		    item_name <= A;
		    item_amt  <= a_amt;
		    change    <= next_state - (price_a * amt_sel);
		  end
		else
		  begin
		    item_name <= A;
		    item_amt  <= 0;
		    change    <= 0;
	  	  end
	      B:
	        if (b_amt >= amt_sel)//////
		  begin
		    item_name <= B;
		    item_amt  <= amt_sel;
		    change    <= next_state - (price_b * amt_sel);
		  end
		else
		  begin
		    item_name <= B;
		    item_amt  <= 0;
		    change    <= 0;
	  	  end
	      C:
	        if (c_amt == amt_sel)
		  begin
		    item_name <= C;
		    item_amt  <= c_amt;
		    change    <= next_state - (price_c * amt_sel);
		  end
		else
		  begin
		    item_name <= C;
		    item_amt  <= 0;
		    change    <= 0;
	  	  end
	      D:
	        if (d_amt == amt_sel)
		  begin
		    item_name <= D;
		    item_amt  <= d_amt;
		    change    <= next_state - (price_d * amt_sel);
		  end
		else
		  begin
		    item_name <= D;
		    item_amt  <= 0;
		    change    <= 0;
	  	  end
	      E:
	        if (e_amt == amt_sel)
		  begin
		    item_name <= E;
		    item_amt  <= e_amt;
		    change    <= next_state - (price_e * amt_sel);
		  end
		else
		  begin
		    item_name <= E;
		    item_amt  <= 0;
		    change    <= 0;
	  	  end
	      default:
		begin
		  item_name <= 0;
		  item_amt  <= 0;
		  change    <= 0;
		end
	    endcase
	  end
      end
  
endmodule

module simulation_tb ();
  reg         clk, cancel, continue_;
  reg [4:0]   item_sel;
  reg [2:0]   amt_sel;
  reg         DIME;
  reg         QUATER;
  reg         DOLLAR;

  wire [31:0] collected;
  wire [31:0] change;
  wire [7:0]  col_seven_1;
  wire [7:0]  col_seven_2;
  wire [7:0]  col_seven_3;
  wire [7:0]  ch_seven_1;
  wire [7:0]  ch_seven_2;
  wire [7:0]  ch_seven_3;
  wire [4:0]  item_LED;
  wire [2:0]  amt_LED;
  wire [2:0]  state, next_state;

  simulation test(.clk(clk), .cancel(cancel), .continue_(continue_), .item_sel(item_sel), .amt_sel(amt_sel), .DIME(DIME), .QUATER(QUATER), .DOLLAR(DOLLAR), .col_seven_1(col_seven_1), .col_seven_2(col_seven_2), .col_seven_3(col_seven_3), .ch_seven_1(ch_seven_1), .ch_seven_2(ch_seven_2), .ch_seven_3(ch_seven_3), .item_LED(item_LED), .amt_LED(amt_LED), .state(state), .next_state(next_state), .collected(collected), .change(change));

  initial begin
	#100
	item_sel = 5'b00001;
	#20
	item_sel = 0;
	#100
	DIME = 0;
	#20
	DIME = 1;
	#100
	DOLLAR = 0;
	#20
	DOLLAR = 1;
	#100
	continue_ = 1;
	#20
	continue_ = 0;
	#300
	item_sel = 5'b00010;
	#20
	item_sel = 0;
	#100
	DIME = 0;
	#20
	DIME = 1;
	#100
	cancel = 1;
	#20
	cancel = 0;
	#100
	continue_ = 1;
	#20
	continue_ = 0;
	#300
	item_sel = 5'b01000;
	#20
	item_sel = 0;
	#100
	amt_sel = 3'b100;
	#20
	amt_sel = 0;
	#100
	DOLLAR = 0;
	#20
	DOLLAR = 1;
	#100
	DOLLAR = 0;
	#20
	DOLLAR = 1;
	#100
	DOLLAR = 0;
	#20
	DOLLAR = 1;
	#100
	QUATER = 0;
	#20
	QUATER = 1;
	#100
	QUATER = 0;
	#20
	QUATER = 1;
	#100
	DIME = 0;
	#20
	DIME = 1;
	#100
	continue_ = 1;
	#20
	continue_ = 0;
  end

  initial begin : clock_loop
    clk = 0;
    forever begin
      #1 clk = 1;
      #1 clk = 0;
    end
  end

  initial begin
    $monitor("STATE:%d|N STATE: %d|COLLECTED:%d(%b %b %b)|ITEM: %b|AMOUNT: %b|CHANGE: %d(%b %b %b)|@ %0t", state, next_state, collected, col_seven_1, col_seven_2, col_seven_3, item_LED, amt_LED, change, ch_seven_1, ch_seven_2, ch_seven_3, $time);
    $dumpfile("simulation_tb.vcd");
    $dumpvars();
    #3000 disable clock_loop;
    $finish;
  end
endmodule

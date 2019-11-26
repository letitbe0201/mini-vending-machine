module ee271_final_proj_v2_tb ();
  reg       tclk, tcancel, tcontinue;
  reg [4:0] titem_sel;
  reg [2:0] tamt_sel;
  reg       tDIME;
  reg       tQUATER;
  reg       tDOLLAR;

  wire [7:0] tcol_seven_1;
  wire [7:0] tcol_seven_2;
  wire [7:0] tcol_seven_3;
  wire [7:0] tch_seven_1;
  wire [7:0] tch_seven_2;
  wire [7:0] tch_seven_3;
  wire       titem_A;
  wire       titem_B;
  wire       titem_C;
  wire       titem_D;
  wire       titem_E;
  wire       tamt_1;
  wire       tamt_2;
  wire       tamt_3;

  ee271_final_proj_v2_5 test(.clk(tclk), .cancel(tcancel), .continue_(tcontinue), .item_sel(titem_sel), .amt_sel(tamt_sel), .DIME(tDIME), .QUATER(tQUATER), .DOLLAR(tDOLLAR), .col_seven_1(tcol_seven_1), .col_seven_2(tcol_seven_2), .col_seven_3(tcol_seven_3), .ch_seven_1(tch_seven_1), .ch_seven_2(tch_seven_2), .ch_seven_3(tch_seven_3), .item_A(titem_A), .item_B(titem_B), .item_C(titem_C), .item_D(titem_D), .item_E(titem_E), .amt_1(tamt_1), .amt_2(tamt_2), .amt_3(tamt_3));

  initial begin
    #6
    titem_sel = 5'b00001;
    #3
    titem_sel = 0;
    #12
    tDIME = 1;
    #3
    tDIME = 0;
    #8
    tQUATER = 1;
    #3
    tQUATER = 0;
    #10
    tcancel = 1;
    #3
    tcancel = 0;
    #5
    tcontinue = 1;
    #3
    tcontinue = 0;
    #10
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #4
    tamt_sel = 3'b001;
    #3
    tamt_sel = 3'b000;
    #10
    tcancel = 1;
    #3
    tcancel = 0;
    #18
    tcontinue = 1;
    #3
    tcontinue = 0;
    #9
    titem_sel = 5'b00010;
    #3
    titem_sel = 0;
    #7
    tamt_sel = 3'b010;
    #3
    tamt_sel = 3'b000;
    #15
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #15
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #15
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #9
    tcontinue = 1;
    #3
    tcontinue = 0;
    #6
    //tQUATER = 1;
    #3
    //tQUATER = 0;
    #4
    tcancel = 1;
    #3
    tcancel = 0;
    #5
    tcontinue = 1;
    #3
    tcontinue = 0;
    #6
    tcancel = 1;
    #3
    tcancel = 0;
    #8
    tDIME = 1;
    #3
    tDIME = 0;
    #10
    titem_sel = 5'b01000;
    #3
    titem_sel = 0;
    #5
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #6
    tamt_sel = 3'b010;
    #3
    tamt_sel = 3'b000;
    #8
    titem_sel = 2;
    #3
    titem_sel = 0;
    #4
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #5
    tcontinue = 1;
    #2
    tcontinue = 0;
    
    //tcancel = 1;
    #3
    //tcancel = 0;
    #4
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #10
    tcancel = 1;
    #3
    tcancel = 0;
    #10
    tcontinue = 1;
    #3
    tcontinue = 0;




  end

  initial begin : clock_loop
    tclk = 0;
    forever begin
      #1 tclk = 1;
      #1 tclk = 0;
    end
  end
  
  initial begin
    $monitor("Collected: %b %b %b | item: A%b B%b C%b D%b E%b | amount: one:%b two:%b three:%b | delivery:// | change: %b %b %b | @ %0t", tcol_seven_1, tcol_seven_2, tcol_seven_3, titem_A, titem_B, titem_C, titem_D, titem_E, tamt_1, tamt_2, tamt_3, tch_seven_1, tch_seven_2, tch_seven_3, $time);
    $dumpfile("ee271_final_proj_v2_2_tb.vcd");
    $dumpvars();
    #400 disable clock_loop;
    $finish;
  end
endmodule

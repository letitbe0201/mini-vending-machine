module ee271_final_proj_v2_tb ();
  reg       tclk, tcancel, tcontinue;
  reg [2:0] titem_sel;
  reg [1:0] tamt_sel;
  reg       tDIME;
  reg       tQUATER;
  reg       tDOLLAR;

  wire [2:0] tstate, tnext_state;
  wire [9:0] tcollected;
  wire [9:0] tchange;
  wire [2:0] titem;
  wire [1:0] tamt;
  wire [2:0] tdelivery;

  ee271_final_proj_v2 test(.clk(tclk), .cancel(tcancel), .continue(tcontinue), .item_sel(titem_sel), .amt_sel(tamt_sel), .DIME(tDIME), .QUATER(tQUATER), .DOLLAR(tDOLLAR), .state(tstate), .next_state(tnext_state), .collected(tcollected), .change(tchange), .item(titem), .amt(tamt), .delivery(tdelivery));

  initial begin
    #6
    titem_sel = 5;
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
    tamt_sel = 3;
    #3
    tamt_sel = 0;
    #10
    tcancel = 1;
    #3
    tcancel = 0;
    #18
    tcontinue = 1;
    #3
    tcontinue = 0;
    #9
    titem_sel = 4;
    #3
    titem_sel = 0;
    #7
    tamt_sel = 2;
    #3
    tamt_sel = 0;
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
    titem_sel = 5;
    #3
    titem_sel = 0;
    #5
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #6
    tamt_sel = 2;
    #3
    tamt_sel = 0;
    #8
    titem_sel = 2;
    #3
    titem_sel = 0;
    #4
    tDOLLAR = 1;
    #3
    tDOLLAR = 0;
    #5
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
    $monitor("collected: %d | item: %d | delivery: %d | change: %d | @ %0t", tcollected, titem, tdelivery, tchange, $time);
    $dumpfile("ee271_final_proj_v2_tb.vcd");
    $dumpvars();
    #400 disable clock_loop;
    $finish;
  end
endmodule

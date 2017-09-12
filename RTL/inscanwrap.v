
module inscanwrap (
		   input 
		   TDR_CAPTURE,
		   TDR_SHIFT,
		   TDR_UPDATE,
		   TDR_TCK,
		   TDR_TRESETN,
		   safe_val,
		   ScanWrpClk,
		   INSCANWRAP_TDR_EN,// come from where ?
		   OUTSCANWRAP_TDR_EN,// come from where ?
		   ScanShiftEn,
		   wrp_if,//what for ?
		   wrp_of,// also ? 
		   inscanwrap_sel,// from tdr to select between JTAG or SCAN mode or ? 
		   CFI,
		   CTI,

		   output reg
		   CFO,
		   CTO
		   );
   
   reg 			     SHIFT_FF,UPDATE_FF;
   wire 		     mux1_mux3;
   wire 		     mux2_mux3;
   wire 		     mux4_shiftflop;
   wire 		     gaterSh_mux4;
   wire 		     mux3_SHIFT_FF;
   wire 		     mux4_SHIFT_FF;
   wire 		     gaterUp_mux6;
   wire 		     mux6_UPDATE_FF;
   wire 		     WSO;
   wire 		     SO;
   wire 		     mux7_mux8;
   wire 		     mux8_mux1;
   
   
   mux21 mux1(.in0(CFO),
	    .in1(CFI),
	    .select(wrp_of&~ScanShiftEn),
	    .out(mux1_mux3)
	    );
   
   mux21 mux2(.in0(ScanShiftEn),
	    .in1(INSCANWRAP_TDR_EN&TDR_SHIFT),
	    .select(INSCANWRAP_TDR_EN|OUTSCANWRAP_TDR_EN),
	    .out(mux2_mux3)
	    );
   mux21 mux3(.in0(mux1_mux3),
	    .in1(CTI),
	    .select(mux2_mux3),
	    .out(mux3_SHIFT_FF) // D for shift reg
	    );
   
   ClkGater gaterSh(.clk(TDR_TCK),
		    .en((TDR_SHIFT|TDR_CAPTURE)&&(INSCANWRAP_TDR_EN|OUTSCANWRAP_TDR_EN)),
		    .clk_out(gaterSh_mux4)
		    );
   
   mux21 mux4(.in0(ScanWrpClk),
	    .in1(gaterSh_mux4),
	    .select(INSCANWRAP_TDR_EN|OUTSCANWRAP_TDR_EN),
	    .out(mux4_SHIFT_FF)//clock for shift reg
	    );
   mux21   mux5(.in0(WSO),
	      .in1(SO),
	      .select(INSCANWRAP_TDR_EN|OUTSCANWRAP_TDR_EN),
	      .out(CTO)// CONTROL TEST OUTPUT 
	      );
   
   ClkGater gaterUp(.clk(TDR_TCK),
		    .en(TDR_UPDATE&&INSCANWRAP_TDR_EN),
		    .clk_out(gaterUp_mux6)
		    );
   mux21 mux6(.in0(ScanWrpClk),
	    .in1(gaterUp_mux6),
	    .select(INSCANWRAP_TDR_EN|OUTSCANWRAP_TDR_EN),
	    .out(mux6_UPDATE_FF)//UPD FLOP CLK 
	    );
   mux21 mux7(.in0(SO),
	    .in1(safe_val),
	    .select(wrp_of|ScanShiftEn),
	    .out(mux7_mux8)
	    );

   mux21 mux8(.in0(CFI),
	    .in1(mux7_mux8),
	    .select(wrp_of|inscanwrap_sel),
	    .out(mux8_mux1)
	    );
   
   //shift//
     always @(posedge mux4_SHIFT_FF or negedge TDR_TRESETN)
       if(~TDR_TRESETN)
	 SHIFT_FF<=1'b0;
       else 
	 SHIFT_FF<=mux3_SHIFT_FF;
   assign WSO=SHIFT_FF;
   
   //update//
     always @(negedge  mux6_UPDATE_FF or negedge TDR_TRESETN)
       if(~TDR_TRESETN)
	 UPDATE_FF<=1'b0;
       else 
       UPDATE_FF<=WSO;
   assign SO=UPDATE_FF;
endmodule // inscanwrap

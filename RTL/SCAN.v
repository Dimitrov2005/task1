module scan(
	    input
	    CTI,
	    CFI1,
	    CFI2,
	    CFI3,
	    TDR_CAPTURE,
	    TDR_SHIFT,
	    TDR_UPDATE,
	    TDR_TCK,
	    TDR_TRESETN,
	    INSCANWRAP_TDR_EN,
	    OUTSCANWRAP_TDR_EN,
	    inscanwrap_sel,
	    outscanwrap_sel,
	    core_phy_func_in1,
	    core_phy_func_in2,
	    core_phy_func_in3,
	    output
	    phy_func_in1_core,
	    phy_func_in2_core,
	    phy_func_in3_core,
	    CFO1,
	    CFO2,
	    CFO3,
	    CTO
	    );
   
 
   wire 	  incellt1_incellt2; 
   wire 	  incellt2_incellt3;
   wire 	  outcellt1_outcellt2;
   wire 	  outcellt2_outcellt3;
   
   inscanwrap incell1( .TDR_CAPTURE(TDR_CAPTURE),
		       .TDR_SHIFT (TDR_SHIFT),
		       .TDR_UPDATE(TDR_UPDATE),
		       .TDR_TCK(TDR_TCK),
		       .TDR_TRESETN(TDR_TRESETN),
		       .safe_val(1'b1),
		       .ScanWrpClk(1'b0),
		       .INSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// come from where ?
		       .OUTSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// come from where ?
		       .ScanShiftEn(1'b0),
		       .wrp_if(1'b0),//what for ?
		       .wrp_of(1'b0),// also ? 
		       .inscanwrap_sel(inscanwrap_sel),//select between JTAG or SCAN mode? 
		       .CFI(core_phy_func_in1),
		       .CTI(CTI),
		       .CTO(incellt1_incellt2),
		       .CFO(phy_func_in1_core)
		       );
   
   inscanwrap incell2( .TDR_CAPTURE(TDR_CAPTURE),
			   .TDR_SHIFT (TDR_SHIFT),
			   .TDR_UPDATE(TDR_UPDATE),
			   .TDR_TCK(TDR_TCK),
			   .TDR_TRESETN(TDR_TRESETN),
			   .safe_val(1'b1),
			   .ScanWrpClk(1'b0),
			   .INSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// come from where ?
			   .OUTSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// come from where ?
			   .ScanShiftEn(1'b0),
			   .wrp_if(1'b0),//what for ?
			   .wrp_of(1'b0),// also ? 
			   .inscanwrap_sel(inscanwrap_sel),//select between JTAG or SCAN mode? 
			   .CFI(core_phy_func_in2),
			   .CTI(incellt1_incellt2),
			   .CTO(incellt2_incellt3),
			   .CFO(phy_func_in2_core)
			   );
     
   inscanwrap incell3( .TDR_CAPTURE(TDR_CAPTURE),
			   .TDR_SHIFT (TDR_SHIFT),
			   .TDR_UPDATE(TDR_UPDATE),
			   .TDR_TCK(TDR_TCK),
			   .TDR_TRESETN(TDR_TRESETN),
			   .safe_val(1'b1),
			   .ScanWrpClk(1'b0),
			   .INSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// come from where ?
			   .OUTSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// come from where ?
			   .ScanShiftEn(1'b0),
			   .wrp_if(1'b0),//what for ?
			   .wrp_of(1'b0),// also ? 
			   .inscanwrap_sel(inscanwrap_sel),//select between JTAG or SCAN mode? 
			   .CFI(core_phy_func_in3),
			   .CTI(incellt2_incellt3),
			   .CTO(CTO),
			   .CFO(phy_func_in3_core)
			   );
   
   inscanwrap outcell1( .TDR_CAPTURE(TDR_CAPTURE),
			   .TDR_SHIFT (TDR_SHIFT),
			   .TDR_UPDATE(TDR_UPDATE),
			   .TDR_TCK(TDR_TCK),
			   .TDR_TRESETN(TDR_TRESETN),
			   .safe_val(1'b1),
			   .ScanWrpClk(1'b0),
			   .INSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// come from where ?
			   .OUTSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// come from where ?
			   .ScanShiftEn(1'b0),
			   .wrp_if(1'b0),//what for ?
			   .wrp_of(1'b0),// also ? 
			   .inscanwrap_sel(outscanwrap_sel),//select between JTAG or SCAN mode? 
			   .CFI(CFO1), // output from phy to scanwrap
			   .CTI(CTO),
			   .CTO(outcellt1_outcellt2),
			   .CFO(CFI1)// otput from scanwrap to core
			   );
   
   inscanwrap outcell2( .TDR_CAPTURE(TDR_CAPTURE),
			   .TDR_SHIFT (TDR_SHIFT),
			   .TDR_UPDATE(TDR_UPDATE),
			   .TDR_TCK(TDR_TCK),
			   .TDR_TRESETN(TDR_TRESETN),
			   .safe_val(1'b1),
			   .ScanWrpClk(1'b0),
			   .INSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// come from where ?
			   .OUTSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// come from where ?
			   .ScanShiftEn(1'b0),
			   .wrp_if(1'b0),//what for ?
			   .wrp_of(1'b0),// also ? 
			   .inscanwrap_sel(outscanwrap_sel),//select between JTAG or SCAN mode? 
			   .CFI(CFO2),
			   .CTI(outcellt1_outcellt2),
			   .CTO(outcellt2_outcellt3),
			   .CFO(CFI2)
			   );
   
   inscanwrap outcell3( .TDR_CAPTURE(TDR_CAPTURE),
			   .TDR_SHIFT (TDR_SHIFT),
			   .TDR_UPDATE(TDR_UPDATE),
			   .TDR_TCK(TDR_TCK),
			   .TDR_TRESETN(TDR_TRESETN),
			   .safe_val(1'b1),
			   .ScanWrpClk(1'b0),
			   .INSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),// select 2 bits from tdr0 to connect to it
			   .OUTSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),// from TDR1
			   .ScanShiftEn(1'b0),
			   .wrp_if(1'b0),//what for ?
			   .wrp_of(1'b0),// also ? 
			   .inscanwrap_sel(outscanwrap_sel),//from IR 
			   .CFI(CFO3),
			   .CTI(outcellt2_outcellt3),
			   .CTO(CTO),
			   .CFO(CFI3)
			   );
   
endmodule // scan

module DFTG (input 
	     TMS,
	     TCLK,
	     TRESETN,
	     WSI, 
	     core_phy_func_in1,
	     core_phy_func_in2,
	     core_phy_func_in3,
	     output 
	     WSO,
	     phy_func_in1_core,
	     phy_func_in2_core,
	     phy_func_in3_core
	     );

   wire 	    CaptureDR;
   wire 	    ShiftDR;
   wire 	    UpdateDR;
   wire 	    CaptureIR;
   wire 	    ShiftIR;
   wire 	    UpdateIR;
   wire 	    CaptureDR_neg;
   wire 	    ShiftDR_neg;
   wire 	    CaptureIR_neg;
   wire 	    ShiftIR_neg;
   wire 	    en1;
   wire 	    en2;
   wire 	    si1_mux;
   wire 	    si2_mux;
   wire 	    INSCANWRAP_TDR_EN;
   wire 	    OUTSCANWRAP_TDR_EN;
   wire 	    scan_incell_chain_out;
   wire 	    scan_outcell_chain_out;
   wire 	    CFI1;
   wire 	    CFI2;
   wire 	    CFI3;
   wire 	    CFO1;
   wire 	    CFO2;
   wire 	    CFO3;
   wire [7:0] 	    ir_po;
   wire [7:0] 	    tdr_po; 	    
  

	
   STAC fsm(.TMS(TMS),
	   .TDI(WSI),
	   .TRSTN(TRESETN),
	   .TCLK(TCLK),
	   .CaptureDR(CaptureDR),
	   .ShiftDR(ShiftDR),
	   .UpdateDR(UpdateDR),
	   .CaptureIR(CaptureIR),
	   .ShiftIR(ShiftIR),
	   .UpdateIR(UpdateIR),
	   .CaptureDR_neg(CaptureDR_neg),
	   .ShiftDR_neg(ShiftDR_neg),
	   .CaptureIR_neg(CaptureIR_neg),
	   .ShiftIR_neg(ShiftIR_neg)
	   );

   dec dec1(.x(ir_po),
	    .EN1(en1),
	    .EN2(en2),
	    .EN3(INSCANWRAP_TDR_EN),
	    .EN4(OUTSCANWRAP_TDR_EN)
	    );
	  

   mux mux1( .SO1(si1_mux),
	     .SO2(si2_mux),
	     .SO3(scan_incell_chain_out),
	     .SO4(scan_outcell_chain_out),
	     .e(ir_po),
	     .WSO(WSO)
	     );
  
   IR ir1( .CaptureIR(CaptureIR_neg),
	   .ShiftIR(ShiftIR_neg),
	   .UpdateIR(UpdateIR), 
	   .TRESETN(TRESETN),
	   .TCLK(TCLK),          
	   .SI(WSI), 
	   .PO(ir_po)
	   );
   
   TDRRW tdr1(.CaptureDR(CaptureDR_neg),
	.ShiftDR(ShiftDR_neg),
	.UpdateDR(UpdateDR),
	.Enable(en1),
	.TRESETN(TRESETN),
	.TCLK(TCLK), 
	.SI(WSI),
	.SO(si1_mux),
	.PO(tdr_po)	     
	);
   
   TDRR  tdr2(.CaptureDR(CaptureDR_neg), 
	.ShiftDR(ShiftDR_neg),
	.UpdateDR(UpdateDR),
	.Enable(en2),
	.TRESETN(TRESETN),
	.TCLK(TCLK), 
	.SI(WSI),
	.PI(33'hca),// connect to constant 
	.SO(si2_mux)
	);
   
   scan ScanWrapper( // connect scanwrapper inputs/outputs
		     .CTII(WSI),
		     .CTIO(WSI),
		     .CFI1(CFI1),
		     .CFI2(CFI2),
		     .CFI3(CFI3),
		     .TDR_CAPTURE(CaptureDr),
		     .TDR_SHIFT(ShiftDR),
		     .TDR_UPDATE(UpdateDR),
		     .TDR_TCK(TCLK),
		     .TDR_TRESETN(TRESETN),
		     .INSCANWRAP_TDR_EN(INSCANWRAP_TDR_EN),
		     .OUTSCANWRAP_TDR_EN(OUTSCANWRAP_TDR_EN),
		     .inscanwrap_sel(tdr_po[0]),//one bit from tdr RW
		     .outscanwrap_sel(tdr_po[1]),// one bit from TDR RW
		     .core_phy_func_in1(1'bx),
		     .core_phy_func_in2(1'bx),
		     .core_phy_func_in3(1'bx),
		     .phy_func_in1_core(phy_func_in1_core),
		     .phy_func_in2_core(phy_func_in2_core),
		     .phy_func_in3_core(phy_func_in3_core),
		     .CFO1(CFO1),
		     .CFO2(CFO2),
		     .CFO3(CFO3),
		     .CTOI(scan_incell_chain_out),
		     .CTOO(scan_outcell_chain_out)
		     );
   phy PHY1(
	    .in1(CFI1),
	    .in2(CFI2),
	    .in3(CFI3),
	    .out1(CFO1),
	    .out2(CFO2),
	    .out3(CFO3)
	    );
endmodule // STAC

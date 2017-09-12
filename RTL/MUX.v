module mux(input
	   SO1,
	   SO2,
	   SO3,
	   SO4,
	   [7:0]e,
	   output reg WSO
	   );
   
   always @(e or SO1 or SO2)
     begin
	case(e)
	  8'h45:WSO=SO1;
	  8'h77:WSO=SO2;
	  8'h54:WSO=SO3;
	  8'h55:WSO=SO4;
	  default :WSO=1'bx; //other instructions drive x
	endcase
     end
endmodule // mux


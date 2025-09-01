module Bridge_Top(Hclk,Hresetn,Hwrite,Hreadyin,Hreadyout,Hwdata,Haddr,Htrans,Prdata,Penable,Pwrite,Pselx,Paddr,Pwdata,Hreadyout,Hresp,Hrdata);

input Hclk,Hresetn,Hwrite,Hreadyin;
input [31:0] Hwdata,Haddr,Prdata;
input[1:0] Htrans;
output Penable,Pwrite,Hreadyout;
output [1:0] Hresp; 
output [2:0] Pselx;
output [31:0] Paddr,Pwdata;
output [31:0] Hrdata;

//INTERMEDIATE SIGNALS

wire valid;
wire [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
wire Hwritereg;
wire [2:0] tempselx;

// MODULE INSTANTIATIONS

AHB_SLAVE_interface AHBSlave (
	Hclk,
	Hresetn,
	Hwrite,
	Hreadyin,
	Htrans,
	Haddr,
	Hwdata,
	Hresp,
	Hrdata,
	valid,
	Haddr1,
	Haddr2,
	Hwdata1,
	Hwdata2,
	Hwritereg,
	Hwritereg1,
	tempselx,
	Prdata);

APB_controller APBControl ( Hclk,Hresetn,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Prdata,Hwrite,Haddr,Hwdata,Hwritereg,tempselx,Pwrite,Penable,Pselx,Paddr,Pwdata,Hreadyout);

endmodule


module AHB_SLAVE_interface (
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

input   Hclk,
	Hresetn,
	Hwrite,
	Hreadyin;

input [1:0] Htrans;

input [31:0] Haddr,Hwdata,Prdata;

output reg [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;

output [31:0] Hrdata; 

output reg valid, Hwritereg, Hwritereg1;

output reg [2:0] tempselx;

output  [1:0] Hresp;

// pipeline logic for address
always@(posedge Hclk)
begin
	if(!Hresetn)
	begin
		Haddr1 <= 32'b0;
		Haddr2 <= 32'b0;
	end
	else 
	begin
		Haddr1 <= Haddr;
		Haddr2 <= Haddr1;
	end
end

// pipeline logic for data
always@(posedge Hclk)
begin
	if(!Hresetn)
	begin
		Hwdata1 <= 32'b0;
		Hwdata2 <= 32'b0;
	end
	else 
	begin
		Hwdata1 <= Hwdata;
		Hwdata2 <= Hwdata1;
	end
end

// pipeline logic for Hwritereg
always@(posedge Hclk)
begin
	if(!Hresetn)
	begin
		Hwritereg <= 32'b0;
		Hwritereg1 <= 32'b0;
	end
	else 
	begin
		Hwritereg <= Hwrite;
		Hwritereg1 <= Hwritereg;
	end
end

//Implementing tempselx logic // logic for selecting peripheral
always@(*)
begin
	tempselx=3'b000;
	if (Hresetn && Haddr>=32'h8000_0000 && Haddr<32'h8400_0000)
		tempselx=3'b001;

	else if (Hresetn && Haddr>=32'h8400_0000 && Haddr<32'h8800_0000)
		tempselx=3'b010;

	else if (Hresetn && Haddr>=32'h8800_0000 && Haddr<32'h8C00_0000)
		tempselx=3'b100;

end

// Implementing valid logic
always @(Hreadyin,Haddr,Htrans,Hresetn)
begin
	
	if (Hresetn && Hreadyin && (Haddr>=32'h8000_0000 || Haddr<32'h8C00_0000) && (Htrans==2'b10 || Htrans==2'b11) )
		valid=1'b1;
	else
		valid=1'b0;

end

assign Hrdata = Prdata;
assign Hresp=2'b00;

endmodule

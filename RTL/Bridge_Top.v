module Bridge_Top(
    input  Hclk,
    input  Hresetn,
    input  Hwrite,
    input  Hreadyin,
    input  [31:0] Hwdata,
    input  [31:0] Haddr,
    input  [31:0] Prdata,
    input  [1:0]  Htrans,
    output Penable,
    output Pwrite,
    output Hreadyout,
    output [1:0]  Hresp, 
    output [2:0]  Pselx,
    output [31:0] Paddr,
    output [31:0] Pwdata,
    output [31:0] Hrdata
);

// INTERMEDIATE SIGNALS
wire valid;
wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
wire Hwritereg;
wire [2:0] tempselx;

// MODULE INSTANTIATIONS
AHB_SLAVE_interface AHBSlave (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Htrans(Htrans),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hresp(Hresp),
    .Hrdata(Hrdata),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Prdata(Prdata)
);

APB_controller APBControl (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Prdata(Prdata),
    .Hwrite(Hwrite),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout)
);

endmodule

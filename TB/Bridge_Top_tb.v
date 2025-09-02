module Bridge_Top_tb;

    reg Hclk;
    reg Hresetn;
    wire Hreadyin;
    wire [31:0] Prdata;
    wire [1:0] Htrans;

    wire Penable;
    wire Pwrite;
    wire [2:0] Pselx;
    wire [31:0] Paddr;
    wire [31:0] Pwdata;
    wire [31:0] Hrdata;
    wire Hreadyout;
    wire [1:0] Hresp;

    // Intermediate
    wire Hwrite;
    wire [31:0] Hwdata;
    wire [31:0] Haddr;

    // Instantiate the DUT (Device Under Test)
   Bridge_Top uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Hwdata(Hwdata),
    .Haddr(Haddr),
    .Prdata(Prdata),
    .Htrans(Htrans),
    .Penable(Penable),
    .Pwrite(Pwrite),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout),
    .Hresp(Hresp),
    .Hrdata(Hrdata)
);

        
    // Instantiate the AHB Master
    AHB_Master master (
        .Hclk(Hclk),
        .Hresetn(Hresetn),
        .Hreadyout(Hreadyout),
        .Hrdata(Hrdata),
        .Haddr(Haddr),
        .Hwdata(Hwdata),
        .Hwrite(Hwrite),
        .Hreadyin(Hreadyin),
        .Htrans(Htrans)
    );

   // Instantiate APB Interface
  APB_Interface slave (
        .Pwrite(Pwrite),
        .Pselx(Pselx),
        .Penable(Penable),
        .Paddr(Paddr),
        .Pwdata(Pwdata),
        .Pwriteout(),    // unconnected
        .Pselxout(),     // unconnected
        .Penableout(),   // unconnected
        .Paddrout(),     // unconnected
        .Pwdataout(),    // unconnected
        .Prdata(Prdata)
    );

    initial 
	begin
        // Initialize Inputs
        Hclk = 1'b0;
        forever #10 Hclk=~Hclk;
	end

	task reset();
	begin
	    @(negedge Hclk)
		Hresetn=1'b0;
	    @(negedge Hclk)
		Hresetn=1'b1;
	end
	endtask   
    
     initial
	  begin
	 reset;
         master.single_write();
        //master.single_read();
	//master.burst_write();
	//master.burst_read(); 
   	 end
     initial #200 $finish;
endmodule


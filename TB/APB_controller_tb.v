
`timescale 1ns / 1ps

module APB_controller_tb;

    // Inputs
    reg Hclk;
    reg Hresetn;
    reg valid;
    reg Hwrite;
    reg Hwritereg;
    reg [31:0] Haddr1;
    reg [31:0] Haddr2;
    reg [31:0] Hwdata1;
    reg [31:0] Hwdata2;
    reg [31:0] Prdata;
    reg [31:0] Haddr;
    reg [31:0] Hwdata;
    reg [2:0] tempselx;

    // Outputs
    wire Pwrite;
    wire Penable;
    wire [2:0] Pselx;
    wire [31:0] Paddr;
    wire [31:0] Pwdata;
    wire Hreadyout;

    // Instantiate the DUT (Device Under Test)
    APB_FSM_Controller uut (
        .Hclk(Hclk),
        .Hresetn(Hresetn),
        .valid(valid),
        .Hwrite(Hwrite),
        .Hwritereg(Hwritereg),
        .Haddr1(Haddr1),
        .Haddr2(Haddr2),
        .Hwdata1(Hwdata1),
        .Hwdata2(Hwdata2),
        .Prdata(Prdata),
        .Haddr(Haddr),
        .Hwdata(Hwdata),
        .tempselx(tempselx),
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pselx(Pselx),
        .Paddr(Paddr),
        .Pwdata(Pwdata),
        .Hreadyout(Hreadyout)
    );

    initial begin
        // Initialize Inputs
        Hclk = 0;
        Hresetn = 0;
        valid = 0;
        Hwrite = 0;
        Hwritereg = 0;
        Haddr1 = 0;
        Haddr2 = 0;
        Hwdata1 = 0;
        Hwdata2 = 0;
        Prdata = 0;
        Haddr = 0;
        Hwdata = 0;
        tempselx = 3'b000;

        // Apply Reset
        #10 Hresetn = 1;

        // Test Case 1: Idle to Read
        #10 valid = 1; Hwrite = 0; Haddr = 32'hAAAA_AAAA; Hwdata = 32'h1234_5678; tempselx = 3'b001;

        // Wait and observe outputs
        #20;

        // Test Case 2: Read to Write
        #10 Hwrite = 1; Haddr1 = 32'hBBBB_BBBB; Hwdata1 = 32'h8765_4321;

        // Wait and observe outputs
        #20;

        // Test Case 3: Write to WriteP
        #10 Hwritereg = 1; Haddr2 = 32'hCCCC_CCCC; Hwdata2 = 32'hABCD_EF01;

        // Wait and observe outputs
        #20;

        // Test Case 4: WriteP to Idle
        #10 valid = 0; Haddr = 32'hDDDD_DDDD; Hwdata = 32'hFEDC_BA98;

        // Finish Simulation
        #20 $stop;
    end

    always #5 Hclk = ~Hclk;  // Generate Clock

endmodule

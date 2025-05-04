`timescale 1ns / 1ps

module APB_Interface_tb;

    // Inputs
    reg Pwrite;
    reg Penable;
    reg [2:0] Pselx;
    reg [31:0] Pwdata;
    reg [31:0] Paddr;

    // Outputs
    wire Pwriteout;
    wire Penableout;
    wire [2:0] Pselxout;
    wire [31:0] Pwdataout;
    wire [31:0] Paddrout;
    wire [31:0] Prdata;

    // Instantiate the DUT (Device Under Test)
    APB_Interface uut (
        .Pwrite(Pwrite),
        .Penable(Penable),
        .Pselx(Pselx),
        .Pwdata(Pwdata),
        .Paddr(Paddr),
        .Pwriteout(Pwriteout),
        .Penableout(Penableout),
        .Pselxout(Pselxout),
        .Pwdataout(Pwdataout),
        .Paddrout(Paddrout),
        .Prdata(Prdata)
    );

    initial begin
        // Initialize Inputs
        Pwrite = 1'b0;
        Penable = 1'b0;
        Pselx = 3'b000;
        Pwdata = 32'h0000_0000;
        Paddr = 32'h0000_0000;

        // Wait for global reset to finish
        #10;
        
        // Test Case 1: Read Operation with Penable
        #10 Pwrite = 1'b0; Penable = 1'b1; Pselx = 3'b001; Paddr = 32'hAAAA_AAAA; Pwdata = 32'h1234_5678;

        // Wait and observe Prdata
        #20;

        // Test Case 2: Write Operation
        #10 Pwrite = 1'b1; Penable = 1'b1; Pselx = 3'b010; Paddr = 32'hBBBB_BBBB; Pwdata = 32'h8765_4321;

        // Wait and observe no change in Prdata
        #20;

        // Test Case 3: Disable Penable
        #10 Pwrite = 1'b0; Penable = 1'b0; Pselx = 3'b011; Paddr = 32'hCCCC_CCCC; Pwdata = 32'hABCD_EF01;

        // Wait and observe Prdata should be 0
        #20;

        // Finish Simulation
        #10 $stop;
    end

endmodule

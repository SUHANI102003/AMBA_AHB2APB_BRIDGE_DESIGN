module AHB_Master_TB;

    // Inputs
    reg Hclk;
    reg Hresetn;
    reg Hreadyout;
    reg [31:0] Hrdata;

    // Outputs
    wire [31:0] Haddr;
    wire [31:0] Hwdata;
    wire Hwrite;
    wire Hreadyin;
    wire [1:0] Htrans;

    // Instantiate the AHB Master
    AHB_Master uut (
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

    // Clock generation
    initial begin
        Hclk = 0;
        forever #5 Hclk = ~Hclk; // 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        Hresetn = 0;
        Hreadyout = 1;
        Hrdata = 32'h0;

        // Apply reset
        #10 Hresetn = 1;

        // Wait for reset deassertion
        #20;

        // Perform single write
        $display("Performing single write");
        uut.single_write();
        #20;

        // Perform single read
        $display("Performing single read");
        uut.single_read();
        #20;

        // Perform burst write
        $display("Performing burst write");
        uut.burst_write();
        #50;

        // Perform wrap write
        $display("Performing wrap write");
        uut.wrap_write();
        #50;

        // End of simulation
        $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t Haddr=%h Hwdata=%h Hwrite=%b Hreadyin=%b Htrans=%b", 
                 $time, Haddr, Hwdata, Hwrite, Hreadyin, Htrans);
    end

endmodule



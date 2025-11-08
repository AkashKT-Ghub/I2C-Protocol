// I2C TESTBENCH

module i2c_tb;
  reg clk,rst,newd,wr;
  reg [7:0] wdata;
  reg [6:0] addr;
  wire [7:0] rdata;
  wire done;
  
  i2c_design dut(clk,rst,newd,wr,wdata,addr,rdata,done);
  
  initial clk=0;
    always #5 clk=~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,i2c_tb);
  end
  
  initial begin
    rst = 1;  //APPLY RESET
    newd = 0;
    wr = 0;
    wdata = 8'h00;
    addr = 7'h00;
    #20;
    rst = 0;  //RELEASE RESET
    #50;
      
    addr = 7'h10;
    wdata = 8'h27;
    wr = 1'b1;
    newd = 1'b1;
    @(posedge done);  //WAIT FOR DONE SIGNAL
      
    newd = 1'b0;
    wr = 1'b0;
    #100;
      
    addr = 7'h10;
    wr = 1'b0;
    newd = 1'b1;
    @(posedge done);
    if(rdata == 8'h27)
   // if(rdata == wdata)
      $display("[PASS] : DATA MATCHED - RDATA = %0h",rdata);
    else
      $display("[FAIL] : DATA MISMATCHED - RDATA = %0h",rdata);
      
    #50;
    $finish();
    end
endmodule

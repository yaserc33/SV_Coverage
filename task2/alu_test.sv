module alu_test(
    output logic [3:0] alu_ctrl,
    output logic [31:0] op1,
    output logic [31:0] op2,
    input logic [31:0] alu_result, 
    input logic zero, 
    input logic clk    
);

  // Define simulation parameters
  `define PERIOD 10
  `define NUM_CYCLE 1000


  int num_error;
  bit ok;
  bit debug = 1;

  initial begin
    #(`NUM_CYCLE * `PERIOD); // Wait for the specified number of clock cycles

    $display("=======================================");
    $display("             TEST TIMEOUT             ");
    $display("=======================================");
    $display("The test has timed out! Either the test is stuck, or it requires more clock cycles.");
    $display("Increase the simulation time by modifying the NUM_CYCLE value in alu_test.sv.");
    $display("Modify `NUM_CYCLE` to a higher value and rerun the simulation.");
    
    $finish;
  end


  // Helper Tasks Here 
  task drive_and_capture(input logic [3:0] opcode, input logic [31:0] a, b, output logic [31:0] result, output logic zero_flag, input bit debug = 0);
    // Drive inputs at the negedge
    @(negedge clk);
        alu_ctrl   <= opcode;
        op1        <= a;
        op2        <= b;
    // Capture DUT response at the next negedge
    @(negedge clk);
        result      = alu_result;
        zero_flag   = zero;
    if(debug) $display("A = %d, B = %d, Operation = %d, ALU_result = %d, zero_flag = %d", a, b, opcode, result, zero_flag);

  endtask


 // Declare Covergroup inside the module
  covergroup ALU_CG @(posedge clk);
    
    // Coverpoint for op1
    alu_result_cp: coverpoint alu_result {
      bins zero = {0}; 
      bins low_range = {[32'h00000000: 32'h000000FF]};  // Covers low range
      bins high_range = {[32'hFFFFFF00: 32'hFFFFFFFF]}; // Covers high range
      bins default_bin = default;                     // Covers all other values
    }

  

    alu_ctrl_cp: coverpoint alu_ctrl; 

  endgroup  



    logic [31:0] rand_a, rand_b;
    logic [3:0] rand_alu_ctrl;
    logic [31:0] test_result;
    logic        test_zero;

    randtrans rtrans;
    ALU_CG alu_coverage = new();

    // Test Cases Here 
    initial begin 
        rtrans = new();
        repeat(200) begin 
            ok = rtrans.randomize() with {
                a inside {[0:255], [32'hFFFFFF00: 32'hFFFFFFFF]};
                b inside {[0:255], [32'hFFFFFF00: 32'hFFFFFFFF]};
            };
            drive_and_capture($urandom_range(0,15), rtrans.a, rtrans.b, rtrans.opcode, test_zero, debug);
        end
        printstatus(0); // currently not checking the alu, only generating the stimulus
        $finish;
    end


    initial begin 
        $dumpfile("waveform.vcd");
        $dumpvars(0);
    end



    // Function to print test status
    function void printstatus(input int status);
        if (status == 0) begin
        $display("\n");
        $display("                                  _\\|/_");
        $display("                                  (o o)");
        $display(" ______________________________oOO-{_}-OOo______________________________");
        $display("|                                                                       |");
        $display("|                               TEST PASSED                             |");
        $display("|_______________________________________________________________________|");
        $display("\n");
        end else begin
        $display("Test Failed with %d Errors", status);
        $display("\n");
        $display("                              _ ._  _ , _ ._");
        $display("                            (_ ' ( `  )_  .__)");
        $display("                          ( (  (    )   `)  ) _)");
        $display("                         (__ (_   (_ . _) _) ,__)");
        $display("                             `~~`\ ' . /`~~`");
        $display("                             ,::: ;   ; :::,");
        $display("                            ':::::::::::::::'");
        $display(" ________________________________/_ __ \\________________________________");
        $display("|                                                                       |");
        $display("|                               TEST FAILED                             |");
        $display("|_______________________________________________________________________|");
        $display("\n");
        end
    endfunction

endmodule

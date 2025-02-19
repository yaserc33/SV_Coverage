module top;

    bit clk;
    always #5 clk = ~clk;


    logic [3:0] alu_ctrl;
    logic [31:0] op1;
    logic [31:0] op2;
    logic [31:0] alu_result; 
    logic zero;


    alu DUT(
        .*,
        .alu_ctrl(alu_t'(alu_ctrl))
    );

    alu_test TEST(
        .*
    );

endmodule : top
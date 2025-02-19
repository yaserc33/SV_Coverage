class randtrans;
    rand logic [31:0] a, b;
    rand logic [3:0] opcode;

    // Constraint for opcode range
    constraint opcode_valid {
        opcode inside {[4'b0000 : 4'b1000], 4'b1101}; // Limit opcode to valid range
    }

endclass

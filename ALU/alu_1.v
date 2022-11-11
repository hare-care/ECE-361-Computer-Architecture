module alu_1 (input operand_a, 
            input operand_b, 
            input [3:0] control, 
            output cout,
            output result);

    wire gnd;
    wire arith_result;
    wire or_result;
    wire and_result;
    wire xor_result;
    wire control_inv [3:0];

    wire b_in;
    wire subtract;
    wire cin;
    
    assign gnd = 0;
    // contgrol logic
    not_gate_n ctrl_inverter(control, control_inv);
    assign cin = control[0];
    assign subtract = control[0];

    xor_gate neg_b(operand_b, subtract, b_in);
    assign result = arith_result;
    

    // arithmetic
    adder_1 adder(operand_a, b_in, cin, arith_result, cout);

    // logic
    xor_gate xor(operand_a, operand_b, xor_result);
    or_gate or(operand_a, operand_b, or_result);
    and_gate and(operand_a, operand_b, and_result);

    // conditions skip for the single bit alu
    
    


endmodule;

module adder_1 (input x,
                input y,
                input cin,
                output sum, 
                output cout);
    
    wire xor1_result;
    wire and1_result;
    wire and2_result;

    xor_gate xor1(x, y, xor1_result);
    xor_gate xor2(xor1_result, cin, sum);

    and_gate and1(xor1_result, cin, and1_result);
    and_gate and2(x, y, and2_result);

    or_gate or1(and1_result, and2_result, cout);
endmodule;






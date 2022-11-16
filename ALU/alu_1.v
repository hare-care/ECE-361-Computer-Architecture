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
    wire [3:0] control_inv;

    wire mux_result1;
    wire mux_result2;

    wire b_in;
    wire subtract;
    wire cin;
    
    assign gnd = 0;
    // contgrol logic
    // not_gate_n ctrl_inverter(.x (control), .z(control_inv));
    assign cin = control[0];
    assign subtract = control[0];

    xor_gate neg_b(.x(operand_b), .y(subtract), .z(b_in));
    mux add_xor_mux(.sel(control[1]), .src0(arith_result), .src1(xor_result), .z(mux_result1));
    mux or_and_mux(.sel(control[1]), .src0(and_result), .src1(or_result), .z(mux_result2));
    mux final_mux(.sel(control[2]), .src0(mux_result1), .src1(mux_result2), .z(result));
    // arithmetic
    adder_1 adder(operand_a, b_in, cin, arith_result, cout);

    // logic
    xor_gate my_xor(.x(operand_a), .y(operand_b), .z(xor_result));
    or_gate my_or(.x(operand_a),.y( operand_b),.z( or_result));
    and_gate my_and(.x(operand_a),.y( operand_b),.z( and_result));

    // conditions skip for the single bit alu
    
    


endmodule

module adder_1 (input x,
                input y,
                input cin,
                output sum, 
                output cout);
    
    wire xor1_result;
    wire and1_result;
    wire and2_result;

    xor_gate xor1(.x(x),.y( y),.z( xor1_result));
    xor_gate xor2(.x(xor1_result),.y( cin), .z(sum));

    and_gate and1(.x(xor1_result), .y(cin), .z(and1_result));
    and_gate and2(.x(x),.y( y), .z(and2_result));

    or_gate or1(.x(and1_result), .y(and2_result), .z(cout));
endmodule

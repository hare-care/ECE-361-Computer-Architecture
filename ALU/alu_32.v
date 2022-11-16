module alu32(input [31:0] operand_a, 
		input [31:0] operand_b,
		input [3:0] control,
		output cout,
		output overflow,
		output zero,
		output [31:0] result);

	// high and low signals
	wire [31:0] gnd;
	wire [31:0] vdd;
	assign gnd = 32'b0;
	assign vdd = 32'hFFFFFFFF;

	// result signals
	wire [31:0] arith_result;
	wire [31:0] or_result;
	wire [31:0] and_result;
	wire [31:0] xor_result;
	wire [31:0] sll_result;
	wire [31:0] srl_result;
	wire [31:0] slt_result;
	wire [31:0] sltu_result;
	
	//result choosing signals
	wire [31:0] arith_and_result;
	wire [31:0] or_xor_result;
	wire [31:0] sll_srl_result;
	wire [31:0] slt_sltu_result;
	wire [31:0] stage2_0_result;
	wire [31:0] stage2_1_result;


	wire [31:0] a_in;
	wire [31:0] b_in;
	wire [31:0] cout_prop;

	wire srl0, srl1, srl2, srl3, srl4;
	wire [31:0] srl0_out;
	wire [31:0] srl1_out;
	wire [31:0] srl2_out;
	wire [31:0] srl3_out;
	wire [31:0] srl4_out;

	wire sll0, sll1, sll2, sll3, sll4;
        wire [31:0] sll0_out;
        wire [31:0] sll1_out;
        wire [31:0] sll2_out;
        wire [31:0] sll3_out;
        wire [31:0] sll4_out;


	wire [31:0] zero_mux_out;

	// condtions
	mux_32 zero_mux(.sel(result), .src0(32'b1), .src1(32'b0), .z(zero_mux_out));
	assign zero = zero_mux_out[0];
	assign cout = cout_prop[31];
	xor_gate overflow_xor(cout_prop[30], cout_prop[31], overflow);


	// control
	//
	// choosing result
	mux_32 arith_and(.sel({31'b0,control[1]}), .src0(arith_result), .src1(and_result), .z(arith_and_result));
	mux_32 or_xor(.sel({31'b0,control[1]}), .src0(or_result), .src1(xor_result), .z(or_xor_result));
	mux_32 sll_srl(.sel({31'b0,control[1]}), .src0(sll_result), .src1(srl_result), .z(sll_srl_result));
	mux_32 slt_sltu(.sel({31'b0,control[1]}), .src0(slt_result), .src1(sltu_result), .z(slt_sltu_result));

	mux_32 arith_or(.sel({31'b0,control[2]}), .src0(arith_and_result), .src1(or_xor_result), .z(stage2_0_result));
	mux_32 sll_sltu(.sel({31'b0,control[2]}), .src0(sll_srl_result), .src1(slt_sltu_result), .z(stage2_1_result));
		
	mux_32 result_mux({31'b0,control[3]},stage2_0_result, stage2_1_result, result);
	
	xor_gate_32 negate_b(operand_b, {32{sub_signal}}, b_in);

	assign a_in = operand_a;
	and_gate slt_and(control[3], control[2], slt_signal);
	or_gate cin_or(control[0], slt_signal, sub_signal);
	
	assign cin = sub_signal;
	

	assign srl0 = operand_b[0];
	assign srl1 = operand_b[1];
	assign srl2 = operand_b[2];
	assign srl3 = operand_b[3];
	assign srl4 = operand_b[3];

	assign sll0 = operand_b[0];
        assign sll1 = operand_b[1];
        assign sll2 = operand_b[2];
        assign sll3 = operand_b[3];
        assign sll4 = operand_b[3];


	// arithmetic
	genvar i;
	generate
		for (i =0;i < 32;i= i+1) begin
		if (i==0)
			adder_1 a0(.x(a_in[0]),
				   .y(b_in[0]),
			   	   .cin(cin),
				   .sum(arith_result[0]),
				   .cout(cout_prop[0]));
		else
			adder_1 a_mid(.x(a_in[i]),
                                    .y(b_in[i]),
                                    .cin(cout_prop[i-1]),
                                    .sum(arith_result[i]),
                                    .cout(cout_prop[i]));
		    end
	    endgenerate
	
	// logic
	xor_gate_32 my_xor(.x(operand_a), .y(operand_b), .z(xor_result));
	or_gate_32 my_or(.x(operand_a), .y(operand_b), .z(or_result));
	and_gate_32 my_and(.x(operand_a), .y(operand_b), .z(and_result));

	// shift right
	
	genvar j;
	genvar k;
	generate 
		for (k=0; k<5; k=k+1) begin
		for (j=0; j<32; j=j+1) begin
			if (k==0) begin
				if (j == 31)
					mux srl_0end(.sel(srl0), .src0(operand_a[j]), .src1(1'b0), .z(srl0_out[j]));
				else
					mux srl_0(.sel(srl0), .src0(operand_a[j]), .src1(operand_a[j+1]), .z(srl0_out[j]));
			end
			else if (k==1) begin
				if (j > 29)
					mux srl_1end(.sel(srl1), .src0(srl0_out[j]), .src1(1'b0), .z(srl1_out[j]));
				else 
					mux srl_1(.sel(srl1), .src0(srl0_out[j]), .src1(srl0_out[j+2]), .z(srl1_out[j]));
			end
			else if (k==2) begin
				if (j > 27)
					mux srl_2end(.sel(srl2), .src0(srl1_out[j]), .src1(1'b0), .z(srl2_out[j]));
				else
					mux srl_2(.sel(srl2), .src0(srl1_out[j]), .src1(srl1_out[j+4]), .z(srl2_out[j]));
			end
			else if (k==3) begin
				if (j > 23)
					mux srl_3end(.sel(srl3), .src0(srl2_out[j]), .src1(1'b0), .z(srl3_out[j]));
				else
					mux srl_3(.sel(srl3), .src0(srl2_out[j]), .src1(srl2_out[j+8]), .z(srl3_out[j]));
			end
			else begin
				if (j >15)
					mux srl_4end(.sel(srl4), .src0(srl3_out[j]), .src1(1'b0), .z(srl_result[j]));
				else
					mux srl_4(.sel(srl4), .src0(srl3_out[j]), .src1(srl3_out[j+16]), .z(srl_result[j]));
			end
		end
	end
	endgenerate

	// shift left

	genvar kk;
	genvar jj;	
	generate
                for (kk=0; kk<5; kk=kk+1) begin
                for (jj=0; jj<32; jj=jj+1) begin
                        if (kk==0) begin
                                if (jj == 0)
                                        mux sll_0end(.sel(sll0), .src0(operand_a[jj]), .src1(1'b0), .z(sll0_out[jj]));
                                else
                                        mux sll_0(.sel(sll0), .src0(operand_a[jj]), .src1(operand_a[jj-1]), .z(sll0_out[jj]));
                        end
                        else if (kk==1) begin
                                if (jj < 2)
                                        mux sll_1end(.sel(sll1), .src0(sll0_out[jj]), .src1(1'b0), .z(sll1_out[jj]));
                                else
                                        mux sll_1(.sel(sll1), .src0(sll0_out[jj]), .src1(sll0_out[jj-2]), .z(sll1_out[jj]));
                        end
                        else if (kk==2) begin
                                if (jj < 4)
                                        mux sll_2end(.sel(sll2), .src0(sll1_out[jj]), .src1(1'b0), .z(sll2_out[jj]));
                                else
                                        mux sll_2(.sel(sll2), .src0(sll1_out[jj]), .src1(sll1_out[jj-4]), .z(sll2_out[jj]));
                        end
                        else if (kk==3) begin
                                if (jj < 8)
                                        mux sll_3end(.sel(sll3), .src0(sll2_out[jj]), .src1(1'b0), .z(sll3_out[jj]));
                                else
                                        mux sll_3(.sel(sll3), .src0(sll2_out[jj]), .src1(sll2_out[jj-8]), .z(sll3_out[jj]));
                        end
                        else begin
                                if (jj < 16)
                                        mux sll_4end(.sel(sll4), .src0(sll3_out[jj]), .src1(1'b0), .z(sll_result[jj]));
                                else
                                        mux sll_4(.sel(sll4), .src0(sll3_out[jj]), .src1(sll3_out[jj-16]), .z(sll_result[jj]));
                        end
                end
        end
        endgenerate



	// condtional
	assign slt_result = {32'b0, arith_result[31]};
	not_gate inv_cout(cout, cout_inv);
	assign sltu_result = {32'b0, cout_inv};

endmodule

module adder_1 (input x,
                input y,
                input cin,
                output sum,
                output cout);

    wire xor1_result;
    wire and1_result;
    wire and2_result;
    wire and3_result;
    wire or1_result;

    xor_gate xor1(.x(x),.y( y),.z( xor1_result));
    xor_gate xor2(.x(xor1_result),.y( cin), .z(sum));

    and_gate and1(.x(xor1_result), .y(cin), .z(and1_result));
    and_gate and2(.x(x),.y( y), .z(and2_result));

    or_gate or1(.x(and1_result), .y(and2_result), .z(cout));
endmodule



module alu31_tb;
	reg [31:0] a, b;
	reg [3:0] control;
	wire [31:0] res;
	wire cout;
	wire zero;
	wire overflow;

	alu32 my_alu(a, b, control, cout, overflow, zero, res);

	initial begin
		control = 4'b0000; //add

		a = 32'b101;
		b = 32'b011;
		#10
		a = 32'b0;
		b = 32'b0;
		#10
		a = 32'b1;
		b = 32'b1;
		#10
		a = 32'b111;
		b = 32'b1101;
		#10
		a = 32'hffffffff;
		b = 32'b10;
		#10
		a = 32'hffffffff;
		b = 32'hffffffff;
		#10
		a = 32'h7fffffff;
		b = 32'h7fffffff;
		#10
		
		control = 4'b0001; //sub

                a = 32'b010001;
                b = 32'b011000;
                #10
                a = 32'b0;
                b = 32'b0;
                #10
                a = 32'b1;
                b = 32'b1;
                #10
                a = 32'b111;
                b = 32'b1101;
                #10
                a = 32'h0;
                b = 32'b1;
                #10
		
		control = 4'b0010; //and
		a = 32'b0;
		b = 32'b0;
		#10
		a = 32'b1;
		b = 32'b1;
		#10
		a = 32'b1;
		b = 32'b0;
		#10
		a = 32'b0;
		b = 32'b1;
		#10
		a = 32'hffffffff;
		b = 32'h0000ffff;
		#10
		a = 32'hf0f0f0f0;
		b = 32'h0f0f0f0f;
		#10
		
		control = 4'b0100; //or
                a = 32'b0;
                b = 32'b0;
                #10
                a = 32'b1;
                b = 32'b1;
                #10
                a = 32'b1;
                b = 32'b0;
                #10
                a = 32'b0;
                b = 32'b1;
                #10
                a = 32'hffffffff;
                b = 32'h0000ffff;
                #10
                a = 32'hf0f0f0f0;
                b = 32'h0f0f0f0f;
                #10
				
		control = 4'b0110; //xor
                a = 32'b0;
                b = 32'b0;
                #10
                a = 32'b1;
                b = 32'b1;
                #10
                a = 32'b1;
                b = 32'b0;
                #10
                a = 32'b0;
                b = 32'b1;
                #10
                a = 32'hffffffff;
                b = 32'h0000ffff;
                #10
                a = 32'hf0f0f0f0;
                b = 32'h0f0f0f0f;
                #10

		control = 4'b1100; //slt
		a = 32'b0;
		b = 32'b1;
		#10
		a = 32'b1;
		b = 32'b11;
		#10
		a = 32'b1;
		b = 32'b0;
		#10
		a = 32'hf0000000;
		b = 32'h011;
		#10

		control = 4'b1110; //sltu
		a = 32'b0;
                b = 32'b1;
                #10
                a = 32'b1;
                b = 32'b11;
                #10
                a = 32'b1;
                b = 32'b0;
                #10
                a = 32'hf0000000;
                b = 32'h011;
                #10

		control = 4'b1010; //srl
                a = 32'b0;
                b = 32'b0;
                #10
                a = 32'b1;
                b = 32'b0;
                #10
                a = 32'b10;
                b = 32'b1;
                #10;
                a = 32'hf0;
                b = 32'h4;
                #10
		
		control = 4'b1000; //sll
                a = 32'b0;
                b = 32'b0;
                #10
                a = 32'b1;
                b = 32'b0;
                #10
                a = 32'b10;
                b = 32'b1;
                #10;
                a = 32'hf0;
                b = 32'h4;
                #10

		$finish;
	end




endmodule


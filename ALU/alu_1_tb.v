module alu1_tb;
    reg a, b;
    reg [3:0] control;
    wire res;
    wire c_out;

    alu_1 my_alu(a, b, control, c_out, res);

    initial begin
        control = 4'b0000; //add

        a = 1'b0;
        b = 1'b0;
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        a = 1'b1;
        b = 1'b0;
        #10 
        a = 1'b1;
        b = 1'b1;
	#10

	control = 4'b0001; //sub
	a = 1'b0;
        b = 1'b0;
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        a = 1'b1;
        b = 1'b0;
        #10
        a = 1'b1;
        b = 1'b1;
        #10

	control = 4'b0010; //xor
        a = 1'b0;
        b = 1'b0;
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        a = 1'b1;
        b = 1'b0;
        #10
        a = 1'b1;
        b = 1'b1;
        #10
	
	control = 4'b0100; //and
        a = 1'b0;
        b = 1'b0;
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        a = 1'b1;
        b = 1'b0;
        #10
        a = 1'b1;
        b = 1'b1;
        #10

	control = 4'b0110; //or
        a = 1'b0;
        b = 1'b0;
        #10
        a = 1'b0;
        b = 1'b1;
        #10
        a = 1'b1;
        b = 1'b0;
        #10
        a = 1'b1;
        b = 1'b1;
        #10



        $finish;

        




    end




endmodule

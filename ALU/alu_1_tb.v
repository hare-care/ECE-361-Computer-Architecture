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
        $finish

        




    end




endmodule

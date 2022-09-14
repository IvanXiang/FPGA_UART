`timescale 1 ns/1 ns

module top_tb();

//时钟和复位
    reg         clk         ;
    reg         rst_n       ;

//测试模块的输入信号
    reg [7:0]   tx_byte     ;
    reg         tx_byte_vld ;


//测试模块的输出信号
    wire        uart_txd    ;

    wire        tx_busy     ;
    wire        tx_bit      ;

//时钟周期定义。
parameter CYCLE    = 20;

//复位周期定义。
parameter RST_TIME = 3 ;

//待测试的模块例化
    uart_tx u_tx(       //发送数据  并串转换
    /*input               */.clk     (clk           ),
    /*input               */.rst_n   (rst_n         ),
    /*input   [1:0]       */.baud_sel(2'd0          ),
    /*input   [7:0]       */.din     (tx_byte       ),
    /*input               */.din_vld (tx_byte_vld   ),
    /*output              */.tx_dout (tx_bit        ),
    /*output              */.tx_busy (tx_busy       ) //发送状态指示   
    );

    top u_top(
    /*input               */.clk     (clk       ),
    /*input               */.rst_n   (rst_n     ),
    /*input               */.uart_rxd(tx_bit    ),
    /*output              */.uart_txd(uart_txd  )    
    );


//生成时钟
    initial begin
        clk = 0;
        forever
        #(CYCLE/2)
        clk=~clk;
    end

//产生复位信号
    initial begin
        rst_n = 1;
        #2;
        rst_n = 0;
        #(CYCLE*RST_TIME);
        rst_n = 1;
    end

    task SEND;   
        input       [7:0]       data    ;
        begin 
            #(CYCLE*20);	
            tx_byte = data;
            tx_byte_vld  = 1'b1;
            #(CYCLE*1);
            tx_byte_vld = 1'b0;
            @(negedge tx_busy);
            #(CYCLE*20);
        end 
    endtask 


//输入信号赋值方式
    initial begin
        #1;
        //赋初值
        tx_byte = 0;
        tx_byte_vld = 0;
        #(10*CYCLE);
        //开始赋值
        repeat(20)begin 
            SEND({$random});
        end 
        #(100*CYCLE);
        $stop;
    end



endmodule


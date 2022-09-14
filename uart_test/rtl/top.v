module top(
    input               clk     ,
    input               rst_n   ,
    
    input               uart_rxd,
    output              uart_txd    
);

//信号定义

    wire        [7:0]       rx_byte     ;
    wire                    rx_byte_vld ;
    wire        [7:0]       tx_byte     ;
    wire                    tx_byte_vld ;
    wire                    tx_busy     ;
    wire        [1:0]       baud_sel    ;
    
    assign baud_sel = 2'd0; //选择波特率

//模块例化
    
    uart_rx u_rx(       //接收串行数据 串并转换
    /*input               */.clk     (clk           ),
    /*input               */.rst_n   (rst_n         ),
    /*input   [1:0]       */.baud_sel(baud_sel      ),
    /*input               */.rx_din  (uart_rxd      ),
    /*output  [7:0]       */.rx_dout (rx_byte       ),
    /*output              */.rx_vld  (rx_byte_vld   ) 
    );

    control u_ctrl(     //缓存
    /*input               */.clk     (clk           ),
    /*input               */.rst_n   (rst_n         ),
    /*input   [7:0]       */.din     (rx_byte       ),
    /*input               */.din_vld (rx_byte_vld   ),
    /*input               */.busy    (tx_busy       ),
    /*output  [7:0]       */.dout    (tx_byte       ),
    /*output              */.dout_vld(tx_byte_vld   )    
    );

    uart_tx u_tx(       //发送数据  并串转换
    /*input               */.clk     (clk           ),
    /*input               */.rst_n   (rst_n         ),
    /*input   [1:0]       */.baud_sel(baud_sel      ),
    /*input   [7:0]       */.din     (tx_byte       ),
    /*input               */.din_vld (tx_byte_vld   ),
    /*output              */.tx_dout (uart_txd      ),
    /*output              */.tx_busy (tx_busy       ) //发送状态指示   
    );

endmodule 


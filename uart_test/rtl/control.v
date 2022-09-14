module control (     //缓存
    input               clk     ,
    input               rst_n   ,
    input   [7:0]       din     ,
    input               din_vld ,
    input               busy    ,
    output  [7:0]       dout    ,
    output              dout_vld    
);

//信号定义
    reg                 rd_flag     ;
    reg     [7:0]       tx_data     ;
    reg                 tx_data_vld ;

    wire                fifo_rdreq  ;
    wire                fifo_wrreq  ;
    wire                fifo_empty  ;
    wire                fifo_full   ;
    wire    [7:0]       fifo_qout   ;
    wire    [3:0]       fifo_usedw  ;

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rd_flag <= 1'b0;
        end
        else if(fifo_usedw >= 8)begin
            rd_flag <= 1'b1;
        end
        else if(fifo_empty)begin 
            rd_flag <= 1'b0;
        end 
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            tx_data <= 0;
            tx_data_vld <= 1'b0; 
        end
        else begin
            tx_data <= fifo_qout;
            tx_data_vld <= fifo_rdreq;
        end
    end

//FIFO例化

    fifo u_fifo(
	.aclr   (~rst_n     ),
	.clock  (clk        ),
	.data   (din        ),
	.rdreq  (fifo_rdreq ),
	.wrreq  (fifo_wrreq ),
	.empty  (fifo_empty ),
	.full   (fifo_full  ),
	.q      (fifo_qout  ),
	.usedw  (fifo_usedw )
    );
    
    assign fifo_wrreq = din_vld & ~fifo_full;
    assign fifo_rdreq = rd_flag & ~busy;  //发送模块 非忙状态下 给发送请求
    
//    assign dout_vld = fifo_rdreq;
//    assign dout = fifo_qout;

    assign dout_vld = tx_data_vld;  //时序逻辑输出
    assign dout = tx_data;

endmodule 


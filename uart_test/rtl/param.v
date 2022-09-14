//定义系统时钟频率
`define CLOCK_FREQ 50_000_000

//定义计数器分频系数
`define BAUD_RATE_115200 `CLOCK_FREQ/115200
`define BAUD_RATE_57600  `CLOCK_FREQ/57600
`define BAUD_RATE_38400  `CLOCK_FREQ/38400
`define BAUD_RATE_9600   `CLOCK_FREQ/9600

//定义校验类型

`define PARITY_ENABLE
//`define ODD_PARITY  //奇校验
`define EVEN_PARITY //偶校验

`ifdef PARITY_ENABLE        //使能校验功能时
    `define DATA_W 9        //数据位宽
    `ifdef ODD_PARITY       //奇校验
        `define PARITY_TYPE 1
    `elsif
        `define PARITY_TYPE 0
    `endif
`else
    `define DATA_W 8
`endif 




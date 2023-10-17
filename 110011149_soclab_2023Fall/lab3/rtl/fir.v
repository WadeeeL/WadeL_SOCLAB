module fir 
#(  
    parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11
)
(
    // axilite_write
    output  wire                     awready,
    output  wire                     wready,
    input   wire                     awvalid,
    input   wire [(pADDR_WIDTH-1):0] awaddr,
    input   wire                     wvalid,
    input   wire [(pDATA_WIDTH-1):0] wdata,
    
    // axilite_read
    output  wire                     arready,
    input   wire                     rready,
    input   wire                     arvalid,
    input   wire [(pADDR_WIDTH-1):0] araddr,
    output  wire                     rvalid,
    output  wire [(pDATA_WIDTH-1):0] rdata,  
     
    // stream
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  wire                     ss_tready, 
    
    input   wire                     sm_tready, 
    output  wire                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast, 
    
    // bram for tap RAM
    output  wire [3:0]               tap_WE,
    output  wire                     tap_EN,
    output  wire [(pDATA_WIDTH-1):0] tap_Di,
    output  wire [(pADDR_WIDTH-1):0] tap_A,
    input   wire [(pDATA_WIDTH-1):0] tap_Do,

    // bram for data RAM
    output  wire [3:0]               data_WE,
    output  wire                     data_EN,
    output  wire [(pDATA_WIDTH-1):0] data_Di,
    output  wire [(pADDR_WIDTH-1):0] data_A,
    input   wire [(pDATA_WIDTH-1):0] data_Do,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n
);

    reg [0:2] ap_ctrl;// 0 : start ; 1 : done ; 2 : idle
    reg datalen;
    
    reg addr_ap_state = 12'h0;
    reg addr_data_length = 12'h10;
    
    // XXX_r : implies that is a reg type
    reg                     awready_r;
    reg                     wready_r;
    
    reg                     arready_r;
    reg                     rvalid_r;
    reg [(pDATA_WIDTH-1):0] rdata_r;
    
    reg                     ss_tready_r;
    
    reg                     sm_tvalid_r;
    reg [(pDATA_WIDTH-1):0] sm_tdata_r;
    reg                     sm_tlast_r;
    
    reg [3:0]               tap_WE_r;
    reg                     tap_EN_r;
    reg [(pDATA_WIDTH-1):0] tap_Di_r;
    reg [(pADDR_WIDTH-1):0] tap_A_r;

    reg [3:0]               data_WE_r;
    reg                     data_EN_r;
    reg [(pDATA_WIDTH-1):0] data_Di_r;
    reg [(pADDR_WIDTH-1):0] data_A_r;
    
    assign awready = awready_r;
    assign wready = wready_r;
    
    assign arready = arready_r;
    assign rvalid = rvalid_r;
    assign rdata = rdata_r;
    
    assign ss_tready = ss_tready_r;
    
    assign sm_tvalid = sm_tvalid_r;
    assign sm_tdata = sm_tdata_r;
    assign sm_tlast = sm_tlast_r;
    
    assign tap_WE = tap_WE_r;
    assign tap_EN = tap_EN_r;
    assign tap_Di = tap_Di_r;
    assign tap_A = tap_A_r;
    
    assign data_WE = data_WE_r;
    assign data_EN = data_EN_r;
    assign data_Di = data_Di_r;
    assign data_A = data_A_r;
       
    // Xn (stream)
        // ss_tready
        always@(posedge axis_clk)begin
            if(~axis_rst_n) ss_tready_r <= 0;
            else begin
                if(ss_tvalid && ~ss_tready) ss_tready_r <= 1; 
                else ss_tready_r <= 0;
            end
        end
        
    // axilite_write
        
        // awready 
        always@(posedge axis_clk)begin
            if(~axis_rst_n) awready_r <= 0;
            else begin // awvalid and awready need to be deassert concurrently
                if(awvalid && ~awready) awready_r <= 1; 
                else awready_r <= 0;
            end
        end
        
        // wready
        always@(posedge axis_clk)begin
            if(~axis_rst_n) wready_r <= 0;
            else begin // wvalid and wready need to be deassert concurrently
                if(awvalid && wvalid && ~wready) wready_r <= 1; 
                else wready_r <= 0;
            end
        end
        
    // axilite_read
    
        // arready 
        always@(posedge axis_clk)begin
            if(~axis_rst_n) arready_r <= 0;
            else begin // arvalid and arready need to be deassert concurrently
                if(arvalid && ~arready) arready_r <= 1; 
                else arready_r <= 0;
            end
        end
        
        // rvalid 
        always@(posedge axis_clk)begin
            if(~axis_rst_n) rvalid_r <= 0;
            else begin
                if(arvalid && rready && ~rvalid) rvalid_r <= 1; 
                else rvalid_r <= 0;
            end
        end
        
        // rdata
        always@(posedge axis_clk)begin
            if(~axis_rst_n) begin
                ap_ctrl[1] <= 0;
                ap_ctrl[2] <= 0;
            end
            else begin
                if(rready && rvalid)begin  
                    case(araddr)
                        12'h0 : begin 
                            rdata_r[0] <= ap_ctrl[0];
                            rdata_r[1] <= ap_ctrl[1];
                            rdata_r[2] <= ap_ctrl[2];
                        end 
                        12'h10 : begin
                            rdata_r <= datalen;
                        end
                
                        default : begin 
                            rdata_r <= tap_Do;
                        end        
                    endcase    
               end
            end
        end
        
    // tap ram 
    
        // tap_EN 
        always@(posedge axis_clk)begin
            if(~axis_rst_n) tap_EN_r <= 0;
            else tap_EN_r <= 1;
        end    
        
        // **tap_WE (enable Di write to Do)
        always@(posedge axis_clk)begin
            if(~axis_rst_n) tap_WE_r <= 4'b0000;
            else begin
                if( awaddr != 12'h0 && awaddr != 12'h10 )begin
                    if(wvalid && ~wready) tap_WE_r <= 4'b1111;
                    else tap_WE_r <= 4'b0000;
                end
            end
        end
        
        // tap_Di (axilite write) - wdata
        always@(posedge axis_clk)begin
            if(awaddr != 12'h10)begin
                datalen <= wdata;
            end
            if( awaddr != 12'h0 && awaddr != 12'h10 ) begin
                tap_Di_r <= wdata;
            end    
        end
        
        // tap_A (axilite write) - awaddr
        always@(posedge axis_clk)begin
            if(awaddr >= 12'h20 && awaddr <= 12'h48)begin
                tap_A_r <= (awaddr -12'h20);
            end
        end 
        
   // data ram
        // data_EN  
        always@(posedge axis_clk)begin
            if(~axis_rst_n) data_EN_r <= 0;
            else data_EN_r <= 1;
        end 
        
        // data_WE
        
        // data_Di - ss_tdata
        
        // data_A - 
        
        // data_Do - ss_tdata
    
    // FIR function
    
    // Yn (stream)
    
        // sm_valid 
        
        // sm_tdata 
        
        // sm_tlast
    
endmodule
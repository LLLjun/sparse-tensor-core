module align_mux #(
    parameter M_TILE = 4, N_TILE = 4,
    parameter M_EXPAND = 4,
    parameter DW_DATA = 32,
    parameter DW_IO = M_TILE*N_TILE*M_EXPAND*DW_DATA
) (
    input [2:0] block_type,
    input [1:0] row,
    input [DW_IO-1:0] data_in,
    output reg [DW_IO-1:0] data_out
);
    
    integer i, j;

    always @(*) begin
        if (block_type==1) begin
            data_out <= 0;
        end
        else if (block_type == 2) begin
            if (row == 0) begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[(((i)*N_TILE+j)*2)*DW_DATA +:2*DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:2*DW_DATA];
                    end
                end
            end
            //else if (row == 2) begin
            else begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[(((1*M_TILE+i)*N_TILE+j)*2)*DW_DATA +:2*DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:2*DW_DATA];
                    end
                end
            end
        end
        //else if (block_type == 4) begin
        else begin
            if (row==0) begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[((0*M_TILE+i)*N_TILE+j)*DW_DATA +:DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:DW_DATA];
                    end
                end
            end
            else if (row==1) begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[((1*M_TILE+i)*N_TILE+j)*DW_DATA +:DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:DW_DATA];
                    end
                end
            end
            else if (row==2) begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[((2*M_TILE+i)*N_TILE+j)*DW_DATA +:DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:DW_DATA];
                    end
                end
            end
            //else if (row==3) begin
            else begin
                for (i=0; i<M_TILE; i=i+1) begin
                    for (j=0; j<N_TILE; j=j+1) begin
                        data_out[((3*M_TILE+i)*N_TILE+j)*DW_DATA +:DW_DATA] <= data_in[((i*N_TILE+j)*M_EXPAND)*DW_DATA +:DW_DATA];
                    end
                end
            end
        end
    end

endmodule
module fifo(
    input wire clk,
    input wire rstn,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output wire full,
    output wire empty
);

// insira seu código aqui

parameter DEPTH = 4;      // Profundidade da FIFO (número de posições de memória)
parameter WIDTH = 8;      // Largura dos dados (8 bits)

// Memória da FIFO
reg [WIDTH-1:0] memory [DEPTH-1:0];  // Array de registradores para armazenar os dados

reg [1:0] w_ptr;  // Ponteiro para a próxima posição de escrita (2 bits para DEPTH = 4)
reg [1:0] r_ptr;  // Ponteiro para a próxima posição de leitura (2 bits para DEPTH = 4)

// reg _full, _empty;

always @(posedge clk or negedge rstn) 
    begin
        if(!rstn) 
            begin
                w_ptr <= 0;
                r_ptr <= 0;
                // empty <= 1;  // FIFO vazia após o reset
                // full <= 0;   // FIFO não está cheia após o reset
                data_out <= 8'bxxxxxxxx; // Inicializa a saída com 0
            end 
        else 
            begin
                // escrita
                if(wr_en && !full) 
                    begin
                        memory[w_ptr] <= data_in;  // Escreve o dado na posição apontada por w_ptr
                        w_ptr <= (w_ptr + 1) % DEPTH;  // Atualiza o ponteiro de escrita (circular)
                    end
                // leitura
                if(rd_en && !empty) 
                    begin
                        data_out <= memory[r_ptr];  // Lê o dado da posição apontada por r_ptr
                        r_ptr <= (r_ptr + 1) % DEPTH;  // Atualiza o ponteiro de leitura (circular)
                    end
            end
    end

assign empty    = (w_ptr == r_ptr);                        // Vazia: ponteiros de leitura e escrita iguais
assign full     = (w_ptr == (r_ptr - 1 + DEPTH) % DEPTH);  // Cheia: ponteiro de escrita atras do de leitura

endmodule


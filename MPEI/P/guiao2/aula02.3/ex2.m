N = 1e5;
p = 1/3;
n_palavras = 3;
n_1seq = 2;

%palavra um = 1;
%palavra dois = 2;
%palavra tres = 3;

sequencias = randi(n_palavras, n_1seq, N);

incluir_palavra_um_e_dois = 0;


for c = 1 : N
    
    coluna = sequencias(:, c);

    if (coluna(1) == 1 || coluna(2) == 1) && (coluna(1) == 2 || coluna(2) == 2)

        incluir_palavra_um_e_dois = incluir_palavra_um_e_dois + 1;

    end

end

probSim = incluir_palavra_um_e_dois / N;
    

    
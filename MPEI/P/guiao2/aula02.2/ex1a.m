n = 2;       %nº de lançamentos
faces = 6;   %nº de faces
N = 1e5;       %nº de testes
kA = 9;


lancamentosA = randi(faces, n, N);

sucessA = sum(lancamentosA) == kA;

probSimulacaoA = sum(sucessA) / N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sucessC = 0;
sucessD = 0;

for c = 1:N
        
    lancamento1 = randi(faces);
    lancamento2 = randi(faces);

    if lancamento1 == 5 || lancamento2 == 5
        sucessC = sucessC + 1;
    end

    if lancamento1 ~= 1 && lancamento2 ~= 1
        sucessD = sucessD + 1;
    end

end


probSimulacaoC = sum(sucessC) / N; 

probSimulacaoD = sum(sucessD) / N;

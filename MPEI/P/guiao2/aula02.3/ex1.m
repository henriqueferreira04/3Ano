pAndre = 0.01;   %probabilidade de erro
pBruno = 0.05; 
pCarlos = 0.001;

progAndre = 20;     %nº de programas
progBruno = 30;
progCarlos = 50;

erroA = pAndre * progAndre;
erroB = pBruno * progBruno;
erroC = pCarlos * progCarlos;

erroTotal = erroA + erroB + erroC;

N = 1e5;


probCarlos = erroC / erroTotal;

probBruno = erroB / erroTotal;

proAndre = erroA / erroTotal;


%%%%%%%%Probabilidade de Carlos = 0.286
%%%%%%%%A probabilidade de ser o programa do Bruno com erro = 86%


%%%%%EXPERIENTALMENTE%%%%%

tentativasA = rand(progAndre, N) < pAndre;
tentativasB = rand(progBruno, N) < pBruno;
tentativasC = rand(progCarlos, N) < pCarlos;

EXP = [tentativasA; tentativasB; tentativasC];

for c = 1:N

    programas = EXP(:,c);

    com_erro = programas(programas);

    [index, v] = find(programas == 1);

    if lenght(index) > 0
        x = randperm(index);
        res = x(1);
      
    end
end

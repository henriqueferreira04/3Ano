%a)

N = 1e5;
p = 1/6;        %probabilidade de cada numero do dado
vezes = 2;      %lançado 2 vezes

tentativas = randi(6, vezes, N);

sucessos = sum(tentativas) == 9;

probSimA = sum(sucessos) / N;


%%%%%%%%%
%2 valor ser par é 2, 4, 6, logo metade dos numeros do dado
sucessos = sum(tentativas(2,:)) / 2;

probSimB = sum(sucessos) / sum(sum(tentativas(2, :)));


%%%%%%%%%

lancamento_ser5 = 0;
lancamento_nao_ser1 = 0;

for c = 1 : N
        
    coluna = tentativas(:,c);

    if coluna(1) == 5 || coluna(2) == 5

        lancamento_ser5 = lancamento_ser5 + 1;

    end

    if coluna(1) ~= 1 && coluna(2) ~= 1

        lancamento_nao_ser1 = lancamento_nao_ser1 + 1;

    end

end

probSimC = lancamento_ser5 / N;

probSimD = lancamento_nao_ser1 / N;



%%%%%%%%%%%%%%%%%%%%%%
%b)

%as possiveis combinacoes sao 6 x 6 = 36

%possibilidades de A (3,6) , (4, 5), (5, 4), (6, 3)

pA = 4/36;

pB = 1/2;


%possibilidades de A interseção com B  (3, 6)  , (5, 4)


pA_com_B = 2/36;

%para serem independentes pA_com_B = pA * pB

pA_com_B2 = pA * pB;

%Dá igual, logo são independentes



%%%%%%%%%%%%%%%%%%%%%%
%c)

%possibilidades de C  2 x  ((1,5) , (2, 5), (3, 5), (4, 5) , (6, 5)) + (5, 5)
                        
pC = 11/36;

%possibilidades de D  36 - 11

pD = 25/36;

% possibilidades de C interseçao com D  (4 * 2) + 1

pC_com_D = 9/36;

%para serem independentes pC_com_D = pC * pD

pC_com_D2 = pC * pD;


%Dá diferente, logo não sao independentes

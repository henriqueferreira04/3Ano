%a)
N = 1e6;

pA = 0.01;          %probabilidade de erro num programa
pB = 0.05;
pC = 0.001;

progA = 20;         %nº de programas
progB = 30;
progC = 50;


pErro_A = pA * progA;
pErro_B = pB * progB;
pErro_C = pC * progC;

pErro_Total = pErro_A + pErro_B + pErro_C;

prob_Teorica_Carlos = pErro_C / pErro_Total;
prob_Teorica_Bruno = pErro_B / pErro_Total;
prob_Teorica_Andre = pErro_A / pErro_Total;


%%%%%%%%Probabilidade de Carlos = 0.0286
%%%%%%%%A probabilidade de ser o programa do Bruno com erro = 86%


%%%%experiencialmente

tentativasA = rand(progA, N) < pA;
tentativasB = rand(progB, N) < pB;
tentativasC = rand(progC, N) < pC;

matriz = [tentativasA ; tentativasB ; tentativasC];

erro_Carlos = 0;
erro_Bruno = 0;
erro_Andre = 0;
casosTotais = 0;

for c = 1 : N

    prog = randi(100);

    if (matriz(prog, c) == 1)

        casosTotais = casosTotais + 1;

        if (prog > 50) 
    
            erro_Carlos = erro_Carlos + 1;

        else 
            
            if (prog > 20)

                erro_Bruno = erro_Bruno + 1;

            else

                erro_Andre = erro_Andre + 1;

            end
        end

    end

end

probSim_Andre = erro_Andre / casosTotais;
probSim_Bruno = erro_Bruno / casosTotais;
probSim_Carlos = erro_Carlos / casosTotais;














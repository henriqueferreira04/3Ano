%a)
N = 1e5;
n = 20;         %nº de dardos
m = 100;        %nº de alvos

tentativas = randi(m, n, N);

colUnique = 0;

for c = 1: N

    coluna = tentativas(:, c);

    if (length(unique(coluna)) == n)    %vê se todos os dardos estao em alvos diferentes

        colUnique = colUnique + 1;  %cada alvo só foi atingido 1 vez
    
    end

end

probSimA = colUnique / N;


%%%%%%%%%%%%%%%%%%%%%%%%
%b)
 
col_notUnique = 0;

for c = 1: N

    coluna = tentativas(:, c);

    if (length(unique(coluna)) < n)

        col_notUnique = col_notUnique + 1;

    end

end


probSimB = col_notUnique / N;



%%%%%%%%%%%%%%%%%%%%%%%%
%c)

m_values = [1000, 100000];

n_values = 10:10:100;

probSim_mxn = zeros(length(m_values), length(n_values));

for i = 1 : length(m_values)

    m = m_values(i);
    
    for j = 1 : length(n_values)
    
        n = n_values(j);

        tentativas = randi(m, n, N);

        col_notUnique = 0;

        for c = 1: N
        
            coluna = tentativas(:, c);
        
            if (length(unique(coluna)) < n)
        
                col_notUnique = col_notUnique + 1;
        
            end
        
        end

        probSimC = col_notUnique / N;

        probSim_mxn(i,j) = probSimC;


    end

end


figure;

% Gráfico para m = 1000
subplot(1, 2, 1); 
plot(n_values, probSim_mxn(1, :), '-o');
title('Probabilidade Simulada para m = 1000');
xlabel('n (Número de dardos)');
ylabel('Probabilidade de 1 alvo ter sido atingido 2 ou +');
grid on;

% Gráfico para m = 100000
subplot(1, 2, 2);
plot(n_values, probSim_mxn(2, :), '-o');
title('Probabilidade Simulada para m = 100000');
xlabel('n (Número de dardos)');
ylabel('Probabilidade de 1 alvo ter sido atingido 2 ou +');
grid on;



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%d)

n = 100;

m_values = [200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000];

probSim_m = zeros(length(m_values), 1);



for i = 1 : length(m_values)

    m = m_values(i);

    tentativas = randi(m, n, N);

    col_notUnique = 0;

    for c = 1 : N

        coluna = tentativas(:,c);


        if(length(unique(coluna)) < n)

            col_notUnique = col_notUnique + 1;

        end

    end

    probSimD = col_notUnique / N;

    probSim_m(i) = probSimD;

end


figure;
plot(m_values, probSim_m, '-o');
title('Probabilidade Simulada para n = 100');
xlabel('m (Número de alvos)');
ylabel('Probabilidade de 1 alvo ter sido atingido 2 ou +');
grid on;





        


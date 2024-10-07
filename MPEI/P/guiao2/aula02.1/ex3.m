%a)
N = 1e5;
keys = 10;
T = 1000;

tentativas = randi(T, keys, N);

col_notUnique = 0;

for c = 1 : N

    coluna = tentativas(:,c);

    if length(unique(coluna)) < keys

        col_notUnique = col_notUnique + 1;

    end
end

probSimA = col_notUnique / N;



%%%%%%%%%%%%%%%%%%%%%%%%%
%b)

keys_values = 10:10:100;

probSim_keys = zeros(length(keys_values), 1);


for i = 1 : length(keys_values)

    keys = keys_values(i);

    tentativas = randi(T, keys, N);

    col_notUnique = 0;

    for c = 1 : N
    
        coluna = tentativas(:,c);
    
        if length(unique(coluna)) < keys
    
            col_notUnique = col_notUnique + 1;
    
        end
    end
    
    probSimB = col_notUnique / N;

    probSim_keys(i) = probSimB;

end


figure;
subplot(1, 2, 1); 
plot(keys_values, probSim_keys, '-o');
title('Probabilidade Simulada para T = 1000');
xlabel('keys (Número de keys)');
ylabel('Probabilidade de haver pelo menps 1 colisão');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%c)

keys = 50;
T_values = 100:100:1000;

probSim_T = zeros(length(T_values), 1);

for i = 1 : length(T_values)

    T = T_values(i);

    tentativas = randi(T, keys, N);

    colUnique = 0;

    for c = 1 : N

        coluna = tentativas(:,c);

        if length(unique(coluna)) == keys

            colUnique = colUnique + 1;

        end

    end

    probSimC = colUnique / N;

    probSim_T(i) = probSimC;

end


subplot(1, 2, 2); 
plot(T_values, probSim_T, '-o');
title('Probabilidade Simulada para keys = 50');
xlabel('T (Número de posições do array)');
ylabel('Probabilidade de não haver colisão');
grid on;
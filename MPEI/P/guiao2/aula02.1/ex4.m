%a)
N = 1e5;
n_values = 1:1:50;
dias = 365;

for i = 1 : length(n_values)

    n = n_values(i);

    tentativas = randi(dias, n, N);

    col_notUnique = 0;

    for c = 1 : N

        coluna = tentativas(:,c);

        if length(unique(coluna)) < n

            col_notUnique = col_notUnique + 1;

        end

    end
    
    
    probSimA = col_notUnique / N;

    if probSimA > 0.5
        
        n_minimoA = n;   %nº mínimo de pessoas para probabilidade ser > 0.5
        break
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b)

for i = 1 : length(n_values)

    n = n_values(i);

    tentativas = randi(dias, n, N);

    col_notUnique = 0;

    for c = 1 : N

        coluna = tentativas(:,c);

        if length(unique(coluna)) < n

            col_notUnique = col_notUnique + 1;

        end

    end
    
    
    probSimB = col_notUnique / N;

    if probSimB > 0.9
        
        n_minimoB = n;   %nº mínimo de pessoas para probabilidade ser > 0.9
        break
    end

end
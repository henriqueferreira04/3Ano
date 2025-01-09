function J = calcular_distancia(Set, Nu)

    J = zeros(Nu, Nu); % Array para guardar distâncias

    h = waitbar(0, 'Calculating'); % Barra de progresso
    
    
    for n1 = 1:Nu
        
        waitbar(n1 / Nu, h); % Atualiza a barra de progresso
        for n2 = n1+1:Nu
            % Conjunto de filmes do utilizador n1 e n2
            set1 = Set{n1};
            set2 = Set{n2};
            
            % Calcula a interseção e união
            intersection = length(intersect(set1, set2));
            union_set = length(union(set1, set2));
            
            % Calcula a distância de Jaccard
            if union_set > 0
                J(n1, n2) = 1 - (intersection / union_set);
            else
                J(n1, n2) = 1; % Caso não tenha filmes em comum
            end
        end
    end

    delete(h); % Remove a barra de progresso
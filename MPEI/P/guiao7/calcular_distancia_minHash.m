function  J = calcular_distancia_minHash(Set, Nu)

    J = zeros(Nu);
    h = waitbar(0, 'Calculating');

    %% Calcular matriz minHash
    MH = zeros(k, Nu);  %linha = hash function
        
        %para cada função de Hash
        for hf = 1:k
            %para cada user(mais propriamente conjunto desse user)
            for user = 1:Nu
                conjunto = Set(user);
                hash_codes = zeros(1, length(conjunto));
                %aplicar funcao de hash a todos os elementos do conjunto
                for elem = 1:length(conjunto)
                %obter minimo dos hash codes gerados
                    hash_codes(elem)= hashFunction(conjunto{elem}, hf);
                
                end

                minHash = min(hash_codes);

                MH(hf, user) = minHash;
                %guardar na matriz (posiçao = hash, user)
            end
        end

    

   %% 2 - calc distancia

        %para cada user
        for n1=1:Nu
            %para todos os outros
            for n2=1+1:Nu
                %obter as 2 assinaturas que sao colunas
                assinaturas1 = MH(:, n1);
                assinaturas2 = MH(:, n2);
                 
                %calcular num de valores iguais (na mesma posiçao)
                val_iguais = sum(assinatura1 == assinatura2);
                %distancia = num de valores iguais / k
                dist = 1 - val_iguais/ k;

            end
        end
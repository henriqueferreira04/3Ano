function SimilarUsers = calcular_pares_similares(J, Nu, users, threshold)


    % Array para guardar pares similares (user1, user2, distância)
    SimilarUsers = [];

    for n1 = 1:Nu
        for n2 = n1+1:Nu
            if J(n1, n2) < threshold
                SimilarUsers = [SimilarUsers; users(n1), users(n2), J(n1, n2)];
            end
        end
    end
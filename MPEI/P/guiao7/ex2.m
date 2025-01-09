udata = load('u.data'); 

[Set, Nu, users] = criar_conjuntos(udata);

J = calcular_distancia(Set, Nu);

threshold = 0.4;

SimilarUsers = calcular_pares_similares(J, Nu, users, threshold);


% Exibe os pares similares encontrados
disp('Pares similares encontrados:');
disp('User1   User2   Distância');
disp(SimilarUsers);

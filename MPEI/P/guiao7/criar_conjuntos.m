function [Set, Nu, users] = criar_conjuntos(ficheiro)
    
    % Fica apenas com as duas primeiras colunas
    u = ficheiro(1:end, 1:2); 
    clear ficheiro;

    users = unique(u(:, 1)); % Extrai os IDs dos utilizadores
    Nu = length(users); % Número de utilizadores
    
    % Constrói a lista de filmes para cada utilizador
    Set = cell(Nu, 1); % Usa células para armazenar os dados
    
    for n = 1:Nu % Para cada utilizador
        % Obtém os filmes de cada um
        ind = find(u(:, 1) == users(n));
        % Guarda os filmes em uma célula
        Set{n} = u(ind, 2)';
    end
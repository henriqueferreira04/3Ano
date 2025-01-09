% Código base para detecção de pares similares

% Carrega o ficheiro dos dados dos filmes
udata = load('u.data'); 

% Fica apenas com as duas primeiras colunas
u = udata(1:end, 1:2); 
clear udata;

% Lista de utilizadores
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

%% Calcula a distância de Jaccard entre todos os pares pela definição
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

%% Determina pares com distância inferior a um limiar pré-definido
threshold = 0.4; % Limiar de decisão

% Array para guardar pares similares (user1, user2, distância)
SimilarUsers = [];

for n1 = 1:Nu
    for n2 = n1+1:Nu
        if J(n1, n2) < threshold
            SimilarUsers = [SimilarUsers; users(n1), users(n2), J(n1, n2)];
        end
    end
end

% Exibe os pares similares encontrados
disp('Pares similares encontrados:');
disp('User1   User2   Distância');
disp(SimilarUsers);

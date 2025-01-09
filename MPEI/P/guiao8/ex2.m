% Matriz de transição H
H = [0.8 0.2 0.0 0.0;
     0.0 0.9 0.1 0.0;
     0.3 0.2 0.4 0.1;
     1.0 0.0 0.0 0.0];

% Estado inicial (começando na página 1)
v = [1 0 0 0]'; 
% Número de passos
n = 1000;
% Calcula H^n * v
res = H^n * v;

% Resultado: probabilidade de estar na página 2 após 1000 passos
fprintf('Probabilidade de estar na página 2 após 1000 passos: %f\n', res(2));


%%
%c)
steps = [1, 2, 10, 100];

% Calcular H^n para cada n em steps
for n = steps
    Hn = H^n; % Potência n da matriz de transição
    fprintf('\nProbabilidades de transição após %d passos (H^%d):\n', n, n);
    disp(Hn);
end



%%
%d)
Q = H(1:3, 1:3);

% Exibir a matriz Q
fprintf('Matriz Q (transições entre estados transitórios):\n');
disp(Q);



%%
%e)
I = eye(size(Q)); % Matriz identidade
F = inv(I - Q);   % Matriz fundamental

% Exibir matriz F
fprintf('Matriz fundamental F:\n');
disp(F);


%%
%f)
t = sum(F, 2); % Soma das linhas de F

fprintf('Média de passos para atingir a página 4:\n');
fprintf('Partindo da página 1: %.4f passos\n', t(1));
fprintf('Partindo da página 2: %.4f passos\n', t(2));
fprintf('Partindo da página 3: %.4f passos\n', t(3));



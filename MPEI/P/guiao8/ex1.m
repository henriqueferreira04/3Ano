%b)

T = [0.7, 0.2, 0.3; 
     0.2, 0.3, 0.3;
     0.1, 0.5, 0.4
    ];

v0 = [1 0 0]';
v2 = T^2 * v0;

fprintf("Alinea c) Probabilidade do dia 2 ser de chuva e dia 0 é sol: %.2f\n", v2(3));


%%
%c)

n_max = 20; % Número de iterações

% Inicialização dinâmica do vetor de elementos
num_elements = numel(T); % Número total de elementos em T (m^2)
elements = zeros(num_elements, n_max); % Matriz para armazenar elementos

% Cálculo das potências da matriz
Tn = T; % Inicializa T^1 = T
for n = 1:n_max
    elements(:, n) = Tn(:); % Salva os elementos da matriz (em vetor coluna)
    Tn = Tn * T; % Calcula T^(n+1)
end

% Gráfico da evolução dos elementos
figure;
plot(1:n_max, elements', 'LineWidth', 2);
xlabel('n (Iteração)');
ylabel('Valores dos elementos de T^n');
title('Evolução dos elementos da matriz T^n');
grid on;

%%
%d)

diff = inf; % Inicializa diferença
n = 1;
Tn = T;
while diff > 10^-4
    T_prev = Tn;
    Tn = Tn * T; % Atualiza T^n
    diff = max(max(abs(Tn - T_prev))); % Máximo do módulo da diferença
    n = n + 1;
end

fprintf('Não excede a diferença de 10^4 em n = %d.\n', n);


%%
%f)
% Resolver o sistema linear pi * T = pi
A = [T - eye(3); ones(1,3)]; % Matriz aumentada
b = [zeros(1,3) 1]'; % Restrições: pi * T = pi e soma(pi) = 1

% Resolver o sistema
v_stationary = A \ b;

fprintf('Vetor estado estacionário:\n');
disp(v_stationary')
fprintf("T * vetor estimado\n");
disp(T * v_stationary);
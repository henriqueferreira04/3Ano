M = [0.9, 0.5, 0.5
     0.09, 0.4, 0.4
     0.01, 0.1, 0.1
     ];

v_1 = [0 0 1]';

%%
%Determine a probabilidade do quarto pacote ser recebido sem erros, com 1 erro ou com 2 ou mais

P4 = M^3 * v_1;

%%
%Determine a probabilidade estacionária dos estados calculando a probabilidade de cada estado até ao pacote em que a diferença de cada probabilidade entre esse pacote e o anterior seja não superior a 0.001.
%Com base no resultado obtido, qual a probabilidade de perda de pacote? Qual seria a probabilidade de perda de pacote sem o código corretor de erros?

tolerance = 0.001;
max_iters = 1000;

p_old = P1;

for i = 1:max_iters
    p_new = M * p_old;
    
    % Critério de parada: diferença máxima entre pacotes sucessivos
    if max(abs(p_new - p_old)) < tolerance
        break;
    end
    
    p_old = p_new;
end

% Resultado final (probabilidade estacionária)
p_stationary = p_new;

% Exibir resultado
disp("Probabilidade Estacionária dos Estados:");
disp(p_stationary);
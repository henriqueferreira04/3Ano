%a)

num_alunos = 120;
media1 = 14;
media2 = 1.2 * media1;

var1 = 0.25 * media1;
var2 = 0.25 * media2;

aux1 = randn(1, num_alunos) * sqrt(var1) + media1;
N1 = round(aux1);

aux2 = randn(1, num_alunos) * sqrt(var2) + media2;
N2 = round(aux2);


Sn1 = min(N1):max(N1);
Sn2 = min(N2):max(N2);

%b)

freq_conj = histcounts2(N1, N2, Sn1, Sn2);

% Normalizando para obter a função de probabilidade conjunta
prob_conj = freq_conj / num_alunos;

% Ajustando as dimensões de joint_prob para corresponder a X e Y
[X, Y] = meshgrid(Sn1(1:end-1), Sn2(1:end-1));  % Exclui último ponto para combinar

% Usando stem3 para visualizar a função de massa de probabilidade conjunta
figure;
stem3(X, Y, prob_conj');
xlabel('N1');
ylabel('N2');
zlabel('P(N1, N2)');
title('Função de Massa de Probabilidade Conjunta de N1 e N2');


%c)

E_N1 = sum(N1) / num_alunos;
E_N2 = sum(N2) / num_alunos;


E_N1N2 = sum(N1 .* N2) / num_alunos;

cov_N1_N2 = E_N1N2 - (E_N1 * E_N2);

E_N1_squared = sum(N1.^2) / num_alunos; 
E_N2_squared = sum(N2.^2) / num_alunos;  


var_N1 = E_N1_squared - (E_N1^2); 
var_N2 = E_N2_squared - (E_N2^2);  


desvio_N1 = sqrt(var_N1);
desvio_N2 = sqrt(var_N2);

% Calcular o coeficiente de correlação
coeficiente_correlacao = cov_N1_N2 / (desvio_N1 * desvio_N2);
%a)
p = 0.5;        % ou é "cara" ou "coroa"
N = 1e5;
n = 4;          % nº de lancamentos de moeda

xi = [0, 1, 2, 3, 4];

lancamentos = rand(4, N) < 0.5;

pX = zeros(length(xi), 1);

for c = 1 : N
    
    coluna = lancamentos(:,c);

    coroa_index = sum(coluna) + 1;

    pX(coroa_index) = pX(coroa_index) + 1;

end

pX = pX / N;


stem(xi, pX), xlabel('x'), ylabel('p(x)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b)

valor_esperado_E_X = sum(xi * pX);

E_X2 = xi .^ 2 * pX;      
variancia = E_X2 - (valor_esperado^2);  

desvio_padrao = sqrt(variancia);


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%c)

i = 1;
pCoroa = 0.5;
pt = zeros(length(xi), 1);

for k = xi
    pt(i) = nchoosek(n , k) * pCoroa ^k * (1 - pCoroa)^(n-k);

    i = i + 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%
%d)

stem(xi, pX);
hold on;
plot(xi, pt, 'b+');


%%%%%%%%%%%%%%%%%%%%%%
%e)


valor_esperado_teorico_E_X = n * pCoroa;        % E[X] = n*p
variancia_teorica = n * pCoroa * (1 - pCoroa); % Var(X) = n*p*(1-p)
desvio_padrao_teorico = sqrt(variancia_teorica); 


%%%%%%%%%%%%%%%%%%%%%%
%f)

fX = cumsum(pX);

%%i)

resultado_i = 1 - fX(xi == 1);

%%ii)

resultado_ii = fX(xi == 1);

%%iii)

resultado_iii = fX(xi == 3) - fX(xi == 0);

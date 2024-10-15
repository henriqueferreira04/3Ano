%a)
N = 1e5;
p = 0.3;     %probabilidade de peça defeituosa
n = 5;       %nº de peças escolhidas aleatoriamente
%%i)

xi = [0, 1, 2, 3, 4, 5];

tentativas = rand(5, N) < p;

pX = zeros(length(xi), 1);

for c = 1 : N

   coluna = tentativas(:, c);

   defeituosas_index = sum(coluna) + 1;

   pX(defeituosas_index) = pX(defeituosas_index) + 1;

end

pX = pX / N;

subplot(121)
stem(xi, pX), xlabel('x'), ylabel('p(x)');


%%ii)
subplot(122)
fX = cumsum(pX);
stairs([0, xi], [0; fX]); 

%%iii)

resultado_a_iii = fX(xi==2);


%%%%%%%%%%%%%%%%%%%%%%%%
%b)
%%i)

i = 1;
pt = zeros(length(xi), 1);
ft = zeros(length(xi), 1);

for k = xi
    pt(i) = nchoosek(n , k) * p ^k * (1 - p)^(n-k);
    
    if (i > 1)
        ft(i) = pt(i) + ft(i-1);
    else
        ft(i) = pt(i);
    end
    i = i + 1;
end


%%ii)

resultado_b_ii = ft(xi==2);



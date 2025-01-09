%a)

k = 7;   %variavel aleatoria X = 7
n = 8000;
p = 1/1000;

P_X = nchoosek(n, k) * p^k * (1-p)^(n-k);

%%%%%%%%%%%%%%%%%%
%b)

lambda = 8;

p_k = 8^k * exp(-lambda) / factorial(k);


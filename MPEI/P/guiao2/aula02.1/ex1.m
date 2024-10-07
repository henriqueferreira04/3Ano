% a)

N=1e5;
p = 0.5;        %probabilidade de ser rapaz
k = 1;          
n = 2;          %familias de 2 filhos


familias = rand(n, N) < p;   
sucessos = sum(familias) >= k;

probSimA = sum(sucessos) / N;   


%%%%%%%%%%%%%%%%%%%%%
%b)

%probabilidade de haver 1 rapaz = 1 - P(2 raparigas)
%logo, P(pelo menos 1 rapaz) = 1 - P(rapariga) * P(rapariga)
% 1 - (0.5 * 0.5) = 1 - 0.25 = 0.75 = 75%


%%%%%%%%%%%%%%%%%%%%%
%c)

k = 2;  %2 rapazes

casosTotais = sum(familias) >= 1;
sucessos = sum(familias) == k;

probSimC = sum(sucessos) / sum(casosTotais);


%%%%%%%%%%%%%%%%%%%%%
%d)

casosTotais = familias(1,:) == 1;  %1ºfilho ser rapaz
sucessos = sum(familias) == k;     %ser os 2 rapazes

probSimD = sum(sucessos) / sum(casosTotais);


%%%%%%%%%%%%%%%%%%%%%
%e)

n = 5;      %familias de 5 filhos
k = 2;      %familias com 2 rapazes

familias = rand(n, N) < p;

casosTotais = sum(familias) >= 1;  %familias com pelo menos 1 rapaz
sucessos = sum(familias) == k;

probSimE = sum(sucessos) / sum(casosTotais);


%%%%%%%%%%%%%%%%%%%%%
%f)

sucessos = sum(familias) >= k;

probSimF = sum(sucessos) / sum(casosTotais);



lambda = 0.02;    
lambda = lambda * 100;

erro = 1;          %1 erro por 100 paginas
p_k_total = 0;

for k = 0 : erro

    p_k_total = p_k_total + (lambda^k * exp(-lambda) / factorial(k));
  
end


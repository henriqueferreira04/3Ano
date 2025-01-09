%a)

lambda = 15;   %receber 15msg/s  == 15*4/4s
lambda = lambda * 4;      %60/4s

k = 0;          %não receber msg, 0/4s

p_k_a = lambda^k * exp(-lambda) / factorial(k);


%%%%%%%%%%%%%%%%%%%%%%%
%b)

msg = 40;    %receber mais do que 40 msg/4s

p_k_resto = 0;

for k = 0 : msg             %calcular para k < 41, para saber 41/4s

    p_k_resto = p_k_resto + (lambda^k * exp(-lambda) / factorial(k));
 
end

p_k_b = 1 - p_k_resto;
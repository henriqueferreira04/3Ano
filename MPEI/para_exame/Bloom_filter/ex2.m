m = 300;  % número de elementos a inserir
probFalsePositive = 0.03; % 3% de probabilidade de falsos positivos
k = 1;  % k funções dispersão

for i = 1e2:1:1e7
    n = i;
    
    prob = (1 - exp(-k*m/n))^k;  % probabilidade de falsos positivos
    if prob <= probFalsePositive
        break;
    end
end
fprintf("Tamanho adequado do filtro de bloom: %d\n", i);


%%
BF = initialize_Bloom_Filter(i);

n = 300;
chars = char('a':'z')';

words = generate_keys(n, 5, 8, chars);

count = 0;
for j = 1 : length(words)
    hc = string2hash(char(words(j)));
    index = mod(hc, i) + 1;
    BF(index) = 1;
    count = count + 1;
end


newwords = generate_keys(10000, 5, 8, chars);
fp = 0;

for j = 1 : length(newwords)
    
    hc = string2hash(char(newwords(j)));
    index = mod(hc, i) + 1;

    if BF(index) == 1
       fp = fp + 1;
    end
end

fprintf("Prob falsos positivos = %.4f\n", fp / 10000);


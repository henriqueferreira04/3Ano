n = 8000;

BF = initialize_Bloom_Filter(n);

k = 3;


N = 1000;
i_min = 6;
i_max = 20;
alfabeto = ['a':'z' 'A':'Z'];

palavras = generate_keys(N, i_min, i_max, alfabeto);

for i = 1:N
    palavra = char(palavras(i)); 
    BF = add_to_Bloom_Filter(palavra, BF, k);
end

sum(BF)
stem(BF)


N = 100000;
novas_palavras = generate_keys(N, i_min, i_max, alfabeto);
n_resp = zeros(1, N);

for i = 1:N
    palavra = char(novas_palavras(i));
    r = belongs_to_Bloom_Filter(palavra, BF, k);
    
    if r == 1
        n_resp(i) = 1;

    end
end


p = sum(n_resp)/ N;

fprintf(['Percentagem de falsos positivos: %.2f'], p * 100);

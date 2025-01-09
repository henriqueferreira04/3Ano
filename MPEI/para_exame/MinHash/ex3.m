frase1 = 'Lisboa e Porto são duas cidades importantes de Portugal.';
frase2 = 'Lisboa é a capital de Portugal.';
frase3 = 'Porto é a capital do Norte de Portugal.';
frase4 = 'Portugal não é só Lisboa e Porto.';

frases = {frase1, frase2, frase3, frase4}';

shingle_size = 3;
nhf = 4;
signatures = zeros(nhf , 4);

for hf = 1 : 4
    for i = 1 : length(frases)
        frase = frases{i};
    
        nshingles = length(frase) - shingle_size + 1;
        hashcodes = zeros(nshingles, 1);
        for n = 1 : nshingles
            shingle = frase(n: n + shingle_size - 1);
            hc = hf1(shingle, hf);
            hashcodes(n) = hc;
        end
    
        signatures(hf, i) = min(hashcodes);
    
    end
end


%%

J = zeros(4);
for n1 = 1:4
    for n2 = n1+1:4
        
        c1 = signatures(:, n1);
        c2 = signatures(:, n2);

        J(n1, n2) = sum(c1 ~= c2)/nhf;
    end
end



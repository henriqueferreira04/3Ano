%a)

frases = {'just plain boring', 'entirely predictable and lacks energy', ...
    'no surprises and very few laughs', 'very powerful', ...
    'the most fun film of the summer'};



palavras_totais = {};

for frase = frases

    palavras = split(frase);
    
    palavras_totais = [palavras_totais; palavras];

    
end

palavras_unicas = unique(palavras_totais);

%%%%%%%%%%%%%%%
%b)

matriz_palavras = zeros(length(frases), length(palavras_unicas));

for i = 1:length(frases)
    palavras = split(frases{i});

    for j = 1:length(palavras_unicas)
        
        matriz_palavras(i, j) = sum(strcmp(palavras, palavras_unicas{j}));
    end
end


%%%%%%%%%%%%%%%%%%
%c)
classes = ['-', '-', '-', '+', '+']';


%%%%%%%%%%%%%%%%%
%d)

%P('-')

docs_neg = sum(classes == '-');

total_docs = length(classes);

p_neg = docs_neg / total_docs;

%P('+')

docs_pos = sum(classes == '+');

p_pos = docs_pos / total_docs;

%P(predictable | '+')


linhas_classe = classes == '+'; 
matriz_classe = matriz_palavras(linhas_classe, :); %linhas da matriz '+'
ocorrencia = sum(matriz_classe) + 1;        %soma de cada palavra em '+'

total = sum(matriz_classe(:)) + length(palavras_unicas);  

prob_palavra_classe_positiva = ocorrencia / total;


%%%%%%%%%%%%%%%%%%%%%%

linhas_classe = classes == '-'; 
matriz_classe = matriz_palavras(linhas_classe, :); %linhas da matriz '-'
ocorrencia = sum(matriz_classe) + 1;        %soma de cada palavra em '-'

total = sum(matriz_classe(:)) + length(palavras_unicas);  

prob_palavra_classe_negativa = ocorrencia / total;




%P('+' | Frase de teste) = P(Frase de teste | '+') * P('+') / P(frase de teste)


palavras_teste = {'Predictable', 'No', 'Fun'};

prob = 1;

for p = 1 : length(palavras_teste)

    palavra = palavras_teste(p);

    index = strcmpi(palavras_unicas, palavra);

    prob = prob * prob_palavra_classe_negativa(index);
end

pTest_neg = prob * p_neg;

prob = 1;

for p = 1 : length(palavras_teste)

    palavra = palavras_teste(p);

    index = strcmpi(palavras_unicas, palavra);

    prob = prob * prob_palavra_classe_positiva(index);
end

pTest_pos = prob * p_pos;

%%logo é um comentario negativo


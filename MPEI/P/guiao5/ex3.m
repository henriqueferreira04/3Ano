%% Dados de Treino: 2
% Caracter ́ısticas
% [Ac ̧ ̃ao?, Com ́edia?, Dura ̧c ̃ao, Num Avalia ̧c ̃oes positivas]
X=[1 0 1 1;
   0 1 0 0;
   0 1 0 1;
   1 0 1 1;
   1 1 0 1;
   0 1 0 0];

classes = categorical({'Interessa', 'Não Interessa', 'Interessa', ...
 'Interessa', 'Interessa','Não Interessa'});


%P('Interessa')

docs_interessa = sum(classes == 'Interessa');

total_docs = length(classes);

p_interessa = docs_interessa / total_docs;

%P('Nao Interessa')

docs_n_interessa = sum(classes == 'Não Interessa');

p_n_interessa = docs_n_interessa / total_docs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


linhas_classe = classes == 'Interessa'; 
matriz_classe = X(linhas_classe, :);        %linhas da matriz 'interessa'
ocorrencia = sum(matriz_classe) + 1;        %soma de cada  em 'Interessa'

total = sum(matriz_classe(:)) + 4;  

prob_palavra_classe_interessa = ocorrencia / total;


%%%%%%%%%%%%%%%%%%%%%%

linhas_classe = classes == 'Não Interessa'; 
matriz_classe = X(linhas_classe, :); %linhas da matriz 'Nao Interessa'
ocorrencia = sum(matriz_classe) + 1;        %soma de cada palavra em 'Nao Interessa'

total = sum(matriz_classe(:)) + 4;  

prob_palavra_classe_n_interessa = ocorrencia / total;


%%%%%%%%%%%%%%%%%%%%%%%
%a)

filme_testes = [1, 0, 1, 1;
                0, 1, 0, 0;
                1, 1, 0, 0];




for i = 1:size(filme_testes, 1)
    
    teste = filme_testes(i, :);
    
    prob = 1;
    for j = 1 : length(teste)
        
        categoria = teste(j);

    
        if categoria == 1
            
            prob = prob * prob_palavra_classe_interessa(j);
        
        else
    
            prob = prob * (1- prob_palavra_classe_interessa(j));
        end
       
    end

    pTest_interessa = prob * p_interessa;

    prob = 1;
    for j = 1 : length(teste)
        
        categoria = teste(j);

    
        if categoria == 1
            
            prob = prob * prob_palavra_classe_n_interessa(j);
        
        else
    
            prob = prob * (1- prob_palavra_classe_n_interessa(j));
        end
        
    end

    pTest_n_interessa = prob * p_n_interessa;

    
    disp(teste);
    
    
    fprintf('Probabilidade de Interessa: %.4f\n', pTest_interessa);
    fprintf('Probabilidade de Não Interessa: %.4f\n', pTest_n_interessa);


    


end




data = readcell('PL5Ex2(in).csv');
   
X = cell2mat(data(2:end, 2:end-1));

palavras = data(1, 2:end-1);

classes = categorical(data(2:end, end));


num_emails = length(data(2:end, 1));

precision = zeros(10, 1);
recall = zeros(10, 1);
f1_score = zeros(10, 1);

for i = 1 : length(precision)

    index_list = randperm(num_emails);
    
    
    emails_treino_index = index_list(1:num_emails * 0.7);
    emails_teste_index = index_list((num_emails*0.7) + 1:end);
    
    classes_treino = classes(emails_treino_index);
    
    p_spam = sum(classes_treino == 'SPAM') / length(classes_treino);
    p_ok = sum(classes_treino == 'OK') / length(classes_treino);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    linhas_classe = classes_treino == 'SPAM'; 
    matriz_classe = X(linhas_classe, :);        %linhas da matriz 'SPAM'
    ocorrencia = sum(matriz_classe) + 1;        %soma de cada  em 'SPAM'
    
    total = sum(matriz_classe(:)) + length(palavras);  
    
    prob_palavra_classe_spam = ocorrencia / total;
    
    
    
    %%%%%%%%%%%%%%%%%
    linhas_classe = classes_treino == 'OK'; 
    matriz_classe = X(linhas_classe, :);        %linhas da matriz 'OK'
    ocorrencia = sum(matriz_classe) + 1;        %soma de cada  em 'OK'
    
    total = sum(matriz_classe(:)) + length(palavras);  
    
    prob_palavra_classe_ok = ocorrencia / total;
    
    success = 0;
    false_positive = 0;
    false_negative = 0;
    %%%%%%%%%%%%%%%%%%%
    
    for index = emails_teste_index
        
        email = X(index,:);
        
    
        prob = 1;
        for j = 1 : length(email)
            
            categoria = email(j);
    
        
            if categoria == 1
                
                prob = prob * prob_palavra_classe_spam(j);
            
            else
        
                prob = prob * (1- prob_palavra_classe_spam(j));
            end
           
        end
    
        pTest_SPAM = prob * p_spam;
    
        prob = 1;
        for j = 1 : length(email)
            
            categoria = email(j);
    
        
            if categoria == 1
                
                prob = prob * prob_palavra_classe_ok(j);
            
            else
        
                prob = prob * (1- prob_palavra_classe_ok(j));
            end
           
        end
    
        pTest_OK = prob * p_ok;
    
    
        disp(email);
    
        
        fprintf('Index: %d Type: %s\n', index, categorical(data(index, end)));
        fprintf('Probabilidade de SPAM: %f\n', pTest_SPAM);
        fprintf('Probabilidade de OK: %f\n', pTest_OK);
        
        if pTest_OK > pTest_SPAM
            fprintf('Probably is OK')
            if categorical(data(index, end)) == 'OK'
                success = success + 1;
    
            else
                false_negative = false_negative + 1;
            end
        
        else
            fprintf('Probably is SPAM')
            if categorical(data(index, end)) == 'SPAM'
                success = success + 1;
            else
                false_positive = false_positive + 1;
            end
         
    
        end
    end
    
    precision(i) = success / (success + false_positive) * 100;
    recall(i) = success / (success + false_negative) * 100;
    f1_score = 2 * (precision(i) * recall(i) / (precision(i) + recall(i)));

    

end


avg_precision = sum(precision) / length(precision);
avg_recall = sum(recall) / length(precision);


fprintf('\nPrecisão média: %0.2f', avg_precision);
fprintf('\nRecall média: %0.2f', avg_recall);

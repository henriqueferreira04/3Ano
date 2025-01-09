function BF = add_to_Bloom_Filter(elemento, BF, k)
     
    % repetir k vezes
        % aplicar funcao de hash a elemento
        % .....obtendo indice
        % garantir que indice está no intervalo 1 a n
        % na posicao indice do array igualar a 1

    chave = elemento;

    for hash_f = 1 : k
         
         chave = [chave, num2str(hash_f)];
         disp(chave)
         indice = string2hash(chave);
          
         indice = mod(indice, length(BF)) + 1;
           
         BF(indice) = 1;
            

    end


end
   
    
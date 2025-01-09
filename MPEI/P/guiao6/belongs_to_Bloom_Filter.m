function res = belongs_to_Bloom_Filter(x, BF, k)
    
    res = true;
    chave = x;

    for hash_f = 1 : k
         
         chave = [chave, num2str(hash_f)];
         indice = string2hash(chave);
          
         indice = mod(indice, length(BF)) + 1;
           
         if BF(indice) == 0
             res = false;
             break
         end
  
    end


end
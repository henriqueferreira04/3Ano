keys_num = 10^5;
hashcodes_size = [5*10^5, 10^6, 2*10^6];
chaining_hashTables = cell(length(keys_num), 1);


for i = 1 : length(hashcodes_size)

  alfabeto = ['a':'z' 'A':'Z'];
  i_min = 6;
  i_max = 20;

  keys = generate_keys(keys_num, i_min, i_max, alfabeto);
   
  for index = 1 : length(keys)
    hc = string2hash(keys{index});
    hc = mod(hc, hashcodes_size(i) + 1);
    keys{index} = hc;
  end
    
    
  chaining_hashTables{i} = keys;

end


for i = 1:length(hashcodes_size)
    subplot(1, 3, i);  % Cria um subgráfico, 1 linha e 3 colunas
    
    scatter(1:length(chaining_hashTables{i}), cell2mat(chaining_hashTables{i}));  % Plotar os hashes
    title(['Hash Keys: ', num2str(hashcodes_size(i))]);
    xlabel('Key index');
    ylabel('HashCode');
end
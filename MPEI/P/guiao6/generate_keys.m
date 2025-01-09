function keys = generate_keys(N, i_min, i_max, chars, probs)
    
    if nargin < 5
        probs = ones(1, length(chars)) / length(chars);
    end
    
    keys = cell(N, 1);

    for n = 1 : N

        size_key = randi([i_min, i_max]);
        
        index_rand = randi(length(chars),1, size_key);
        keys{n} = chars(index_rand);

    end

end
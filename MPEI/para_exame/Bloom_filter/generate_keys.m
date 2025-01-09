function keys = generate_keys(N, iMin, iMax, usableChars, probs)
    if nargin < 5
        probs = ones(length(usableChars),1)*(1/length(usableChars));
    end
        
    keys = cell(N,1);
    while 1
        for i=1:N
            n = rand(1);
            if n <= 0.4
                size = iMin;
            else
                size = iMax;
            end
            key_size = size;
            char_indices = randsample(1:length(usableChars), key_size, true, probs);
            key = usableChars(char_indices)';
            keys{i} = key;
        end
        if length(unique(keys)) == length(keys)
            break
        end
    end
end
function hc = hash_function(elemento, hf, R, p)

    codigos_ASCII = double(elemento);
    %r = randi(1234567, 1, 3);
    r = R(hf, :);
    hc = mod(codigos_ASCII * r', p);



   
    
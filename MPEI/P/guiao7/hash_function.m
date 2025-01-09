function  hf = hash_function(elem, hf, R)

    a = R.a(hf);
    b = R.b(hf);

    hc = mod(a*elem + b, R.p);
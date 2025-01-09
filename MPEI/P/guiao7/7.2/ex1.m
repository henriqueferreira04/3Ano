ks = 3;
[movie_names, set] = shingle('film_info.txt', ks);

p = 100003;
nhf = 100;
R = randi(p, nhf, ks);


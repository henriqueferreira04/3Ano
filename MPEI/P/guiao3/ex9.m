N = 1e5;
media = 14;
desvio_padrao = 2;

notas = media + desvio_padrao * randn(1, N);


alunos_12a16 = sum(notas> 12 & notas < 16) / N;
alunos_10a18 = sum(notas> 10 & notas < 18) / N;
alunos_passou = sum(notas >= 10) / N;

%%%%%%
%%%b)

%P(10 < X < 18)
%P((10-14)/2 < z < (18-14)/2)
%= Fz(2) - Fz(-2)
%= Fz(2) - (1 - Fz(2))
%= 1 - Q(2) - (1 - (1 - Q(2)))
%=1 - Q(2) + 1 - 1 - Q(2)
%= 1 - 2Q(2) = 0.954




P_a = normcdf(16, media, desvio_padrao) - normcdf(12, media, desvio_padrao);
P_b = normcdf(18, media, desvio_padrao) - normcdf(10, media, desvio_padrao);
P_c = 1- normcdf(10, media, desvio_padrao);

        
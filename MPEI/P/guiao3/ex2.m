%a)

n = 100;

p = 1 / n;

%%%%%%%%%%%%%%%%%%
%b)

xi = [5, 50, 100];

n_notas = [90, 9, 1];

pX = zeros(length(xi), 1);

for i = 1 : length(xi)

    pX(i) = n_notas(i) / n;

end

stem(xi, pX), xlabel('x'), ylabel('p(x)');


%%%%%%%%%%%%%%%%%%%%%%%%%
%c)

graf_X = cumsum(pX);
stairs([0, xi], [0; graf_X]); 
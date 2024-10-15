%a)
n = 6;          %número de faces dum dado
xi = 1:n;
pX = ones(1,n)/n;

subplot(121);
stem(xi, pX), xlabel('x'), ylabel('p(x)');


%%%%%%%%%%%%%%%%%%%%%%%%%
%b)

subplot(122);

graf_X = cumsum(pX);
stairs([0, xi], [0, graf_X]);   %gráfico stairs
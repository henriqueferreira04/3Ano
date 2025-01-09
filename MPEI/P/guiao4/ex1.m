%a)
xyi = [0, 1, 2];


pXY = [
    [0.3, 0.2, 0],
    [0.1, 0.15, 0.05],
    [0, 0.1, 0.1]
];

pX = sum(pXY, 2);
pY = sum(pXY, 1);

subplot(121);
stem(xyi, pX), xlabel('x'), ylabel('p(x)');


subplot(122);
stem(xyi, pY), xlabel('y'), ylabel('p(y)');

%%%%%%%%%%%%%%%%%%%%
%b)

E_X = sum(xyi * pX);
E_X2 = sum(xyi.^2 * pX);
VarX = E_X2 - E_X^2;


E_Y = sum(xyi .* pY);
E_Y2 = sum(xyi.^2 .* pY);
VarY = E_Y2 - E_Y^2;


%%%%%%%%%%%%%%%%%%%%
%c)

E_XY = sum(sum((xyi' * xyi) .* pXY));

E_XxY = E_X * E_Y;

Covar_XY = E_XY - E_XxY;



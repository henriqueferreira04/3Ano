pXY = [1/8, 1/8, 1/24;
    
       1/8, 1/4, 1/8;
       
       1/24, 1/8, 1/24
       ];

xyi = [-1, 0, 1];


subplot(131)
imagesc(pXY)
colormap("gray")
colorbar()
title("E[XY]")



pX = sum(pXY, 2);
pY = sum(pXY, 1);

E_X = xyi .* pX;
E_Y = xyi' * pY;

E_XxY = E_X * E_Y';

diff = pXY - E_XxY;

subplot(132)
imagesc(E_XxY)
colormap("gray")
colorbar()
title("E[X] * E[Y]")


subplot(133)
imagesc(diff)
colormap("gray")
colorbar()
title("E[XY] - E[X] * E[Y]")



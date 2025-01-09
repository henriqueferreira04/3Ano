%       A      B        C      D       E       F

%   A   0      0        0      0       1       0

   %B   0.5    0        0      0       0.5     0

   %C   0      0.5      0      0.5     0       0

   %D   0      0        1      0       0       0
    
   %E   0      1        0      0       0       0

   %F   0      0        0      0       1       0


 M = [0,        0,      0,       0,      1,    0
      1,        0,      0,       0,      1,    0
      0,        1,    0        1,      0,      0
      0,        0,      1,       0,      0,      0
      0,        1,    0,       0,      0,      0
      0,        0,      0,       0,      1,    0
      ];


 M_10 = M^10;



d=sum(full(M));
M = M./d;
p = 0.8;
n = 6;

A=p*M+(1-p)*ones(n)/n;
A(isnan(A))=1/n;

pr0=ones(n,1)/n;
% -----------------------
iter=1;
pr=pr0;
epsilon=1e-4;
while 1
    fprintf(1,'iteração %d\n',iter);
    prold=pr;
    pr=A*pr;
    if max(abs(pr-prold))<epsilon 
        break;
    end
    iter=iter+1;
end

pr;




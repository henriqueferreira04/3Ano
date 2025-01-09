load("L.mat");
%identifique o valor de n (numero de paginas) e quais as que sao dead ends.
N = length(L);


for i=1: N
    if L(:,i) == 0
        disp(i);
    end
end


%%
% calcule a matriz H assumindo a mesma probabilidade de transição de cada
%%pagina para todas as paginas seguintes possiveis.

%d=sum(full(L)); % n de ligações (d)
%H=H./d
%p=0.85
%A=p*H+(1-p)*ones(N)/N % matriz da Google
%A(isnan(A))=1/N



H = zeros(N, N);

for i = 1 : N
    nLinks = sum(L(:,i));

    if nLinks == 0
        H(:, i) = 1/N;
         
    else
        for j = 1 : N
            if L(j, i) ~= 0
                H(j, i) = 1/nLinks;
            end
        end
    end
end


%%calcule a matriz A do google com beta = 0.85
p = 0.85;

A=p*H+(1-p)*ones(N)/N;


%%calcule o valor de pagerank de todas as paginas de forma exata
pr0=ones(N,1)/N;
iter=1;
pr=pr0;
epsilon=1e-3;
while 1
    prold=pr;
    pr=A*pr;
    if max(abs(pr-prold))<epsilon 
        break;
    end
    iter=iter+1;
end
pr

%%identifique as 3 paginas de melhor pagerank e indique o valor do pagerank
%%dessas paginas

best_3 = zeros(3,2);

for p = 1 : N
    for b = 1 : 3
        if pr(p) > best_3(b, 1)
            best_3(b, 1) = pr(p);
            best_3(b, 2) = p;
            break;
        end
    end
end


fprintf("Maiores pageranks:\n");

for i = 1 : size(best_3, 1)
    fprintf("nº%d -> %f\n", best_3(i,2), best_3(i,1));
end





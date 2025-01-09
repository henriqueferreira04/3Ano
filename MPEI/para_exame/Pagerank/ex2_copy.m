T = [0, 1, 1, 1, 0
     1, 0, 0, 1, 1
     1, 1, 1, 1, 0
     0, 0, 0, 0, 1
     0, 0, 1, 1, 0
     ];


%%
%Defina em Matlab a matriz da Google A = BH + (1 - B)[~NxN, em que: H, é
%matriz de hyperlinks e representa as probabilidades de transição entre
%páginas (da i para a j):[~INxN é uma matriz de N por N com todas as
%entradas iguais a 1/N; N representa o número de páginas. Assuma beta = 0..8
N = 5;
H = zeros(N, N);

for i = 1 : N
    nLinks = sum(T(:,i));

    if nLinks == 0
        disp(i)
        H(:, i) = 1/N;
         
    else
        for j = 1 : N
            if T(j, i) ~= 0
                H(j, i) = 1/nLinks;
            end
        end
    end
end


beta = 0.8;
A=beta*H+(1-beta)*ones(N)/N;

%%
%Usando a matriz A, qual o valor da estimativa do pagerank de cada página
%ao fim de 10 iterações do processo de cálculo? Considere que se inicializa
%esse valor com um valor igual para todas as páginas a 1/N

pr0=ones(N,1)/N;
iter=1;
pr=pr0;

while iter < 11
    prold=pr;
    pr=A*pr;
    
    iter=iter+1;
end
pr
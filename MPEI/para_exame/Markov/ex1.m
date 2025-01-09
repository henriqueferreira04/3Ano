%%%% O    F     D    U

T = [0.1, 0.25, 0.2, 0.25
     0.3, 0.25, 0.2, 0.25
     0.3, 0.25, 0.4, 0.25
     0.3, 0.25, 0.2, 0.25
     ];


%%
res = T^6 * T(:,2);

fprintf("A probabilidade da sétima sessão do jogo ser em ambiente Floresta é de:\n");
disp(res(2,1));
%%
M = [T - eye(4); ones(1,4)];
x = [0 0 0 0 1]';
u = M\x;
disp("d) Probabilidade limite de ser escolhido cenário Floresta = ");
disp(u(2,1));


%%
P2 = 0.25 * T(3,3);
P3 = T^2 * T(:, 3);
P4 = P3(4);
P5 = P4 * T(4,4);
P = P2 * P5;

fprintf("A probabilidade de nas primeiras 5 sessões do jogo, as sessões 1 e 2 serem em ambiente Deserto e as sessões 4 e 5 serem em ambiente Urbano.")
disp(P);




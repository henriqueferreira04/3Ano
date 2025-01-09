% a     b       c       d       ?       .


T = [0.7, 0.2,  0,     0,    0,  0
     0.2, 0,    0.3,   0,    0,  0
     0  , 0.6,  0.3,   0,    0,  0
     0.1, 0.2,  0.3,   0.1,  0,  0
     0,     0,    0,   0.4,  1,  0
     0,     0,  0.1,   0.5,  0,  1
     ];


%%
%Qual a probabilidade de sendo o primeiro carácter um 'a' o décimo carácter ser um 'c'? E, nas mesmas condições iniciais, a probabilidade do décimo quinto carácter ser um 'd'?

P0 = [1; 0; 0; 0; 0; 0];

P10 = T^9 * P0;

fprintf("Probabilidade do decimo caracter ser um 'c' é de: %d\n",P10(3));

P15 = T^14 * P0;

fprintf("Probabilidade do decimo caracter ser um 'd' é de: %d\n",P15(4));

%%
% Qual  a media(valor esperado do comprimento das cadeias de caracteres começadas em "c" e terminadas em "?" ou "." ?)

% Estados transitórios (a, b, c, d)
Q = T(1:4, 1:4);

% Matriz Fundamental
N = inv(eye(size(Q)) - Q);

% Tempo esperado para absorção a partir de 'c' (estado 3)
E_c = sum(N(3, :));

fprintf("O valor esperado do comprimento das cadeias começadas em 'c' e terminadas em '?' ou '.' é: %.4f\n", E_c);
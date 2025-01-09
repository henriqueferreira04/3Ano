p = logspace(-3,log10(1/2),100);

N = 1e5;

despenha_2motor = zeros(length(p), 1);
for i = 1 : length(p)

    tentativas_2motor = rand(2,N) < p(i);

    sucessos = sum(tentativas_2motor) > 1;

    despenha_2motor(i) = sum(sucessos) / N;

end


despenha_4motor = zeros(length(p), 1);
for i = 1 : length(p)

    tentativas_4motor = rand(4,N) < p(i);

    sucessos = sum(tentativas_4motor) > 2;

    despenha_4motor(i) = sum(sucessos) / N;

end

figure;
semilogx(p, despenha_2motor, 'b-', 'LineWidth', 2);

hold on;

semilogx(p, despenha_4motor, 'r-', 'LineWidth', 2);

title('Probabilidade de Despenho de Aviões');
xlabel('Probabilidade de Falha em um Motor');
ylabel('Probabilidade de Despenho');
legend('2 Motores', '4 Motores', 'Location','Best');
grid on;

xlim([1/30, 0.5])

hold off;

    



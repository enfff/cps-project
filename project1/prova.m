figure(2)

domain = linspace(-2,20);
hold on;
plot(domain, essential_eigenvalues(1).^domain, "r-");
plot(domain, essential_eigenvalues(2).^domain, "g-");
plot(domain, essential_eigenvalues(3).^domain, "b-");
plot(domain, essential_eigenvalues(2).^domain, "k-");
ylabel("Convergence Speed");
xlabel("Time");
axis tight
title("YOLO AGGIUNGI TITOLO");
% grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_3$', 'Interpreter','latex');
grid
hold off;
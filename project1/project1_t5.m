clear;
close all;
clc;

load stochasticmatrices
% load 'task5.mat'

n = 10;
q = 20;
h = 2; % sensor attacks
tau = 0.03;
% lambda = 2e-4/tau;
sigma = 1e-2;
nu = sigma*randn(q,1);
delta = 1e-7;
T = 1e5;

% conservo i dati per i plot
% rimangono fissi per ogni iterazione
eigenvalues = {zeros(q, 1), zeros(q, 1), zeros(q, 1), zeros(q, 1)};
essential_eigenvalues = zeros(1, 4);
max_iterations = 20;

% variano per ogni iterazione
cvg_times = zeros(max_iterations, 4);
misses = zeros(max_iterations, 4); % Quante volte sbaglia a stimare il supporto
accuracies = zeros(max_iterations, 4); % Quanto precisamente è stato stimato lo stato
X_means = zeros(max_iterations, 4, n, 1); % Media del consenso sullo stato

topologies = {Q1, Q2, Q3, Q4};

% La metto fuori perché dobbiamo calcolarlo una volta sola per tutte e
% venti le iterazioni
for idx=1:4
Q = topologies{idx}; % Itera tra le matrici dentro topologies
        % Calcola essential eigenvalues per Q; ci serve dopo
        tmp = abs(eig(Q));
        eigenvalues{idx} = tmp;
        essential_eigenvalues(idx) = tmp(end - 1);
        clear tmp; % tmp non ci serve più
end


for iteration=1:max_iterations

    a = zeros(q,1);
    a_i1= 1 + rand(1);
    a_i2= -a_i1;   
    S_a = randi(q,h,1);                 % calculates support of a (attack vec)
    a(S_a(1))= a_i1;
    a(S_a(2))= a_i2;
    while duplicates(S_a)               % check for duplicates
        S_a = randi(q,h,1);   
    end

    C = randn(q, n);
    x_tilde = rand(n ,1);
    y = C*x_tilde + nu + a;             % Genera y
    L = 2e-4*[zeros(n,1); ones(q, 1)];
    G = [C eye(q)];

    for idx=1:4
        Q = topologies{idx}; % Itera tra le matrici dentro topologies
        z_prec = zeros(n+q, q); % z(k)
        z_curr = zeros(n+q, q); % z(k+1)

        % DIST
        for k=1:T
            for i=1:q
                arg = zeros(n+q, 1);
                for j=1:q
                    arg = arg + Q(i,j)*z_prec(:, j);
                end
                z_curr(:, i) = IST(arg + tau*G(i,:)'*(y(i)-G(i,:)*z_prec(:, i)), L);

                z_prec_2 = z_prec; % per la condizione di uscita, non piace manco a me
                z_prec = z_curr;
                
            end
            
            % exit condition
            if k>1
                diff = 0;
                for w=1:q
                    diff = diff + norm(z_curr(:, w) - z_prec_2(:, w), 2);
                end
                
                if diff < delta % Stop criterion
                        disp(['Exit condition satisfied! Time: ', num2str(k)])
                    break
                end
            end
            
        end

        % Sensors Consensus
        X = z_curr(1:n, :);
        A = z_curr(n+1:n+q, :);
        miss = 0;

        for i=1:q
            A(i, :) = prune_array(A(i, :), 0.2);
        
            [~, a_found_indices] = zero_norm(A(i, :));
            [~, a_indices] = zero_norm(a);
                
            if ~compare(a_found_indices,a_indices)
                miss = miss+1;
            end

            clear a_found_indices a_indices;
        end
        
        % Calcola il valor medio dello stato stimato da tutti i sensori
        % nell'iterazione k+1-esima
        X_mean = zeros(n, 1);
        for i=1:q
            X_mean = X_mean + X(:, i);
        end
        X_mean = X_mean / q;

        misses(iteration, idx) = miss; % # times a support was badly estimated
        X_means(iteration, idx, :) = X_mean;
        accuracies(iteration, idx) = norm(x_tilde - X_mean, 2)^2;
        cvg_times(iteration, idx) = k+1;
    end
end

disp(accuracies)
disp(misses)
disp(cvg_times)

%% Plots

iterations = linspace(1, max_iterations, max_iterations);
figure(1)
% Rate of attack detection: how many times the support of a is correctly
% estimated, i.e., we identify the sensors under attack?
% subplot(2,2,1);
xlabel("Iterations");
ylabel("Misses (%)");
title("Attack Detection Rate");
axis padded
hold on;
plot(iterations, misses(:, 1)'/20, 'r.-');
plot(iterations, misses(:, 2)'/20, 'g*');
plot(iterations, misses(:, 3)'/20, 'b-.');
plot(iterations, misses(:, 4)'/20, 'ko');
grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_4$', 'Interpreter','latex');
hold off;

% Estimation accuracy

figure(2)
% subplot(2,2,2);
xlabel("Iterations");
ylabel("Accuracy");
title("State Estimation Accuracy");
axis padded
hold on;
plot(iterations, accuracies(:, 1)', 'r.-');
plot(iterations, accuracies(:, 2)', 'g.-');
plot(iterations, accuracies(:, 3)', 'b.-');
plot(iterations, accuracies(:, 4)', 'k.-');
grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_4$', 'Interpreter','latex');
hold off;

figure(3)
% Convergence time (1)
subplot(2,1,1)
hold on;
plot(iterations, cvg_times(:, 1)', 'r.-');
plot(iterations, cvg_times(:, 2)', 'g.-');
plot(iterations, cvg_times(:, 3)', 'b.-');
plot(iterations, cvg_times(:, 4)', 'k.-');
grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_4$', 'Interpreter','latex');
title("Convergence time")
axis padded
hold off;

% Convergence time (2) (= number of iterations): can you see a relationship
% between the essential spectral radius of Q and the convergence time?
subplot(2,1,2)
domain = linspace(-2,20);
hold on;
plot(domain, essential_eigenvalues(1).^domain, "r-");
plot(domain, essential_eigenvalues(2).^domain, "g-");
plot(domain, essential_eigenvalues(3).^domain, "b-");
plot(domain, essential_eigenvalues(4).^domain, "k-");
ylabel("Exponential decay");
xlabel("Time (t)");
axis tight
grid, legend('$\lambda_2(Q_1)^t$', '$\lambda_2(Q_2)^t$', '$\lambda_2(Q_3)^t$', '$\lambda_2(Q_4)^t$', 'Interpreter','latex');
hold off;

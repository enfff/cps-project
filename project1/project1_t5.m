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
C = randn(q, n);
x_tilde = rand(n ,1);
sigma = 1e-2;
nu = sigma*randn(q,1);
delta = 1e-7;
T = 1e5;

S_a = randi(q,h,1);                 % calculates support of a (attack vec)
while duplicates(S_a)               % check for duplicates
    S_a = randi(q,h,1);   
end

% Generates support of a
a = zeros(q,1);
a_i1= 1+ rand(1);
a_i2= -a_i1;   
a(S_a(1))= a_i1;
a(S_a(2))= a_i2;
clear a_i1 ai2;

y = C*x_tilde + nu + a;             % Genera y
L = 2e-4*[zeros(n,1); ones(q, 1)];
G = [C eye(q)];
Z = zeros(n+q, q, T+1);             % Matrice di bookeeping


% conservo i dati per i plot
% rimangono fissi per ogni iterazione
eigenvalues = {zeros(q, 1), zeros(q, 1), zeros(q, 1), zeros(q, 1)};
essential_eigenvalues = zeros(1, 4);
max_iterations = 20;

% variano per ogni iterazione
cvg_times = zeros(max_iterations, 4);
misses = zeros(max_iterations, 4); % Quante volte sbaglia a stiamre il supporto
accuracies = zeros(max_iterations, 4); % Quanto precisamente è stato stimato lo stato
X_means = zeros(max_iterations, 4, n, 1); % Media del consenso sullo stato

topologies = {Q1, Q2, Q3, Q4};


% Checking that Q_i are doubly stochastic. (Serve per la condizione sufficiente)
delta = 1e4;
for idx=1:4
    Q = topologies{idx};
    for i=1:20
        if (sum(Q(i, :)) - 1) > delta || (sum(Q(:, i)) - 1) > delta
            disp(['Matrix Q', num2str(idx), ' not doubly stochastic'])
            sum(Q(i, :))
            sum(Q(:, i))
            return
        end
    end
end

disp('tutto ok!! matrici doppio stocastiche')

% La metto fuori perché dobbiamo calcolarlo una volta sola per tutte e
% venti le iterazioni
for idx=1:4
Q = topologies{idx}; % Itera tra le matrici dentro topologies
        % Calcola essential eigenvalues per Q; ci serve dopo
        tmp = abs(eig(Q));
        eigenvalues{idx} = tmp;
        eigenvalues{idx} = abs(eigenvalues{idx});
        essential_eigenvalues(idx) = tmp(end - 1);
        clear tmp; % tmp non ci serve più
        disp(['Q', num2str(idx), ' max eigenvalue is ', num2str(max(eigenvalues{idx}))])
        % Since the sufficient condition is satisfied (max eigenvalue == 1), we didn't
        % investigate any further.
end

%% 
% La ciccia sta qua
for iteration=1:max_iterations
    for idx=1:4
        Q = topologies{idx}; % Itera tra le matrici dentro topologies
    
        for k=1:T
            for i=1:q
                arg = zeros(n+q, 1);
                for j=1:q
                    arg = arg + Q(i,j)*Z(:, j, k);
                end
                Z(:, i, k+1) = IST(arg + tau*G(i,:)'*(y(i)-G(i,:)*Z(:, i, k)), L);
            end
            
            if k > 1 % Salta la prima iterazione
                diff = 0;
                for i=1:q
                    diff = diff + norm(Z(:,i, k-1) - Z(:,i, k),2);
                end
        
                if diff < delta % Stop criterion
                    break
                end
            end
        end
        
        z_est = Z(:,:,k+1); % Sensors Consensus
        X = z_est(1:n, :);
        A = z_est(n+1:n+q, :);
        
        miss = 0;
        for i=1:q
            A(:, i) = prune_array(A(:, i), 0.2);
        
            [~, a_found_indices] = zero_norm(A(:, i));
            [~, a_indices] = zero_norm(a);
                
            if ~compare(a_found_indices,a_indices)
                miss = miss+1;
                return
            end
        end
        
        % Calcola il valor medio dello stato stimato da tutti i sensori
        X_mean = zeros(n, 1);
        for i=1:q
            X_mean = X_mean + X(:, i);
        end
        X_mean = X_mean / q;
        
        misses(iteration, idx) = miss; % # times a got badly estimated
        X_means(iteration, idx, :) = X_mean;
        accuracies(iteration, idx) = norm(x_tilde - X_mean)^2;
        cvg_times(iteration, idx) = k+1;
    end
end

%% Plots

iterations = linspace(1, max_iterations, max_iterations);
figure(1)

% Rate of attack detection: how many times the support of a is correctly
% estimated, i.e., we identify the sensors under attack?
subplot(2,2,1);
xlabel("Iterations");
ylabel("Misses (%)");
title("Attack Detection Rate");
axis padded
hold on;
plot(iterations, misses(:, 1)'/20, 'r-o');
plot(iterations, misses(:, 2)'/20, 'g-.');
plot(iterations, misses(:, 3)'/20, 'b-^');
plot(iterations, misses(:, 4)'/20, 'k-*');
grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_4$', 'Interpreter','latex');
hold off;

% Estimation accuracy

subplot(2,2,2);
xlabel("Iterations");
ylabel("Accuracy (%)");
title("State Estimation Accuracy");
axis padded
hold on;
plot(iterations, 100 - accuracies(:, 1)', 'r-o');
plot(iterations, 100 - accuracies(:, 2)', 'g-.');
plot(iterations, 100 - accuracies(:, 3)', 'b-^');
plot(iterations, 100 - accuracies(:, 4)', 'k-*');
grid, legend('$Q_1$','$Q_2$', '$Q_3$', '$Q_4$', 'Interpreter','latex');
hold off;

% Convergence time (= number of iterations): can you see a relationship
% between the essential spectral radius of Q and the convergence time?
% figure(2)
subplot(2, 2, [3 4])
domain = linspace(-2,20);
hold on;
plot(domain, essential_eigenvalues(1).^domain, "r-");
plot(domain, essential_eigenvalues(2).^domain, "g-");
plot(domain, essential_eigenvalues(3).^domain, "b-");
plot(domain, essential_eigenvalues(4).^domain, "k-");
ylabel("Convergence Speed");
xlabel("Time (t)");
axis tight
title("Convergence time");
grid, legend('$\lambda_2(Q_1)^t$', '$\lambda_2(Q_2)^t$', '$\lambda_2(Q_3)^t$', '$\lambda_2(Q_4)^t$', 'Interpreter','latex');
hold off;

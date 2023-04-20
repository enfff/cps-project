clear;
close all;
clc;

load stochasticmatrices

% TODO: Sistemare la stima di a!!

% Dovremmo anche verificare che l'autovalore max = 1 è UNICO; l'abbiamo
% visto empiricamente e poi abbiamo pisciato



% [m, ind] = min(eig);

% Q4 converge più velocemente delle altre
% Vedi slides 9 pag 31; l'essential spectral radius più piccolo è quello
% che assicura la convergenza più veloce perché ha un modo esponenziale
% plotta lambda^x, con lambda = essential spectral radius

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

y = C*x_tilde + nu + a;             % Genera y
L = 2e-4*[zeros(n,1); ones(q, 1)];
G = [C eye(q)];
Z = zeros(n+q, q, T+1);             % Matrice di bookeeping


topologies = {Q1, Q2, Q3, Q4};
eigenvalues = {zeros(q, 1), zeros(q, 1), zeros(q, 1), zeros(q, 1)};
essential_eigenvalues = zeros(1, 4);

cvg_times = zeros(1, 4);
misses = zeros(1, 4); 
X_means = {zeros(n, 1), zeros(n, 1), zeros(n, 1), zeros(n, 1)};
accuracies = zeros(1, 4);


for idx=1:4
    Q = topologies{idx}; % Itera tra le matrici dentro topologies
    
    % Calcola essential eigenvalues per Q; ci serve dopo
    tmp = abs(eig(Q));
    eigenvalues{idx} = tmp;
    essential_eigenvalues(idx) = tmp(end - 1);

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
        end
    end
    
    X_mean = zeros(n, 1);
    for i=1:q
        X_mean = X_mean + X(:, i);
    end
    X_mean = X_mean / q;
    
    misses(idx) = miss;
    X_means{idx} = X_mean;
    accuracies(idx) = norm(x_tilde - X_mean)^2;
    cvg_times(idx) = k+1;
end

% Per velocizzare il tutto si può commentare il ciclo più esterno (con
% idx)


% Print results
misses, accuracies
for i=1:4
    misses(i)
    accuracies(i)
%     X_means{i}
    essential_eigenvalues(i)
    cvg_times(i)
end
% L'essential eigenvalue minore, la Q4, converge più rapidamente!!

% plot(1:4, 100-accuracies(i),".");
% xlabel("iterations");
% ylabel("accuracy (%)");
% axis padded
% ylim([99, 100])
% grid;



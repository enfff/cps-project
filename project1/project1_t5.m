clear all;
close all;
clc;

load stochasticmatrices

%

% Dovremmo anche verificare che l'autovalore max = 1 è UNICO; l'abbiamo
% visto empiricamente e poi abbiamo pisciato

eigenvalues_1 = abs(eig(Q1));
eigenvalues_2 = abs(eig(Q2));
eigenvalues_3 = abs(eig(Q3));
eigenvalues_4 = abs(eig(Q4));

eig = [eigenvalues_1(end - 1) eigenvalues_2(end - 1) eigenvalues_3(end - 1) eigenvalues_4(end - 1)];
[m, ind] = min(eig);

% Q4 converge più velocemente delle altre
% Vedi slides 9 pag 31; l'essential spectral radius più piccolo è quello
% che assicura la convergenza più veloce perché ha un modo esponenziale
% plotta lambda^x, con lambda = essential spectral radius

%

Q = Q1;

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

S_a = randi(q,h,1); % support        % calcualtes support of a (attack vec)
while duplicates(S_a)               % check for duplicates
    S_a= randi(q,h,1);   
end

% Generates support of a
a = zeros(q,1);
a_i1= 1+ rand(1);
a_i2= -a_i1;   
a(S_a(1))= a_i1;
a(S_a(2))= a_i2;

% Genera y
y = C*x_tilde + nu + a;

L = 2e-4*[zeros(n,1); ones(q, 1)];

% Stima zhat(K)

T = 1e5;
% z_hat = zeros(n+q, 1);

G = [C eye(q)];

Z = zeros(n+q, q, T+1); % Matrice di bookeeping

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
    
    % L'iterazione a cui è uscita è quello che corrisponde a
    % Z(:,:,k+1)

    
end

z_est = Z(:,:,k+1); % Sensors Consensus
X = z_est(1:n, :);
A = z_est(n+1:n+q, :);
cvg_time = k+1;

miss = 0;
for i=1:q
    A(:, i) = prune_array(A(:, i), 0.2);
%     ind_max = n_greatest(A(:, i), 2);
%     for l=1:q
%         if ismember(l,ind_max)
%             A(l,i)=1;
%         else
%             A(l,i)=0;
%         end
%     end

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

miss
X_mean
accuracy = norm(x_tilde - X_mean)^2

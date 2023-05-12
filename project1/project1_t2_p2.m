clear;
close all;
% clc;

casetype = 'noise'; % accepted values: noise, noisefree;

n = 10; % dimension of x
q = 20; % dimension of y
h=2;    % #sensor attacks
sigma = 1e-2; %standard deviation
delta = 1e-12;

big_lambda = [zeros(n, 1)' ones(q, 1)']';

L=(1e-3)* big_lambda;
num_iterations=1000;
T=1:num_iterations;
accuracy=zeros(num_iterations, 1);
miss=zeros(num_iterations, 1); % Counts the number of times

for i=T
    a= zeros(q,1);   %attacks vector
    C= randn(q,n);
    x= randn(n,1);
    
    switch casetype
        case 'noise'
            nu = sigma*randn(q,1);
        case 'noisefree'
            nu = 0;
    end

    epsilon = 1e-8; %precision
    tau = norm(C,2)^(-2) - epsilon;
    y = C*x + nu;   % no attack

    a_i1= 1 + rand(1);                  % generates a value in [1, 2]
    a_i2= -a_i1;
    S_a = randi(q,h,1);                 % calculates the attack vector support a
    
    while duplicates(S_a)               % check for duplicates
        S_a = randi(q,h,1);   
    end

    a(S_a(1))= 0.5*y(S_a(1));
    a(S_a(2))= 0.5*y(S_a(2));

    y = C*x + nu + a;   % [C I] [x a]' + nu

    [~, a_indices] = zero_norm(a);
    w_0 = zeros(n+q,1);    %w= [x a]'
    G=[C eye(q)];

    while 1
        w = IST(w_0+tau*G'*(y-G*w_0),L);
        if norm(w - w_0,2)<delta
            break;
        end
        w_0 = w;
    end

    x_found= [eye(n) zeros(n,q)]*w;
    a_found= [zeros(q,n) eye(q)]*w;

    [~, afound_indices] = zero_norm(a_found);
    % Compares two vector componently-wise, returns 1 if they're equal,
    % returns 0 if at least one component is different
    if ~compare(a_indices,afound_indices)  
        miss(i) = miss(i)+1;
    end

    accuracy(i)= norm(x_found - x,2)^2;
    % Distance between x_found and x. The lower the better.
end 

%% Plots

display(mean(miss)*100);
disp(max(accuracy));
disp(min(accuracy));

plot(T,accuracy,".");
xlabel("Iterations");
ylabel("Accuracy");

switch casetype
    case 'noise'
        title("Aware attack, with noise")
    case 'noisefree'
        title("Aware attack, noise free")
end

axis padded
grid;
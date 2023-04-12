clear all;
close all;
clc;

n = 10; % dimension of x
q = 20; % dimension of y
h=2;    % #sensor attacks
sigma = 1e-2; %standard deviation
delta = 1e-12;

big_lambda = [zeros(n, 1)' ones(q, 1)']';

L=(1e-2)* big_lambda;
num_iterations=1000;
T=1:num_iterations;
accuracy=[];
miss=0; % Counts the number of times

for i=T
    a= zeros(q,1);   %attacks vector
    C= randn(q,n);
    x= randn(n,1);
    S_a= randi(q,h,1); %support of attacks vector % could contain duplicates
    nu = sigma*randn(q,1);
   % nu=0;
    epsilon = 1e-8; %precision (?)
    tau = norm(C,2)^(-2) - epsilon;
    y = C*x + nu;   % no attack

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
        miss = miss+1;
    end

    accuracy(i)= 100 - norm(x_found - x,2);
    % Distance between x_found and x. The lower the better.
    % Sottraggo 100 così l'accuracy è al 100% quando la norma è nulla
end 

miss

plot(T,accuracy,".");
xlabel("iterations");   
ylabel("accuracy");
axis padded
ylim([98, 100])
grid;


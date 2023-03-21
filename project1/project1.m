close all;
clear all;
clc;

%%%%%%%%
%Task 1%
%%%%%%%%

format long

miss = 0;
outer_iterations = 20;
iterations = zeros(outer_iterations,1);
q = 10; %dimension of y
lambda = 1e-1;
p = 20; %dimension of x
L = lambda*ones(p,1); %vector of lambda 
epsilon = 1e-8; %precision (?)
sigma = 1e-2; %standard deviation
nu = sigma^(2)*randn(q,1);
delta = 1e-12;
k=2; %numeber of non-null elements of x

for i=1:outer_iterations

    C = randn(q,p);
    tau = norm(C,2)^(-2) - epsilon;
    x = 1 + (2-1)*rand(p,1);
    x_0 = zeros(p,1);

    mask = randi([1 p],k,1); %generates k non-null indices

    for j=1:p
        if ~ismember(mask,j)
            x(j) = 0;
        end
    end

    y = C*x + nu;
    [x_zero_norm, x_indices] = zero_norm(x);

    while 1
        iterations(i) = iterations(i)+1;
        iterations(i)=iterations(i)+1;
        x_new = IST(x_0+tau*C'*(y-C*x_0),L);
        if norm(x_new - x_0,2)<delta
            break;
        end
        x_0 = x_new;
    end
    
    [x0_zero_norm, x0_indices] = zero_norm(x_0);
    if ~compare(x0_indices,x_indices)
        miss = miss+1;
        %[x_indices x0_indices]
    end
end

disp("Number of misses: "+miss);
disp("Total number of elements in x: "+p);
disp("Mean number of cycles required for convergence: "+mean(iterations));
disp("Min number of cycles required for convergence: "+min(iterations));
disp("Max number of cycles required for convergence: "+max(iterations));


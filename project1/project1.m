close all;
clear all;
clc;

%%%%%%%%
%Task 1%
%%%%%%%%

format long

misses = [];
means = [];
maxes = [];
mins = [];

Q = 10:50;
for q=Q
    miss = 0;
    outer_iterations = 1000;
    iterations = zeros(outer_iterations,1);
    lambda = 1e-1;
    p = 20; %dimension of x
    L = lambda*ones(p,1); %vector of lambda 
    epsilon = 1e-8; %precision (?)
    sigma = 1e-2; %standard deviation
    nu = sigma*randn(q,1);
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
            iterations(i)=iterations(i)+1;
            x_new = IST(x_0+tau*C'*(y-C*x_0),L);
            if norm(x_new - x_0,2)<delta
                break;
            end
            x_0 = x_new;
        end
        
        prune_array(x_0,lambda);
        [x0_zero_norm, x0_indices] = zero_norm(x_0);
        if ~compare(x0_indices,x_indices)
            miss = miss+1;
        end
    end
    
    misses(end+1) = miss;
    means(end+1) = mean(iterations);
    maxes(end+1) = max(iterations);
    mins(end+1) = min(iterations);
    
    %disp("Number of misses: "+miss);
    %disp("Total number of elements in x: "+p);
    %disp("Mean number of cycles required for convergence: "+mean(iterations));
    %disp("Min number of cycles required for convergence: "+min(iterations));
    %disp("Max number of cycles required for convergence: "+max(iterations));
    

end

figure(1)
hold on
xlabel("Dimension of y");
ylabel("Percentage of Correct Evaluations");
title("Number of correct evaluations in function of the dimension q of y");
plot(Q,(outer_iterations-misses)/(outer_iterations)*100,"ko-");
grid;
hold off

figure(2)
hold on
xlabel("Dimension of y");
ylabel("Mean Convergence time");
title("Mean convergence time in function of the dimension q of y");
plot(Q,means,"ro-");
grid;
hold off

figure(3)
hold on
xlabel("Dimension of y");
ylabel("Maximum Convergence time");
title("Maximum convergence time in function of the dimension q of y");
plot(Q,maxes,"bo-");
grid;
hold off

figure(4)
hold on
xlabel("Dimension of y");
ylabel("Minimum Convergence time");
title("Minimum convergence time in function of the dimension q of y");
plot(Q,mins,"go-");
grid;
hold off


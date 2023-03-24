close all;
clear all;
clc;

%%%%%%%%%%%%%%%%%%
% Task 1 point 4 %
%%%%%%%%%%%%%%%%%%

format long

misses = [];
means = [];
maxes = [];
mins = [];

tau=[];
p = 20; %dimension of x
q= 50; %dimension of y 
C = randn(q,p);

for t=1:30 
    miss = 0;
    outer_iterations = 20;
    iterations = zeros(outer_iterations,1);

    if t==1
        tau(t) = norm(C,2)^(-2) - 1e-8;  
    else                    
        tau(t) = tau(t-1) - 1e-4;   % if 1e-3 or greater IST does not converge
    end
 
    lambda = 1e-1;
    L = lambda*ones(p,1); 
    sigma = 1e-2; %standard deviation
    nu = sigma*randn(q,1);
    delta = 1e-12;
    k=2; %numeber of non-null elements of x

    for i=1:outer_iterations
        
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
            x_new = IST(x_0+tau(t)*C'*(y-C*x_0),L);
            if norm(x_new - x_0,2)<delta
                break;
            end
            x_0 = x_new;
        end
    
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
subplot(2,2,1);
plot(tau,misses,"ko-");
xlabel("tau");
ylabel("Number of misevaluations");
title("Number of misevaluations in function of tau");
grid;

subplot(2,2,2)
plot(tau,means,"ro-");
xlabel("tau");
ylabel("Mean Convergence time");
title("Mean convergence time in function of tau");
grid;

subplot(2,2,3)
plot(tau,maxes,"bo-");
xlabel("tau");
ylabel("Maximum Convergence time");
title("Maximum convergence time in function of tau");
grid;

subplot(2,2,4)
plot(tau,mins,"go-");
xlabel("tau");
ylabel("Minimum Convergence time");
title("Minimum convergence time in function of tau");
grid;


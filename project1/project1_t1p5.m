close all;
clear all;
clc;

%% Task 1 part 5

format long

misses = [];
means = [];
maxes = [];
mins = [];

lambda=[];
p = 20; %dimension of x
q= 50; %dimension of y 
C = randn(q,p);
epsilon = 1e-8; %precision (?)
tau = norm(C,2)^(-2) - epsilon;

for t=1:30 
    miss = 0;
    outer_iterations = 20;
    iterations = zeros(outer_iterations,1);

    if t==1
        lambda(t) = 1e-2;  
    else                    
        lambda(t) = lambda(t-1) + 1e-1;
    end
 
    L = lambda(t)*ones(p,1); 
    sigma = 1e-2; %standard deviation
    nu = sigma*randn(q,1);
    delta = 1e-12;
    k=2; %numeber of non-null elements of x

    for i=1:outer_iterations
        
        x = zeros(p, 1);
        x_1 = 1 + rand(1);
        x_2 = - 1 - rand(1);
        x_0 = zeros(p,1); % starting array

        S_x = randperm(p,2); % computes the vector's support

        x(S_x(1))= x_1;
        x(S_x(2))= x_2;

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

%% Plots
% figure(1)
% subplot(2,2,1);
% plot(lambda,misses,"ko-");
% xlabel("lambda");
% ylabel("Number of misevaluations");
% title("Number of misevaluations in function of lambda");
% grid;
% 
% subplot(2,2,2)
% plot(lambda,means,"ro-");
% xlabel("lambda");
% ylabel("Mean Convergence time");
% title("Mean convergence time in function of lambda");
% grid;
% 
% subplot(2,2,3)
% plot(lambda,maxes,"bo-");
% xlabel("lambda");
% ylabel("Maximum Convergence time");
% title("Maximum convergence time in function of lambda");
% grid;
% 
% subplot(2,2,4)
% plot(lambda,mins,"go-");
% xlabel("lambda");
% ylabel("Minimum Convergence time");
% title("Minimum convergence time in function of lambda");
% grid;

theta_miss = [(lambda').^3 (lambda').^2 (lambda') (lambda').^0]\misses';
theta_mean = [(lambda').^3 (lambda').^2 (lambda') (lambda').^0]\means';
theta_max = [(lambda').^3 (lambda').^2 (lambda') (lambda').^0]\maxes';
theta_min = [(lambda').^3 (lambda').^2 (lambda') (lambda').^0]\mins';

est_miss = theta_miss(1)*lambda.^3 + theta_miss(2)*lambda.^2 + theta_miss(3)*lambda + theta_miss(4);
est_mean = theta_mean(1)*lambda.^3 + theta_mean(2)*lambda.^2 + theta_mean(3)*lambda + theta_mean(4);
est_max = theta_max(1)*lambda.^3 + theta_max(2)*lambda.^2 + theta_max(3)*lambda + theta_max(4);
est_min = theta_min(1)*lambda.^3 + theta_min(2)*lambda.^2 + theta_min(3)*lambda + theta_min(4);

%plots the number of misevaluations in function of lambda

figure(1)
subplot(2,2,1);
hold on
plot(lambda,misses,"k-");
plot(lambda,est_miss,"r-","LineWidth",1);
xlabel("$\lambda$","Interpreter","latex");
ylabel("Number of misevaluations");
title("Number of misevaluations in function of $\lambda$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the mean convergence time in function of lambda

subplot(2,2,2)
hold on
plot(lambda,means,"k-");
plot(lambda,est_mean,"r-","LineWidth",1);
xlabel("$\lambda$","Interpreter","latex");
ylabel("Mean Convergence time");
title("Mean convergence time in function of $\lambda$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the max convergence time in function of lambda

subplot(2,2,3)
hold on
plot(lambda,maxes,"k-");
plot(lambda,est_max,"r-","LineWidth",1);
xlabel("$\lambda$","Interpreter","latex");
ylabel("Maximum Convergence time");
title("Max convergence time in function of $\lambda$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the min convergence time in function of q

subplot(2,2,4)
hold on
plot(lambda,mins,"k-");
plot(lambda,est_min,"r-","LineWidth",1);
xlabel("$\lambda$","Interpreter","latex");
ylabel("Minimum Convergence time");
title("Min convergence time in function of $\lambda$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

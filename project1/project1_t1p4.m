close all;
clear all;
clc;

%% Setup

format long
%rng('default');

misses = []; % contains the misses for each value of tau
means = []; % contains the mean convergence time for each value of tau
maxes = []; % contains the max convergence time for each value of tau
mins = []; % contains the minimum convergence time for each value of tau

p = 20; % dimension of x
q = 10; % dimension of y 
C = randn(q,p);
eps = 1e-8;
Tau=linspace(eps,norm(C,2)^(-2)-eps,200); % array containing the different values of tau
sigma = 1e-2; % standard deviation
nu = sigma*randn(q,1); % noise
delta = 1e-12; % stopping criterion    
inner_iterations = 2000;

%% Excution of the algorithm

for t=1:length(Tau)
    t
    miss = 0;
    iterations = zeros(inner_iterations,1);
    lambda = 1/(10*Tau(t));
    Lambda = lambda*Tau(t)*ones(p,1);

    for i=1:inner_iterations
        x = zeros(p, 1);
        x_1 = 1 + rand(1);
        x_2 = - 1 - rand(1);
        x0 = zeros(p,1); % starting array

        S_x = randperm(p,2); % computes the vector's support

        x(S_x(1))= x_1;
        x(S_x(2))= x_2;

        y = C*x + nu;

        while 1
            iterations(i)=iterations(i)+1;
            x_new = IST_v2(x0+Tau(t)*C'*(y-C*x0),Lambda);
            if norm(x_new - x0,2)<delta
                x0 = x_new;
                break;
            end
            x0 = x_new;
        end

        % Prune array
        x0(abs(x0)<abs(max(x0))/10) = 0;

        % Evaluate Supports
        x0_supp = zeros(p,1);
        x0_supp(x0~=0) = 1;
        x_supp = zeros(p,1);
        x_supp(x~=0) = 1;

        % Compute misevaluations
        % checks if any of the elements resulting from x0_supp~x_supp
        % is different from 0, that is if some of the elements are
        % different
        if any(x0_supp~=x_supp)
            miss = miss + 1;
        end

    end

    % saves the number of misevaluations for the current value of tau
    misses(end+1) = miss;
    % saves the mean convergence time for the current value of tau
    % (over all the inner iterations)
    means(end+1) = mean(iterations);
    % saves the max convergence time for the current value of tau
    % (over all the inner iterations)
    maxes(end+1) = max(iterations);
    % saves the min convergence time for the current value of tau
    % (over all the inner iterations)
    mins(end+1) = min(iterations);

end

%% Plot

% figure(1)
% hold on
% plot(Tau,(1-misses/inner_iterations)*100,"k-");
% ylabel("Percentage of correct estimations","Interpreter","latex");
% title("Percentage of correct estimations of the support of $x$ in function of $\tau$","Interpreter","latex");
% ytickformat('percentage')
% grid;
% hold off

theta_miss = [(Tau').^3 (Tau').^2 (Tau') (Tau').^0]\misses';
theta_mean = [(Tau').^3 (Tau').^2 (Tau') (Tau').^0]\means';
theta_max = [(Tau').^3 (Tau').^2 (Tau') (Tau').^0]\maxes';
theta_min = [(Tau').^3 (Tau').^2 (Tau') (Tau').^0]\mins';

est_miss = theta_miss(1)*Tau.^3 + theta_miss(2)*Tau.^2 + theta_miss(3)*Tau + theta_miss(4);
est_mean = theta_mean(1)*Tau.^3 + theta_mean(2)*Tau.^2 + theta_mean(3)*Tau + theta_mean(4);
est_max = theta_max(1)*Tau.^3 + theta_max(2)*Tau.^2 + theta_max(3)*Tau + theta_max(4);
est_min = theta_min(1)*Tau.^3 + theta_min(2)*Tau.^2 + theta_min(3)*Tau + theta_min(4);

%plots the number of misevaluations in function of Tau

figure(1)
subplot(2,2,1);
hold on
plot(Tau,misses,"k-");
plot(Tau,est_miss,"r-","LineWidth",1);
xlabel("$\Tau$","Interpreter","latex");
ylabel("Number of misevaluations");
title("Number of misevaluations in function of $\Tau$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the mean convergence time in function of Tau

subplot(2,2,2)
hold on
plot(Tau,means,"k-");
plot(Tau,est_mean,"r-","LineWidth",1);
xlabel("$\Tau$","Interpreter","latex");
ylabel("Mean Convergence time");
title("Mean convergence time in function of $\Tau$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the max convergence time in function of Tau

subplot(2,2,3)
hold on
plot(Tau,maxes,"k-");
plot(Tau,est_max,"r-","LineWidth",1);
xlabel("$\Tau$","Interpreter","latex");
ylabel("Maximum Convergence time");
title("Max convergence time in function of $\Tau$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off

%plots the min convergence time in function of q

subplot(2,2,4)
hold on
plot(Tau,mins,"k-");
plot(Tau,est_min,"r-","LineWidth",1);
xlabel("$\Tau$","Interpreter","latex");
ylabel("Minimum Convergence time");
title("Min convergence time in function of $\Tau$","Interpreter","latex");
grid;
legend(["True Data","Trend"])
hold off


close all;
clear all;
clc;

%% Task 1 part 4

format long

misses = []; % contains the misses for each value of tau
means = []; % contains the mean convergence time for each value of tau
maxes = []; % contains the max convergence time for each value of tau
mins = []; % contains the minimum convergence time for each value of tau

tau=zeros(30, 1); % array containing the different values of tau
p = 20; % dimension of x
q= 10; % dimension of y 
C = randn(q,p);

for t=1:30 % number of different values of tau used 
    miss = 0;
    inner_iterations = 20;
    iterations = zeros(inner_iterations,1);

    if t==1
        tau(t) = norm(C,2)^(-2) - 1e-8;  
    else                    
        tau(t) = tau(t-1) - tau(t-1)*0.2;   % if 1e-3 or greater IST does not converge
    end
 
    lambda = 1e-1; % labda*tau is constant and equal to 1e-1
    L = lambda*ones(p,1); 
    sigma = 1e-2; % standard deviation
    nu = sigma*randn(q,1); % noise
    delta = 1e-12; % stopping criterion
    k=2; % numeber of non-null elements of x

    for i=1:inner_iterations
        x = zeros(p, 1);
        x_1 = 1 + rand(1)
        x_2 = -x_1
        x_0 = zeros(p,1); % starting array

        % set to 0 all the elements of x that do not belong to 
        % the pre-determined support

        S_x = randi([1, p], [2 1]);                 % calculates the attack vector support a
        
        while duplicates(S_x)               % check for duplicates
            S_x = randi([1, p], [2 1]);   
        end

        % disp(["Il  supporto è: "]);
        % S_x

        x(S_x(1))= x_1;
        x(S_x(2))= x_2;

        y = C*x + nu;
        [x_zero_norm, x_indices] = zero_norm(x);

        %IST execution for the i-th inner iteration for the value tau
        while 1
            iterations(i)=iterations(i)+1;
            % disp("Valore di tau");
            % tau(t)
            % disp("in quale tempo");
            % t
            x_new = IST(x_0+tau(t)*C'*(y-C*x_0),L);
            if norm(x_new - x_0,2)<delta
                break;
            end
            x_0 = x_new;
        end
    
        % checks wheter the original x array and the x_0 estimated array
        % have the same support, if not, the number of misevalutations
        % for the i-th innver iteration is incremented
        [x0_zero_norm, x0_indices] = zero_norm(x_0);
        if ~compare(x0_indices,x_indices)
            miss = miss+1;
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

%plots the number of misevaluations in function of tau

figure(1)
subplot(2,2,1);
plot(tau,misses,"ko-");
xlabel("$\tau$","Interpreter","latex");
ylabel("Number of misevaluations");
title("Number of misevaluations in function of $\tau$","Interpreter","latex");
grid;

%plots the mean convergence time in function of tau

subplot(2,2,2)
plot(tau,means,"ro-");
xlabel("$\tau$","Interpreter","latex");
ylabel("Mean Convergence time");
title("Mean convergence time in function of $\tau$","Interpreter","latex");
grid;

%plots the max convergence time in function of tau

subplot(2,2,3)
plot(tau,maxes,"bo-");
xlabel("$\tau$","Interpreter","latex");
ylabel("Maximum Convergence time");
title("Max convergence time in function of $\tau$","Interpreter","latex");
grid;

%plots the min convergence time in function of q

subplot(2,2,4)
plot(tau,mins,"go-");
xlabel("$\tau$","Interpreter","latex");
ylabel("Minimum Convergence time");
title("Min convergence time in function of $\tau$","Interpreter","latex");
grid;


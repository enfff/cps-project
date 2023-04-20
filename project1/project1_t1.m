close all;
clear all;
clc;

%% Task 1

format long

misses = []; % contains the misses for each value of q
means = []; % contains the mean convergence time for each value of q
maxes = []; % contains the max convergence time for each value of q
mins = []; % contains the minimum convergence time for each value of q

Q = 10:50; % ranges on which to variate q
for q=Q 
    miss = 0; % initialize the number of misses for the current valye of q
    inner_iterations = 1000; % number of time the algorithm is executed for 
                             % each value of q
    iterations = zeros(inner_iterations,1); % number of iteration required 
                                            % for the alogrithm 
                                            % to converge for each inner
                                            % iteration
    lambda = 1e-2;
    p = 20; % dimension of x
    L = lambda*ones(p,1); % vector of lambda 
    epsilon = 1e-8; 
    sigma = 1e-2; % standard deviation
    nu = sigma*randn(q,1); % vettore di rumore
    delta = 1e-12;
    k=2; % number of non-null elements of x

    for i=1:inner_iterations
        C = randn(q,p); 
        tau = norm(C,2)^(-2) - epsilon;
        
        x = 1 + (2-1)*rand(p,1); % vettore x originale
        x_0 = zeros(p,1);

        mask = randi([1 p],k,1); % generates k non-null indices

        % set to 0 all the elements of x that do not belong to 
        % the pre-determined support
        for j=1:p
            if ~ismember(mask,j)
                x(j) = 0;
            end
        end

        y = C*x + nu;
        [x_zero_norm, x_indices] = zero_norm(x);

        %IST execution for the i-th inner iteration for the value q
        while 1
            iterations(i)=iterations(i)+1;
            x_new = IST(x_0+tau*C'*(y-C*x_0),L);
            if norm(x_new - x_0,2)<delta
                break;
            end
            x_0 = x_new;
        end
        
        prune_array(x_0,lambda); % pruning of the array
        [x0_zero_norm, x0_indices] = zero_norm(x_0);

        % checks wheter the original x array and the x_0 estimated array
        % have the same support, if not, the number of misevalutations
        % for the i-th innver iteration is incremented
        if ~compare(x0_indices,x_indices)
            miss = miss+1;
        end
    end

    % saves the number of misevaluations for the current value of q
    misses(end+1) = miss;
    % saves the mean convergence time for the current value of q
    % (over all the inner iterations)
    means(end+1) = mean(iterations);
    % saves the max convergence time for the current value of q
    % (over all the inner iterations)
    maxes(end+1) = max(iterations);
    % saves the min convergence time for the current value of q
    % (over all the inner iterations)
    mins(end+1) = min(iterations);
    

end

%plots the number of misevaluations in function of q

figure(1)
hold on
xlabel("Dimension of y");
ylabel("Percentage of Correct Evaluations");
title("Number of correct evaluations in function of the dimension q of y");
plot(Q,(inner_iterations-misses)/(inner_iterations)*100,"ko-");
grid;
hold off

%plots the mean convergence time in function of q

figure(2)
hold on
xlabel("Dimension of y");
ylabel("Mean Convergence time");
title("Mean convergence time in function of the dimension q of y");
plot(Q,means,"ko-");
grid;
hold off

%plots the max convergence time in function of q

figure(3)
hold on
xlabel("Dimension of y");
ylabel("Maximum Convergence time");
title("Maximum convergence time in function of the dimension q of y");
plot(Q,maxes,"ko-");
grid;
hold off

%plots the min convergence time in function of q

figure(4)
hold on
xlabel("Dimension of y");
ylabel("Minimum Convergence time");
title("Minimum convergence time in function of the dimension q of y");
plot(Q,mins,"ko-");
grid;
hold off


%% Setup
clear;
close all;
clc;

run task3realdata.m    % Loads D (we don't need it!), and the measurement y

q = 6; % # sensors
p = 7; % # cells

delta = 1e-12;
lambda = 1e-1;
L = lambda*ones(p,1);
epsilon = 1e-8;
tau = norm(D,2)^(-2) - epsilon;

x = zeros(p,1);

%% We're formulating a LASSO problem to recover how many targets are present
% D is unnormalized

while 1
    x_new = IST(x+tau*D'*(y-D*x),L);
    if norm(x-x_new,2) < delta
        break;
    end
    x = x_new;
end

x
% non funziona bene perche D non è normalizzata

%% We're formulating a LASSO problem to recover how many targets are present
% D is normalized

D = normalize(D);
tau = norm(D,2)^(-2) - epsilon;
L = lambda*tau*ones(p,1);

x = zeros(p,1);

while 1
    x_new = IST(x + tau*D'*(y-D*x), L);
    if norm(x-x_new, 2) < delta
        break;
    end
    x = x_new;
end

x %serve prendere il valore massimo
% x = x/max(x)
% x > 0.1
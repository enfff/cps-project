close all;
clear all;
clc;

%%%%%%%%
%Task 1%
%%%%%%%%

format long

q = 10; %dimension of y
lambda = 1e-1;
p = 20; %dimension of x
L = lambda*ones(p,1); %vector of lambda
C = randn(q,p); 
epsilon = 1e-8; %precision (?)
tau = norm(C,2)^(-2) - epsilon;
sigma = 1e-2; %standard deviation
nu = sigma^(2)*randn(q,1);
delta = 1e-12;

x = 1 + (2-1)*rand(p,1);
x_0 = zeros(p,1);

mask = x>1.8;
while mask==0
    x = 1 + (2-1)*rand(p,1);
    mask = x>1.8;
end
x = mask.*x;
y = C*x + nu;

while 1
    x_new = IST(x_0+tau*C'*(y-C*x_0),L);
    if norm(x_new - x_0,2)<delta
        break;
    end
    x_0 = x_new;
end

x_new
x
norm(x-x_new,2)



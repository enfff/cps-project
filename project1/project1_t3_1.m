clear all;
close all;
clc;

run realdata.m

q = 6;
p = 7;
delta = 1e-12;
lambda = 1e-1;
L = lambda*ones(p,1);
epsilon = 1e-8;
tau = norm(D,2)^(-2) - epsilon;

x = zeros(p,1);

while 1
    x_new = IST(x+tau*D'*(y-D*x),L);
    if norm(x-x_new,2) < delta
        break;
    end
    x = x_new;
end

x %non funziona bene perche D non e' normalizzata

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q = 6;
p = 7;
delta = 1e-12;
lambda = 1;
epsilon = 1e-8;
D = normalize(D);
tau = norm(D,2)^(-2) - epsilon;
L = lambda*tau*ones(p,1);

x = zeros(p,1);

while 1
    x_new = IST(x+tau*D'*(y-D*x),L);
    if norm(x-x_new,2) < delta
        break;
    end
    x = x_new;
end

x %serve prendere il valore massimo



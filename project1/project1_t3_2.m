clear all;
close all;
clc;

run realdata.m

q = 6;
p = 7;
h=1;
delta = 1e-12;
lambda = 1e-1;
L = lambda*ones(p+q,1);
epsilon = 1e-8;
tau = norm(D,2)^(-2) - epsilon;

ind = randi([1 q],1);
a = zeros(q,1);
a(ind) = 1/5*y(ind);
y = y+a;

x = zeros(p,1);
G = [D eye(q)];
w = zeros(p+q,1);

while 1
    w_new = IST(w+tau*G'*(y-G*w),L);
    if norm(w-w_new,2) < delta
        break;
    end
    w = w_new;
end

x = [eye(p) zeros(p,q)]*w;
[~, x_indices] = zero_norm(x)






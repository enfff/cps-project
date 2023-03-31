clear all;
close all;
clc;

load task4data.mat

T=50;
j=4; % # target
p=100;  % # cells
for i=1:50
    if i==1
        S_x = randi(p,j,1) % support
        x(:,i)=zeros(p,1);   % positions of targets TODO: duplicates
        for i=1:j
            x(S_x(i))=1;
        end
    else
        x(:,i)=A*x(:, i-1);
    end 
end

q=25; % # sensors

h=2; % # sensors attacks
S_a= randi(q,h,1) % support
a=zeros(q,1);   % positions of targets TODO: duplicates
for i=1:h
    a(S_a(i))=30;
end

G= [D eye(q)];
G=normalize(G);

zhat_0= zeros(p+q,1);
sigma=0.2; % std dev
nu= sigma*randn(q,1); %noise

y= zeros(q,T);
for i=1:T
    y(:,i)= D*x(:,i)+ nu+ a;
end


epsilon= 1e-8;
sigma = 1e-2; %standard deviation
tau= norm(G,2)^-2 - epsilon;
lambda=[];
for i=1: p+q
    if i<=p
        lambda(i)=10;
    else
        lambda(i)=20;
    end
end

L= tau*lambda;

% for i=1:T
%     y= D*x + a + nu;
%     zhat_middle = IST(zhat(:,i)+tau*G'*(y-G*zhat(:,i)),L);
%    
%     zhat_0 = zhat_new;
% end
% 
% x_found= [eye(n) zeros(n,q)]*zhat_new;
% a_found= [zeros(q,n) eye(q)]*zhat_new
% 
% [afound_zero_norm, afound_indices] = zero_norm(a_found);
% if ~compare(a_indices,afound_indices)
%     miss = miss+1;
% end

x
y


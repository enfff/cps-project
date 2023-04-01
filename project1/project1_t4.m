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

zhat= zeros(p+q,T);     %start xhat=0
% zhat(:,1)= [x(:,1); zeros(q,1)];      %start xhat== x real

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
miss=zeros(T,1);

for i=1:T
    zhat_middle = IST(zhat(:,i)+tau*G'*(y(:,i)-G*zhat(:,i)),L);
    
    %xhat 
    zhat(1:p,i+1)= A* zhat_middle(1:p);
   
    %ahat 
    zhat(p+1:p+q,i+1) = zhat_middle(p+1:p+q);
    
end

% cleaning xhat and ahat
for i=1:T

    ind_max= n_greater( zhat(1:p,i), j);
    for l=1:p
        if ismember(l,ind_max)
            zhat(l,i)=1;
        else
            zhat(l,i)=0;
        end
    end

    ind_max= n_greater( zhat(p+1:p+q,i), h);
    for l=p+1:p+q
        if ~ismember(l,ind_max)
           zhat(l,i)=0;
        end
    end

    [x_zero_norm, x_indices] = zero_norm(x(:,i));
    [xfound_zero_norm, xfound_indices] = zero_norm(zhat(1:p,i));
    if ~compare(x_indices,xfound_indices)
         miss(i) = 1;
    end

end

miss

figure();
xlabel("iterations");
ylabel("mismatches");
plot(1:T,miss)





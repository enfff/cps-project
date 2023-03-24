clear all;
close all;
clc;

n = 10; % dimension of x
q = 20; % dimension of y
h=2;    % #sensor attacks
sigma = 1e-2; %standard deviation
delta = 1e-12;

big_lambda= zeros(n+q,1);
for k=1:n
    big_lambda(k)=1;
end
L=(2*1e-2)* big_lambda;
miss=0;
num_iterations=30;
T=1:num_iterations;
accuracy=[];

for i=T
    a=zeros(q,1);   %attacks vector
    C= randn(q,n);
    x= randn(n,1);
    S_a= randi(q,h,1); %support of attacks vector
    nu = sigma*randn(q,1);
   % nu=0;
    epsilon = 1e-8; %precision (?)
    tau = norm(C,2)^(-2) - epsilon;
    
    %set non-zero values of a (case with zero_norm(a)=2 )
    a_i1= 1+ rand(1);
    a_i2= -a_i1;
    
    a(S_a(1))= a_i1;
    a(S_a(2))= a_i2;
    a

    y = C*x + nu + a;   % [C I] [x a]' + nu
    [a_zero_norm, a_indices] = zero_norm(a);
    xtilde_0 = zeros(n+q,1);    %xtilde= [x a]'
    G=[C eye(q)];

    while 1
        xtilde_new = IST(xtilde_0+tau*G'*(y-G*xtilde_0),L);
        if norm(xtilde_new - xtilde_0,2)<delta
            break;
        end
        xtilde_0 = xtilde_new;
    end
   
    x_found= [eye(n) zeros(n,q)]*xtilde_new
    a_found= [zeros(q,n) eye(q)]*xtilde_new

    [afound_zero_norm, afound_indices] = zero_norm(a_found)
    if ~compare(a_indices,afound_indices)
        miss = miss+1;
    end

    accuracy(i)= norm(x_found-x,2);
end

miss

figure()
plot(T,accuracy,"ko-");
xlabel("iterations");
ylabel("accuracy");
grid;


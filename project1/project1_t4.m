clear;
close all;
clc;

load task4data.mat

T=50;
j=4; % # target
p=100;  % # cells
x=[];

for i=1:T
    if i==1
        S_x = randi(p,j,1);         % calculates support of x
        while duplicates(S_x)       % checks for duplicates
            S_x = randi(p,j,1);   
        end
        x(:,i)=zeros(p,1);          % positions of targets 
        for k=1:j
            x(S_x(k))=1;
        end
    else
        x(:,i)=A*x(:, i-1);
    end 
end

q=25;   % # sensors
h=2;    % # sensors attacks


S_a = randi(q,h,1); % support        % calcualtes support of a (attack vec)
while duplicates(S_a)               % check for duplicates
    S_a= randi(q,h,1);   
end
a=zeros(q,1);                       % positions of attacks 
for i=1:h
    a(S_a(i))= 30;
end

G= [D eye(q)];
G=normalize(G);

zhat= zeros(p+q,T);                 %start xhat=0

sigma=0.2; % std dev
nu= sigma*randn(q,1); %noise

y= zeros(q,T);
for i=1:T
%     y(:,i)= D*x(:,i)+ nu+ a;    % unaware attacks
    y(:,i)= D*x(:,i)+nu;      %uncomment for aware attacks
    y(:,i)= 1.5* y(:,i);
end

epsilon= 1e-8;
tau= norm(G,2)^(-2) - epsilon;
lambda=[];
for i=1: p+q
    if i<=p
        lambda(i)=10;
    else
        lambda(i)=20;
    end
end

% lambda = [10*ones(p, 1); 20*ones(q, 1)];
% lambda = lambda';

S_x
S_a

L= tau*lambda;
miss=zeros(T,1);


%% 

% Sparse Oberver algorithm
for i=1:T
    zhat_middle = IST(zhat(:,i)+tau*G'*(y(:,i)-G*zhat(:,i)),L);
    
    %xhat 
    zhat(1:p,i+1)= A* zhat_middle(1:p);
   
    %ahat 
    zhat(p+1:p+q,i+1) = zhat_middle(p+1:p+q);
    
end
 
    
    figure();

 for i=1:T
    % cleaning xhat and ahat
    % places 1 
    ind_max= n_greatest( zhat(1:p,i), j);
    for l=1:p
        if ismember(l,ind_max)
            zhat(l,i)=1;
        else
            zhat(l,i)=0;
        end
    end

%     ind_max= n_greatest( zhat(p+1:p+q,i), h);
%     for l=p+1:p+q
%         if ~ismember(l,ind_max)
%            zhat(l,i)=0;
%         end
%     end

    % Cosa fa sta cosa???
    for l=p+1:p+q
        if zhat(l,i)<2
            zhat(l,i)=0;
        end
    end   
    
    % processing misses
    [~, x_indices] = zero_norm(x(:,i));
    [~, xfound_indices] = zero_norm(zhat(1:p,i));
    if ~compare(x_indices,xfound_indices)
         miss(i) = miss(i) + 1;
    end


    
    % generating dynamic plot
    
    nonzerox= n_greatest(x(:,i),j);
    nonzeroxhat= n_greatest(zhat(1:p,i),j);

    xaxis=[];
    yaxis=[];
                    
    xaxishat=[];
    yaxishat=[];
   
    for k=1:j
        d= nonzerox(k)/10;
        r= mod(nonzerox(k),10);
        d1= nonzeroxhat(k)/10;
        r1= mod(nonzeroxhat(k),10);
        if r==0
            xaxis(end+1)=10;
            yaxis(end+1)=10-d;
            xaxishat(end+1)=10;
            yaxishat(end+1)=10-d1;
        else
            xaxis(end+1)=r;
            yaxis(end+1)=10-d;
            xaxishat(end+1)=r1;
            yaxishat(end+1)=10-d1;
        end
    end
    
    

    scatter(xaxis, yaxis, 80, "red");
    axis equal;
    xlim([0 10]);
    ylim([0 10]);

    hold on
    scatter(xaxishat, yaxishat, 50, "blue");
    hold off
    
    pause(0.1);
 end

miss

figure();
plot(1:T,miss)
xlabel("iterations");
ylabel("mismatches");


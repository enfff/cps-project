clear;
close all;
clc;

load task4data.mat

unaware=0;  % 0 = aware attacks    1 = unaware attacks

T=100;
j=4; % # target
p=100;  % # cells
x=zeros(100, 100);

for i=1:T
    if i==1
        S_x = randperm(p, j);       % calculates support of x
        S_x = S_x';
        x(:,i)=zeros(p,1);          % positions of targets
        
        for k=1:j
            x(S_x(k))=1;
        end
    else
        x(:,i)=A*x(:, i-1);
    end 
end

q=25;   % # sensors
h=4;    % # sensors attacks

S_a = randperm(q, h);              % calculates the support of a (attack vec)
S_a = S_a';

a=zeros(q,T);                       % positions of attacks 

if unaware
    for k=1:T
        for i=1:h
            a(S_a(i),k)= 30;
        end
    end
end


G= [D eye(q)];
G=normalize(G);

zhat= zeros(p+q,T);                 %start xhat=0

sigma=0.2; % std dev
nu= sigma*randn(q,1); %noise

y= zeros(q,T);
for i=1:T
    y(:,i)= D*x(:,i)+ nu;    
    if ~unaware
        for k=1:h
            a(S_a(k),i)= 0.5*y(S_a(k),i);
        end
    end
    y(:,i)= y(:,i)+ a(:,i);
end

epsilon= 1e-8;
tau= norm(G,2)^(-2) - epsilon;

lambda = [10*ones(p, 1); 20*ones(q, 1)];
lambda = lambda';

S_x
S_a

L= tau*lambda;
miss=zeros(T,1);

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

    for l=p+1:p+q
        if norm(zhat(l,i))<2
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
    nonzeroa= n_greatest(a(:,i),h);
    nonzeroahat= n_greatest(zhat(p+1:p+q,i),h);

    xaxis=zeros(1, 4);
    yaxis=zeros(1, 4);
                    
    xaxishat=zeros(1, 4);
    yaxishat=zeros(1, 4);

    xaxis_a=zeros(1, 4);
    yaxis_a=zeros(1, 4);
                    
    xaxishat_a=zeros(1, 4);
    yaxishat_a=zeros(1, 4);

    %plot for targets position estimation
   
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

     %plot for attacks estimation

    for k=1:h
        d= nonzeroa(k)/10;
        r= mod(nonzeroa(k),10);
        d1= nonzeroahat(k)/10;
        r1= mod(nonzeroahat(k),10);
        if r==0
            xaxis_a(end+1)=10;
            yaxis_a(end+1)=10-d;
            xaxishat_a(end+1)=10;
            yaxishat_a(end+1)=10-d1;
        else
            xaxis_a(end+1)=r;
            yaxis_a(end+1)=10-d;
            xaxishat_a(end+1)=r1;
            yaxishat_a(end+1)=10-d1;
        end
    end

    scatter(xaxis, yaxis, 120, "red", 'LineWidth', 2);
    hold on
    scatter(xaxis_a, yaxis_a, 100, "green", 'filled');
    axis equal;
    xlim([0 10]);
    ylim([0 10]);

    hold on
    scatter(xaxishat, yaxishat, 70, "blue", 'filled');
    hold on
    scatter(xaxishat_a, yaxishat_a, 120, "*", 'LineWidth', 2);
    grid
    hold off
    
    pause(0.1); 
 end

miss

%% 

figure;
plot(1:T,miss, ".");
yticklabels({'Correct', '', '', '', '', '', '', '', '', '', 'Uncorrect'})

xlabel("Iterations");
ylabel("State Support Estimation");
axis padded

close all;
clear all;
clc;

automatically_generate_plots = false;
% true -> automatically generates plots
% false -> doesn't automatically generate plots

%% Setup

%Number of follower nodes
N = 6;

%Matrices that describe the maglevs
A = [
    0       1;
    880.87  0
];

B = [
    0;
    -9.9453
];

C = [708.27 0];

xhat0 = [0 0]';
x0_followers = [1 0]';
x0= x0_followers;

%sensors noise
sigma_followers= 0.5;
sigma_leader= 0.5;

% Assegnamo un numero identificativo ad ogni topologia
% CHANGE THIS 
topology_num = 3;
% Adjagency Matrix (read above)
Ad = [
    0 0 0 0 0 1;
    1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 1 0;
];


%Degree Matrix
D = get_Degree_Matrix(Ad);

%Pinning Matrix
% G = [
%     1 0 0 0 0 0;
%     zeros(4,6);
%     0 0 0 0 0 1
% ];
G= eye(6);      % for topology 2 and 3

% Luenberger Observer for the leader
Lu_obs = (place(A', C', [-20, -10]))';

% Regulator for the leader
K_reg = place(A, B, [-5, -10]);

% Coupling Gain
L = D - Ad;
eigs = eig(L+G);
c = (0.5/min(real(eigs))) + 1.5;

% Calculating K Gain
Q = 10*eye(2);
R = 1;
P = are(A, B*pinv(R)*B', Q);
K = R\B'*P;
% chiedi ad enf perche la pseudo inversa

% Calculating F
Pf= are(A, C'*pinv(R)*C, Q);
F = Pf*C'/R;

%% System Simulation

t = 30.0; %Simulation Time
out = sim("project2_sim_p1.slx",t);

%Followers Output
y1 = get(out,"y1");
y2 = get(out,"y2");
y3 = get(out,"y3");
y4 = get(out,"y4");
y5 = get(out,"y5");
y6 = get(out,"y6");

%State 1 of each follower
x11 = get(out,"x11");
x21 = get(out,"x21");
x31 = get(out,"x31");
x41 = get(out,"x41");
x51 = get(out,"x51");
x61 = get(out,"x61");

%State 2 of each follower
x12 = get(out,"x12"); 
x22 = get(out,"x22"); 
x32 = get(out,"x32"); 
x42 = get(out,"x42"); 
x52 = get(out,"x52"); 
x62 = get(out,"x62"); 

%Leader Output
y_leader = get(out,"y_leader");

%State 1 of the leader
x_leader_1 = get(out,"x_leader_1");

%State 2 of the leader
x_leader_2 = get(out,"x_leader_2");

%Simulation Time
T = get(out,"T");

%% Plot

close all

if automatically_generate_plots
    % Create folder
    folder_name = create_folder(topology_num, Q, R);
end


%Plot outputs
figure
hold on
plot(T,y1)
plot(T,y2)
plot(T,y3)
plot(T,y4)
plot(T,y5)
plot(T,y6)
plot(T,y_leader,"--")
legend([ 
    "$y_{1}$"
    "$y_{2}$"
    "$y_{3}$"
    "$y_{4}$"
    "$y_{5}$"
    "$y_{6}$"
    "$y_{l}$"
],"Interpreter","latex")
title("Output ($y$)","Interpreter","latex")
xlabel("$t$","Interpreter","latex")

if automatically_generate_plots
    saveas(gcf, folder_name+'\output.jpg');
end

hold off

%Plot state 1
figure(1)
hold on
plot(T,x11)
plot(T,x21)
plot(T,x31)
plot(T,x41)
plot(T,x51)
plot(T,x61)
plot(T,x_leader_1,"--")
legend([ 
    "Follower 1 $x_{1}$"
    "Follower 2 $x_{1}$"
    "Follower 3 $x_{1}$"
    "Follower 4 $x_{1}$"
    "Follower 5 $x_{1}$"
    "Follower 6 $x_{1}$"
    "Leader $x_{1}$"
],"Interpreter","latex")
title("State 1 ($x_{1}$)","Interpreter","latex")
xlabel("$t$","Interpreter","latex")
if automatically_generate_plots
    saveas(gcf, folder_name+'\status1.jpg');
end

hold off

%Plot state 2
figure
hold on
plot(T,x12)
plot(T,x22)
plot(T,x32)
plot(T,x42)
plot(T,x52)
plot(T,x62)
plot(T,x_leader_2,"--")
legend([ 
    "Follower 1 $x_{2}$"
    "Follower 2 $x_{2}$"
    "Follower 3 $x_{2}$"

    "Follower 4 $x_{2}$"
    "Follower 5 $x_{2}$"
    "Follower 6 $x_{2}$"
    "Leader $x_{2}$"
],"Interpreter","latex")
title("State 2 ($x_{2}$)","Interpreter","latex")
xlabel("$t$","Interpreter","latex")
if automatically_generate_plots
    saveas(gcf, folder_name+'\status2.jpg');
end
hold off

if automatically_generate_plots
    fprintf('Created new files in %s\n', folder_name);
end

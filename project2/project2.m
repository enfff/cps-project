close all;
clear all;
clc;

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

%Adjagency Matrix
Ad = [
    0 0 0 0 0 0;
    1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 1 0;
];

%Degree Matrix
D = diag([0 1 1 1 1 1]);

%Pinning Matrix
G = [
    1 0 0 0 0 0;
    zeros(4,6);
    0 0 0 0 0 0
];

% Luenberger Observer for the leader
Lu_obs = (place(A', C', [-20, -10]))';

% Regulator for the leader
K_reg = place(A, B, [-5, -10]);

% Coupling Gain
L = D - Ad;
eigs = eig(L+G);
c = (0.5/min(real(eigs))) + 1.5;

% Calculating K Gain
Q = 5*eye(2);
R =  1;
P = are(A, B*pinv(R)*B', Q);
K = inv(R)*B'*P;
% chiedi ad enf perche la pseudo inversa

% Calculating F
Pf= are(A, C'*pinv(R)*C, Q);
F = Pf*C'*inv(R);
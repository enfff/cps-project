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
    zeros(5,6)
];

% Luenberger Observer
Lu_obs = place(A', C', [-10 -20])';

% Regulator
K_reg = place(A, B, [-5, -10]);

% Coupling Gain
L = D - Ad;
eigs = eig(L+G);
c = 0.5/min(real(eigs)) + 0.2;

% Calculating K Gain
Q = eye(2);
R =  1;
P = are(A, B*pinv(R)*B', Q);
K = inv(R)*B'*P;
% chiedi ad enf perche la pseudo inversa

% Calculating F
F = P*C'*inv(R);
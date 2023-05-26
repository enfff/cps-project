close all;
clear all;
clc;

%% Setup

%Number of follower nodes
N = 6;

%Matrices that describe the maglevs
A = [
    0 1;
    880.87 0
];

B = [
    0;
    -9.9453
];

C = [708.27 0];

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







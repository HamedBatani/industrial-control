%% Problem 1: Generating Noise with Known Covariance Matrix
clear; clc; close all;

%% Common Setup
N = 1e6;
Q = [0.30, 0.15;
     0.15, 0.55];

noiseRaw = randn(2, N);

%% Method 1.1: Using sqrtm(Q)
Qsqrt = sqrtm(Q);
noiseGenerated1 = Qsqrt * noiseRaw;
covarianceMatrix1 = cov(noiseGenerated1');

%% Method 2.1: Using chol(Q, 'lower')
L = chol(Q, 'lower');
noiseGenerated2 = L * noiseRaw;
covarianceMatrix2 = cov(noiseGenerated2');

%% Display Results
disp('Target covariance matrix Q:');
disp(Q);

disp('Method 1.1 (sqrtm) - Resulting covariance matrix:');
disp(covarianceMatrix1);

disp('Method 2.1 (chol, lower) - Resulting covariance matrix:');
disp(covarianceMatrix2);

disp('Difference: Q - covarianceMatrix1');
disp(Q - covarianceMatrix1);

disp('Difference: Q - covarianceMatrix2');
disp(Q - covarianceMatrix2);
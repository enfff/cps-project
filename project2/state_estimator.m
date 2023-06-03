function [y_hat, x_hat_dot] = state_estimator(u, corr, A, B, C, x_hat)

    y_hat = 0;
    x_hat_dot = zeros(2,1);

    x_hat_dot = A*x_hat + B*u - corr;
    y_hat = C*x_hat;
return
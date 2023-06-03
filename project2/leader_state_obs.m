function [x_hat, y_hat] = leader_state_obs(x0_hat, y0, u, L, A, B, C)
    x_hat = zeros(2,1);
    y_hat = 0;
    
    x_hat = A*x0_hat + B*u - L*(y_hat-y0);
    y_hat = C'*x_hat;
return

    
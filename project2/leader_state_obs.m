function [x0_hat_dot] = leader_state_obs(x0_hat, y0,  L, A, C)
    x0_hat_dot = zeros(2,1);
  %  y_hat = 0;

    x0_hat_dot = A*x0_hat- L*(C*x0_hat-y0);
   % y_hat = C*x0_hat;
return
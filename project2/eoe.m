% Estimation Output Error
% Returns y_tilde, the output estimation error
% y_hat vector containing all the output estimates
% y vector containing all the true outputs

function y_tilde = eoe(y_hat, y)
    y_tilde = y - y_hat;
end
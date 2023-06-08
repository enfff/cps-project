function [corr1, corr2, corr3, corr4, corr5, corr6]  = compute_local_correction(y_tilde, L)
    corr1 = zeros(2, 1);
    corr2 = zeros(2, 1);
    corr3 = zeros(2, 1);
    corr4 = zeros(2, 1);
    corr5 = zeros(2, 1);
    corr6 = zeros(2, 1);

    corr1 = L*y_tilde(1);
    corr2 = L*y_tilde(2);
    corr3 = L*y_tilde(3);
    corr4 = L*y_tilde(4);
    corr5 = L*y_tilde(5);
    corr6 = L*y_tilde(6);

end 
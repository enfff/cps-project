function [corr1, corr2, corr3, corr4, corr5, corr6]  = compute_correction(c,Xi,F)
    corr1 = zeros(2, 1);
    corr2 = zeros(2, 1);
    corr3 = zeros(2, 1);
    corr4 = zeros(2, 1);
    corr5 = zeros(2, 1);
    corr6 = zeros(2, 1);

    corr1 = c*F*Xi(1);
    corr2 = c*F*Xi(2);
    corr3 = c*F*Xi(3);
    corr4 = c*F*Xi(4);
    corr5 = c*F*Xi(5);
    corr6 = c*F*Xi(6);
end 
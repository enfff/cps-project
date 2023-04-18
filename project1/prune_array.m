function x = prune_array(x, tol)
    for i=1:length(x)
        if x(i) < tol
            x(i) = 0;
        end
    end
end
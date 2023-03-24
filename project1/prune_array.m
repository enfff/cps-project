function prune_array(x,tol)

    s = size(x);
    for i=1:s(1)
        if abs(x(i))<tol
            x(i) = 0;
        end
    end

end
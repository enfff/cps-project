function x=IST(x_old,L)

    x = x_old;
    s = size(x_old);
    for i=1:s(1)
        if x_old(i) > L(i)
            x(i) = x(i) - L(i);
        elseif x_old(i) < -L(i)
            x(i) = x(i) + L(i);
        else 
            x(i) = 0;
        end
    end
end
function [n,indices]=zero_norm(v)
    %% n = number of non zero values
    %% indices = logical array where 1 rappresents the presence of a value

    s = size(v);
    indices = zeros(s(1),1);
    n=0;
    for i=1:s(1)
       if v(i)~=0
           n=n+1;
           indices(i) = 1;
       end
    end
end
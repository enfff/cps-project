function [n,indices]=zero_norm(v)
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
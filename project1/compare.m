function res = compare(v1,v2)
    
    res = 1;
    s = size(v1);
    for i = 1:s(1)
        if v1(i)~=v2(i)
            res = 0;
        end
    end

end
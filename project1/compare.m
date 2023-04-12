function res = compare(v1,v2)
    % Compares two vector componently-wise, returns 1 if they're equal,
    % returns 0 if at least one component is different
    
    res = 1;
    for i = 1:length(v1)
        if v1(i)~=v2(i)
            res = 0;
        end
    end

end
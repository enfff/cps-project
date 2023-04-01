function indmin= arr_min(vector)
    min=1000;
    indmin=1;
    for i=1:length(vector)
        if vector(i)<min
            min= vector(i);
            indmin=i;
        end
    end

end


function res = duplicates(v)
% checks if there are duplicates in the input vector v
res=0;
for i=1: length(v)
    if ismember(v(i), v(i+1:length(v)))
        res=1;
        break;
    end
end


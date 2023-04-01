function indices = n_greater(vector, n)
    indices= zeros(n,1);
    for i=1:n
        indices(i)=i;
    end
    maxes=vector(1:n);
    for i=n+1:length(vector)
        insert=0;
        for j=1:n
           insert= insert | (vector(i)>maxes(j)); 
        end
        if insert 
            k=arr_min(maxes);
            maxes(k)= vector(i);
            indices(k)=i;
        end
    end
end


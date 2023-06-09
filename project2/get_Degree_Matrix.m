% Calculates the degree matrix D given an
% adjecency matrix Adj: entries are the weights associated to the arcs
% connecting the nodes;
%degree matrix D: number of entering arcs in the i-th node (doesn't
%consider the nodes);

function D = get_Degree_Matrix(Adj)
    [n, ~] = size(Adj);
    res = zeros(n, 1);
    % TODO
    for i=1:size(Adj)
        temp = nnz(Adj(i, :));
        if  temp ~= 0
            res(i) = temp; 
        end
    end
    D = diag(res);
    clear temp res
return
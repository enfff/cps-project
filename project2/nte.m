% Returns the Neighborhood Tracking Error of the i-th agent
% Ad adj matrix
% G leader pinning matrix
% i describes the i-th agent
% x0 leader state
% X matrix containing all agents' states ordered by column. (column i-th is
% the i-th agent's state)

function te = nte(Ad, G, x0, X, i)
    te = zeros(2, 1);
    for j=1:6 % total agents number
        te = te + Ad(i, j)*(X(:, j) - X(:, i));
    end

    te = te + G(i, i)*(x0 - X(:, i));
return
% Neighborhood Output Estimation Error of the i-th agent
% Ad adj matrix
% G leader pinning matrix
% i describes the i-th agent
% yt0 leader output
% yt vector containing all agents' outputs (column i-th element is
% the i-th agent's state)

function xi = noer(Ad, G, yt0, yt, i)
    xi = 0;

    for j=1:6 % total agents number
        xi = xi + Ad(i, j)*(yt(j) - yt(i));
    end

    xi = xi + G(i, i)*(yt0 - yt(i));
return
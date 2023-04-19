Q1 = 1*ones(5);
Q2 = 2*ones(5);
Q3 = 3*ones(5);
Q4 = 4*ones(5);

topologies = {Q1, Q2, Q3, Q4};
misses = zeros(1,4);
Q = zeros(5);
for idx=1:4
    Q = topologies{idx};
    misses(idx) = idx;
end
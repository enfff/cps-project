% Returns the matrices that define a topology given a topology_num.
% D     Degree Matrix
% Ad    Adjacency Matrix
% G     Pinning Matrix

function [D, Ad, G] = set_topology(topology_num)

% Per topologia si instende la combinazione di Pinning Matrix e Adjacency
% Matrix. Le topologie sono quelle documentate nel report

switch topology_num
    case 1
        Ad = [
            0 0 0 0 0 0;
            1 0 0 0 0 0;
            0 1 0 0 0 0;
            0 0 1 0 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 0;
        ];
        G = diag([1 0 0 0 0 0]);
    case 2
        Ad = [
            0 0 0 0 0 0;
            1 0 0 0 0 0;
            0 1 0 0 0 0;
            0 0 1 0 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 0;
        ];
        G=diag([1 1 1 1 1 1]);
    case 3
        Ad = [
            0 0 0 0 0 0;
            0 0 0 0 0 1;
            1 0 0 0 0 0;
            0 1 0 0 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 0
        ];
        G=diag([1 0 0 0 0 1]);
    otherwise
        fprintf("This topology %d hasn't been implemented yet!\n", topology_num);
end


%Degree Matrix
D = get_Degree_Matrix(Ad);



end
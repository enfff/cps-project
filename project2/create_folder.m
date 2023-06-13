% creates folders and subfolders with the following nomenclature
% topology_3 / reference / Q10_R1
% which contains the statuses and outputs calculated by using
% Q = 10*eye(2), R = 5
% topology_num  topology id
% ref           reference type
% Q             Q matrix
% R             R matrix (scalar)
% prefix        root folder prefix

% example
% prefix/topology_3
% | ->  Q10_R5
% |     -> constant
% |         -> status1.jpg
% |         -> status2.jpg
% |         -> output.jpg
% |     -> sinusoidal
% |         -> status1.jpg
% |         -> status2.jpg
% |         -> output.jpg
% |     -> ramp
% |         -> status1.jpg
% |         -> status2.jpg
% |         -> output.jpg

function [path] = create_folder(topology_num, ref, Q, R, prefix)
    if ispc % Genera path per windows
        topology_name = prefix+'\'+'topology_' + string(topology_num);
        folder_name = 'Q' + string(Q(1,1)) + '_R' + string(R(1)) + '\' + ref;
        mkdir(topology_name, folder_name)
        path = topology_name + '\' + folder_name;        
    else % Genera path per Linux/MacOS
        topology_name = prefix+'/'+'topology_' + string(topology_num);
        folder_name = 'Q' + string(Q(1,1)) + '_R' + string(R(1)) + '/' + ref;
        mkdir(topology_name, folder_name)
        path = topology_name + '/' + folder_name; 
    end 
end
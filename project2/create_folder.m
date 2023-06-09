% creates folders and subfolders with the following nomenclature
% topology_3 / Q10_R5
% which contains the statuses and outputs calculated by using
% Q = 10*eye(2), R = 5

% example
% topology_3
% | ->  Q10_R5
% |     -> status1.jpg
% |     -> status2.jpg
% |     -> output.jpg
% | ->  Q30_R2
% |     -> status1.jpg
% |     -> status2.jpg
% |     -> output.jpg
% topology_6
% | ->  Q40_R1
% |     -> status1.jpg
% |     -> status2.jpg
% |     -> output.jpg
% | ->  Q10_R50
% |     -> status1.jpg
% |     -> status2.jpg
% |     -> output.jpg

function [path] = create_folder(topology_num, Q, R)
    topology_name = 'topology_' + string(topology_num);
    folder_name = 'Q' + string(Q(1,1)) + '_R' + string(R(1));
    mkdir(topology_name, folder_name)
    path = topology_name + '\' + folder_name;
    clear Qval topology_name folder_name topology_name
end
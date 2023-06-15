close all;
clear all;
clc;

% Parameters
automatically_save_plots = true;
% true -> automatically generates plots
% false -> doesn't automatically generate plots

QR_couples = [
    [1 100]
    [1 10]
    [1 1]
    [10 1]
    [100 1]
];

% Assigning a topology
topology_num = 3; % Serve nella funzione set_topology

[couples_number, ~] = size(QR_couples);

%% Setup

%Number of follower nodes
N = 6;

%Matrices that describe the maglevs
A = [
    0       1;
    880.87  0
];

B = [
    0;
    -9.9453
];

C = [708.27 0];

for ref = ["constant", "sinusoidal", "ramp"] % iterates through all references
    fprintf("Working on topology #%d, ref: %s\n", topology_num, ref);
    [D, Ad, G, t] = set_topology(topology_num);
    
    % Initial conditions
    xhat0 = [0 0]';
    x0_followers = [0 0]';
    
    % Sensors noise
    sigma_followers= 0.5;
    sigma_leader= 0.5;
    
    % Luenberger Observer for the leader
    Lu_obs_leader = (place(A', C', [-20, -10]))';
    
    % Leader Regulator
    % Initializing variables
    K_reg=zeros(1,2);
    x0=0;

    switch ref
        case "constant"
            x0=[0 1.4119]';
            K_reg = place(A, B, [0, -10]);
            
        case "sinusoidal"
            x0= [1 1]';
            K_reg= place(A,B,[1i -1i]);
            
        case "ramp"
            x0= [0 1]';
            K_reg= acker(A,B, [0 0]);       
    end
    
    A= A-B*K_reg;
    
    % Coupling Gain
    L = D - Ad;
    eigs = eig(L+G);
    c = (0.5/min(real(eigs))) + 0.5;
    
    for couple_id=1:couples_number % iterates trough all Q, R couples
        % Calculating K Gain
        Q = QR_couples(couple_id, 1)*eye(2);
        R = QR_couples(couple_id, 2);
        P = are(A, B*inv(R)*B', Q);
        K = R\B'*P;
        
        % Calculating F
        F=[-1; -0.0001];        %values chosen after computing tf x/noise
        
        % System Simulation
        out = sim("project2_sim_p2.slx", t);
        
        %Followers Output
        y1 = get(out,"y1");
        y2 = get(out,"y2");
        y3 = get(out,"y3");
        y4 = get(out,"y4");
        y5 = get(out,"y5");
        y6 = get(out,"y6");
        
        %State 1 of each follower
        x11 = get(out,"x11");
        x21 = get(out,"x21");
        x31 = get(out,"x31");
        x41 = get(out,"x41");
        x51 = get(out,"x51");
        x61 = get(out,"x61");
        
        %State 2 of each follower
        x12 = get(out,"x12"); 
        x22 = get(out,"x22"); 
        x32 = get(out,"x32"); 
        x42 = get(out,"x42"); 
        x52 = get(out,"x52"); 
        x62 = get(out,"x62"); 
        
        %Leader Output
        y_leader = get(out,"y_leader");
        
        %State 1 of the leader
        x_leader_1 = get(out,"x_leader_1");
        
        %State 2 of the leader
        x_leader_2 = get(out,"x_leader_2");
        
        %Simulation Time
        T = get(out,"T");
        
        % Plot
        
        close all
        
        if automatically_save_plots
            % Create folder
            folder_name = create_folder(topology_num, ref, Q, R, "local_observer");
        end
        
        % String to append in the plot titles
        append_me = ", Q: " + num2str(Q(1:1)) + "I, R: " + num2str(R) + ", ref: " + ref;
        
        %Plot outputs
        figure
        hold on
        plot(T,y1)
        plot(T,y2)
        plot(T,y3)
        plot(T,y4)
        plot(T,y5)
        plot(T,y6)
        plot(T,y_leader,"--")
        legend([ 
            "$y_{1}$"
            "$y_{2}$"
            "$y_{3}$"
            "$y_{4}$"
            "$y_{5}$"
            "$y_{6}$"
            "$y_{l}$"
        ],"Interpreter","latex")
        title("Output ($y$)" + append_me,"Interpreter","latex")
        xlabel("$t$","Interpreter","latex")
        
        if automatically_save_plots
            if ispc
                    saveas(gcf, folder_name+'\output.jpg');
            else
                    saveas(gcf, folder_name+'/output.jpg');
            end
        end
        
        hold off
        
        %Plot state 1
        figure
        hold on
        plot(T,x11)
        plot(T,x21)
        plot(T,x31)
        plot(T,x41)
        plot(T,x51)
        plot(T,x61)
        plot(T,x_leader_1,"--")
        legend([ 
            "Follower 1 $x_{1}$"
            "Follower 2 $x_{1}$"
            "Follower 3 $x_{1}$"
            "Follower 4 $x_{1}$"
            "Follower 5 $x_{1}$"
            "Follower 6 $x_{1}$"
            "Leader $x_{1}$"
        ],"Interpreter","latex")
        title("State 1 ($x_{1}$)" + append_me,"Interpreter","latex")
        xlabel("$t$","Interpreter","latex")
            if automatically_save_plots
                if ispc
                    saveas(gcf, folder_name+'\state1.jpg');
                else
                    saveas(gcf, folder_name+'/state1.jpg');
                end
            end
        
        hold off
        
        %Plot state 2
        figure
        hold on
        plot(T,x12)
        plot(T,x22)
        plot(T,x32)
        plot(T,x42)
        plot(T,x52)
        plot(T,x62)
        plot(T,x_leader_2,"--")
        legend([ 
            "Follower 1 $x_{2}$"
            "Follower 2 $x_{2}$"
            "Follower 3 $x_{2}$"
            "Follower 4 $x_{2}$"
            "Follower 5 $x_{2}$"
            "Follower 6 $x_{2}$"
            "Leader $x_{2}$"
        ],"Interpreter","latex")
        title("State 2 ($x_{2}$)" + append_me,"Interpreter","latex")
        xlabel("$t$","Interpreter","latex")
        if automatically_save_plots
            if ispc
                saveas(gcf, folder_name+'\state2.jpg');
            else
                saveas(gcf, folder_name+'/state2.jpg');
            end
        end
        hold off
        
        if automatically_save_plots
            fprintf('Created new files in %s\n', folder_name);
        end
    end
end
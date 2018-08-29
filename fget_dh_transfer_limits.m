function DH_transfer_limits = fget_dh_transfer_limits(DH_Nodes, times, tout, temperature_case)

if nargin() == 3
    temperature_case = 1;
end

%summer season begins and ends, inclusive
% May starts in hour 2905
% September ends in hour 6576
summer_begins = 2905;
summer_ends = 6576;
% Delta temperatures from D4.1.3 case 1 on format 
%'outside temperature', 'supply temp - return temp'
% In summer mode only O7:29 (MC2) and O7:4 (Kemi) are supplied
if temperature_case == 1
    delta_T_DH = {-10, 82-52;
                  -5, 75-50;
                  0, 72-49;
                  5, 70-49;
                  15, 68-51;
                  20, 68-51
                  };
    summer_mode_delta_T = 49 - 42;

elseif temperature_case == 2
    delta_T_DH = {-10, 75-54;
                  -5, 71-52;
                  0, 68-50;
                  5, 65-50;
                  15, 65-51;
                  20, 65-51
                  };    
    summer_mode_delta_T = 40 - 35;

elseif temperature_case == 3
    delta_T_DH = {-10, 70-50;
                  -5, 65-47;
                  0, 65-45;
                  5, 65-45;
                  15, 65-51;
                  20, 65-51
                  };
    summer_mode_delta_T = 40 - 35;
end

CP_Water = 4.187; % kJ/kgK
Rho_Water = 997; % kg/m3
DH_transfer_limits = struct('name','DH_node_transfer_limits','type','parameter','form','full');
DH_transfer_limits.val = zeros(length(times.uels), length(DH_Nodes.name)); % Each column is a nodes transfer limits
DH_transfer_limits.uels = {times.uels, DH_Nodes.name};

for node = 1:length(DH_Nodes.name)
    maximum_flow_rate = DH_Nodes.maximum_flow(node);
    for hour = 1:length(times.uels)
        % Get current temperature diff
        if hour >= summer_begins && hour <= summer_ends
            delta_T_current = summer_mode_delta_T;
        else
            % ignored output '~' is the minimum difference between the
            % index of delta_T_DH and current outside temperature tout
            [~, index_current_temp] = min(abs([delta_T_DH{1:5,1}]-tout.val(hour)));
            delta_T_current = delta_T_DH{index_current_temp, 2};
        end

        % Transfer limit [kWh/h] = m3/s * kg/m3 * kJ/kgK
        DH_transfer_limits.val(hour,node) = maximum_flow_rate * Rho_Water * CP_Water * delta_T_current;
    end
end

end
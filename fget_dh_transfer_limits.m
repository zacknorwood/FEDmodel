function DH_transfer_limits = fget_dh_transfer_limits(DH_Nodes, times, tout, temperature_case)

if nargin() == 3
    temperature_case = 1;
end


% Delta temperatures from D4.1.3 case 1 on format 
%'outside temperature', 'supply temp - return temp'
if temperature_case == 1
    delta_T_DH = {-10, 82-52;
                  -5, 75-50;
                  0, 72-49;
                  5, 70-49;
                  15, 68-51;
                  20, 68-51
                  };
end

if temperature_case == 2
    
end

if temperature_case == 3

end

CP_Water = 4.187; % kJ/kgK
Rho_Water = 997; % kg/m3
MW_per_kW = 1/1000; % MW/kW
DH_transfer_limits = struct('name','DH_node_transfer_limits','type','parameter','form','full');
DH_transfer_limits.val = zeros(length(times.uels), length(DH_Nodes.name)); % Each column is a nodes transfer limits
DH_transfer_limits.uels = {times.uels, DH_Nodes.name};

for node = 1:length(DH_Nodes.name)
    maximum_flow_rate = DH_Nodes.maximum_flow(node);
    for hour = 1:length(times.uels)
        % Get current temperature diff
        [min_temp_diff, index_current_temp] = min(abs([delta_T_DH{1:5,1}]-tout.val(hour)));
        delta_T_current = delta_T_DH{index_current_temp, 2};

        % Transfer limit [MWh/h] = m3/s * kg/m3 * kJ/kgK  * MW/kW 
        DH_transfer_limits.val(hour,node) = maximum_flow_rate * Rho_Water * CP_Water * delta_T_current * MW_per_kW;
    end
end

end
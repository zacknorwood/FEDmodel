function DH_transfer_limits = fget_dh_transfer_limits(DH_Nodes, times, tout, temperature_case)

if nargin() == 3
    temperature_case = 1;
end


% Delta temperatures on format 'outside temperature', 'supply temp - return
% temp'
delta_T_DH = {-15, 40;
              -5, 40;
              0, 40;
              10, 30;
              20, 30
              };


CP_Water = 4.187; % kJ/kgK
Rho_Water = 997; % kg/m3
MW_per_kW = 1/1000; % MW/kW
DH.uels = times.uels;
DH.nodes = DH_Nodes.names;

DH.transfer_limits = zeros(length(DH.uels), length(DH.nodes)) % Each column is a nodes transfer limits
for node = 1:length(DH.nodes)
    maximum_flow_rate = DH_Nodes.maximum_flow(node);
    for hour = 1:length(DH.uels)
        % Get current temperature diff
        [min_temp_diff, index_current_temp] = min(abs([delta_T_DH{1:5,1}]-tout(hour)));
        delta_T_current = delta_T_DH{index_current_temp, 2};

        % Transfer limit [MWh/h] = m3/s * kg/m3 * kJ/kgK  * MW/kW 
        DH.transfer_limits(hour,node) = maximum_flow_rate * Rho_Water * CP_Water * delta_T_current * MW_per_kW;
    end
end
DH_transfer_limits = DH;

end
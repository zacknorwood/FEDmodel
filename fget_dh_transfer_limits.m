function DH_transfer_limits = fget_dh_transfer_limits(DH_Nodes, times, tout, temperature_case)

if nargin() == 3
    temperature_case = 1;
end


delta_T_DH = [20 , 20, 20, 20, 25]' % delta T for DH water during h_sim hours
delta_T_current_hours = 10 .* tout.val
% Populate delta_T_current_hours with correct temperature difference for
% coming hours


CP_Water = 4.187; % kJ/kgK
Rho_Water = 997; % kg/m3
MW_per_kW = 1/1000; % MW/kW
DH.uels = times.uels;
DH.nodes = DH_Nodes.names;

DH.transfer_limits = zeros(length(DH.uels), length(DH.nodes)) % Each column is a nodes transfer limits
for node = 1:length(DH.nodes)
    maximum_flow_rate = DH_Nodes.maximum_flow(node);
    for hour = 1:length(DH.uels)
        % Transfer limit [MWh/h] = m3/s * kg/m3 * kJ/kgK  * MW/kW 
        DH.transfer_limits(hour,node) = maximum_flow_rate * Rho_Water * CP_Water * delta_T_current_hours(hour) * MW_per_kW;
    end
end
DH_transfer_limits = DH;

end
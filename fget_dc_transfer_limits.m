function DC_transfer_limits = fget_dc_transfer_limits(DC_Nodes, times)

%summer season begins and ends, inclusive
% May starts in hour 2905
% September ends in hour 6576
summer_begins = 2905;
summer_ends = 6576;

% Delta temperatures from D4.1.3 case 1 on format 
%'outside temperature', 'supply temp - return temp'
summer_delta_T_DC = 12-6;
winter_delta_T_DC = 15-10;

CP_Water = 4.187; % kJ/kgK
Rho_Water = 997; % kg/m3
DC_transfer_limits = struct('name','DC_node_transfer_limits','type','parameter','form','full');
DC_transfer_limits.val = zeros(length(times.uels), length(DC_Nodes.name)); % Each column is a nodes transfer limits
DC_transfer_limits.uels = {times.uels, DC_Nodes.name};

for node = 1:length(DC_Nodes.name)
    maximum_flow_rate = DC_Nodes.maximum_flow(node);
    for hour = 1:length(times.uels)
        % Transfer limit [kWh/h] = m3/s * kg/m3 * kJ/kgK * K
        if hour >= summer_begins && hour <= summer_ends
            delta_T_DC = summer_delta_T_DC;
        else
            delta_T_DC = winter_delta_T_DC;
        end
        DC_transfer_limits.val(hour,node) = maximum_flow_rate * Rho_Water * CP_Water * delta_T_DC;
    end
end

end
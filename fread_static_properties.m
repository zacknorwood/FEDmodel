function [P1P2_dispatch, BAC_savings_period, BTES_model, BES_min_SoC] = fread_static_properties(sim_start, data_read_stop, data_length)
%This function reads static properties of model input parameters

% Set the minimum state of charge for the batteries.
BES_min_SoC = 0.20;

xlRange = strcat('C',num2str(sim_start+1),':C',num2str(data_read_stop+1));
%P1P2 dispatchability
P1P2_dispatch = xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx', 1, xlRange);

if (length(P1P2_dispatch)<data_length) || (any(isnan(P1P2_dispatch),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%BAC_savings_period
BAC_savings_period = xlsread('Input_dispatch_model\BAC_parameters.xlsx', 1, xlRange);
if (length(BAC_savings_period)<data_length) || (any(isnan(BAC_savings_period),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%BTES parameters
BTES_model=xlsread('Input_dispatch_model\UFO_TES.xlsx',2,'B2:AJ10');
if (any(isnan(BTES_model),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
BTES_model(isnan(BTES_model)) = 0;
end


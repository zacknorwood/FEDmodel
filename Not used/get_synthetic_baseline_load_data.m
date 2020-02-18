function [el_demand, h_demand, c_demand, ann_production_pruned, el_factors, dh_factors, temperature, dh_price, el_price, solar_irradiation, h_boiler_1_production] = get_synthetic_baseline_load_data(start_datetime, end_datetime, time_resolution)
% get_synthetic_baseline_load_data - Retrieves load data for synthetic
% baseline using in-function specified load files.
%
% Returns el_demand, h_demand, c_demand for specified date range and
% (optionally) specified resolution
% 
% Inputs:
% start_datetime - datetime representing beginning of desired demand series
% end_datetime - datetime representing end of desired demand series
% time_resolution (optional) - string, currently only 'hourly' implemented

%% Setup of date range and resolution
if nargin==2
    % If no time_resolution is provided use hourly, the only one
    % implemented currently
    time_resolution = 'hourly';
elseif nargin==0
    % Mainly used for debug purposes, alternatively one can alter the dates
    % and comment below to skip calling with specifi start, end times
    warning('No start_datetime or end_datetime specified, using 2019-01-01 00:00 and 2019-04-30 23:00 respectively with a 1 hour step size')
    start_datetime = datetime(2019,01,3,0,0,0);
    end_datetime = datetime(2019,04,28,23,0,0);
    time_resolution = 'hourly';
end
dates = (start_datetime:hours(1):end_datetime)';


    function output = prune_data(data_table, start_date, end_date, time_resolution, correction_factor)
        %Prune the data, removing all values before and after start_date
        %and end_date respectively with a resolution of time_resolution.
        %Optionally multiply all values by correction_factor
        if nargin < 5
            % The correction factor is used to convert e.g. MWh to kWh
            correction_factor = 1;
        end
        
        if all(time_resolution == 'hourly')
           time_step = hours(1) ;
        else
            warning('Only hourly pruning of data currently implemented')
        end
        
        output = data_table(start_date:time_step:end_date,:);
        
        if correction_factor ~= 1
           corrected_values = output{:, vartype('double')}.*correction_factor;
           output{:, vartype('double')} = corrected_values;
        end
    end

%% Input data folder & file names
base_folder = 'Input_dispatch_model\synthetic_baseline_data\';
measurements_data_folder = 'Input_dispatch_model\synthetic_baseline_data\measurement_data\';
ann_data_folder = 'Input_dispatch_model\synthetic_baseline_data\ann_data\';
kibana_data_folder = 'Input_dispatch_model\synthetic_baseline_data\kibana_data\';

% Heat related files
h_export_file = 'Värme export till GBG O0007008_fj_201_v1_2018-10-01_2019-06-04.xls';
h_import_file = 'Värme import från GBG O0007008_fj_103_v1_2018-10-01_2019-06-04.xls';
boiler_1_file = 'Värme panna 1 O0007008_fj_101_v1_2018-10-01_2019-06-04.xls';
h_vka_1_file = 'Värme VKA1 O0007008_fj_001_v1_2018-10-01_2019-06-04.xls';
h_vka_2_file = 'Värme VKA2 O0007008_fj_104_v1_2018-10-01_2019-06-04.xls';
h_vka_4_file = 'Värme VKA4 O0007008_fj_002_v1_2018-10-01_2019-06-04.xls';
fgc_file = 'Värme rökgaskondensor panna 1.xlsx';
%h_export_file = 'Värme export till GBG O0007008_fj_201_v1_2018-10-01_2019-06-04.xls';
%h_import_file = 'Värme import från GBG O0007008_fj_103_v1_2018-10-01_2019-06-04.xls';
%boiler_1_file = 'Värme panna 1 O0007008_fj_101_v1_2018-10-01_2019-06-04.xls';
%h_vka_1_file = 'Värme VKA1 O0007008_fj_001_v1_2018-10-01_2019-06-04.xls';
%h_vka_2_file = 'Värme VKA2 O0007008_fj_104_v1_2018-10-01_2019-06-04.xls';
%h_vka_4_file = 'Värme VKA4 O0007008_fj_002_v1_2018-10-01_2019-06-04.xls';
%fgc_file = 'Värme rökgaskondensor panna 1.xlsx';

% Electricity related files
el_import_file = 'Inkommande el O0007008_el_901_v1_2018-10-01_2019-06-04.xls';
el_kc_pv_file = 'Solceller KC O0007008_el_920_v1_2018-10-01_2019-06-04.xls';

% Cooling related files
c_import_file = 'Kyla import från GBG O0007008_kb_501_v1_2018-10-01_2019-06-04.xls';
c_vka_1_file = 'Kyla VKA1 O0007008_kb_502_v1_2018-10-01_2019-06-04.xls';
c_vka2_file = 'Kyla VKA2 O0007008_kb_504_v1_2018-10-01_2019-06-04.xls';
c_vka_4_file = 'Kyla VKA4 O0007008_kb_503_v1_2018-10-01_2019-06-04.xls';

% Building files
ann_file = 'HeatDemandsActiveBuildings.csv';
h_kibana_file = 'DH_demand_kibana.csv';
c_kibana_file = 'DC_demand_kibana.csv'; % Unused as we don't consider cooling as affected by active buildings 
el_kibana_file = 'EL_demand_kibana.csv'; % Unused as we don't consider electricity as affected by active buildings 

% Production file
ann_production_file = 'ProductionUnitsANN.csv'; % File containing boiler 1 production, AbsC, total cooling production
mc2_cooling_production_file = 'mc2cooling.csv'; % Ignored further down, contains all zeros for cooling production

P1_kibana_file = 'P1_kibana.csv';
P1_market_file = 'boiler1JantoAug.csv';

% Temperaure file
temperature_file = 'Temperatur_Goteborg_A_2019.xlsx';

% Price data
dh_price_file = 'district heating price.csv';
el_price_file = 'electricity price retailagent.csv';

% Solar irradiation file
solar_file = 'Strång UTC+1 global horizontal Wm2.xlsx';

%% Create series of simulation steps
%simulation_steps = start_datetime:hours(step_hours):end_datetime;

%% Input file reading
    function output = process_data(data_table, dates, energy_data, remove_outliers)
        % Processes Mx1 timetables, removing outliers, below zero values,
        % and interpolates missing values.
        % Returns a timetable with for timeindices in 'dates'
        if nargin == 3
           remove_outliers = 1;
        end
        input_table = data_table;
        
        if remove_outliers == 1
            % The outlier removal is exactly the same methodology as used
            % by Claes Sandels in the processing of Kibana data etc for the
            % progress reports. For questions regarding why this
            % methodology is chosen, consult him.
            quantiles = quantile(input_table.Value, [0.25, 0.5, 0.75]);
            q1 = quantiles(1);
            q3 = quantiles(3);
            whisker_max_length = 5;
            % Extract positive outliers based on boxplots whisker definition
            positive_whisker = q3 + whisker_max_length * (q3 - q1);

            % Check whether the table values exceed the positive values, if not
            % then no operation to correct is required
            if max(input_table.Value)>positive_whisker
                minimum_positive_outlier = min(input_table.Value(input_table.Value>positive_whisker));
                input_table.Value(input_table.Value>minimum_positive_outlier) = NaN;
            end
        end

        input_table.Value(input_table.Value<0) = NaN;

        if energy_data==0
        input_table.Value(input_table.Value==0) = NaN;
        end
        % Shift all timestamps to next whole hour, e.g. values timestamped
        % 13:45 are moved to the next whole hour, 14:00 so that all data is
        % uniform with regards to indices.
        input_table.Date = dateshift(input_table.Date,'start','hour','next') ;
        new_table = timetable(dates, zeros(length(dates),1));
        %Check if entire table is NaN, if so interpolation will not work.
        if sum(isnan(input_table.Value))==length(input_table.Value)
            output = synchronize(new_table, input_table,'first'); 
        else
            %Synchronise the new table with correct timestamps with measurement data and interpolate missing values
            output = synchronize(new_table, input_table,'first','linear'); 
        end
        
        if energy_data==0
            % Calculate the hourly power from the measurements
        for t=1:length(output.Value)
            if t==1
                output.Value1(t)=0;
            else
                output.Value1(t)=output.Value(t)-output.Value(t-1);
            end
        end
        % 
        output.Properties.VariableNames = {'Var1', 'Value','Var2'};
        output = removevars(output, {'Var2'});
        end
        % Remove temporary data from output
        output = removevars(output, {'Var1'});
    end

    function output = process_large_data(data, dates, remove_outliers)
        % Used for NxM timetables where M>1. 
        % Calls process data for each variable in the timetable
        if nargin == 2
           remove_outliers = 1;
        end
        
        temp_table = timetable(dates, zeros(length(dates),1));
        for variable_name = data.Properties.VariableNames
            one_variable = data(:,variable_name);
            % Change VariableNames as process_data expects to work on
            % column named 'Value'
            one_variable.Properties.VariableNames = {'Value'};
            % Process one column of data which is what process_data expects
            partial_data = process_data(one_variable , dates, energy_data, remove_outliers);
            % Change to original VariableName
            partial_data.Properties.VariableNames = {variable_name{1}};
            % Append temp_table to continue reconstructing original shape
            temp_table = [temp_table partial_data];
        end
        output = removevars(temp_table, {'Var1'});
    end

    function output = read_measurement_xls(file_path, dates)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.Tidpunkt, 'format', 'yyyy-MM-dd HH:mm:ss');
        % Removes columns which are present in the source data, but unused
        % by this script. If the methodology in which the source data is
        % compiled changes, this part will need changing as well.
        output = removevars(output, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_', 'V_rde'});
        % Change so we are looking at the energy meter reading instead
%        output = removevars(output, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_', 'Diff'});
        output = table2timetable(output);
        output = sortrows(output);
        output.Properties.VariableNames = {'Value'};
        output = process_data(output, dates, energy_data);   
    end

    function output = read_ann_csv(file_path, dates)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.DateTimeUTC, 'format', 'yyyy-MM-dd HH:mm:ss');
        % Removes columns which are present in the source data, but unused
        % by this script. If the methodology in which the source data is
        % compiled changes, this part will need changing as well.
        output = removevars(output, {'DateTimeUTC', 'AmbientTemperature'}); 
        
        output = table2timetable(output);
        output = sortrows(output);
        output = process_large_data(output, dates, 0);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

    function output = read_kibana_csv(file_path, dates)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.X_Timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
        % Removes columns which are present in the source data, but unused
        % by this script. If the methodology in which the source data is
        % compiled changes, this part will need changing as well.
        output = removevars(output, {'Var1', 'X_Timestamp'});       
        
        output.pump_stop_lokalkontor = str2double(output.pump_stop_lokalkontor);
        output.evi_agent_elkraft = str2double(output.evi_agent_elkraft);
        output.pump_stop_fysik = str2double(output.pump_stop_fysik);
        output.evi_agent_ffh = str2double(output.evi_agent_ffh);
        output.evi_agent_fos = str2double(output.evi_agent_fos);
        output.passive_building_kemi = str2double(output.passive_building_kemi);
        output.passive_building_lokalkontor = str2double(output.passive_building_lokalkontor);
        
        output = table2timetable(output);
        output = sortrows(output);
        output = process_large_data(output, dates);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

 function output = read_kibana_P1_csv(file_path, dates)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.X_Timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
        % Removes columns which are present in the source data, but unused
        % by this script. If the methodology in which the source data is
        % compiled changes, this part will need changing as well.
        output = removevars(output, {'Var1', 'X_Timestamp','marketStatus'});       
        %output = removevars(output, {'marketStatus', 'X_Timestamp'});   
        
       
        output.researchMode = str2double(output.researchMode);
        
        output = table2timetable(output);
        output = sortrows(output);
        output = process_large_data(output, dates);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

%% Heating production reading
energy_data=1;
h_export = read_measurement_xls(strcat(measurements_data_folder , h_export_file), dates);
h_import = read_measurement_xls(strcat(measurements_data_folder , h_import_file), dates);
h_boiler_1_production = read_measurement_xls(strcat(measurements_data_folder , boiler_1_file), dates);
h_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_1_file), dates);
h_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_2_file), dates);
h_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_4_file), dates);

energy_data=1;
h_fgc_production = readtable(strcat(measurements_data_folder , fgc_file), 'ReadVariableNames',true, 'Range','A3:B4454'); % fgc_file on different format requiring separate file reading
fgc_times = table2cell(h_fgc_production(:,1));
fgc_date = datetime(fgc_times,'InputFormat','yyyy-MM-dd HH', 'format', 'yyyy-MM-dd HH:mm:ss');
h_fgc_production.Date = fgc_date;
clearvars fgc_date fgc_times
h_fgc_production = removevars(h_fgc_production, {'Var1'});
h_fgc_production = table2timetable(h_fgc_production);
h_fgc_production.Properties.VariableNames = {'Value'};
h_fgc_production = process_data(h_fgc_production, dates, energy_data);
energy_data=0;

% Cooling production reading
c_import = read_measurement_xls(strcat(measurements_data_folder , c_import_file), dates);
c_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_1_file), dates);
c_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , c_vka2_file), dates);
c_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_4_file), dates);

% ANN reading
ann_buildings = read_ann_csv(strcat(ann_data_folder, ann_file), dates);
h_kibana_demand = read_kibana_csv(strcat(kibana_data_folder, h_kibana_file), dates);


% MC2 Cooling production
% Cooling production = 0 for entire period according to actualCapacity in
% file.

%% Electricity reading 
%Read imported electricity
el_imported = readtable(strcat(measurements_data_folder, el_import_file), 'ReadVariableNames',true);
el_imported.Date = datetime(el_imported.Tidpunkt, 'format', 'yyyy-MM-dd HH:mm:ss');
%Remove unnecessary columns
el_imported = removevars(el_imported, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_'});
el_imported = table2timetable(el_imported);
el_imported = sortrows(el_imported);
el_imported.Properties.VariableNames = {'Value'};
%Interpret strings in value as double
el_imported.Value = strrep(el_imported.Value, " ", "");
el_imported.Value = strrep(el_imported.Value, ",", ".");
%el_imported.Value = str2double(el_imported.Value);
%Process the data
el_imported = process_data(el_imported, dates, energy_data);   

%Read production of PV-panels on KC
el_kc_pv_production = read_measurement_xls(strcat(measurements_data_folder, el_kc_pv_file ), dates);

%% Production reading
% Read file
ann_production = read_ann_csv(strcat(ann_data_folder, ann_production_file), dates);
ann_production_pruned = prune_data(ann_production, start_datetime, end_datetime, time_resolution, 1000);




%ann_production.AbsC_production(ann_production.AbsC_production<0) = 0
%ann_production.Boiler1_production(ann_production.Boiler1_production<0) = 0
%ann_production.Total_cooling_demand(ann_production.Total_cooling_demand<0) = 0

%% Heat demand calculation
% Heat load = 
% Total production
% - Measured demand active buildings
% + Calculated demand active buildings

h_export = prune_data(h_export, start_datetime, end_datetime, time_resolution, 1000); % Production data reported in MW therefore a correction factor of 1000 is needed for kW values
h_import = prune_data(h_import, start_datetime, end_datetime, time_resolution, 1000);
h_boiler_1_production =  prune_data(h_boiler_1_production, start_datetime, end_datetime, time_resolution, 1000);
h_vka_1_production =  prune_data(h_vka_1_production, start_datetime, end_datetime, time_resolution, 1);
h_vka_2_production =  prune_data(h_vka_2_production, start_datetime, end_datetime, time_resolution, 1);
h_vka_4_production =  prune_data(h_vka_4_production, start_datetime, end_datetime, time_resolution, 1);
h_fgc_production =  prune_data(h_fgc_production, start_datetime, end_datetime, time_resolution, 1000);
h_export.Value(h_export.Value>h_boiler_1_production.Value)=h_boiler_1_production.Value(h_export.Value>h_boiler_1_production.Value);

h_ann = prune_data(ann_buildings, start_datetime, end_datetime, time_resolution, 1000);
h_kibana_demand = prune_data(h_kibana_demand, start_datetime, end_datetime, time_resolution, 1);

% Read P1 bidds
P1_kibana = read_kibana_P1_csv(strcat(kibana_data_folder, P1_kibana_file), dates);
P1_kibana_pruned = prune_data(P1_kibana, start_datetime, end_datetime, time_resolution, 1);
ann_production_pruned_temp=ann_production_pruned;
ann_production_pruned.Boiler1_production(P1_kibana_pruned.researchMode==0)=h_boiler_1_production.Value((P1_kibana_pruned.researchMode==0));

%% This is just to compare market 
% 
% function output = read_kibana_market_P1_csv(file_path, dates)
%         output = readtable(file_path, 'ReadVariableNames',true);
%         output.Date = datetime(output.p_executionStartTime, 'format', 'yyyy-MM-dd HH:mm:ss');
%         Removes columns which are present in the source data, but unused
%         by this script. If the methodology in which the source data is
%         compiled changes, this part will need changing as well.
%         output = removevars(output, {'p_executionStartTime','clearedPrice','energyCarrier','agentId'});       
%         output = removevars(output, {'marketStatus', 'X_Timestamp'});   
%         
%        
%         output.clearedCapacity = str2double(output.clearedCapacity);
%         
%         output = table2timetable(output);
%         output = sortrows(output);
%         output = process_large_data(output, dates);
%         output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
%     end
% P1_market=read_kibana_market_P1_csv(strcat(kibana_data_folder, P1_market_file), dates);
% 
% plot(P1_market,'r')
% hold on
% plot(h_boiler_1_production,'g--')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% plot(ann_production_pruned_temp.Boiler1_production)
% hold on
% plot(h_boiler_1_production.Value)
% plot(ann_production_pruned.Boiler1_production)
% plot(P1_kibana_pruned.researchMode*10000)
% legend('P1 ANN', 'P1 Historical', 'P1 ANN or Historical', 'ResearchMode')

%% Calculate net load
net_production = (h_import.Value...
                 - h_export.Value...
                 + h_boiler_1_production.Value...
                 + h_vka_1_production.Value...
                 + h_vka_2_production.Value...
                 + h_vka_4_production.Value...
                 + h_fgc_production.Value); 
figure
plot(h_boiler_1_production.Value)
hold on
plot(h_export.Value,'g--')
% FoS har kass Kibana data, Antar att FoS är oförändrad.
evi_correction = (h_ann.Evi_agent_Mattecentrum_heating...
                + h_ann.Evi_agent_Elkraft_heating...
                + h_ann.Evi_agent_SB2_heating...
                + h_ann.Evi_agent_SB1_heating .* 0 ... %No ANN demand for SB1
                + h_ann.Evi_agent_Ffh_heating...
                + h_ann.Evi_agent_Fos_heating...
                - h_kibana_demand.evi_agent_mattecentrum...
                - h_kibana_demand.evi_agent_elkraft...
                - h_kibana_demand.evi_agent_sb2...
                - h_kibana_demand.evi_agent_sb1 .*0 ... % Removing SB1 for troubleshooting
                - h_kibana_demand.evi_agent_ffh...
                - h_kibana_demand.evi_agent_fos);
disp('Warning EVI agent SB1 currently excluded!')

setpoint_offset_correction = ( h_ann.Sp_offset_agent_a10_heating...
                             + h_ann.Sp_offset_agent_a27_heating...
                             - h_kibana_demand.sp_offset_agent_a10...
                             - h_kibana_demand.sp_offset_agent_a27);
                         
total_correction = evi_correction +setpoint_offset_correction;    
total_correction(-total_correction > net_production) = 0; % Prevent negative values
h_net_load_values = net_production + total_correction;
h_demand = timetable(dates, h_net_load_values);

%% Cooling calculation
% Cooling load =
% + Cooling import (AbsC)
% + Cooling production
c_import = prune_data(c_import, start_datetime, end_datetime, time_resolution, 1000);
c_vka_1_production = prune_data(c_vka_1_production, start_datetime, end_datetime, time_resolution, 1);
c_vka_2_production = prune_data(c_vka_2_production, start_datetime, end_datetime, time_resolution, 1);
c_vka_4_production = prune_data(c_vka_4_production, start_datetime, end_datetime, time_resolution, 1);

c_net_load_values = c_import.Value + c_vka_1_production.Value + c_vka_2_production.Value + c_vka_4_production.Value;
c_demand = timetable(dates, c_net_load_values);

%% Electricity calculation
% Electricity load = 
% + Electricity import
% + Electricity production

el_imported = prune_data(el_imported, start_datetime, end_datetime, time_resolution, 1);
el_kc_pv_production = prune_data(el_kc_pv_production, start_datetime, end_datetime, time_resolution, 1);

el_net_load_values = el_imported.Value + el_kc_pv_production.Value; % Need to add local production and consumption (KC, VKA, PVs, Batteries)

el_demand = timetable(dates, el_net_load_values);

%% Get Electricity CO2 and PEF data
    function output = remove_duplicates(input)
        input = unique(input);
        dupTimes = sort(input.Date);
        TF = (diff(dupTimes) == 0);
        dupTimes = dupTimes(TF);
        dupTimes = unique(dupTimes);
        input(dupTimes,:);
        uniqueTimes = unique(input.Date);
        output = retime(input,uniqueTimes);
        output = retime(input,uniqueTimes,'previous');
    end

el_factors = readtable(strcat(base_folder, 'factors_el_janapril.csv'), 'ReadVariableNames',true);
el_factors.Date = datetime(el_factors.X_timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
el_factors = removevars(el_factors, {'Var1', 'X_timestamp'});       

el_factors = table2timetable(el_factors);
el_factors = sortrows(el_factors);
el_factors = remove_duplicates(el_factors); % Table contains duplicate dates which need to be removed
el_factors = process_large_data(el_factors, dates, 0);
el_factors = fillmissing(el_factors,'linear'); 
el_factors = prune_data(el_factors, start_datetime, end_datetime, time_resolution, 1);

%% Get District heating CO2 and PEF data
dh_factors = readtable(strcat(base_folder, 'factors_dh_janapril.csv'), 'ReadVariableNames',true);
dh_factors.Date = datetime(dh_factors.X_timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
dh_factors = removevars(dh_factors, {'Var1', 'X_timestamp'});       

dh_factors = table2timetable(dh_factors);
dh_factors = sortrows(dh_factors);
dh_factors = remove_duplicates(dh_factors);
dh_factors = process_large_data(dh_factors, dates, 0);
dh_factors = fillmissing(dh_factors,'linear');
dh_factors = prune_data(dh_factors, start_datetime, end_datetime, time_resolution, 1);

    function length=get_length(input)
        length = size(input);
        length = length(1);
    end
%% Load temperature data
temperature = readtable(strcat(base_folder, temperature_file), 'ReadVariableNames', true);
temperature.Date = datetime(temperature.CombinedDate_UTC_, 'format', 'yyyy-MM-dd HH:mm:ss');
temperature.Value = temperature.Lufttemperatur;
temperature = removevars(temperature, {'CombinedDate_UTC_', 'Kvalitet', 'Lufttemperatur'});       

temperature = table2timetable(temperature);
temperature = sortrows(temperature);
temperature = remove_duplicates(temperature);
temperature = process_data(temperature, dates, energy_data, 0);
temperature = fillmissing(temperature,'linear');
temperature = prune_data(temperature, start_datetime, end_datetime, time_resolution, 1);

%% Load el and DH prices
dh_price = readtable(strcat(base_folder, dh_price_file), 'ReadVariableNames', true);
dh_price.Date = datetime(dh_price.x_timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
dh_price.Value = dh_price.price;

dh_price = removevars(dh_price, {'agentId', 'x_timestamp', 'price'});       
dh_price = table2timetable(dh_price);
dh_price = sortrows(dh_price);
dh_price = remove_duplicates(dh_price);
dh_price = process_data(dh_price, dates, energy_data, 0);
dh_price = fillmissing(dh_price,'linear');
dh_price = prune_data(dh_price, start_datetime, end_datetime, time_resolution, 1);


el_price = readtable(strcat(base_folder, el_price_file), 'ReadVariableNames', true);
el_price.Date = datetime(el_price.x_timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
el_price.Value = el_price.price;
el_price = removevars(el_price, {'agentId', 'x_timestamp', 'price'});       
el_price = table2timetable(el_price);
el_price = sortrows(el_price);
el_price = remove_duplicates(el_price);
el_price = process_data(el_price, dates, energy_data, 0);
el_price = fillmissing(el_price,'linear');
el_price = prune_data(el_price, start_datetime, end_datetime, time_resolution, 1);

%% Read solar data
solar_irradiation = readtable(strcat(base_folder, solar_file), 'ReadVariableNames', true);          
solar_irradiation.Date = datetime(solar_irradiation.x2019_01_01, 'format', 'yyyy-MM-dd HH:mm:ss');
solar_irradiation.Value = solar_irradiation.x0;
solar_irradiation = removevars(solar_irradiation, {'x0', 'x2019_01_01'});       
solar_irradiation = table2timetable(solar_irradiation);
solar_irradiation = sortrows(solar_irradiation);
solar_irradiation = remove_duplicates(solar_irradiation);
solar_irradiation = process_data(solar_irradiation, dates, energy_data, 0);
solar_irradiation = fillmissing(solar_irradiation,'linear');
solar_irradiation = prune_data(solar_irradiation, start_datetime, end_datetime, time_resolution, 1);

end


function [el_demand, h_demand, c_demand] = get_synthetic_baseline_load_data(start_datetime, end_datetime, time_resolution)
% get_synthetic_baseline_load_data - Retrieves load data for synthetic
% baseline using in-function specified load files.

%outputArg1 = inputArg1;
%outputArg2 = inputArg2;

if nargin==2
    time_resolution = 'hourly';
elseif nargin==0
    warning('No start_datetime or end_datetime specified, using 2019-01-01 00:00 and 2019-03-31 23:00 respectively with a 1 hour step size')
    start_datetime = datetime(2019,04,01,0,0,0);
    end_datetime = datetime(2019,04,05,23,0,0);
    time_resolution = 'hourly';
end
%% Input data folder & file names
measurements_data_folder = 'Input_dispatch_model\synthetic_baseline_data\measurement_data\';
ann_data_folder = 'Input_dispatch_model\synthetic_baseline_data\ann_data\';
kibana_data_folder = 'Input_dispatch_model\synthetic_baseline_data\kibana_data\';
% Heat production files
h_export_file = 'Värme export till GBG O0007008_fj_201_v1_2018-10-01_2019-06-04.xls';
h_import_file = 'Värme import från GBG O0007008_fj_103_v1_2018-10-01_2019-06-04.xls';
boiler_1_file = 'Värme panna 1 O0007008_fj_101_v1_2018-10-01_2019-06-04.xls';
vka_1_file = 'Värme VKA1 O0007008_fj_001_v1_2018-10-01_2019-06-04.xls';
vka_2_file = 'Värme VKA2 O0007008_fj_104_v1_2018-10-01_2019-06-04.xls';
vka_4_file = 'Värme VKA4 O0007008_fj_002_v1_2018-10-01_2019-06-04.xls';
fgc_file = 'Värme rökgaskondensor panna 1.xlsx';

% Building files
ann_file = 'HeatDemandsActiveBuildings.csv';
h_kibana_file = 'DH_demand_kibana.csv';
c_kibana_file = 'DC_demand_kibana.csv';
el_kibana_file = 'EL_demand_kibana.csv'; 

%% Create series of simulation steps
%simulation_steps = start_datetime:hours(step_hours):end_datetime;

%% Input file reading
    function output = read_heating_xls(file_path, time_resolution)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.Tidpunkt, 'format', 'yyyy-MM-dd HH:mm:ss');
        
        output = removevars(output, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_'});
        output.V_rde = strrep(output.V_rde, " ", "");
        output.V_rde = strrep(output.V_rde, ",", ".");
        output.V_rde = str2double(output.V_rde);
        
        output = table2timetable(output);
        output = sortrows(output);
        
        output = retime(output, time_resolution, 'previous');
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
        % Check for unreasonable values (ie above 10 MW or something like
        % it)
    end

    function output = read_ann_csv(file_path)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.DateTimeUTC, 'format', 'yyyy-MM-dd HH:mm:ss');
        output = removevars(output, {'DateTimeUTC'});       

        output = table2timetable(output);
        output = sortrows(output);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

    function output = read_kibana_csv(file_path)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.X_Timestamp, 'format', 'yyyy-MM-dd HH:mm:ss');
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
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

% Heating production
h_export = read_heating_xls(strcat(measurements_data_folder , h_export_file), time_resolution);
h_import = read_heating_xls(strcat(measurements_data_folder , h_import_file), time_resolution);
boiler_1_production = read_heating_xls(strcat(measurements_data_folder , boiler_1_file), time_resolution);
vka_1_production = read_heating_xls(strcat(measurements_data_folder , vka_1_file), time_resolution);
vka_2_production = read_heating_xls(strcat(measurements_data_folder , vka_2_file), time_resolution);
vka_4_production = read_heating_xls(strcat(measurements_data_folder , vka_4_file), time_resolution);

% fgc_file on different format requiring separate file reading
fgc_production = readtable(strcat(measurements_data_folder , fgc_file), 'ReadVariableNames',true, 'Range','A3:B4454');
fgc_times = table2cell(fgc_production(:,1));
fgc_date = datetime(fgc_times,'InputFormat','yyyy-MM-dd HH', 'format', 'yyyy-MM-dd HH:mm:ss');
fgc_production.Date = fgc_date;
clearvars fgc_date fgc_times
fgc_production = removevars(fgc_production, {'Var1'});
fgc_production = table2timetable(fgc_production);
fgc_production = retime(fgc_production, time_resolution, 'previous');

% ANN reading
ann_buildings = read_ann_csv(strcat(ann_data_folder, ann_file));
h_kibana_demand = read_kibana_csv(strcat(kibana_data_folder, h_kibana_file));

%% Electricity demand reading and calculation



%% Heat demand calculation
% Heat load = 
% Total production
% - Measured demand active buildings
% + Calculated demand active buildings


%Prune the data
    function output = prune_data(data_table, start_date, end_date, time_resolution, correction_factor)
        if nargin < 5
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

% data_start_date = max([min(h_export.Date),...
%                        min(h_import.Date),...
%                        min(boiler_1_production.Date),...
%                        min(vka_1_production.Date),...
%                        min(vka_2_production.Date),...
%                        min(vka_4_production.Date),...
%                        min(fgc_production.Date)]);
% 
% data_end_date = min([max(h_export.Date),...
%                      max(h_import.Date),...
%                      max(boiler_1_production.Date),...
%                      max(vka_1_production.Date),...
%                      max(vka_2_production.Date),...
%                      max(vka_4_production.Date),...
%                      max(fgc_production.Date)]);
data_start_date = start_datetime;
data_end_date = end_datetime;

h_export = prune_data(h_export, data_start_date, data_end_date, time_resolution, 1000); % Production data reported in MW therefore a correction factor of 1000 is needed for kW values
h_import = prune_data(h_import, data_start_date, data_end_date, time_resolution, 1000);
boiler_1_production =  prune_data(boiler_1_production, data_start_date, data_end_date, time_resolution, 1000);
vka_1_production =  prune_data(vka_1_production, data_start_date, data_end_date, time_resolution, 1000);
vka_2_production =  prune_data(vka_2_production, data_start_date, data_end_date, time_resolution, 1000);
vka_4_production =  prune_data(vka_4_production, data_start_date, data_end_date, time_resolution, 1000);
fgc_production =  prune_data(fgc_production, data_start_date, data_end_date, time_resolution, 1000);

h_ann = prune_data(ann_buildings, data_start_date, data_end_date, time_resolution, 1);
h_kibana_demand = prune_data(h_kibana_demand, data_start_date, data_end_date, time_resolution, 1);

% Calculate net load
dates = (start_datetime:hours(1):end_datetime)';
net_production = (h_import.Diff...
                 - h_export.Diff...
                 + boiler_1_production.Diff...
                 + vka_1_production.Diff...
                 + vka_2_production.Diff...
                 + vka_4_production.Diff...
                 + fgc_production.MW); 

evi_correction = (h_ann.Evi_agent_Mattecentrum_heating...
                + h_ann.Evi_agent_Elkraft_heating...
                + h_ann.Evi_agent_SB2_heating...
                + h_ann.Evi_agent_SB1_heating...
                + h_ann.Evi_agent_Ffh_heating...
                + h_ann.Evi_agent_Fos_heating...
                - h_kibana_demand.evi_agent_elkraft...
                - h_kibana_demand.evi_agent_sb2...
                - h_kibana_demand.evi_agent_sb1...
                - h_kibana_demand.evi_agent_ffh...
                - h_kibana_demand.evi_agent_fos);
                    
                
setpoint_offset_correction = ( h_ann.Sp_offset_agent_a10_heating...
                             + h_ann.Sp_offset_agent_a27_heating...
                             - h_kibana_demand.sp_offset_agent_a10...
                             - h_kibana_demand.sp_offset_agent_a27);
                             
net_load_values = net_production + evi_correction +setpoint_offset_correction;
h_demand = timetable(dates, net_load_values);
h_demand = h_demand(start_datetime:end_datetime,:);
% Remove Kibana data and add ANN to net_load
%% Cooling demand reading and calculation


end


function [el_demand, h_demand, c_demand] = get_synthetic_baseline_load_data(start_datetime, end_datetime, time_resolution)
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
    time_resolution = 'hourly';
elseif nargin==0
    warning('No start_datetime or end_datetime specified, using 2019-01-01 00:00 and 2019-03-31 23:00 respectively with a 1 hour step size')
    start_datetime = datetime(2019,04,01,0,0,0);
    end_datetime = datetime(2019,04,05,23,0,0);
    time_resolution = 'hourly';
end
dates = (start_datetime:hours(1):end_datetime)';


    function output = prune_data(data_table, start_date, end_date, time_resolution, correction_factor)
        %Prune the data, removing all values before and after start_date
        %and end_date respectively with a resolution of time_resolution.
        %Optionally multiply all values by correction_factor
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

%% Input data folder & file names
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

% Electricity related files
el_import_file = 'Inkommande el O0007008_el_901_v1_2018-10-01_2019-06-04.xls';
kc_pv_file = 'Solceller KC O0007008_el_920_v1_2018-10-01_2019-06-04.xls';

% Cooling related files
c_import_file = 'Kyla import från GBG O0007008_kb_501_v1_2018-10-01_2019-06-04.xls';
c_vka_1_file = 'Kyla VKA1 O0007008_kb_502_v1_2018-10-01_2019-06-04.xls';
c_vka2_file = 'Kyla VKA2 O0007008_kb_504_v1_2018-10-01_2019-06-04.xls';
c_vka_4_file = 'Kyla VKA4 O0007008_kb_503_v1_2018-10-01_2019-06-04.xls';

% Building files
ann_file = 'HeatDemandsActiveBuildings.csv';
h_kibana_file = 'DH_demand_kibana.csv';
c_kibana_file = 'DC_demand_kibana.csv';
el_kibana_file = 'EL_demand_kibana.csv'; 

%% Create series of simulation steps
%simulation_steps = start_datetime:hours(step_hours):end_datetime;

%% Input file reading
    function output = read_measurement_xls(file_path, time_resolution)
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

% Heating production reading
h_export = read_measurement_xls(strcat(measurements_data_folder , h_export_file), time_resolution);
h_import = read_measurement_xls(strcat(measurements_data_folder , h_import_file), time_resolution);
h_boiler_1_production = read_measurement_xls(strcat(measurements_data_folder , boiler_1_file), time_resolution);
h_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_1_file), time_resolution);
h_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_2_file), time_resolution);
h_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_4_file), time_resolution);


h_fgc_production = readtable(strcat(measurements_data_folder , fgc_file), 'ReadVariableNames',true, 'Range','A3:B4454'); % fgc_file on different format requiring separate file reading
fgc_times = table2cell(h_fgc_production(:,1));
fgc_date = datetime(fgc_times,'InputFormat','yyyy-MM-dd HH', 'format', 'yyyy-MM-dd HH:mm:ss');
h_fgc_production.Date = fgc_date;
clearvars fgc_date fgc_times
h_fgc_production = removevars(h_fgc_production, {'Var1'});
h_fgc_production = table2timetable(h_fgc_production);
h_fgc_production = retime(h_fgc_production, time_resolution, 'previous');

% Cooling production reading
c_import = read_measurement_xls(strcat(measurements_data_folder , c_import_file), time_resolution);
c_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_1_file), time_resolution);
c_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , c_vka2_file), time_resolution);
c_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_4_file), time_resolution);

% ANN reading
ann_buildings = read_ann_csv(strcat(ann_data_folder, ann_file));
h_kibana_demand = read_kibana_csv(strcat(kibana_data_folder, h_kibana_file));


%% Electricity demand reading and calculation



%% Heat demand calculation
% Heat load = 
% Total production
% - Measured demand active buildings
% + Calculated demand active buildings

h_export = prune_data(h_export, start_datetime, end_datetime, time_resolution, 1000); % Production data reported in MW therefore a correction factor of 1000 is needed for kW values
h_import = prune_data(h_import, start_datetime, end_datetime, time_resolution, 1000);
h_boiler_1_production =  prune_data(h_boiler_1_production, start_datetime, end_datetime, time_resolution, 1000);
h_vka_1_production =  prune_data(h_vka_1_production, start_datetime, end_datetime, time_resolution, 1000);
h_vka_2_production =  prune_data(h_vka_2_production, start_datetime, end_datetime, time_resolution, 1000);
h_vka_4_production =  prune_data(h_vka_4_production, start_datetime, end_datetime, time_resolution, 1000);
h_fgc_production =  prune_data(h_fgc_production, start_datetime, end_datetime, time_resolution, 1000);

h_ann = prune_data(ann_buildings, start_datetime, end_datetime, time_resolution, 1);
h_kibana_demand = prune_data(h_kibana_demand, start_datetime, end_datetime, time_resolution, 1);

% Calculate net load
net_production = (h_import.Diff...
                 - h_export.Diff...
                 + h_boiler_1_production.Diff...
                 + h_vka_1_production.Diff...
                 + h_vka_2_production.Diff...
                 + h_vka_4_production.Diff...
                 + h_fgc_production.MW); 

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
                             
h_net_load_values = net_production + evi_correction +setpoint_offset_correction;
h_demand = timetable(dates, h_net_load_values);
h_demand = h_demand(start_datetime:end_datetime,:);

%% Cooling demand reading and calculation
c_import = prune_data(c_import, start_datetime, end_datetime, time_resolution, 1000);
c_vka_1_production = prune_data(c_vka_1_production, start_datetime, end_datetime, time_resolution, 1000);
c_vka_2_production = prune_data(c_vka_2_production, start_datetime, end_datetime, time_resolution, 1000);
c_vka_4_production = prune_data(c_vka_4_production, start_datetime, end_datetime, time_resolution, 1000);

c_net_load_values = c_import.Diff + c_vka_1_production.Diff + c_vka_2_production.Diff + c_vka_4_production.Diff;
c_demand = timetable(dates, c_net_load_values);
c_demand = c_demand(start_datetime:end_datetime,:);

end


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
    end_datetime = datetime(2019,04,17,23,0,0);
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
    function output = process_data(data_table, dates)
        % Processes Mx1 timetables, removing outliers, below zero values,
        % and interpolates missing values.
        % Returns a timetable with for timeindices in 'dates'
        input_table = data_table;
        
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
        
        input_table.Value(input_table.Value<0) = NaN;
        % Shift all timestamps to next whole hour
        input_table.Date = dateshift(input_table.Date,'start','hour','next') ;
        new_table = timetable(dates, zeros(length(dates),1));
        %Check if entire table is NaN, if so interpolation will not work.
        if sum(isnan(input_table.Value))==length(input_table.Value)
            output = synchronize(new_table, input_table,'first'); 
        else
            %Synchronise the new table with correct timestamps with measurement data and interpolate missing values
            output = synchronize(new_table, input_table,'first','linear'); 
        end
        % Remove temporary data from output
        output = removevars(output, {'Var1'}); 
    end

    function output = process_large_data(data, dates)
        % Used for NxM timetables where M>1. 
        % Calls process data for each variable in the timetable
        temp_table = timetable(dates, zeros(length(dates),1));
        for variable_name = data.Properties.VariableNames
            one_variable = data(:,variable_name);
            % Change VariableNames as process_data expects to work on
            % column named 'Value'
            one_variable.Properties.VariableNames = {'Value'};
            % Process one column of data which is what process_data expects
            partial_data = process_data(one_variable , dates);
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
        
        output = removevars(output, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_', 'V_rde'});
               
        output = table2timetable(output);
        output = sortrows(output);
        output.Properties.VariableNames = {'Value'};
        output = process_data(output, dates);   
    end

    function output = read_ann_csv(file_path, dates)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.DateTimeUTC, 'format', 'yyyy-MM-dd HH:mm:ss');
        output = removevars(output, {'DateTimeUTC', 'AmbientTemperature'});       

        output = table2timetable(output);
        output = sortrows(output);
        output = process_large_data(output, dates);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

    function output = read_kibana_csv(file_path, dates)
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
        output = process_large_data(output, dates);
        output = fillmissing(output,'constant',0); % Replaces NaN, NaT, etc with 0
    end

% Heating production reading
h_export = read_measurement_xls(strcat(measurements_data_folder , h_export_file), dates);
h_import = read_measurement_xls(strcat(measurements_data_folder , h_import_file), dates);
h_boiler_1_production = read_measurement_xls(strcat(measurements_data_folder , boiler_1_file), dates);
h_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_1_file), dates);
h_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_2_file), dates);
h_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , h_vka_4_file), dates);


h_fgc_production = readtable(strcat(measurements_data_folder , fgc_file), 'ReadVariableNames',true, 'Range','A3:B4454'); % fgc_file on different format requiring separate file reading
fgc_times = table2cell(h_fgc_production(:,1));
fgc_date = datetime(fgc_times,'InputFormat','yyyy-MM-dd HH', 'format', 'yyyy-MM-dd HH:mm:ss');
h_fgc_production.Date = fgc_date;
clearvars fgc_date fgc_times
h_fgc_production = removevars(h_fgc_production, {'Var1'});
h_fgc_production = table2timetable(h_fgc_production);
h_fgc_production.Properties.VariableNames = {'Value'};
h_fgc_production = process_data(h_fgc_production, dates);

% Cooling production reading
c_import = read_measurement_xls(strcat(measurements_data_folder , c_import_file), dates);
c_vka_1_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_1_file), dates);
c_vka_2_production = read_measurement_xls(strcat(measurements_data_folder , c_vka2_file), dates);
c_vka_4_production = read_measurement_xls(strcat(measurements_data_folder , c_vka_4_file), dates);

% ANN reading
ann_buildings = read_ann_csv(strcat(ann_data_folder, ann_file), dates);
h_kibana_demand = read_kibana_csv(strcat(kibana_data_folder, h_kibana_file), dates);

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
net_production = (h_import.Value...
                 - h_export.Value...
                 + h_boiler_1_production.Value...
                 + h_vka_1_production.Value...
                 + h_vka_2_production.Value...
                 + h_vka_4_production.Value...
                 + h_fgc_production.Value); 

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

c_net_load_values = c_import.Value + c_vka_1_production.Value + c_vka_2_production.Value + c_vka_4_production.Value;
c_demand = timetable(dates, c_net_load_values);
c_demand = c_demand(start_datetime:end_datetime,:);

end


function [EDIT_data] = sort_and_fix_AH_data(EDIT_data,start_time1,end_time1,start_time2,end_time2)
% Fixing the data from AH (impoerted with import_measurments.m, this includes removing not valid data,
% interpolating for missing data segments and assigining the data to
% different specific hours. 

% EDIT_data is the data structure created in import_measurments.m, it also
% functions as an output as the fixed data is ammended to the original data

% Start_time1 and 2, and end_time1 and 2
%Define the starting and ending of the period of interest, this inorder to
%check if data is missing between first or last data point and the
%begining or end of the period of interest. 
% Example below 1 is for the 2017 period and 2
%is for the 2018 period.
% Example:
%start_time1 =  datetime('2017-04-01 00:08:00','InputFormat','yyyy-MM-dd HH:mm:SS');
%end_time1 =  datetime('2017-12-31 23:08:00','InputFormat','yyyy-MM-dd HH:mm:SS');
%
%start_time2 =  datetime('2018-01-01 00:08:00','InputFormat','yyyy-MM-dd HH:mm:SS');
%end_time2 =  datetime('2018-10-12 23:08:00','InputFormat','yyyy-MM-dd HH:mm:SS');

% Loop through all different buildings or production units. HERE SHOULD THE
% STRUCTURE CREATED IN import_measurments.m be used to loop over, i.e.,
% replace all instances of 'bibaln' with the name you gave to that
% structure.
for j = 1:length(EDIT_data) 
    
    % Loop through all diffrent meassuring points
   for k = 1:length(EDIT_data(j).e_flows)
       
        % Extract all data available
        data_RAW = EDIT_data(j).e_flows(k).data;
        
        % Extract timestamp for consumption or production (Row one is name
        % of data so start on row 2, column 2 is the time) The erliest
        % timestep is at the end of the vector.
        data_t = data_RAW(2:end,2);
        
        % Convert timestamp to matalab datetime data type
        timestamp = datetime(data_t,'InputFormat','yyyy-MM-dd HH:mm:SS');  
        
        % Extract data for consumption or production for each timestep,
        % last datapoint (the first in the timeseries) is skiped since this
        % is a non valid datapoint.
        data_dem = cell2mat(data_RAW(2:(end),7));
        
        % Exctract which data is labled not valid
        ogilt_data = strcmp(data_RAW(2:(end),4),'Ogiltigt');
        
        % last datapoint (the first in the timeseries) is set as "ogilitig since this
        % is a non valid datapoint (no prior logged value).
%         ogilt_data(end) = true;
        
        
        %Extract data that has been interpolated
        inter_data = ~strcmp(data_RAW(2:(end),3),'EOV');
        
        % The logic conditions below checks where the non valid periods
        % ends(-1) and begins(1) and then calculates the total amount of energy
        % produced or consumed during that period.
        diff_ogilt = ogilt_data(1:(end-1))-ogilt_data(2:end);
        % Extracts data from point of starting missing data and ending
        % missing data
        miss_data_neg = data_dem(diff_ogilt == 1);
        miss_data_pos = data_dem(diff_ogilt == -1);
        
        % If first or last data point is non-valid the code below acounts for that
        if diff_ogilt(1) == 1
            
            miss_data_neg = miss_data_neg(2:end);
            
        end
            
        if diff_ogilt(end) == -1
            
            miss_data_pos = miss_data_pos(1:(end-1));
            
            idx_last = find(diff_ogilt,1,'last');
            
            diff_ogilt(idx_last) = 0;
            ogilt_data(end) = false;
            
        end
        
        
        % After the first and last points have been checked.If there is a
        % difference in length between the two this indicates
        % that several of the first or last values belong to the "ogilitg"
        % category. Check which of the cases that is happening and remove
        % that occation
        if sum(diff_ogilt) == 1
             
            miss_data_neg = miss_data_neg(2:end);
            
        elseif sum(diff_ogilt) == -1
            
            miss_data_pos = miss_data_pos(1:(end-1));
            
            %Finds location of the start of the valid measurement period
            idx_last = find((ogilt_data-1),1,'last');
            
            %Sets this as unvalid data as there is no start to the missing
            %data period
            ogilt_data(idx_last) = false;
            
            diff_ogilt(idx_last) = 0;
            
        elseif sum(diff_ogilt) == 0
            
        else
            
            error('The diff_ogilt variable for dataset number %d of building %d is not balanced',k,j)
            
        end
        
        %Gives the total missing data for each period of missing data
        miss_diff = miss_data_pos + miss_data_neg;
        
        
        % Loop that inserts the total amount of energy for as consumption
        % for the final timestep in the non valid period (diff_ogilt == -1).
        h = 1;
        for i = 1:length(diff_ogilt)
            
            if diff_ogilt(i) == -1
                data_dem(i) = miss_diff(h);
                h = h+1;
            end
            
        end
        
        % Remove all non valid data points 
        data_dem = data_dem(ogilt_data == 0);
        
        % Remove all non valid timestamps
        timestamp_2 = timestamp(ogilt_data == 0);
        
        %Remove all non valid interplated steps
        inter_data = inter_data(ogilt_data == 0);
        
        timestamp = timestamp_2;
        
        % Check difference between timestamps
        time_diff = timestamp(1:(end-1)) - timestamp(2:end);
        
        % If difference is larger then 1.5 hours indication that there is a
        % missing messurment point.
        max_diff = hours(1.5);
        idx_time = time_diff < max_diff;
        
        % Sets up inital missing data positions
        idx_miss = idx_time == 0;
        % As the last timestep in the vector (but first in chronological
        % order) is not checked against any other an additional value is
        % added to make it the same length as the data.
        idx_miss(end+1) = false;
        
        %Create idx_miss_ix  as
        % index needes to be shifted one step to indicate that it is that
        % hour that is missing. To be used in while loop.
        idx_miss_it = circshift(idx_miss,1);

        % Dump data into new variables for while loop
        new_timestamp = timestamp ;
        new_data_dem = data_dem;
        new_inter_data = inter_data;
        
        % Creates new data with the intial missing data position length
        % added
        temp_missing_data = false(length(new_data_dem)+sum(idx_miss),1);
        
        % While there is still points missing keep running. The loop will
        % look if there is still missing points. If that is the case it
        % will distribute the data consumed during the missing hours
        % evenely over the period. It adds one additional timeslot to each
        % period with missing data until the period no longer contains
        % missing timeslots.
        while sum(idx_miss) > 0
            

            temp_tstamp = new_timestamp;
            temp_ddem = new_data_dem;
            temp_inter = new_inter_data;
            
            % Create time position for missing data points
            diff = time_diff(idx_miss) - hours(1);
            % Creates datetime value for missing points
            time_miss = temp_tstamp(idx_miss)- diff;
            
            %Since the total demand for the periods with missing
            %meassurments is stored 
            data_miss = temp_ddem(idx_miss);
            
            %Create empty dataset that will be filled with old data and new
            %added points
            new_timestamp = NaT(length(temp_ddem)+sum(idx_miss),1);

            new_data_dem = zeros(length(temp_ddem)+sum(idx_miss),1);
            
            new_inter_data = false(length(temp_ddem)+sum(idx_miss),1);
            
            missing_data = false(length(temp_ddem)+sum(idx_miss),1);
            
            h = 0;
            
            
            % Loop that fills in missing timestamps
            for i = 1:(length(temp_tstamp))

                %If a timeslot is missing 
                if idx_miss_it(i) == 1
                    
                    %Seperate index from the for loop to keep track of when
                    %extra data points are added.
                    h=h+1;
                    %Add the datetime off missing timeslot
                    new_timestamp(i+(h-1)) = time_miss(h);
                    
                    %Divide the missing data by the number of missing
                    %hours, this results in the demand being distributed
                    %even among these hours,
                    new_data_dem(i+(h-1)) = data_miss(h)/(round(diff(h)/hours(1))+1);
                    
                    %remove the data added earlier from the total data
                    %missing for the timeperiod represeted by data_miss(h)
                    new_data_dem(i+(h-2)) = data_miss(h) - data_miss(h)/(round(diff(h)/hours(1))+1);
                    
                    %Register these datapoints as points of missing data.
                    missing_data(i+(h-1)) = true;
                    missing_data(i+(h-2)) = true;
                    

                end
                    
                %If not a missing data point just add the data that is
                %valid for that time.
                    new_timestamp(i+h) = temp_tstamp(i);

                    new_data_dem(i+h)  =  temp_ddem(i);
                    
                    missing_data(i+h) = temp_missing_data(i);
                    
                    new_inter_data(i+h) = temp_inter(i);

            end
            
            % Calcualte if there are more datapoints missing or if the loop
            % is done
            new_timestamp(end) = temp_tstamp(end);

            time_diff = new_timestamp(1:(end-1)) - new_timestamp(2:end);

            idx_time = time_diff < max_diff;

            idx_miss = idx_time == 0;
            idx_miss(end+1) = false;
            idx_miss_it = circshift(idx_miss,1);
            temp_missing_data = missing_data;

        end
        
        % Last (first chronologicly) is always seen as a missing data point
        missing_data(end) = true;
        
        %Check if additional timestamps need to be added due to missing
        %meaurments in the beginning or end of the measurment period.
        % The first check is for if it is the 2017 period or 2018 period
        % through checking if the data source is even or odd in the order
        % of the data.
        % THIS IS INPUT SPECIFIC AND NEEDS TO BE ADAPTED TO THE SITUATION.
        if mod(k,2) == 1
            
            % Check if there is timesteps missing between the start of the
            % data and the expected start of the measuring period.
            if  new_timestamp(end) -  start_time1  > hours(1)

                h_to_add = new_timestamp(end) -  start_time1;

                [h_val,~,~] = hms(h_to_add);

                q = 1;
                
                %Add missing timesteps and missing data
                for i = 1:h_val

                    h_to_add = h_to_add - hours(1);

                    new_timestamp(end + 1) = start_time1 + h_to_add;

                    missing_data(end + 1) = true;

                    new_data_dem(end + 1) = 0;

                    new_inter_data(end + 1) = false;

                end
                
                    %The start time time step needs to be added.
                    new_timestamp(end + 1) = start_time1 ;

                    missing_data(end + 1) = true;

                    new_data_dem(end + 1) = 0;

                    new_inter_data(end + 1) = false;
                
            end
            
            % Check if there is timesteps missing between the end of the
            % data and the expected end of the measuring period.            
            if  end_time1 - new_timestamp(1) > hours(1)
                
                h_to_add =  end_time1 - new_timestamp(1);

                [h_val,~,~] = hms(h_to_add);

                q = 1;
                
                %Add missing timesteps and missing data
                for i = 1:h_val

                    h_to_add = h_to_add - hours(1);

                    temp_timestamp(2:(length(new_timestamp)+1)) = new_timestamp;
                    
                    temp_timestamp(1) = end_time1 - h_to_add;
                    
                    temp_missing_data(2:(length(missing_data)+1)) = missing_data;
                    
                    temp_missing_data(1) = true;
                    

                    temp_new_data_dem(2:(length(new_data_dem)+1)) = new_data_dem;
                    
                    temp_new_data_dem(1) = 0;  
                    
                    temp_new_inter_data(2:(length(new_inter_data)+1)) = new_inter_data;
                    
                    temp_new_inter_data(1) = false; 
                    
                    
                    new_timestamp = temp_timestamp;

                    missing_data = temp_missing_data;

                    new_data_dem = temp_new_data_dem;

                    new_inter_data = temp_new_inter_data;
                    

                end
                
                %First value must be added since this is the same as
                %the end time stamp

                temp_timestamp(2:(length(new_timestamp)+1)) = new_timestamp;

                temp_timestamp(1) = end_time1 ;

                temp_missing_data(2:(length(missing_data)+1)) = missing_data;

                temp_missing_data(1) = true;


                temp_new_data_dem(2:(length(new_data_dem)+1)) = new_data_dem;

                temp_new_data_dem(1) = 0;  

                temp_new_inter_data(2:(length(new_inter_data)+1)) = new_inter_data;

                temp_new_inter_data(1) = false; 
                

                new_timestamp = temp_timestamp;

                missing_data = temp_missing_data;

                new_data_dem = temp_new_data_dem;

                new_inter_data = temp_new_inter_data;

                clear temp_new_inter_data temp_new_data_dem temp_missing_data temp_timestamp

            end
            
        else
           
            % Check if there is timesteps missing between the start of the
            % data and the expected start of the measuring period.
            if  new_timestamp(end) -  start_time2  > hours(1)

                h_to_add = new_timestamp(end) -  start_time2;

                [h_val,~,~] = hms(h_to_add);

                q = 1;
                for i = 1:h_val

                    h_to_add = h_to_add - hours(1);

                    new_timestamp(end + q) = start_time2 + h_to_add;

                    missing_data(end + q) = true;

                    new_data_dem(end + q) = 0;

                    new_inter_data(end + q) = false;

                end
                
                    %The start time time step needs to be added.
                    new_timestamp(end + 1) = start_time2 ;

                    missing_data(end + 1) = true;

                    new_data_dem(end + 1) = 0;

                    new_inter_data(end + 1) = false;
                
                
            end
            
            % Check if there is timesteps missing between the end of the
            % data and the expected end of the measuring period.             
            if  end_time2 - new_timestamp(1) > hours(1)
                
                h_to_add =  end_time2 - new_timestamp(1);

                [h_val,~,~] = hms(h_to_add);

                
                
                %Add missing timesteps and missing data
                for i = 1:h_val

                    h_to_add = h_to_add - hours(1);

                    temp_timestamp(2:(length(new_timestamp)+1)) = new_timestamp;
                    
                    temp_timestamp(1) = end_time2 - h_to_add;
                    
                    temp_missing_data(2:(length(missing_data)+1)) = missing_data;
                    
                    temp_missing_data(1) = true;
                    

                    temp_new_data_dem(2:(length(new_data_dem)+1)) = new_data_dem;
                    
                    temp_new_data_dem(1) = 0;  
                    
                    temp_new_inter_data(2:(length(new_inter_data)+1)) = new_inter_data;
                    
                    temp_new_inter_data(1) = false; 
                    
                    new_timestamp = temp_timestamp;
                    
                    missing_data = temp_missing_data;

                    new_data_dem = temp_new_data_dem;

                    new_inter_data = temp_new_inter_data;
                    
                    clear temp_new_inter_data temp_new_data_dem temp_missing_data temp_timestamp


                end
                
                %First value must be added since this is the same as
                %the end time stamp

                temp_timestamp(2:(length(new_timestamp)+1)) = new_timestamp;

                temp_timestamp(1) = end_time2 ;

                temp_missing_data(2:(length(missing_data)+1)) = missing_data;

                temp_missing_data(1) = true;


                temp_new_data_dem(2:(length(new_data_dem)+1)) = new_data_dem;

                temp_new_data_dem(1) = 0;  

                temp_new_inter_data(2:(length(new_inter_data)+1)) = new_inter_data;

                temp_new_inter_data(1) = false; 
                

                new_timestamp = temp_timestamp;

                missing_data = temp_missing_data;

                new_data_dem = temp_new_data_dem;

                new_inter_data = temp_new_inter_data;
                
                clear temp_new_inter_data temp_new_data_dem temp_missing_data temp_timestamp
                
                
            end
        end
        
        % Since the interpolated values in AH dataset have timestamps that
        % always fall on the hour mark there is a risk of excess datapoints
        % from the treatment above, i.e, more than one datapoint
        % represeting one hour. These extra steps are removed below. This
        % results in a lower total consumption for the total period than
        % the orignal (the points themself will always be classified as missing datapoints). However, the number of points are so few that this
        % should not have a major impact (if there are many points the code
        % will warn).
        
        %extract hour values from the timestep values
        timestep_hours  = hour(new_timestamp);
        
        %Check difference between each hour value.
        diff_hours = timestep_hours(1:(end-1)) -timestep_hours(2:end);
        
        %index which specifies which values are to be used
        idx_hours = diff_hours ~= 0;
        % Last value in idex added manually since the last timestep in the
        % set isn't checked against anything.
        idx_hours(end+1) = true;
        
        if (length(idx_hours) - sum(idx_hours))/length(idx_hours) > 0.05
            warning('The number of removed hours exceed 5%% of total hours for dataset number %d of building %d',k,j)
        end
        
        new_data_dem = new_data_dem(idx_hours);
        new_timestamp = new_timestamp(idx_hours);
        missing_data = missing_data(idx_hours);
        new_inter_data = new_inter_data(idx_hours);
        
        %An additional check is done incase there are timesteps that have
        %been missed due to the choice of 1.5 hours as the cut off. Should
        %only result in a 2 hour diff, if diff is larger something is
        %wrong.
        %extract hour values from the timestep values
        timestep_hours  = hour(new_timestamp);
        
        %Check difference between each hour value.
        diff_hours = timestep_hours(1:(end-1)) -timestep_hours(2:end);
        
        q= 0;
        for i = 1:length(diff_hours)
            
            if diff_hours(i) == 2
                
                temp_timestamp(i+q) = new_timestamp(i);
                
                temp_new_data_dem(i+q) = new_data_dem(i);
                
                temp_missing_data2(i+q) = missing_data(i);
                
                temp_new_inter_data(i+q) = new_inter_data(i);
                
                q= q+1;
                %subtraction since the time starts at the end of the vector
                temp_timestamp(i+q) = new_timestamp(i) - hours(1);
                
                temp_new_data_dem(i+q) = 0;
                
                temp_missing_data2(i+q) = true;
                
                temp_new_inter_data(i+q) = false;
                
                
            else
            
                temp_timestamp(i+q) = new_timestamp(i);
                
                temp_new_data_dem(i+q) = new_data_dem(i);
                
                temp_missing_data2(i+q) = missing_data(i);
                
                temp_new_inter_data(i+q) = new_inter_data(i);
                
            end
        end
        
        % Since the diff compairison is 1 value shortert than the data the
        % final data point of the orgiginal dataset is added.
        temp_timestamp(end+1) = new_timestamp(end);

        temp_new_data_dem(end+1) = new_data_dem(end);

        temp_missing_data2(end+1) = missing_data(end);

        temp_new_inter_data(end+1) = new_inter_data(end);
        
        new_timestamp = temp_timestamp';
        
        new_data_dem = temp_new_data_dem';
        
        missing_data = temp_missing_data2';
        
        new_inter_data = temp_new_inter_data';
        
        clear temp_timestamp temp_new_data_dem temp_missing_data2 temp_new_inter_data
        
        
        % When done add data to the datastructure        
        EDIT_data(j).e_flows(k).data_fixed = new_data_dem;
        
        % Indicates the timestamp of the datapoint.
        EDIT_data(j).e_flows(k).time_fixed = new_timestamp;
        
        % Indicates datapoints that are missing
        EDIT_data(j).e_flows(k).data_miss = missing_data; 
        
        % Indicates data points that where interpolated
        EDIT_data(j).e_flows(k).inter_data = new_inter_data;
        
        
    end
end            
            
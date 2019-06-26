function [m_data] = import_measurments(directory)
% Improting data from AH requiers that the folder structure is following
% the one used in the data recived from AH (can be used with the origianl CAFH structure as well). Directory should be the folder
% that contains all the folders with data, e.g., 'Mätadata\Mätardata 17 -
% 18\'. 
% Creates a structure that is the input to the sort_and_fix_AH_data.m file
% The strucutre contains the file name and the raw data from each
% measurment.

%Folder with data
mappar = dir(directory);

%Indexation used in the loop below
h = 1;

%Loop over all folders within mappar
for i = 1:length(mappar)
    
    %remove all . files
    if (strcmp(mappar(i).name,'.') ||  strcmp(mappar(i).name,'..')) == 0
        
        %Extract name of data folder
        dirren = mappar(i).name;
        
        m_data(h).build = dirren;
        
        temp_mapp = dir([directory dirren]);
        
        k = 1;
        
        %Loop over all files within the folder temp_mapp
        for j = 1:length(temp_mapp)
             
             %remove all . files
             if (strcmp(temp_mapp(j).name,'.') ||  strcmp(temp_mapp(j).name,'..')) == 0
                 
                 file = temp_mapp(j).name;
                 
                 %Extract the raw data from the file
                 [NUM,TXT,RAW] = xlsread([directory dirren '\' file]);
                 
                 %Save file name
                 m_data(h).e_flows(k).file = file;
                 
                 %Save raw data
                 m_data(h).e_flows(k).data = RAW;
                 
                 k = k +1;
                 
             end
             
        end
        
        h = h +1 ;
    end
end
                 
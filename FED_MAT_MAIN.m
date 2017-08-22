
clc;
clear; 
close all;
%% Calculate PE and CO2 of the external grids and the FED system in the base case
tic

%CO2 and PE facrors of local generation unists
CO2F_PV=45;
PEF_PV=1.25;

CO2F_P1=12;
PEF_P1=1.33;

CO2F_P2=12;
PEF_P2=1.33;

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH
P1_eff=0.9;          %assumed efficiency of Panna1
P1_eff_temp = struct('name','P1_eff','type','parameter','form','full','val',P1_eff);

%calculate new values
NEW_data=1;

while NEW_data==1
    get_CO2PE_FED;   %this routine calculates the CO2 and PE factors of the external grid also    
    save('FED_PE0','FED_PE0');
    save('FED_CO20','FED_CO20');
    save('el_exGCO2F','el_exGCO2F');
    save('el_exGPEF','el_exGPEF');
    save('DH_CO2F','DH_CO2F');
    save('DH_PEF','DH_PEF');
    save('tb_heat_2016','tb_heat_2016');
    save('fgc_heat_2016','fgc_heat_2016');
    save('fuel_P1','fuel_P1');
    save('q_P1','q_P1');
    save('el_Import_2016','el_Import_2016')
    save('heat_Import_2016','heat_Import_2016')
    break;
end

%load saved values
while NEW_data==0
    load FED_PE0;
    load FED_CO20;
    load el_exGCO2F;
    load el_exGPEF;
    load DH_CO2F;
    load DH_PEF;
    load tb_heat_2016;
    load fgc_heat_2016;
    load fuel_P1;
    load q_P1;
    load el_Import_2016;
    load heat_Import_2016;
    break;
end
%% Define GAMS input parameters
tlen=24*365;                %length the time series data
%for t=1:tlen
%    str{t}=(strcat(num2str('H'),num2str(t)));
%end
H.name='H0';
H.uels=num2cell(1:tlen);
%H.uels=(str);

%Data to be exported to GAMS
FED_PE_0 = struct('name','FED_PE0','type','parameter','form','full','val',FED_PE0);
FED_PE_0.uels=H.uels;
FED_CO2_0 = struct('name','FED_CO20','type','parameter','form','full','val',FED_CO20);
FED_CO2_0.uels=H.uels;
temp_CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2F_PV);
temp_PEF_PV = struct('name','PEF_PV','type','parameter','val',PEF_PV);
temp_CO2F_P1 = struct('name','CO2F_P1','type','parameter','val',CO2F_P1);
temp_PEF_P1 = struct('name','PEF_P1','type','parameter','val',PEF_P1);
temp_CO2F_P2 = struct('name','CO2F_P2','type','parameter','val',CO2F_P2);
temp_PEF_P2 = struct('name','PEF_P2','type','parameter','val',PEF_P2);

pCO2ref=0.95; %Choose the percentage the reference CO2 [this value can be varied for sensetivity analysis]
FED_CO2ref = struct('name','CO2_ref','type','parameter','val',pCO2ref*max(FED_CO20));
FED_inv=76761000;  %this is projected FED investment cost in SEK
fInv_lim=1;        %multiplication factor [can be varied for sensetivity analysis]
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',fInv_lim*FED_inv);


CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full','val',el_exGCO2F);
CO2F_exG.uels=H.uels;
PEF_exG = struct('name','PEF_exG','type','parameter','form','full','val',el_exGPEF);
PEF_exG.uels=H.uels;
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full','val',DH_CO2F);
CO2F_DH.uels=H.uels;
PEF_DH = struct('name','PEF_DH','type','parameter','form','full','val',DH_PEF);
PEF_DH.uels=H.uels;
Q_P1_TB = struct('name','q_P1_TB','type','parameter','form','full','val',tb_heat_2016);
Q_P1_TB.uels=H.uels;
Q_P1_FGC = struct('name','q_P1_FGC','type','parameter','form','full','val',fgc_heat_2016);
Q_P1_FGC.uels=H.uels;
FUEL_P1 = struct('name','fuel_P1','type','parameter','form','full','val',fuel_P1);
FUEL_P1.uels=H.uels;
%% GAMS Model input

%optimization option
option1=0; %minimize total cost, PE and CO2 cap
option2=2; %minimize tottal PE use, investment cost cap
option3=0; %minimize total CO2 emission, investment cost cap
option4=0; %minimize total CO2 and PE (compromise), investement cost cap
temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_totPE','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);
temp_optn4 = struct('name','min_totPECO2','type','parameter','form','full','val',option4);

wgdx('MtoG.gdx', FED_PE_0, FED_CO2_0,CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,...
     Q_P1_TB, Q_P1_FGC, FUEL_P1, P1_eff_temp,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     temp_optn1, temp_optn2, temp_optn3, temp_optn4, FED_CO2ref, FED_Inv_lim);
%% RUN GAMS model

 RUN_GAMS_MODEL = 1;
 while RUN_GAMS_MODEL==1
     system 'gams FED_SIMULATOR_MAIN lo=3';
     break;
 end
 %% Post processing results 
 
 %use the 'plot_results.m' script to plot desired results
%%

toc
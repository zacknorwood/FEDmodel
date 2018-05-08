
clc;
clear; 
close all;
tic
%% RE-LOAD MAIN INPUT DATA IN GAMS IF THERE IS NY CHANGE IN THE INPUT EXCEL FILES

RE_LOAD_INPUT=0;
while RE_LOAD_INPUT==1
    
    system 'gams FED_GENERATE_GDX_FILE lo=3';
    break;
end

%% DECISSION PARAMETERS TO DECIDE WHICH INVESTMENT OPTIONS TO CONSIDER
% use of switch to determine whether HP, CHP, TES should CONSIDERED or not
% 1=CONSIDERED, 0=NOT CONSIDERED
HP_SW = 0;
sw_HP = struct('name','sw_HP','type','parameter','val',HP_SW);
TES_SW = 0;
sw_TES = struct('name','sw_TES','type','parameter','val',TES_SW);
BTES_SW = 0;
sw_BTES = struct('name','sw_BTES','type','parameter','val',BTES_SW);
BAC_SW = 0;
sw_BAC = struct('name','sw_BAC','type','parameter','val',BAC_SW);
BES_SW = 0;
sw_BES = struct('name','sw_BES','type','parameter','val',BES_SW);
PV_SW = 0;
sw_PV = struct('name','sw_PV','type','parameter','val',PV_SW);
RMMC_SW = 0;
sw_RMMC = struct('name','sw_RMMC','type','parameter','val',RMMC_SW);
P2_SW = 0;
sw_P2 = struct('name','sw_P2','type','parameter','val',P2_SW);
TURB_SW = 0;
sw_TURB = struct('name','sw_TURB','type','parameter','val',TURB_SW);
AbsCInv_SW = 0;
sw_AbsCInv = struct('name','sw_AbsCInv','type','parameter','val',AbsCInv_SW);
RMInv_SW = 0;
sw_RMInv = struct('name','sw_RMInv','type','parameter','val',RMInv_SW);

%% FXED INVESTMENT OPTIONS
%Option to set if any investments are to be fixed
opt_fx_inv=1;
temp_opt_fx_inv = struct('name','opt_fx_inv','type','parameter','form','full','val',opt_fx_inv);

%Option for RMMC investment
opt_fx_inv_RMMC=0;  %Set to 1 if the investment in MC2 cooling connection is
temp_opt_fx_inv_RMMC = struct('name','opt_fx_inv_RMMC','type','parameter','form','full','val',opt_fx_inv_RMMC);

%Option for new AbsChiller investment
opt_fx_inv_AbsCInv=0;
temp_opt_fx_inv_AbsCInv = struct('name','opt_fx_inv_AbsCInv','type','parameter','form','full','val',opt_fx_inv_AbsCInv);
opt_fx_inv_AbsCInv_cap=1;
temp_opt_fx_inv_AbsCInv_cap = struct('name','opt_fx_inv_AbsCInv_cap','type','parameter','form','full','val',opt_fx_inv_AbsCInv_cap);

%Option for P2 investment
opt_fx_inv_P2=1;
temp_opt_fx_inv_P2 = struct('name','opt_fx_inv_P2','type','parameter','form','full','val',opt_fx_inv_P2);

%Option for Turbine investment
opt_fx_inv_TURB=1;
temp_opt_fx_inv_TURB = struct('name','opt_fx_inv_TURB','type','parameter','form','full','val',opt_fx_inv_TURB);

%Option for new HP investment
opt_fx_inv_HP=0;
temp_opt_fx_inv_HP = struct('name','opt_fx_inv_HP','type','parameter','form','full','val',opt_fx_inv_HP);
opt_fx_inv_HP_cap=1;
temp_opt_fx_inv_HP_cap = struct('name','opt_fx_inv_HP_cap','type','parameter','form','full','val',opt_fx_inv_HP_cap);
 
%Option for TES investment
opt_fx_inv_TES=1;
temp_opt_fx_inv_TES = struct('name','opt_fx_inv_TES','type','parameter','form','full','val',opt_fx_inv_TES);
opt_fx_inv_TES_cap=0;
temp_opt_fx_inv_TES_cap = struct('name','opt_fx_inv_TES_cap','type','parameter','form','full','val',opt_fx_inv_TES_cap);

%Option for BES investment
opt_fx_inv_BES=0;
temp_opt_fx_inv_BES = struct('name','opt_fx_inv_BES','type','parameter','form','full','val',opt_fx_inv_BES);
opt_fx_inv_BES_cap=1;
temp_opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full','val',opt_fx_inv_BES_cap);

%% INPUT PE and CO2 FACTORS and Dispatch of local generating units

%CO2 and PE facrors of local generation unists
CO2F_PV=22; %45
temp_CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2F_PV);
PEF_PV=0.25;
temp_PEF_PV = struct('name','PEF_PV','type','parameter','val',PEF_PV);

CO2F_P1=12;
temp_CO2F_P1 = struct('name','CO2F_P1','type','parameter','val',CO2F_P1);
PEF_P1=1.33;
temp_PEF_P1 = struct('name','PEF_P1','type','parameter','val',PEF_P1);

CO2F_P2=12;
temp_CO2F_P2 = struct('name','CO2F_P2','type','parameter','val',CO2F_P2);
PEF_P2=1.33;
temp_PEF_P2 = struct('name','PEF_P2','type','parameter','val',PEF_P2);

CO2F_spillvarme=98;      %98
PEF_spillvarme=0.03;     %0.03

COP_AbsC=0.5;
COP_AAC=10;

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH
P1_eff=0.9;          %assumed efficiency of Panna1
P1_eff_temp = struct('name','P1_eff','type','parameter','form','full','val',P1_eff);

% calculate new values
NEW_data=1;

while NEW_data==1
    get_CO2PE_FED;   %this routine calculates the CO2 and PE factors of the external grid also    
    save('el_exGCO2F','el_exGCO2F');
    save('el_exGPEF','el_exGPEF');
    save('DH_CO2F','DH_CO2F');
    save('DH_PEF','DH_PEF');
    save('h0_AbsC','h0_AbsC');
    save('e0_AAC','e0_AAC');
    save('e0_VKA1','e0_VKA1');
    save('e0_VKA4','e0_VKA4');
        
    FED_CO20=load('Sim_Results\Sim_Results_base\Data\FED_CO2');
    FED_CO20=FED_CO20.FED_CO2;
    FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
    FED_PE0=FED_PE0.FED_PE;
    break;
end

%load saved values
while NEW_data==0
    FED_CO20=load('Sim_Results\Sim_Results_base\Data\FED_CO2');
    FED_CO20=FED_CO20.FED_CO2;
    FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
    FED_PE0=FED_PE0.FED_PE;

    load el_exGCO2F;
    load el_exGPEF;
    load DH_CO2F;
    load DH_PEF;
    load h0_AbsC;
    load e0_AAC;
    load e0_VKA1;
    load e0_VKA4;
    break;
end

%Simulation time
tlen=24*365*2;                %length the time series data
%for t=1:tlen
%    str{t}=(strcat(num2str('H'),num2str(t)));
%end
H.name='H0';
H.uels=num2cell(1:tlen);
%H.uels=(str);

%FED_PE_0 = struct('name','FED_PE0','type','parameter','form','full','val',FED_PE0);
%FED_PE_0.uels=H.uels;
%FED_CO2_0 = struct('name','FED_CO20','type','parameter','form','full','val',FED_CO20);
%FED_CO2_0.uels=H.uels;
pCO2ref=5;    %Choose the percentage the reference CO2 to determine reference CO2 that defined the peal hours
              %[this value can be changed depending on how the CO2 peak is defined]
data=sort(FED_CO20,'descend'); 
duration= 0 : 100/(length(FED_CO20)-1) : 100;
x=find(duration<=5);
CO2ref=data(length(x)); %CO2 reference
FED_CO2_max = struct('name','CO2_max','type','parameter','val',max(FED_CO20));
FED_CO2_peakref = struct('name','CO2_peak_ref','type','parameter','val',CO2ref);
FED_PE_totref = struct('name','PE_tot_ref','type','parameter','val',sum(FED_PE0));
CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full','val',el_exGCO2F);
CO2F_exG.uels=H.uels;
PEF_exG = struct('name','PEF_exG','type','parameter','form','full','val',el_exGPEF);
PEF_exG.uels=H.uels;
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full','val',DH_CO2F);
CO2F_DH.uels=H.uels;
PEF_DH = struct('name','PEF_DH','type','parameter','form','full','val',DH_PEF);
PEF_DH.uels=H.uels;

h_AbsC0 = struct('name','h0_AbsC','type','parameter','form','full','val',h0_AbsC);
h_AbsC0.uels=H.uels;
e_AAC0 = struct('name','e0_AAC','type','parameter','form','full','val',e0_AAC);
e_AAC0.uels=H.uels;
e_VKA10 = struct('name','e0_VKA1','type','parameter','form','full','val',e0_VKA1);
e_VKA10.uels=H.uels;
e_VKA40 = struct('name','e0_VKA4','type','parameter','form','full','val',e0_VKA4);
e_VKA40.uels=H.uels;

%% FED INVESTMENT LIMIT

FED_inv = 68570065;%68570065; %76761000;  %this is projected FED investment cost in SEK
fInv_lim=1;        %multiplication factor [can be varied for sensetivity analysis]
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',fInv_lim*FED_inv);

%% SIMULATION OPTIONS

%SIMULATION START AND STOP TIME
start=1442;
stop=10202;
h_sim.name='h';
h_sim.uels=num2cell(start:stop);

% optimization option
option0=1;    %Base case, Pannn1, q_AbsC, e_AAC, e_VKA1, e_VKA4 fixed to the measured value
option1=0;    %minimize total cost, PE and CO2 cap
option2=0;    %minimize tottal PE use, investment cost cap
option3=0;    %minimize total CO2 emission, investment cost cap
option4=0;    %minimize total CO2 and PE (compromise), investement cost cap
option5=0;    %minimize CO2 peak, with investement cost cap

temp_optn0 = struct('name','min_totCost0','type','parameter','form','full','val',option0);
temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_totPE','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);
temp_optn4 = struct('name','min_totPECO2','type','parameter','form','full','val',option4);
temp_optn5 = struct('name','min_peakCO2','type','parameter','form','full','val',option5);

%% RUN GAMS model

wgdx('MtoG.gdx', sw_HP, sw_TES, sw_BTES, sw_BAC, sw_BES, sw_PV, sw_RMMC, sw_P2, sw_TURB, sw_AbsCInv, sw_RMInv,...
    temp_opt_fx_inv,temp_opt_fx_inv_RMMC,temp_opt_fx_inv_AbsCInv,temp_opt_fx_inv_AbsCInv_cap, temp_opt_fx_inv_P2,temp_opt_fx_inv_TURB,temp_opt_fx_inv_HP, temp_opt_fx_inv_HP_cap,...
     temp_opt_fx_inv_TES, temp_opt_fx_inv_TES_cap, temp_opt_fx_inv_BES, temp_opt_fx_inv_BES_cap, h_sim,...
     FED_PE_totref, FED_CO2_max, FED_CO2_peakref,CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,...
     h_AbsC0,e_AAC0,e_VKA10,e_VKA40,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     temp_optn0,temp_optn1, temp_optn2, temp_optn3, temp_optn4, temp_optn5, FED_Inv_lim);
%return
 RUN_GAMS_MODEL = 1;
 while RUN_GAMS_MODEL==1
     system 'gams FED_SIMULATOR_MAIN lo=3';
     break;
 end
 %% Post processing results 
 
 %use the 'plot_results.m' script to plot desired results
%%

toc

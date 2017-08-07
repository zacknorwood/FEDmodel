
clc;
clear; 
close all;
%% Calculate PE and CO2 of the external grids and the FED system in the base case

SAVE_data=1;
NEW_data=0;

%CO2 and PE facrors of local generation unists
CO2F_PV=45;
PEF_PV=1.25;

CO2F_P1=12;
PEF_P1=1.33;

CO2F_P2=12;
PEF_P2=1.33;

%calculate new values
while NEW_data==1
    get_CO2PE_FED;   %this routine calculates the CO2 and PE factors of the external grid also
    FED_PE_base=sum(FED_PE);
    FED_CO2Peak_base=max(FED_CO2);
    if SAVE_data==1
       save('FED_PE_base','FED_PE_base')
       save('FED_CO2Peak_base','FED_CO2Peak_base');
       save('el_exGCO2F','el_exGCO2F');
       save('el_exGPEF','el_exGPEF');
       save('DH_CO2F','DH_CO2F');
       save('DH_PEF','DH_PEF');
    end
    break;
end

%load saved values
while NEW_data==0
    load FED_PE_base;
    load FED_CO2Peak_base;
    load el_exGCO2F;
    load el_exGPEF;
    load DH_CO2F;
    load DH_PEF;
    break;
end
%% Define GAMS input parameters

%Data to be exported to GAMS
FED_PE_0 = struct('name','FED_PE_base','type','parameter','form','full','val',FED_PE_base);
FED_CO2Peak_0 = struct('name','FED_CO2Peak_base','type','parameter','form','full','val',FED_CO2Peak_base);
temp_CO2F_PV = struct('name','CO2F_PV','type','parameter','form','full','val',CO2F_PV);
temp_PEF_PV = struct('name','PEF_PV','type','parameter','form','full','val',PEF_PV);
temp_CO2F_P1 = struct('name','CO2F_P1','type','parameter','form','full','val',CO2F_P1);
temp_PEF_P1 = struct('name','PEF_P1','type','parameter','form','full','val',PEF_P1);
temp_CO2F_P2 = struct('name','CO2F_P2','type','parameter','form','full','val',CO2F_P2);
temp_PEF_P2 = struct('name','PEF_P2','type','parameter','form','full','val',PEF_P2);

tlen=24*365;                %length the time series data
%for t=1:tlen
%    str{t}=(strcat(num2str('H'),num2str(t)));
%end
H.name='H0';
H.uels=num2cell(1:tlen);
%H.uels=(str);

CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full','val',el_exGCO2F);
CO2F_exG.uels=H.uels;
PEF_exG = struct('name','PEF_exG','type','parameter','form','full','val',el_exGPEF);
PEF_exG.uels=H.uels;
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full','val',DH_CO2F);
CO2F_DH.uels=H.uels;
PEF_DH = struct('name','PEF_DH','type','parameter','form','full','val',DH_PEF);
PEF_DH.uels=H.uels;
%% Run GAMS Model

%optimization option
option1=0; %minimize total cost
option2=1; %minimize investment cost
option3=0; %minimize total CO2 emission
temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_invCost','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);

wgdx('MtoG.gdx', FED_PE_0, FED_CO2Peak_0,CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     temp_optn1, temp_optn2, temp_optn3);

system 'gams FED_SIMULATOR_MAIN lo=3';
%% Get output results

GET_RESULTS=0;
while GET_RESULTS==1
    %% Get results from VKA1
    
    %heating output from VKA1
    H_VKA1.name='H_VKA1';
    H_VKA1.form='full';
    H_VKA1=rgdx('GtoM',H_VKA1);
    H_VKA1=H_VKA1.val;
    %cooling output from VKA1
    C_VKA1.name='C_VKA1';
    C_VKA1.form='full';
    C_VKA1=rgdx('GtoM',C_VKA1);
    C_VKA1=C_VKA1.val;
    %electricty input to VKA1
    el_VKA1.name='el_VKA1';
    el_VKA1.form='full';
    el_VKA1=rgdx('GtoM',el_VKA1);
    el_VKA1=el_VKA1.val;
    %% Get results from VKA4
    
    %heating output from VKA4
    H_VKA4.name='H_VKA4';
    H_VKA4.form='full';
    H_VKA4=rgdx('GtoM',H_VKA4);
    H_VKA4=H_VKA4.val;
     %cooling output from VKA4
    C_VKA4.name='C_VKA4';
    C_VKA4.form='full';
    C_VKA4=rgdx('GtoM',C_VKA4);
    C_VKA4=C_VKA4.val;
    %electricty input to VKA4
    el_VKA4.name='el_VKA4';
    el_VKA4.form='full';
    el_VKA4=rgdx('GtoM',el_VKA4);
    el_VKA4=el_VKA4.val;    
    %% Get results from Panna2
    
    %Binary decission variable to invest in P2 (is 1 if invested, 0 otherwise)
    B_P2.name='B_P2';    
    B_P2=rgdx('GtoM',B_P2);
    B_P2=B_P2.val;
    %investment cost in P2
    invCost_P2.name='invCost_P2';    
    invCost_P2=rgdx('GtoM',invCost_P2);
    invCost_P2=invCost_P2.val;
    %Fuel input to P2
    q_P2.name='q_P2';
    q_P2.form='full';
    q_P2=rgdx('GtoM',q_P2);
    q_P2=q_P2.val;
    %heating output from P2 to DH
    H_P2T.name='H_P2T';
    H_P2T.form='full';
    H_P2T=rgdx('GtoM',H_P2T);
    H_P2T=H_P2T.val;
    %Binary decission variable to invest in the turbine (is 1 if invested, 0 otherwise)
    B_TURB.name='B_TURB';    
    B_TURB=rgdx('GtoM',B_TURB);
    B_TURB=B_TURB.val;
    %investment cost in the turbine
    invCost_TURB.name='invCost_TURB';    
    invCost_TURB=rgdx('GtoM',invCost_TURB);
    invCost_TURB=invCost_TURB.val;
    %electricty output from the turbine
    e_TURB.name='e_TURB';
    e_TURB.form='full';
    e_TURB=rgdx('GtoM',e_TURB);
    e_TURB=e_TURB.val;
    %heating input to the turbine
    q_TURB.name='q_TURB';
    q_TURB.form='full';
    q_TURB=rgdx('GtoM',q_TURB);
    q_TURB=q_TURB.val;    
    %% Get results from Absorbtion Chiller
    
    %heating input to the existing Absorbtion chiller
    q_AbsC.name='q_AbsC';
    q_AbsC.form='full';
    q_AbsC=rgdx('GtoM',q_AbsC);
    q_AbsC=q_AbsC.val;
    %cooling output from the existing Absorbtion chiller
    k_AbsC.name='k_AbsC';
    k_AbsC.form='full';
    k_AbsC=rgdx('GtoM',k_AbsC);
    k_AbsC=k_AbsC.val;
    %Capacity of a nwe Absorbtion chiller
    AbsCInv_cap.name='AbsCInv_cap';    
    AbsCInv_cap=rgdx('GtoM',AbsCInv_cap);
    AbsCInv_cap=AbsCInv_cap.val;
    %Investment cost of the nwe Absorbtion chiller
    invCost_AbsCInv.name='invCost_AbsCInv';    
    invCost_AbsCInv=rgdx('GtoM',invCost_AbsCInv);
    invCost_AbsCInv=invCost_AbsCInv.val;
    %heating input to the new Absorbtion chiller
    q_AbsCInv.name='q_AbsCInv';
    q_AbsCInv.form='full';
    q_AbsCInv=rgdx('GtoM',q_AbsCInv);
    q_AbsCInv=q_AbsCInv.val;
    %cooling output from the new Absorbtion chiller
    k_AbsCInv.name='k_AbsCInv';
    k_AbsCInv.form='full';
    k_AbsCInv=rgdx('GtoM',k_AbsCInv);
    k_AbsCInv=k_AbsCInv.val;
    %% Get results from refrigerating machines
    
    %Elecricity demand by the refrigerator system in AH building
    e_RM.name='e_RM';
    e_RM.form='full';
    e_RM=rgdx('GtoM',e_RM);
    e_RM=e_RM.val;
    %Cooling generated by the refrigerator system in AH building
    k_RM.name='k_RM';
    k_RM.form='full';
    k_RM=rgdx('GtoM',k_RM);
    k_RM=k_RM.val;
    %Binary decission variable to invest in the MMC connection (is 1 if invested, 0 otherwise)
    RMMC_inv.name='RMMC_inv';    
    RMMC_inv=rgdx('GtoM',RMMC_inv);
    RMMC_inv=RMMC_inv.val;
    %investment cost in the MMC connection
    invCost_RMMC.name='invCost_RMMC';    
    invCost_RMMC=rgdx('GtoM',invCost_RMMC);
    invCost_RMMC=invCost_RMMC.val;
    %Elecricity demand by the refrigerator system in nonAH building
    e_RMMC.name='e_RMMC';
    e_RMMC.form='full';
    e_RMMC=rgdx('GtoM',e_RMMC);
    e_RMMC=e_RMMC.val;
    %Cooling generated by the refrigerator system in nonAH building
    k_RMMC.name='k_RMMC';
    k_RMMC.form='full';
    k_RMMC=rgdx('GtoM',k_RMMC);
    k_RMMC=k_RMMC.val;
    %% Get results from Ambient Air Cooler (AAC)
    
    %Elecricity demand by the AAC
    e_AAC.name='e_AAC';
    e_AAC.form='full';
    e_AAC=rgdx('GtoM',e_AAC);
    e_AAC=e_AAC.val;
    %Cooling generated by the AAC
    k_AAC.name='k_AAC';
    k_AAC.form='full';
    k_AAC=rgdx('GtoM',k_AAC);
    k_AAC=k_AAC.val;
    %% Get results from the new reversible heat pump
    
    %Capacity of a nwe HP
    HP_cap.name='HP_cap';    
    HP_cap=rgdx('GtoM',HP_cap);
    HP_cap=HP_cap.val;
    %Investment cost of the nwe HP
    invCost_HP.name='invCost_HP';    
    invCost_HP=rgdx('GtoM',invCost_HP);
    invCost_HP=invCost_HP.val;
    %heating output from the new HP
    q_HP.name='q_HP';
    q_HP.form='full';
    q_HP=rgdx('GtoM',q_HP);
    q_HP=q_HP.val;
     %cooling output from the new HP
    c_HP.name='c_HP';
    c_HP.form='full';
    c_HP=rgdx('GtoM',c_HP);
    c_HP=c_HP.val;
    %electricty input to the new HP
    e_HP.name='e_HP';
    e_HP.form='full';
    e_HP=rgdx('GtoM',e_HP);
    e_HP=e_HP.val;
    %% Get results from the new TES
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    TES_inv.name='TES_inv';    
    TES_inv=rgdx('GtoM',TES_inv);
    TES_inv=TES_inv.val;
    %TES capacity
    TES_cap.name='TES_cap';    
    TES_cap=rgdx('GtoM',TES_cap);
    TES_cap=TES_cap.val;
    %investment cost in the TES
    invCost_TES.name='invCost_TES';    
    invCost_TES=rgdx('GtoM',invCost_TES);
    invCost_TES=invCost_TES.val;
    %TES charging
    TES_ch.name='TES_ch';
    TES_ch.form='full';
    TES_ch=rgdx('GtoM',TES_ch);
    TES_ch=TES_ch.val;
    %TES discharging
    TES_dis.name='TES_dis';
    TES_dis.form='full';
    TES_dis=rgdx('GtoM',TES_dis);
    TES_dis=TES_dis.val;
    %TES energy stored
    TES_en.name='TES_en';
    TES_en.form='full';
    TES_en=rgdx('GtoM',TES_en);
    TES_en=TES_en.val;
    %% Get results from building inertia thermal energy storage (BITES)
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    B_BITES.name='B_BITES'; 
    B_BITES.form='full';
    B_BITES=rgdx('GtoM',B_BITES);
    B_BITES=B_BITES.val;    
    %investment cost in the TES
    invCost_BITES.name='invCost_BITES';    
    invCost_BITES=rgdx('GtoM',invCost_BITES);
    invCost_BITES=invCost_BITES.val;
    %BITES charging (Shallow)
    BTES_Sch.name='BTES_Sch';
    BTES_Sch.form='full';
    BTES_Sch=rgdx('GtoM',BTES_Sch);
    BTES_Sch=BTES_Sch.val;
    %BITES discharging (Sahllow)
    BTES_Sdis.name='BTES_Sdis';
    BTES_Sdis.form='full';
    BTES_Sdis=rgdx('GtoM',BTES_Sdis);
    BTES_Sdis=BTES_Sdis.val;    
    %BITES energy stored (shallow)
    BTES_Sen.name='BTES_Sen';
    BTES_Sen.form='full';
    BTES_Sen=rgdx('GtoM',BTES_Sen);
    BTES_Sen=BTES_Sen.val;
    %BITES energy stored (Deep)
    BTES_Den.name='BTES_Den';
    BTES_Den.form='full';
    BTES_Den=rgdx('GtoM',BTES_Den);
    BTES_Den=BTES_Den.val;
    %BITES energy loss (shallow)
    BTES_Sloss.name='BTES_Sloss';
    BTES_Sloss.form='full';
    BTES_Sloss=rgdx('GtoM',BTES_Sloss);
    BTES_Sloss=BTES_Sloss.val;
    %BITES energy loss (Deep)
    BTES_Dloss.name='BTES_Dloss';
    BTES_Dloss.form='full';
    BTES_Dloss=rgdx('GtoM',BTES_Dloss);
    BTES_Dloss=BTES_Dloss.val;
    %BITES energy flow between Deep ad shallow
    link_BS_BD.name='link_BS_BD';
    link_BS_BD.form='full';
    link_BS_BD=rgdx('GtoM',link_BS_BD);
    link_BS_BD=link_BS_BD.val;
    %% Get results from PV
    
    %PV capacity
    PV_cap_temp.name='PV_cap_temp';    
    PV_cap_temp=rgdx('GtoM',PV_cap_temp);
    PV_cap_temp=PV_cap_temp.val;
    %investment cost in the PV
    invCost_PV.name='invCost_PV';    
    invCost_PV=rgdx('GtoM',invCost_PV);
    invCost_PV=invCost_PV.val;
    %Electricty from PV
    e_PV.name='e_PV';
    e_PV.form='full';
    e_PV=rgdx('GtoM',e_PV);
    e_PV=e_PV.val;
    %% Get results from battery energy storage
    
    %BES capacity
    BES_cap.name='BES_cap';    
    BES_cap=rgdx('GtoM',BES_cap);
    BES_cap=BES_cap.val;
    %investment cost in the BES
    invCost_BEV.name='invCost_BEV';    
    invCost_BEV=rgdx('GtoM',invCost_BEV);
    invCost_BEV=invCost_BEV.val;
    %BES charging
    BES_ch.name='BES_ch';
    BES_ch.form='full';
    BES_ch=rgdx('GtoM',BES_ch);
    BES_ch=BES_ch.val;
    %BES discharging
    BES_dis.name='BES_dis';
    BES_dis.form='full';
    BES_dis=rgdx('GtoM',BES_dis);
    BES_dis=BES_dis.val;
    %BES energy stored
    BES_en.name='BES_en';
    BES_en.form='full';
    BES_en=rgdx('GtoM',BES_en);
    BES_en=BES_en.val;
    %% Get simulated PE use and CO2 emission
    
    %Total PE use in the new FED system
    FED_PE.name='FED_PE';    
    FED_PE=rgdx('GtoM',FED_PE);
    FED_PE=FED_PE.val;
    %Time series PE use in the new FED system
    FED_PE_ft.name='FED_PE_ft';
    FED_PE_ft.form='full';
    FED_PE_ft=rgdx('GtoM',FED_PE_ft);
    FED_PE_ft=FED_PE_ft.val;
    %Time series CO2 emission in the new FED system
    FED_CO2.name='FED_CO2';
    FED_CO2.form='full';
    FED_CO2=rgdx('GtoM',FED_CO2);
    FED_CO2=FED_CO2.val;
    %% Get electricty and heat import
    
    %Electricty import to the new FED system
    e_exG.name='e_exG';
    e_exG.form='full';
    e_exG=rgdx('GtoM',e_exG);
    e_exG=e_exG.val;
    %Heat import to the new FED system
    q_DH.name='q_DH';
    q_DH.form='full';
    q_DH=rgdx('GtoM',q_DH);
    q_DH=q_DH.val;
    break;
end



% %Get electrical o/p of the CHP
% e_CHP.name='e_CHP';
% e_CHP.form='full';
% e_CHP=rgdx('GtoM',e_CHP);
% e_CHP=e_CHP.val;
% 
% %Get heating o/p of the CHP
% q_CHP.name='q_CHP';
% q_CHP.form='full';
% q_CHP=rgdx('GtoM',q_CHP);
% q_CHP=q_CHP.val;

%FED PE
FED_PE_gams.name='FED_PE_ft';
FED_PE_gams.form='full';
FED_PE_gams=rgdx('GtoM',FED_PE_gams);
FED_PE_gams=FED_PE_gams.val;

%FED PE
FED_CO2_gams.name='FED_CO2';
FED_CO2_gams.form='full';
FED_CO2_gams=rgdx('GtoM',FED_CO2_gams);
FED_CO2_gams=FED_CO2_gams.val;


%Energy in the shallow storage
BITES_Sen.name='BTES_Sen';
BITES_Sen.form='full';
BITES_Sen=rgdx('GtoM',BITES_Sen);
BITES_Sen=BITES_Sen.val;

%Energy in the deep storage
BITES_Den.name='BTES_Den';
BITES_Den.form='full';
BITES_Den=rgdx('GtoM',BITES_Den);
BITES_Den=BITES_Den.val;

%use the 'plot_results.m' script to plot desired results
%%

clc;
clear; 
close all;
%% Calculate PE and CO2 of the external grids and the FED system in the base case

%CO2 and PE facrors of local generation unists
CO2F_PV=45;
PEF_PV=1.25;

CO2F_P1=12;
PEF_P1=1.33;

CO2F_P2=12;
PEF_P2=1.33;

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH
tb_eff=0.9;          %assumed efficiency of the boiler, can be modified
fgc_eff=0.4;         %assumed efficiency of the fuel gas condencer, can be modified

%calculate new values
SAVE_data=1;
NEW_data=0;

while NEW_data==1
    get_CO2PE_FED;   %this routine calculates the CO2 and PE factors of the external grid also
    FED_PE_base=sum(FED_PE0);
    FED_CO2Peak_base=max(FED_CO20);
    if SAVE_data==1
       save('FED_PE0','FED_PE0')
       save('FED_CO20','FED_CO20')
       save('FED_PE_base','FED_PE_base')
       save('FED_CO2Peak_base','FED_CO2Peak_base');
       save('el_exGCO2F','el_exGCO2F');
       save('el_exGPEF','el_exGPEF');
       save('DH_CO2F','DH_CO2F');
       save('DH_PEF','DH_PEF');
       save('tb_heat_2016','tb_heat_2016');
       save('fgc_heat_2016','fgc_heat_2016');
       save('fuel_P1','fuel_P1');
    end
    break;
end

%load saved values
while NEW_data==0
    load FED_PE0;
    load FED_CO20;
    load FED_PE_base;
    load FED_CO2Peak_base;
    load el_exGCO2F;
    load el_exGPEF;
    load DH_CO2F;
    load DH_PEF;
    load tb_heat_2016;
    load fgc_heat_2016;
    load fuel_P1;
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

pCO2ref=0.95; %Choose the percentage the reference CO2 [this value can be varied for sensetivity analysis]
FED_CO2ref = struct('name','CO2_ref','type','parameter','form','full','val',pCO2ref*FED_CO2Peak_base);
FED_inv=76761000;  %this is projected FED investment cost in SEK
fInv_lim=1;        %multiplication factor [can be varied for sensetivity analysis]
FED_Inv_lim = struct('name','inv_lim','type','parameter','form','full','val',fInv_lim*FED_inv);

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
Q_P1_TB = struct('name','q_P1_TB0','type','parameter','form','full','val',tb_heat_2016);
Q_P1_TB.uels=H.uels;
Q_P1_FGC = struct('name','q_P1_FGC0','type','parameter','form','full','val',fgc_heat_2016);
Q_P1_FGC.uels=H.uels;
FUEL_P1 = struct('name','fuel_P1','type','parameter','form','full','val',fuel_P1);
FUEL_P1.uels=H.uels;
%% GAMS Model input

%optimization option
option1=1; %minimize total cost
option2=0; %minimize investment cost
option3=0; %minimize total CO2 emission
temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_invCost','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);

wgdx('MtoG.gdx', FED_PE_0, FED_CO2Peak_0,CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,...
     Q_P1_TB, Q_P1_FGC, FUEL_P1,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     temp_optn1, temp_optn2, temp_optn3, FED_CO2ref, FED_Inv_lim);
%% RUN GAMS model

 RUN_GAMS_MODEL=1;
 while RUN_GAMS_MODEL==1
     system 'gams FED_SIMULATOR_MAIN lo=3';
     break;
 end
%% Get output results

GET_RESULTS=1;
while GET_RESULTS==1
    %% Get results from VKA1
    
    tic
    
    gdxData='GtoM_mintotCost';
    temp=struct('name','B_BITES');
    temp=rgdx(gdxData,temp);
    temp=temp.uels;
    temp=temp{1:1};
    tuels=temp(1:8760);
    buels=temp(8760:end);
    
    %heating output from VKA1
    H_VKA1=struct('name','H_VKA1','form','full');
    H_VKA1.uels=tuels;
    H_VKA1=rgdx(gdxData,H_VKA1);
    H_VKA1=H_VKA1.val;    
    %cooling output from VKA1
    C_VKA1=struct('name','C_VKA1','form','full');
    C_VKA1.uels=tuels;
    C_VKA1=rgdx(gdxData,C_VKA1);
    C_VKA1=C_VKA1.val;
    %electricty input to VKA1
    el_VKA1=struct('name','el_VKA1','form','full');
    el_VKA1.uels=tuels;
    el_VKA1=rgdx('GtoM',el_VKA1);
    el_VKA1=el_VKA1.val;
    %% Get results from VKA4
    
    %heating output from VKA4
    H_VKA4=struct('name','H_VKA4','form','full');
    H_VKA4.uels=tuels;
    H_VKA4=rgdx('GtoM',H_VKA4);
    H_VKA4=H_VKA4.val;
    %cooling output from VKA4
    C_VKA4=struct('name','C_VKA4','form','full');
    C_VKA4.uels=tuels;
    C_VKA4=rgdx('GtoM',C_VKA4);
    C_VKA4=C_VKA4.val;
    %electricty input to VKA4
    el_VKA4=struct('name','el_VKA4','form','full');
    el_VKA4.uels=tuels;
    el_VKA4=rgdx('GtoM',el_VKA4);
    el_VKA4=el_VKA4.val;    
    %% Get results from Panna2
    
    %Binary decission variable to invest in P2 (is 1 if invested, 0 otherwise)
    B_P2=struct('name','B_P2');    
    B_P2=rgdx('GtoM',B_P2);
    B_P2=B_P2.val;
    %investment cost in P2
    invCost_P2=struct('name','invCost_P2');    
    invCost_P2=rgdx('GtoM',invCost_P2);
    invCost_P2=invCost_P2.val;
    %Fuel input to P2
    q_P2=struct('name','q_P2','form','full');
    q_P2.uels=tuels;
    q_P2=rgdx('GtoM',q_P2);
    q_P2=q_P2.val;
    %heating output from P2 to DH
    H_P2T=struct('name','H_P2T','form','full');
    H_P2T.uels=tuels;
    H_P2T=rgdx('GtoM',H_P2T);
    H_P2T=H_P2T.val;
    %Binary decission variable to invest in the turbine (is 1 if invested, 0 otherwise)
    B_TURB=struct('name','B_TURB');    
    B_TURB=rgdx('GtoM',B_TURB);
    B_TURB=B_TURB.val;
    %investment cost in the turbine
    invCost_TURB=struct('name','invCost_TURB');    
    invCost_TURB=rgdx('GtoM',invCost_TURB);
    invCost_TURB=invCost_TURB.val;
    %electricty output from the turbine
    e_TURB=struct('name','e_TURB','form','full');
    e_TURB.uels=tuels;
    e_TURB=rgdx('GtoM',e_TURB);
    e_TURB=e_TURB.val;
    %heating input to the turbine
    q_TURB=struct('name','q_TURB','form','full');
    q_TURB.uels=tuels;
    q_TURB=rgdx('GtoM',q_TURB);
    q_TURB=q_TURB.val;    
    %% Get results from Absorbtion Chiller
    
    %heating input to the existing Absorbtion chiller
    q_AbsC=struct('name','q_AbsC','form','full');
    q_AbsC.uels=tuels;
    q_AbsC=rgdx('GtoM',q_AbsC);
    q_AbsC=q_AbsC.val;
    %cooling output from the existing Absorbtion chiller
    k_AbsC=struct('name','k_AbsC','form','full');
    k_AbsC.uels=tuels;
    k_AbsC=rgdx('GtoM',k_AbsC); 
    k_AbsC=k_AbsC.val;
    %Capacity of a nwe Absorbtion chiller
    AbsCInv_cap=struct('name','AbsCInv_cap');    
    AbsCInv_cap=rgdx('GtoM',AbsCInv_cap);
    AbsCInv_cap=AbsCInv_cap.val;
    %Investment cost of the nwe Absorbtion chiller
    invCost_AbsCInv=struct('name','invCost_AbsCInv');    
    invCost_AbsCInv=rgdx('GtoM',invCost_AbsCInv);
    invCost_AbsCInv=invCost_AbsCInv.val;
    %heating input to the new Absorbtion chiller
    q_AbsCInv=struct('name','q_AbsCInv','form','full');
    q_AbsCInv.uels=tuels;
    q_AbsCInv=rgdx('GtoM',q_AbsCInv);
    q_AbsCInv=q_AbsCInv.val;
    %cooling output from the new Absorbtion chiller
    k_AbsCInv=struct('name','k_AbsCInv','form','full');
    k_AbsCInv.uels=tuels;
    k_AbsCInv=rgdx('GtoM',k_AbsCInv);
    k_AbsCInv=k_AbsCInv.val;
    %% Get results from refrigerating machines
    
    %Elecricity demand by the refrigerator system in AH building
    e_RM=struct('name','e_RM','form','full');
    e_RM.uels=tuels;
    e_RM=rgdx('GtoM',e_RM);
    e_RM=e_RM.val;
    %Cooling generated by the refrigerator system in AH building
    k_RM=struct('name','k_RM','form','full');
    k_RM.uels=tuels;
    k_RM=rgdx('GtoM',k_RM);
    k_RM=k_RM.val;
    %Binary decission variable to invest in the MMC connection (is 1 if invested, 0 otherwise)
    RMMC_inv=struct('name','RMMC_inv');    
    RMMC_inv=rgdx('GtoM',RMMC_inv);
    RMMC_inv=RMMC_inv.val;
    %investment cost in the MMC connection
    invCost_RMMC=struct('name','invCost_RMMC');    
    invCost_RMMC=rgdx('GtoM',invCost_RMMC);
    invCost_RMMC=invCost_RMMC.val;
    %Elecricity demand by the refrigerator system in nonAH building
    e_RMMC=struct('name','e_RMMC','form','full');
    e_RMMC.uels=tuels;
    e_RMMC=rgdx('GtoM',e_RMMC);
    e_RMMC=e_RMMC.val;
    %Cooling generated by the refrigerator system in nonAH building
    k_RMMC=struct('name','k_RMMC','form','full');
    k_RMMC.uels=tuels;
    k_RMMC=rgdx('GtoM',k_RMMC);
    k_RMMC=k_RMMC.val;
    %% Get results from Ambient Air Cooler (AAC)
    
    %Elecricity demand by the AAC
    e_AAC=struct('name','e_AAC','form','full');
    e_AAC.uels=tuels;
    e_AAC=rgdx('GtoM',e_AAC);
    e_AAC=e_AAC.val;
    %Cooling generated by the AAC
    k_AAC=struct('name','k_AAC','form','full');
    k_AAC.uels=tuels;
    k_AAC=rgdx('GtoM',k_AAC);
    k_AAC=k_AAC.val;
    %% Get results from the new reversible heat pump
    
    %Capacity of a nwe HP
    HP_cap=struct('name','HP_cap');
    HP_cap=rgdx('GtoM',HP_cap);
    HP_cap=HP_cap.val;
    %Investment cost of the nwe HP
    invCost_HP=struct('name','invCost_HP','form','full');    
    invCost_HP=rgdx('GtoM',invCost_HP);
    invCost_HP=invCost_HP.val;
    %heating output from the new HP
    q_HP=struct('name','q_HP','form','full');
    q_HP.uels=tuels;
    q_HP=rgdx('GtoM',q_HP);
    q_HP=q_HP.val(1:8760);
     %cooling output from the new HP
    c_HP=struct('name','c_HP','form','full');
    c_HP.uels=tuels;
    c_HP=rgdx('GtoM',c_HP);
    c_HP=c_HP.val(1:8760);
    %electricty input to the new HP
    e_HP=struct('name','e_HP','form','full');
    e_HP.uels=tuels;
    e_HP=rgdx('GtoM',e_HP);
    e_HP=e_HP.val(1:8760);
    %% Get results from the new TES
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    TES_inv=struct('name','TES_inv');    
    TES_inv=rgdx('GtoM',TES_inv);
    TES_inv=TES_inv.val;
    %TES capacity
    TES_cap=struct('name','TES_cap');    
    TES_cap=rgdx('GtoM',TES_cap);
    TES_cap=TES_cap.val;
    %investment cost in the TES
    invCost_TES=struct('name','invCost_TES');    
    invCost_TES=rgdx('GtoM',invCost_TES);
    invCost_TES=invCost_TES.val;
    %TES charging
    TES_ch=struct('name','TES_ch','form','full');
    TES_ch.uels=tuels;
    TES_ch=rgdx('GtoM',TES_ch);
    TES_ch=TES_ch.val;
    %TES discharging
    TES_dis=struct('name','TES_dis','form','full');
    TES_dis.uels=tuels;
    TES_dis=rgdx('GtoM',TES_dis);
    TES_dis=TES_dis.val;
    %TES energy stored
    TES_en=struct('name','TES_en','form','full');
    TES_en.uels=tuels;
    TES_en=rgdx('GtoM',TES_en);
    TES_en=TES_en.val;
    %% Get results from building inertia thermal energy storage (BITES)
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    B_BITES=struct('name','B_BITES','form','full'); 
    B_BITES.uels=buels;
    B_BITES=rgdx('GtoM',B_BITES);    
    B_BITES=B_BITES.val;    
    %investment cost in the TES
    invCost_BITES=struct('name','invCost_BITES','form','full');    
    invCost_BITES=rgdx('GtoM',invCost_BITES);
    invCost_BITES=invCost_BITES.val;
    %BITES charging (Shallow)
    BTES_Sch=struct('name','BTES_Sch','form','full');
    BTES_Sch.uels={tuels,buels};
    BTES_Sch=rgdx('GtoM',BTES_Sch);
    BTES_Sch=BTES_Sch.val;
    %BITES discharging (Sahllow)
    BTES_Sdis=struct('name','BTES_Sdis','form','full');
    BTES_Sdis.uels={tuels,buels};
    BTES_Sdis=rgdx('GtoM',BTES_Sdis);
    BTES_Sdis=BTES_Sdis.val;    
    %BITES energy stored (shallow)
    BTES_Sen=struct('name','BTES_Sen','form','full');
    BTES_Sen.uels={tuels,buels};
    BTES_Sen=rgdx('GtoM',BTES_Sen);
    BTES_Sen=BTES_Sen.val;
    %BITES energy stored (Deep)
    BTES_Den=struct('name','BTES_Den','form','full');
    BTES_Sen.uels={tuels,buels};
    BTES_Den=rgdx('GtoM',BTES_Den);
    BTES_Den=BTES_Den.val;
    %BITES energy loss (shallow)
    BTES_Sloss=struct('name','BTES_Sloss','form','full');
    BTES_Sloss.uels={tuels,buels};
    BTES_Sloss=rgdx('GtoM',BTES_Sloss);
    BTES_Sloss=BTES_Sloss.val;
    %BITES energy loss (Deep)
    BTES_Dloss=struct('name','BTES_Dloss','form','full');
    BTES_Dloss.uels={tuels,buels};
    BTES_Dloss=rgdx('GtoM',BTES_Dloss);
    BTES_Dloss=BTES_Dloss.val;
    %BITES energy flow between Deep ad shallow
    link_BS_BD=struct('name','link_BS_BD','form','full');
    link_BS_BD.uels={tuels,buels};
    link_BS_BD=rgdx('GtoM',link_BS_BD);
    link_BS_BD=link_BS_BD.val;
    %% Get results from PV
    
    %PV capacity-roof
    PV_cap_roof=struct('name','PV_cap_roof','form','full');
    PV_cap_roof.uels=num2cell(1:70);
    PV_cap_roof=rgdx('GtoM',PV_cap_roof);
    PV_cap_roof=PV_cap_roof.val;
    %PV capacity-facade
    PV_cap_facade=struct('name','PV_cap_facade','form','full');  
    PV_cap_facade.uels=num2cell(1:70);
    PV_cap_facade=rgdx('GtoM',PV_cap_facade);
    PV_cap_facade=PV_cap_facade.val;
    %investment cost in the PV
    invCost_PV=struct('name','invCost_PV');    
    invCost_PV=rgdx('GtoM',invCost_PV);
    invCost_PV=invCost_PV.val;
    %Electricty from PV
    e_PV=struct('name','e_PV','form','full');
    e_PV.uels=tuels;
    e_PV=rgdx('GtoM',e_PV);
    e_PV=e_PV.val;
    %% Get results from battery energy storage
    
    %BES capacity
    BES_cap=struct('name','BES_cap');     
    BES_cap=rgdx('GtoM',BES_cap);
    BES_cap=BES_cap.val;
    %investment cost in the BES
    invCost_BEV=struct('name','invCost_BEV');    
    invCost_BEV=rgdx('GtoM',invCost_BEV);
    invCost_BEV=invCost_BEV.val;
    %BES charging
    BES_ch=struct('name','BES_ch','form','full');
    BES_ch.uels=tuels;
    BES_ch=rgdx('GtoM',BES_ch);
    BES_ch=BES_ch.val;
    %BES discharging
    BES_dis=struct('name','BES_dis','form','full');
    BES_dis.uels=tuels;
    BES_dis=rgdx('GtoM',BES_dis);
    BES_dis=BES_dis.val;
    %BES energy stored
    BES_en=struct('name','BES_en','form','full');
    BES_en.uels=tuels;
    BES_en=rgdx('GtoM',BES_en);
    BES_en=BES_en.val;
    %% Get simulated PE use and CO2 emission
    
    %Total PE use in the new FED system
    FED_PE=struct('name','FED_PE','form','full');    
    FED_PE=rgdx('GtoM',FED_PE);
    FED_PE=FED_PE.val;
    %Time series PE use in the new FED system
    FED_PE_ft=struct('name','FED_PE_ft','form','full');
    FED_PE_ft=rgdx('GtoM',FED_PE_ft);
    FED_PE_ft=FED_PE_ft.val';
    %Time series CO2 emission in the new FED system
    FED_CO2=struct('name','FED_CO2','form','full');
    FED_CO2=rgdx('GtoM',FED_CO2);
    FED_CO2=FED_CO2.val';
    %% Get electricty and heat import
    
    %Electricty import to the new FED system
    e_exG=struct('name','e_exG','form','full');
    e_exG=rgdx('GtoM',e_exG);
    e_exG=e_exG.val;
    %Heat import to the new FED system
    q_DH=struct('name','q_DH','form','full');
    q_DH=rgdx('GtoM',q_DH);
    q_DH=q_DH.val;
    toc
    %% Display results
    
    DISP_RESULTS=1;
    while DISP_RESULTS==1
        clc;
        close all;
        % intialize plot properties
        properties=finit_plot_properties;   %initialise plot properties
        properties.legendFontsize = 1;
        properties.labelFontsize = 1;
        properties.axelFontsize = 20;
        Font_Size=properties.axelFontsize;
        lgnd_size=1;
        LineWidth=1;
        LineThickness=2;        
        %% PLot FED primary energy with and without investment
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=FED_PE0(1:8760)/1000;
        ydata2=FED_PE_ft(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE use [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('Base case','With new investment')
        
        %percentage change in PE
        display('Percentage change in total FED PE use (New/Base)');
        FED_pPE=FED_PE/sum(FED_PE0)*100
        %% PLot FED primary energy with and without investment
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=FED_CO20(1:8760)/1000;
        ydata2=FED_CO2(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('Base case','With new investment')
        return;
        %% 
%         fprintf('====================OPtimum Investment Options====================\n')
%         fprintf('Investment in Panna2 = %d MSEK, Investment in the turbine = %d MSEK\n', invCost_P2/10^6, invCost_TURB/10^6)
%         fprintf('Investment in New Absorbtion chiller \n Capacity = %d kW, Investment cost = %d MSEK\n', AbsCInv_cap, invCost_AbsCInv/10^6)
%         fprintf('Investment in RMMC = %d MSEK \n', invCost_RMMC/10^6)
%         fprintf('Investment in New Heat Pump \n Capacity = %d kW, Investment cost = %d MSEK \n',HP_cap, invCost_HP/10^6)
%         fprintf('Investment in Termal Energy Storage \n TES Capacity = %d m^3, TES Investment cost = %d MSEK \n',TES_cap, invCost_TES/10^6)
%         fprintf('Investment in Building INertia Termal Energy Storage \n Feasible Buildings = %d , BITES Investment cost = %d MSEK \n',0, invCost_BITES/10^6)
%         fprintf('Investment in New Solar PV \n Roof Capacity = %d kW, Facade Capacity = %d kW, Investment cost = %d MSEK \n',PV_cap_roof,PV_cap_facade, invCost_PV/10^6)
%         fprintf('Investment in Batery Energy Storage  \n Capacity = %d kW, Investment cost = %d MSEK \n',BES_cap, invCost_BEV/10^6)
%         fprintf('Total investment cost  = %d MSEK \n', invCost/10^6)
    end
    
    return;
end
%use the 'plot_results.m' script to plot desired results
%%
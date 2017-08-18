clc;
close all;
%% Here, results are processed and ploted, displayed and saved when needed

%% Read set GDXes
h.name = 'h';
h.form = 'full';
h = rgdx (h.name, h);

BID.name = 'BID';
BID.form = 'full';
BID = rgdx (BID.name, BID);

i_All.name = 'i';
i_All.form = 'full';
i_All = rgdx (i_All.name, i_All);

i_AH.name = 'i_AH';
i_AH.form = 'full';
i_AH = rgdx (i_AH.name, i_AH);

i_nonAH.name = 'i_nonAH';
i_nonAH.form = 'full';
i_nonAH = rgdx (i_nonAH.name, i_nonAH);

i_nonBITES.name = 'i_nonBITES';
i_nonBITES.form = 'full';
i_nonBITES = rgdx (i_nonBITES.name, i_nonBITES);

m.name = 'm';
m.form = 'full';
m = rgdx (m.name, m);

d.name = 'd';
d.form = 'full';
d = rgdx (d.name, d);

sup_unit.name = 'sup_unit';
sup_unit.form = 'full';
sup_unit = rgdx (sup_unit.name, sup_unit);

inv_opt.name = 'inv_opt';
inv_opt.form = 'full';
inv_opt = rgdx (inv_opt.name, inv_opt);

coefs.name = 'coefs';
coefs.form = 'full';
coefs = rgdx (coefs.name, coefs);

BTES_properties.name = 'BTES_properties';
BTES_properties.form = 'full';
BTES_properties = rgdx (BTES_properties.name, BTES_properties);

%% Get output results

PORCESS_RESULTS=1;
while PORCESS_RESULTS==1    
    %% Set results in a gdx file for a given scenario/option    
    
    %marginalCostElWeightedAve.name = 'mc_el_weighted_avg';
    %marginalCostElWeightedAve.form = 'full';
    %marginalCostElWeightedAve.uels = {regionsInSimulation.uels{1,1}, years.uels{1,1}};
    %marginalCostElWeightedAve = rgdx(inputFilename, marginalCostElWeightedAve);

    gdxData='GtoM';
    PROCESS_DATA=1;
    % el demand
    el_demand0.name = 'el_demand0'
    el_demand0.form = 'full'
    el_demand0.uels = {i_All.uels{1,1}, h.uels{1,1}}
    el_demand0 = rgdx(gdxData, el_demand0);    
    
    while PROCESS_DATA==1
    
    %% Get results from VKA1
    
    %heating output from VKA1
    H_VKA1.name = 'H_VKA1'
    H_VKA1.form = 'full'
    H_VKA1.field = 'l'
    H_VKA1.uels ={h.uels{1,1}}
    H_VKA1 = rgdx(gdxData, H_VKA1)

    %cooling output from VKA1
    C_VKA1.name = 'C_VKA1'
    C_VKA1.form = 'full'
    C_VKA1.field = 'l'
    C_VKA1.uels ={h.uels{1,1}}
    C_VKA1 = rgdx(gdxData, C_VKA1)

    %electricty input to VKA1
    el_VKA1.name = 'el_VKA1'
    el_VKA1.form = 'full'
    el_VKA1.field = 'l'
    el_VKA1.uels ={h.uels{1,1}}
    el_VKA1 = rgdx(gdxData, el_VKA1)
    
    %% Get results from Panna2
    %Binary decission variable to invest in P2 (is 1 if invested, 0 otherwise)
    B_P2.name = 'B_P2'
    B_P2.form = 'full'
    B_P2.field = 'l'
    B_P2.uels = {}
    B_P2 = rgdx(gdxData, B_P2)
    %investment cost in P2
    invCost_P2.name = 'invCost_P2'
    invCost_P2.form = 'full'
    invCost_P2.uels = {}
    invCost_P2 = rgdx(gdxData, invCost_P2)

    %Fuel input to P2
    q_P2.name = 'q_P2'
    q_P2.form = 'full'
    q_P2.field = 'l'
    q_P2.uels = {h.uels{1,1}}
    q_P2 = rgdx(gdxData, q_P2)

    %heating output from P2 to DH
    H_P2T.name = 'H_P2T'
    H_P2T.form = 'full'
    H_P2T.field = 'l'
    H_P2T.uels = {h.uels{1,1}}
    H_P2T = rgdx(gdxData, H_P2T)
    %Binary decission variable to invest in the turbine (is 1 if invested, 0 otherwise)
    B_TURB.name = 'B_TURB'
    B_TURB.form = 'full'
    B_TURB.field = 'l'
    B_TURB.uels = {}
    B_TURB = rgdx(gdxData, B_TURB)
    %investment cost in the turbine
    invCost_TURB.name = 'invCost_TURB'
    invCost_TURB.form = 'full'
    invCost_TURB.uels = {}
    invCost_TURB = rgdx(gdxData, invCost_TURB)
    %electricty output from the turbine
    e_TURB.name = 'e_TURB'
    e_TURB.form = 'full'
    e_TURB.field = 'l'
    e_TURB.uels = {h.uels{1,1}}
    e_TURB = rgdx(gdxData, e_TURB)
    %heating input to the turbine
    q_TURB.name = 'q_TURB'
    q_TURB.form = 'full'
    q_TURB.field = 'l'
    q_TURB.uels = {h.uels{1,1}}
    q_TURB = rgdx(gdxData, q_TURB)
    %% Get results from Absorbtion Chiller
    
    %heating input to the existing Absorbtion chiller
    q_AbsC.name = 'q_AbsC'
    q_AbsC.form = 'full'
    q_AbsC.field = 'l'
    q_AbsC.uels = {h.uels{1,1}}
    q_AbsC = rgdx(gdxData, q_AbsC)
    %cooling output from the existing Absorbtion chiller
    k_AbsC.name = 'k_AbsC'
    k_AbsC.form = 'full'
    k_AbsC.field = 'l'
    k_AbsC.uels = {h.uels{1,1}}
    k_AbsC = rgdx(gdxData, k_AbsC)
    %Capacity of a new Absorbtion chiller
    AbsCInv_cap.name = 'AbsCInv_cap'
    AbsCInv_cap.form = 'full'
    AbsCInv_cap.field = 'l'
    AbsCInv_cap.uels = {}
    AbsCInv_cap = rgdx(gdxData, AbsCInv_cap)
    %Investment cost of the nwe Absorbtion chiller
    invCost_AbsCInv.name = 'invCost_AbsCInv'
    invCost_AbsCInv.form = 'full'
    invCost_AbsCInv.uels = {}
    invCost_AbsCInv = rgdx(gdxData, invCost_AbsCInv)
    %heating input to the new Absorbtion chiller
    q_AbsCInv=struct('name','q_AbsCInv','form','full');    
    q_AbsCInv=rgdx(gdxData,q_AbsCInv);
    q_AbsCInv=q_AbsCInv.val;
    q_AbsCInv=q_AbsCInv(1:8760);
    %cooling output from the new Absorbtion chiller
    k_AbsCInv.name = 'k_AbsCInv'
    k_AbsCInv.form = 'full'
    k_AbsCInv.field = 'l'
    k_AbsCInv.uels = {h.uels{1,1}}
    k_AbsCInv = rgdx(gdxData, k_AbsCInv)
    %% Get results from refrigerating machines
    
    %Elecricity demand by the refrigerator system in AH building
    e_RM.name = 'e_RM'
    e_RM.form = 'full'
    e_RM.field = 'l'
    e_RM.uels = {h.uels{1,1}}
    e_RM = rgdx(gdxData, e_RM)
    %Cooling generated by the refrigerator system in AH building
    k_RM.name = 'k_RM'
    k_RM.form = 'full'
    k_RM.field = 'l'
    k_RM.uels = {h.uels{1,1}}
    k_RM = rgdx(gdxData, k_RM)
    %Binary decission variable to invest in the MMC connection (is 1 if invested, 0 otherwise)
    RMMC_inv.name = 'RMMC_inv'
    RMMC_inv.form = 'full'
    RMMC_inv.field = 'l'
    RMMC_inv.uels = {}
    RMMC_inv = rgdx(gdxData, RMMC_inv)    
    %investment cost in the MMC connection
    invCost_RMMC.name = 'invCost_RMMC'
    invCost_RMMC.form = 'full'
    invCost_RMMC.uels = {}
    invCost_RMMC = rgdx(gdxData, invCost_RMMC)
    %Elecricity demand by the refrigerator system in nonAH building
    e_RMMC.name = 'e_RMMC'
    e_RMMC.form = 'full'
    e_RMMC.field = 'l'
    e_RMMC.uels = {h.uels{1,1}}
    e_RMMC = rgdx(gdxData, e_RMMC)
    %Cooling generated by the refrigerator system in nonAH building
    k_RMMC.name = 'k_RMMC'
    k_RMMC.form = 'full'
    k_RMMC.field = 'l'
    k_RMMC.uels = {h.uels{1,1}}
    k_RMMC = rgdx(gdxData, k_RMMC)
    %% Get results from Ambient Air Cooler (AAC)
    
    %Elecricity demand by the AAC
    e_AAC=struct('name','e_AAC','form','full');    
    e_AAC=rgdx(gdxData,e_AAC);
    e_AAC=e_AAC.val;
    e_AAC=e_AAC(1:8760);
    %Cooling generated by the AAC
    k_AAC=struct('name','k_AAC','form','full');    
    k_AAC=rgdx(gdxData,k_AAC);
    k_AAC=k_AAC.val;
    k_AAC=k_AAC(1:8760);
    %% Get results from the new reversible heat pump
    
    %Capacity of a nwe HP
    HP_cap=struct('name','HP_cap');
    HP_cap=rgdx(gdxData,HP_cap);
    HP_cap=HP_cap.val;
    %Investment cost of the nwe HP
    invCost_HP=struct('name','invCost_HP','form','full');    
    invCost_HP=rgdx(gdxData,invCost_HP);
    invCost_HP=invCost_HP.val;
    %heating output from the new HP
    q_HP=struct('name','q_HP','form','full');    
    q_HP=rgdx(gdxData,q_HP);
    q_HP=q_HP.val;
    q_HP=q_HP(1:8760);
    %cooling output from the new HP
    c_HP=struct('name','c_HP','form','full');    
    c_HP=rgdx(gdxData,c_HP);
    c_HP=c_HP.val;
    c_HP=c_HP(1:8760);
    %electricty input to the new HP
    e_HP=struct('name','e_HP','form','full');    
    e_HP=rgdx(gdxData,e_HP);
    e_HP=e_HP.val;
    e_HP=e_HP(1:8760);
    %% Get results from the new TES
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    TES_inv=struct('name','TES_inv');    
    TES_inv=rgdx(gdxData,TES_inv);
    TES_inv=TES_inv.val;
    %TES capacity
    TES_cap=struct('name','TES_cap');    
    TES_cap=rgdx(gdxData,TES_cap);
    TES_cap=TES_cap.val;
    %investment cost in the TES
    invCost_TES=struct('name','invCost_TES');    
    invCost_TES=rgdx(gdxData,invCost_TES);
    invCost_TES=invCost_TES.val;
    %TES charging
    TES_ch=struct('name','TES_ch','form','full');    
    TES_ch=rgdx(gdxData,TES_ch);
    TES_ch=TES_ch.val;
    TES_ch=TES_ch(1:8760);
    %TES discharging
    TES_dis=struct('name','TES_dis','form','full');    
    TES_dis=rgdx(gdxData,TES_dis);
    TES_dis=TES_dis.val;
    TES_dis=TES_dis(1:8760);
    %TES energy stored
    TES_en=struct('name','TES_en','form','full');    
    TES_en=rgdx(gdxData,TES_en);
    TES_en=TES_en.val;
    TES_en=TES_en(1:8760);
    %% Get results from building inertia thermal energy storage (BITES)
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    B_BITES=struct('name','B_BITES','form','full');    
    B_BITES=rgdx(gdxData,B_BITES);    
    B_BITES=B_BITES.val; 
    B_BITES=B_BITES(8761:end);
    %investment cost in the TES
    invCost_BITES=struct('name','invCost_BITES');    
    invCost_BITES=rgdx(gdxData,invCost_BITES);
    invCost_BITES=invCost_BITES.val;
    %BITES charging (Shallow)
    BTES_Sch=struct('name','BTES_Sch','form','full');    
    BTES_Sch=rgdx(gdxData,BTES_Sch);
    BTES_Sch=BTES_Sch.val;
    BTES_Sch=BTES_Sch(1:8760,8761:end);
    %BITES discharging (Sahllow)
    BTES_Sdis=struct('name','BTES_Sdis','form','full');    
    BTES_Sdis=rgdx(gdxData,BTES_Sdis);
    BTES_Sdis=BTES_Sdis.val;
    BTES_Sdis=BTES_Sdis(1:8760,8761:end);
    %BITES energy stored (shallow)
    BTES_Sen=struct('name','BTES_Sen','form','full');    
    BTES_Sen=rgdx(gdxData,BTES_Sen);
    BTES_Sen=BTES_Sen.val;
    BTES_Sen=BTES_Sen(1:8760,8761:end);
    %BITES energy stored (Deep)
    BTES_Den=struct('name','BTES_Den','form','full');    
    BTES_Den=rgdx(gdxData,BTES_Den);
    BTES_Den=BTES_Den.val;
    BTES_Den=BTES_Den(1:8760,8761:end);
    %BITES energy loss (shallow)
    BTES_Sloss=struct('name','BTES_Sloss','form','full');    
    BTES_Sloss=rgdx(gdxData,BTES_Sloss);
    BTES_Sloss=BTES_Sloss.val;
    BTES_Sloss=BTES_Sloss(1:8760,8761:end);
    %BITES energy loss (Deep)
    BTES_Dloss=struct('name','BTES_Dloss','form','full');    
    BTES_Dloss=rgdx(gdxData,BTES_Dloss);
    BTES_Dloss=BTES_Dloss.val;
    BTES_Dloss=BTES_Dloss(1:8760,8761:end);
    %BITES energy flow between Deep ad shallow
    link_BS_BD=struct('name','link_BS_BD','form','full');    
    link_BS_BD=rgdx(gdxData,link_BS_BD);
    link_BS_BD=link_BS_BD.val;
    link_BS_BD=link_BS_BD(1:8760,8761:end);
    %% Get results from PV
    
    %PV capacity-roof
    PV_cap_roof=struct('name','PV_cap_roof','form','full');    
    PV_cap_roof=rgdx(gdxData,PV_cap_roof);
    %%
    PV_cap_roof=PV_cap_roof.val(1:72);    
    %PV capacity-facade
    PV_cap_facade=struct('name','PV_cap_facade','form','full');    
    PV_cap_facade=rgdx(gdxData,PV_cap_facade);
    PV_cap_facade=PV_cap_facade.val(1:72); 
    %investment cost in the PV
    invCost_PV=struct('name','invCost_PV');    
    invCost_PV=rgdx(gdxData,invCost_PV);
    invCost_PV=invCost_PV.val;
    %Electricty from PV
    e_PV=struct('name','e_PV','form','full');    
    e_PV=rgdx(gdxData,e_PV);
    e_PV=e_PV.val(1:8760);   
    
    %% Get results from battery energy storage
    
    %BES capacity
    BES_cap=struct('name','BES_cap');     
    BES_cap=rgdx(gdxData,BES_cap);
    BES_cap=BES_cap.val;
    %investment cost in the BES
    invCost_BES=struct('name','invCost_BEV');    
    invCost_BES=rgdx(gdxData,invCost_BES);
    invCost_BES=invCost_BES.val;
    %BES charging
    BES_ch=struct('name','BES_ch','form','full');    
    BES_ch=rgdx(gdxData,BES_ch);
    BES_ch=BES_ch.val(1:8760);
    %BES discharging
    BES_dis=struct('name','BES_dis','form','full');    
    BES_dis=rgdx(gdxData,BES_dis);
    BES_dis=BES_dis.val(1:8760);
    %BES energy stored
    BES_en=struct('name','BES_en','form','full');    
    BES_en=rgdx(gdxData,BES_en);
    BES_en=BES_en.val(1:8760);
    %% Get simulated PE use and CO2 emission
    
    %Time series PE use in the new FED system
    FED_PE=struct('name','FED_PE','form','full');
    FED_PE=rgdx(gdxData,FED_PE);
    FED_PE=FED_PE.val(1:8760);
    %Time series CO2 emission in the new FED system
    FED_CO2=struct('name','FED_CO2','form','full');
    FED_CO2=rgdx(gdxData,FED_CO2);
    FED_CO2=FED_CO2.val(1:8760);
    %% Get electricty and heat import
    
    %Electricty import to the new FED system
    e_exG=struct('name','e_exG','form','full');
    e_exG=rgdx(gdxData,e_exG);
    e_exG=e_exG.val(1:8760);
    %Heat import to the new FED system
    q_DH=struct('name','q_DH','form','full');
    q_DH=rgdx(gdxData,q_DH);
    q_DH=q_DH.val(1:8760);
    %% Total investment cost
    
    invCost=struct('name','invCost');    
    invCost=rgdx(gdxData,invCost);
    invCost=invCost.val;
    break;
    end
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
        %% PLot imported electricity 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load el_Import_2016;
        ydata=el_Import_2016(1:8760)/1000;
        ydata2=e_exG(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricty import [MW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('Base case','With new investment')
        %% PLot imported heat 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load heat_Import_2016;
        ydata=heat_Import_2016(1:8760)/1000;
        ydata2=q_DH(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heat import [MW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size) 
        box off
        xlim([0 100])
        legend('Base case','With new investment')
        %% PLot heat sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load q_P1;
        ydata=H_VKA1;
        ydata2=H_VKA4;
        ydata3=q_P1/10;
        ydata4=H_P2T;
        ydata5=q_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heat source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','P1/10','P2','HP')
        %% PLot cooling sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=C_VKA1;
        ydata2=C_VKA4;
        ydata3=k_AbsC;
        ydata4=k_AbsCInv;
        ydata5=k_RM;
        ydata6=k_RMMC;
        ydata7=k_AAC;
        ydata8=c_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'-.',duration,sort(ydata6,'descend'),...
             duration,sort(ydata7,'descend'),'-.',duration,sort(ydata8,'descend'),'LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','AbcC','AbsCInv','RM','RMMC','AAC','HP')
        %% PLot electricty sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=e_TURB/1000;
        ydata2=e_PV/1000;        
        duration= 0 : 100/(length(ydata)-1) : 100;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata5,'descend'),'LineWidth',LineThickness);
        %plot(time,ydata,'LineWidth',LineThickness);
        %area(time,ydata);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricty source [MW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('TURB','Solar PV')        
        %% PLot FED primary energy with and without investment
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load FED_PE0;
        ydata=FED_PE0(1:8760)/1000;
        ydata2=FED_PE(1:8760)/1000;
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
        
        %percentage change in PE use in the FED system
        fprintf('*********REDUCTION IN THE FED PRIMARY ENERGY USE********** \n')
        FED_pPE=(1-sum(FED_PE)/sum(FED_PE0));
        fprintf('Change in total FED PE use (New/Base) = %d \n\n', FED_pPE);
        %% PLot FED CO2 emission with and without investment
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load FED_CO20;
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
        
        %percentage change in peak CO2 emission in the FED system
        fprintf('*********REDUCTION IN THE FED PEAK CO2 EMISSION********** \n')
        FED_pCO2_peak=(1-max(FED_CO2)/max(FED_CO20));
        fprintf('Change in THE FED peak co2 emission (New/Base) = %d \n\n', FED_pCO2_peak);
        %percentage change in total CO2 emission in the FED system
        fprintf('*********REDUCTION IN THE FED TOTAL CO2 EMISSION********** \n')
        FED_pCO2_tot=1-sum(FED_CO2)/sum(FED_CO20);
        fprintf('Change in THE FED total co2 emission (New/Base) = %d \n\n', FED_pCO2_tot);
        %% PLot variation of energy stored in TES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=TES_en/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        LineThickness=4;
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('TES [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %% PLot variation of energy stored in the shallow part of BITES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=BTES_Sen/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        %plot(xdata,ydata,'LineWidth',LineThickness); 
        area(xdata,ydata)
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BITES-Shallow [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])        
        %% PLot variation of energy stored in the deep part of BITES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=BTES_Den/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        %plot(xdata,ydata,'LineWidth',LineThickness); 
        area(xdata,ydata)
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BITES-Deep [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %% PLot BITES investments (feasible buildings for investment)
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=B_BITES;
        %time=(1:length(ydata))/(24*30);
        xdata=1:30;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(xdata,ydata,'X','LineWidth',LineThickness); 
        %bar(xdata,ydata)
        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('Feasibility [1 or 0]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        %set(gca,'YTickLabel',{'0','1'},'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',xdata,...
            'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 30])
        ylim([0 2])
        %% PLot variation of energy stored in the BES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=BES_en/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        plot(xdata,ydata,'LineWidth',LineThickness); 
        %area(xdata,ydata)
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BES [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %% Investment options
        
        fprintf('*********************OPtimum Investment Options********************\n\n')
        fprintf('Investment in Panna2 = %d MSEK, Investment in the turbine = %d MSEK\n', invCost_P2/10^6, invCost_TURB/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in New Absorbtion chiller \n Capacity = %d kW, Investment cost = %d MSEK\n', AbsCInv_cap, invCost_AbsCInv/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('                    Investment in RMMC = %d MSEK \n', invCost_RMMC/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in New Heat Pump \n Capacity = %d kW, Investment cost = %d MSEK \n',HP_cap, invCost_HP/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in Termal Energy Storage \n TES Capacity = %d m^3, TES Investment cost = %d MSEK \n',TES_cap, invCost_TES/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in Building Inertia Termal Energy Storage \n')
        fprintf('Feasible Buildings = ');
        fprintf(' %d',B_BITES(1:30));
        fprintf('\n')
        BITES_cap=struct('name','BTES_model0','form','full');
        BITES_cap=rgdx('UFO_TES',BITES_cap);
        BITES_cap=BITES_cap.val(31:32,1:30);
        BITES_Scap=BITES_cap(1,:);
        BITES_Dcap=BITES_cap(2,:);
        tot_BITES_cap=sum(BITES_Scap.*B_BITES' + BITES_Dcap.*B_BITES');        
        fprintf('Total Building inertia thermal capacity [MW]= %d, BITES Investment cost = %d MSEK \n',tot_BITES_cap, invCost_BITES/10^6)
        fprintf('                    ===========================                     \n\n')
        %Roof Capacity = %d kW, Facade Capacity = %d kW, Investment cost = %d MSEK \n',PV_cap_roof,PV_cap_facade, invCost_PV/10^6
 %%
        fprintf('Investment in New Solar PV \n')
        fprintf('Roof Capacity [kw]= ')
        fprintf(' %d ',PV_cap_roof)
        fprintf('\n')
        fprintf('Total roof capacity %d MW \n',sum(PV_cap_roof)/1000)
        fprintf('Facade Capacity [kw]= ')
        fprintf(' %d ',PV_cap_facade)
        fprintf('\n')
        fprintf('Total facade capacity %d MW \n',sum(PV_cap_facade)/1000)
        fprintf('Total investment cost on solar PV %d MSEK \n',invCost_PV/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in Battery Energy Storage \n BES Capacity = %d kW, BES Investment cost = %d MSEK \n',BES_cap, invCost_BES/10^6)
        fprintf('                    ===========================                     \n\n')
        %% Total investment cost in the FED system
        fprintf('\n\n************************************************************** \n')
        fprintf('************************************************************** \n \n')
        fprintf('    Total investment cost in the FED system = %d MSEK \n',invCost/10^6)
        fprintf('                    ===========================                     \n')
        fprintf('************************************************************** \n')
        fprintf('************************************************************** \n')
        return;
        %% 
    end    
    return;
end
%% Convert the data into daily mean
return
data0=cooling_demand_2016;
rs=24;
len=length(data0)/rs;
[x, y]=size(data0);
data=zeros(len,y);
temp=reshape(data0,rs,[]);
for i=1:y
    temp2=mean(temp(:,((i-1)*len+1):i*len),1);
    data(:,i)=temp2';
end
%%
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

figure('Units','centimeters','PaperUnits','centimeters',...
       'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
       'PaperSize',properties.PaperSize)

ydata=FED_PE/1000;
ydata2=FED_PE_gams/1000;
duration= 0 : 100/(length(ydata)-1) : 100;
time=(1:length(ydata))/(24*30);
xdata=time;
%plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
plot(duration(1:8760),sort(ydata(1:8760),'descend'),'-.r',...
     duration(1:8760),sort(ydata2(1:8760),'descend'),'g','LineWidth',LineThickness);
%plot(time,ydata,'LineWidth',LineThickness);
%area(time,ydata);
xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
%ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
%set(gca,'XTickLabel',{'','Winter', 'Spring', 'Summer', 'Fall'},'FontName','Times New Roman','FontSize',Font_Size)
%legend('xL=100km','xL=200km','xL=300km','xL=400km','xL=500km');
%h=legend('$$\overline{D}$$=3250MW','$$\overline{D}$$=6500MW','$$\overline{D}$$=9750MW','$$\overline{D}$$=13000MW','$$\overline{D}$$=16250MW','$$\overline{D}$$=19500MW');
%set(h,'Interpreter','latex')
%legend('Cap=300MW','Cap=600MW','Cap=900MW','Cap=1200MW','Cap=1500MW');
%h=legend('$$\overline{D}$$=33GW','$$\overline{D}$$=25GW','$$\overline{D}$$=16GW');
%set(h,'Interpreter','latex')
%legend('\Delta\theta=0%','\Delta\theta=25%','\Delta\theta=50%');
%legend('\theta=0.0052','\theta=0.0032','\theta=0.0012')

set(gca,'FontName','Times New Roman','FontSize',Font_Size)
box off
xlim([0 100])
legend('Base case','Improved case')
%legend('ANG HP1 ','ANG HP2','ANG HP3','S�V HP1 + RK1','S�V HP2',...
%        'S�V HP3 (H1) + RK2','ROS HP2','ROS HP3','ROS HP4','ROS HP5',...
%        'ROS LK1 + del i RK1', 'ROS LK2 + del i RK1', 'RYA HP6',...
%        'RYA HP7', 'RYA VP','RYA KVV','TYN HVC','H�G KVV NM1-3','Spillv�rme' )
%ylim([0 3])
%DTyp=['NO'; 'SE'; 'DK'; 'FI'; 'EE'; 'LV'; 'LT'];
%NPVComp={'C1'; 'C2'; 'C3'; 'C4'; 'C5'};
%% save plot
return
folder_name='D:\PhD project\PhD\Report\Thesis\figures\phd_ch05\';
plot_fname=['ME_C2_gen_cor1_D1eqD2'];
fsave_figure(folder_name,plot_fname);


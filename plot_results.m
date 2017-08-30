clc;
close all;
clear all;
%% Here, results are processed and ploted, displayed and saved when needed

%% Get output results
tic
PROCESS_RESULTS=1;
while PROCESS_RESULTS==1    
    %% Set results in a gdx file for a given scenario/option    
    tic
    
    %st desired option
    option='No_investment\fixed_Panna1\minpeakCO2\'; %option can be 'mintotCOst', 'mintotPE', 'mintotCCO2' or 'mintotPECO2'
    path=strcat('Sim_Results\',option);
    file_name='GtoM_minpeakCO2';
    gdxData=strcat(path,file_name);
    %% Assign uels
    
    % uels for hourlly time series
    h=get_uels('Sim_Results\uels\h','h');    
    % uels for all building names as presented by utilifeed
    i=get_uels('Sim_Results\uels\i','i');    
    % uels for all building names as presented by utilifeed
    i_AH=get_uels('Sim_Results\uels\i_AH','i_AH');
    % uels for building for PV application
    BID=get_uels('Sim_Results\uels\BID','BID');
    % uels for BITES properties
    BTES_properties=get_uels('Sim_Results\uels\BTES_properties','BTES_properties');
    % uels for supply units properties
    sup_unit=get_uels('Sim_Results\uels\sup_unit','sup_unit');
    % uels for investment options
    inv_opt=get_uels('Sim_Results\uels\inv_opt','inv_opt');    
    %% Get parameters and variables from a GDX file 
    
    PROCESS_DATA=0;
    while PROCESS_DATA==1
    %% Set the path for the extracted data to be saved in 
    
    path_Data=strcat(path,'Data\');    
    %% Electricty, heating and cooling demand data used as inputs in the simulation     
    
    %electricity demand in the FED system
    el_demand0=gdx2mat(gdxData,'el_demand0',{h,i});
    q_demand0=gdx2mat(gdxData,'q_demand0',{h,i});
    k_demand0=gdx2mat(gdxData,'k_demand0',{h,i});
    k_demand_AH=gdx2mat(gdxData,'k_demand_AH',{h,i_AH});
    save(strcat(path_Data,'el_demand0'),'el_demand0'); 
    save(strcat(path_Data,'q_demand0'),'q_demand0');
    save(strcat(path_Data,'k_demand0'),'k_demand0');
    save(strcat(path_Data,'k_demand_AH'),'k_demand_AH');    
    %% Electricity and heat price and out door temprature
    
    el_price0=gdx2mat(gdxData,'el_price0',h);
    q_price0=gdx2mat(gdxData,'q_price0',h);
    tout0=gdx2mat(gdxData,'tout0',h);
    save(strcat(path_Data,'el_price0'),'el_price0');
    save(strcat(path_Data,'q_price0'),'q_price0');
    save(strcat(path_Data,'tout0'),'tout0');
    %% Area of roofs and walls of buildings in the FED system 
    
    area_facade_max=gdx2mat(gdxData,'area_facade_max',BID);
    area_roof_max=gdx2mat(gdxData,'area_roof_max',BID);
    nPV_el0=gdx2mat(gdxData,'nPV_el0',h);    %electricity from a kW of a PV
    save(strcat(path_Data,'area_facade_max'),'area_facade_max');
    save(strcat(path_Data,'area_roof_max'),'area_roof_max');
    save(strcat(path_Data,'nPV_el0'),'nPV_el0');
    %% FED PE use and CO2 emission base and simulated case
    
    FED_PE0=gdx2mat(gdxData,'FED_PE0',h);
    FED_PE=gdx2mat(gdxData,'FED_PE',h);
    FED_CO20=gdx2mat(gdxData,'FED_CO20',h);
    FED_CO2=gdx2mat(gdxData,'FED_CO2',h);
    save(strcat(path_Data,'FED_PE0'),'FED_PE0');
    save(strcat(path_Data,'FED_PE'),'FED_PE');
    save(strcat(path_Data,'FED_CO20'),'FED_CO20');
    save(strcat(path_Data,'FED_CO2'),'FED_CO2');
    %% PEF use and CO2F of the external grids (electricity and DH)
    
    PEF_exG=gdx2mat(gdxData,'PEF_exG',h);
    CO2F_exG=gdx2mat(gdxData,'CO2F_exG',h);
    PEF_DH=gdx2mat(gdxData,'PEF_DH',h);
    CO2F_DH=gdx2mat(gdxData,'CO2F_DH',h);
    save(strcat(path_Data,'PEF_exG'),'PEF_exG');
    save(strcat(path_Data,'CO2F_exG'),'CO2F_exG');
    save(strcat(path_Data,'PEF_DH'),'PEF_DH');
    save(strcat(path_Data,'CO2F_DH'),'CO2F_DH');
    %% Output from panna 1
    
    q_p1_TB=gdx2mat(gdxData,'q_p1_TB',h);
    q_p1_FGC=gdx2mat(gdxData,'q_p1_FGC',h);
    fuel_P1=gdx2mat(gdxData,'fuel_P1',h);
    q_Pana1=gdx2mat(gdxData,'q_Pana1',h);
    save(strcat(path_Data,'q_p1_TB'),'q_p1_TB');
    save(strcat(path_Data,'q_p1_FGC'),'q_p1_FGC');
    save(strcat(path_Data,'fuel_P1'),'fuel_P1'); 
    save(strcat(path_Data,'q_Pana1'),'q_Pana1');
    %% Get results from VKA1
    
    %heating output from VKA1
    H_VKA1=gdx2mat(gdxData,'H_VKA1',h);
    save(strcat(path_Data,'H_VKA1'),'H_VKA1');
    %cooling output from VKA1
    C_VKA1=gdx2mat(gdxData,'C_VKA1',h);
    save(strcat(path_Data,'C_VKA1'),'C_VKA1');
    %electricty input to VKA1
    el_VKA1=gdx2mat(gdxData,'el_VKA1',h);
    save(strcat(path_Data,'el_VKA1'),'el_VKA1');
    %% Get results from VKA4
    
    %heating output from VKA4
    H_VKA4=gdx2mat(gdxData,'H_VKA4',h);
    save(strcat(path_Data,'H_VKA4'),'H_VKA4');
    %cooling output from VKA4
    C_VKA4=gdx2mat(gdxData,'C_VKA4',h);
    save(strcat(path_Data,'C_VKA4'),'C_VKA4');
    %electricty input to VKA4
    el_VKA4=gdx2mat(gdxData,'el_VKA4',h);
    save(strcat(path_Data,'el_VKA4'),'el_VKA4');
    %% Get results from Panna2
    
    %Binary decission variable to invest in P2 (is 1 if invested, 0 otherwise)
    B_P2=struct('name','B_P2');    
    B_P2=rgdx(gdxData,B_P2);
    B_P2=B_P2.val;
    %investment cost in P2
    invCost_P2=struct('name','invCost_P2');    
    invCost_P2=rgdx(gdxData,invCost_P2);
    invCost_P2=invCost_P2.val;
    save(strcat(path_Data,'invCost_P2'),'invCost_P2');
    %Fuel input to P2
    q_P2=gdx2mat(gdxData,'q_P2',h);
    save(strcat(path_Data,'q_P2'),'q_P2');
    %heating output from P2 to DH
    H_P2T=gdx2mat(gdxData,'H_P2T',h);
    save(strcat(path_Data,'H_P2T'),'H_P2T');
    %Binary decission variable to invest in the turbine (is 1 if invested, 0 otherwise)
    B_TURB=struct('name','B_TURB');    
    B_TURB=rgdx(gdxData,B_TURB);
    B_TURB=B_TURB.val;
    %investment cost in the turbine
    invCost_TURB=struct('name','invCost_TURB');    
    invCost_TURB=rgdx(gdxData,invCost_TURB);
    invCost_TURB=invCost_TURB.val;
    save(strcat(path_Data,'invCost_TURB'),'invCost_TURB');
    %electricty output from the turbine
    e_TURB=gdx2mat(gdxData,'e_TURB',h);
    save(strcat(path_Data,'e_TURB'),'e_TURB');
    %heating input to the turbine
    q_TURB=gdx2mat(gdxData,'q_TURB',h);
    save(strcat(path_Data,'q_TURB'),'q_TURB');
    %% Get results from Absorbtion Chiller
    
    %heating input to the existing Absorbtion chiller
    q_AbsC=gdx2mat(gdxData,'q_AbsC',h);
    save(strcat(path_Data,'q_AbsC'),'q_AbsC');
    %cooling output from the existing Absorbtion chiller
    k_AbsC=gdx2mat(gdxData,'k_AbsC',h);
    save(strcat(path_Data,'k_AbsC'),'k_AbsC');
    %Capacity of a nwe Absorbtion chiller
    AbsCInv_cap=struct('name','AbsCInv_cap');    
    AbsCInv_cap=rgdx(gdxData,AbsCInv_cap);
    AbsCInv_cap=AbsCInv_cap.val;
    save(strcat(path_Data,'AbsCInv_cap'),'AbsCInv_cap');
    %Investment cost of the nwe Absorbtion chiller
    invCost_AbsCInv=struct('name','invCost_AbsCInv');    
    invCost_AbsCInv=rgdx(gdxData,invCost_AbsCInv);
    invCost_AbsCInv=invCost_AbsCInv.val;
    save(strcat(path_Data,'invCost_AbsCInv'),'invCost_AbsCInv');
    %heating input to the new Absorbtion chiller
    q_AbsCInv=gdx2mat(gdxData,'q_AbsCInv',h);
    save(strcat(path_Data,'q_AbsCInv'),'q_AbsCInv');
    %cooling output from the new Absorbtion chiller
    k_AbsCInv=gdx2mat(gdxData,'k_AbsCInv',h);
    save(strcat(path_Data,'k_AbsCInv'),'k_AbsCInv');
    %% Get results from refrigerating machines
    
    %Elecricity demand by the refrigerator system in AH building
    e_RM=gdx2mat(gdxData,'e_RM',h);
    save(strcat(path_Data,'e_RM'),'e_RM');
    %Cooling generated by the refrigerator system in AH building
    k_RM=gdx2mat(gdxData,'k_RM',h);
    save(strcat(path_Data,'k_RM'),'k_RM');
    %Binary decission variable to invest in the MMC connection (is 1 if invested, 0 otherwise)
    RMMC_inv=struct('name','RMMC_inv');    
    RMMC_inv=rgdx(gdxData,RMMC_inv);
    RMMC_inv=RMMC_inv.val;
    %investment cost in the MMC connection
    invCost_RMMC=struct('name','invCost_RMMC');    
    invCost_RMMC=rgdx(gdxData,invCost_RMMC);
    invCost_RMMC=invCost_RMMC.val;
    save(strcat(path_Data,'invCost_RMMC'),'invCost_RMMC');
    %Elecricity demand by the refrigerator system in nonAH building
    e_RMMC=gdx2mat(gdxData,'e_RMMC',h);
    save(strcat(path_Data,'e_RMMC'),'e_RMMC');
    %Cooling generated by the refrigerator system in nonAH building
    k_RMMC=gdx2mat(gdxData,'k_RMMC',h); 
    save(strcat(path_Data,'k_RMMC'),'k_RMMC');
    %% Get results from Ambient Air Cooler (AAC)
    
    %Elecricity demand by the AAC
    e_AAC=gdx2mat(gdxData,'e_AAC',h);
    save(strcat(path_Data,'e_AAC'),'e_AAC');
    %Cooling generated by the AAC
    k_AAC=gdx2mat(gdxData,'k_AAC',h);
    save(strcat(path_Data,'k_AAC'),'k_AAC');
    %% Get results from the new reversible heat pump
    
    %Capacity of a nwe HP
    HP_cap=struct('name','HP_cap');
    HP_cap=rgdx(gdxData,HP_cap);
    HP_cap=HP_cap.val;
    save(strcat(path_Data,'HP_cap'),'HP_cap');
    %Investment cost of the nwe HP
    invCost_HP=struct('name','invCost_HP','form','full');    
    invCost_HP=rgdx(gdxData,invCost_HP);
    invCost_HP=invCost_HP.val;
    save(strcat(path_Data,'invCost_HP'),'invCost_HP');
    %heating output from the new HP
    q_HP=gdx2mat(gdxData,'q_HP',h);
    save(strcat(path_Data,'q_HP'),'q_HP');
    %cooling output from the new HP
    c_HP=gdx2mat(gdxData,'c_HP',h);
    save(strcat(path_Data,'c_HP'),'c_HP');
    %electricty input to the new HP
    e_HP=gdx2mat(gdxData,'e_HP',h);
    save(strcat(path_Data,'e_HP'),'e_HP');
    %% Get results from the new TES
    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    TES_inv=struct('name','TES_inv');    
    TES_inv=rgdx(gdxData,TES_inv);
    TES_inv=TES_inv.val;
    %TES capacity
    TES_cap=struct('name','TES_cap');    
    TES_cap=rgdx(gdxData,TES_cap);
    TES_cap=TES_cap.val;
    save(strcat(path_Data,'TES_cap'),'TES_cap');
    %investment cost in the TES
    invCost_TES=struct('name','invCost_TES');    
    invCost_TES=rgdx(gdxData,invCost_TES);
    invCost_TES=invCost_TES.val;
    save(strcat(path_Data,'invCost_TES'),'invCost_TES');
    %TES charging
    TES_ch=gdx2mat(gdxData,'TES_ch',h);
    save(strcat(path_Data,'TES_ch'),'TES_ch');
    %TES discharging
    TES_dis=gdx2mat(gdxData,'TES_dis',h);
    save(strcat(path_Data,'TES_dis'),'TES_dis');
    %TES energy stored
    TES_en=gdx2mat(gdxData,'TES_en',h);
    save(strcat(path_Data,'TES_en'),'TES_en');
    %% Get results from building inertia thermal energy storage (BITES)
    
    % BITES properties    
    BTES_model=gdx2mat(gdxData,'BTES_model',{BTES_properties,i});
    BTES_Scap=BTES_model(1,:);
    BTES_Dcap=BTES_model(2,:);
    save(strcat(path_Data,'BTES_Scap'),'BTES_Scap');
    save(strcat(path_Data,'BTES_Dcap'),'BTES_Dcap');    
    %Binary decission variable to invest in the TES (is 1 if invested, 0 otherwise)
    B_BITES=gdx2mat(gdxData,'B_BITES',i);
    save(strcat(path_Data,'B_BITES'),'B_BITES');
    %investment cost in the TES
    invCost_BITES=struct('name','invCost_BITES');    
    invCost_BITES=rgdx(gdxData,invCost_BITES);
    invCost_BITES=invCost_BITES.val;
    save(strcat(path_Data,'invCost_BITES'),'invCost_BITES');
    %BITES charging (Shallow)
    BTES_Sch=gdx2mat(gdxData,'BTES_Sch',{h,i});
    save(strcat(path_Data,'BTES_Sch'),'BTES_Sch');
    %BITES discharging (Sahllow)
    BTES_Sdis=gdx2mat(gdxData,'BTES_Sdis',{h,i});
    save(strcat(path_Data,'BTES_Sdis'),'BTES_Sdis');
    %BITES energy stored (shallow)
    BTES_Sen=gdx2mat(gdxData,'BTES_Sen',{h,i});
    save(strcat(path_Data,'BTES_Sen'),'BTES_Sen');
    %BITES energy stored (Deep)
    BTES_Den=gdx2mat(gdxData,'BTES_Den',{h,i});
    save(strcat(path_Data,'BTES_Den'),'BTES_Den');
    %BITES energy loss (shallow)
    BTES_Sloss=gdx2mat(gdxData,'BTES_Sloss',{h,i});
    save(strcat(path_Data,'BTES_Sloss'),'BTES_Sloss');
    %BITES energy loss (Deep)
    BTES_Dloss=gdx2mat(gdxData,'BTES_Dloss',{h,i});
    save(strcat(path_Data,'BTES_Dloss'),'BTES_Dloss');
    %BITES energy flow between Deep ad shallow
    link_BS_BD=gdx2mat(gdxData,'link_BS_BD',{h,i});
    save(strcat(path_Data,'link_BS_BD'),'link_BS_BD');
    %% Get results from PV
    
    %PV capacity-roof
    PV_cap_roof=gdx2mat(gdxData,'PV_cap_roof',BID);
    save(strcat(path_Data,'PV_cap_roof'),'PV_cap_roof');
    %PV capacity-facade
    PV_cap_facade=gdx2mat(gdxData,'PV_cap_facade',BID);
    save(strcat(path_Data,'PV_cap_facade'),'PV_cap_facade');
    %investment cost in the PV
    invCost_PV=struct('name','invCost_PV');    
    invCost_PV=rgdx(gdxData,invCost_PV);
    invCost_PV=invCost_PV.val;
    save(strcat(path_Data,'invCost_PV'),'invCost_PV');
    %Electricty from PV
    e_PV=gdx2mat(gdxData,'e_PV',h);
    save(strcat(path_Data,'e_PV'),'e_PV');
    %% Get results from battery energy storage
    
    %BES capacity
    BES_cap=struct('name','BES_cap');     
    BES_cap=rgdx(gdxData,BES_cap);
    BES_cap=BES_cap.val;
    save(strcat(path_Data,'BES_cap'),'BES_cap');
    %investment cost in the BES
    invCost_BES=struct('name','invCost_BEV');    
    invCost_BES=rgdx(gdxData,invCost_BES);
    invCost_BES=invCost_BES.val;
    save(strcat(path_Data,'invCost_BES'),'invCost_BES');
    %BES charging
    BES_ch=gdx2mat(gdxData,'BES_ch',h);
    save(strcat(path_Data,'BES_ch'),'BES_ch');
    %BES discharging
    BES_dis=gdx2mat(gdxData,'BES_dis',h);
    save(strcat(path_Data,'BES_dis'),'BES_dis');
    %BES energy stored
    BES_en=gdx2mat(gdxData,'BES_en',h);
    save(strcat(path_Data,'BES_en'),'BES_en');    
    %% Get electricty and heat import
    
    %Electricty import to the new FED system
    e_exG=gdx2mat(gdxData,'e_exG',h);
    save(strcat(path_Data,'e_exG'),'e_exG');
    %Heat import to the new FED system
    q_DH=gdx2mat(gdxData,'q_DH',h);
    save(strcat(path_Data,'q_DH'),'q_DH');
    %% Total investment cost
    
    invCost=struct('name','invCost');    
    invCost=rgdx(gdxData,invCost);
    invCost=invCost.val;
    save(strcat(path_Data,'invCost'),'invCost');
    %% VAriable and fuel cost     
    
    %electricity demand in the FED system
    fuel_cost=gdx2mat(gdxData,'fuel_cost',{sup_unit,h});
    var_cost=gdx2mat(gdxData,'var_cost',{sup_unit,h});
    save(strcat(path_Data,'fuel_cost'),'fuel_cost'); 
    save(strcat(path_Data,'var_cost'),'var_cost'); 
    %%
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
        LineThickness=1.5; 
        path_Data=strcat(path,'Data\');
        path_Figures=strcat(path,'Figures\');
        %% PEF and CO2F of the DH and electrity grid        
        
        %PEF of the electricty grid
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PEF_exG'));
        ydata=PEF_exG;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE [kWh_{PE}/kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %ylim([0 inf])
        legend('PE factor of external electricity grid')
        %save result 
        plot_fname=['PEF_exG'];
        fsave_figure(path_Figures,plot_fname);
        
        %CO2F of the electricty grid
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'CO2F_exG'));
        ydata=CO2F_exG;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO_2eq [g/kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('CO_2 factor of external electricity grid')
        %save result 
        plot_fname=['CO2F_exG'];
        fsave_figure(path_Figures,plot_fname);
        
        %PEF of the DH
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PEF_DH'));
        ydata=PEF_DH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE [kWh_{PE}/kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('PE factor of external DH')
        %save result 
        plot_fname=['PEF_DH'];
        fsave_figure(path_Figures,plot_fname);
        
        %CO2F of the DH
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'CO2F_DH'));
        ydata=CO2F_DH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO_2eq [g/kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('CO_2 factor of external DH')
        %save result 
        plot_fname=['CO2_DH'];
        fsave_figure(path_Figures,plot_fname);
        %% Plot local production and import 
        
        %Electricity
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load el_Import_2016;
        load(strcat(path_Data,'e_exG'));
        load(strcat(path_Data,'e_PV'));
        load(strcat(path_Data,'e_TURB'));
        
        ydata=e_exG;
        ydata2=e_PV+e_TURB;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,':',xdata,ydata2,'-.','LineWidth',LineThickness);       
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('Import','Local production')
        %save result 
        plot_fname=['el_import_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        
        %Heat
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load heat_Import_2016;
        load(strcat(path_Data,'q_DH'));
        load(strcat(path_Data,'H_VKA1'));
        load(strcat(path_Data,'H_VKA4'));
        load(strcat(path_Data,'q_Pana1'));
        load(strcat(path_Data,'H_P2T'));
        load(strcat(path_Data,'q_HP'));
        
        ydata=q_DH;
        ydata2=q_Pana1+H_VKA1+H_VKA4+H_P2T+q_HP;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,':',xdata,ydata2,'-.','LineWidth',LineThickness);       
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heat [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('Import','Local production')
        %save result 
        plot_fname=['heat_import_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        
        %Cooling
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        %load(strcat(path_Data,'k_DH'));
        load(strcat(path_Data,'C_VKA1'));
        load(strcat(path_Data,'C_VKA4'));
        load(strcat(path_Data,'k_AbsC'));
        load(strcat(path_Data,'k_AbsCInv'));
        load(strcat(path_Data,'k_RM'));
        load(strcat(path_Data,'k_RMMC'));
        load(strcat(path_Data,'c_HP'));
        
        ydata=zeros(length(C_VKA1),1);
        ydata2=C_VKA1+C_VKA4+k_AbsC+k_AbsCInv+k_RM+k_RMMC+c_HP;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,':',xdata,ydata2,'-.','LineWidth',LineThickness);       
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('Import','Local production')
        %save result 
        plot_fname=['cooling_import_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %% Stacked plots of local production 
                
        %Electricity
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'e_PV'));
        load(strcat(path_Data,'e_TURB'));
        
        ydata=[e_PV  e_TURB];
        xdata=(1:length(ydata))/(24*30);
        area(xdata,ydata,'EdgeColor','none')       
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('PV','TURB')
        %save result 
        plot_fname=['el_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        
        %Heat
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'H_VKA1'));
        load(strcat(path_Data,'H_VKA4'));
        load(strcat(path_Data,'q_Pana1'));
        load(strcat(path_Data,'H_P2T'));
        load(strcat(path_Data,'q_HP'));
        
        ydata=[q_Pana1 H_VKA1 H_VKA4 H_P2T q_HP];       
        xdata=(1:length(ydata))/(24*30);
        area(xdata,ydata,'EdgeColor','none')
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heat [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('Panna1','VKA1', 'VKA4' ,'Panna2', 'HP')
        %save result 
        plot_fname=['heat_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        
        %Cooling
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        %load(strcat(path_Data,'k_DH'));
        load(strcat(path_Data,'C_VKA1'));
        load(strcat(path_Data,'C_VKA4'));
        load(strcat(path_Data,'e_AAC'));
        load(strcat(path_Data,'k_AbsC'));
        load(strcat(path_Data,'k_AbsCInv'));
        load(strcat(path_Data,'k_RM'));
        load(strcat(path_Data,'k_RMMC'));
        load(strcat(path_Data,'c_HP'));
        
        ydata=[C_VKA1 C_VKA4 k_AbsC k_AbsCInv k_RM k_RMMC c_HP];        
        xdata=(1:length(ydata))/(24*30);
        area(xdata,ydata,'EdgeColor','none')
        xlabel('Time [Days]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        legend('VKA1','VKA4', 'AbsC', 'AbsInv', 'RM','RMMC','HP')
        %save result 
        plot_fname=['cooling_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot heat sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load q_P1;
        ydata=H_VKA1;
        ydata2=H_VKA4;
        ydata3=q_Pana1;
        ydata4=H_P2T;
        ydata5=q_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Local heat source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','P1','P2','HP')
        %save result 
        plot_fname=['heating_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
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
        ydata7=e_AAC;
        ydata8=c_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'-.',duration,sort(ydata6,'descend'),...
             duration,sort(ydata7,'descend'),'-.',duration,sort(ydata8,'descend'),'LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','AbcC','AbsCInv','RM','RMMC','AAC','HP')
        %save result 
        plot_fname=['cooling_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot electricty sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        ydata=e_TURB;
        ydata2=e_PV;        
        duration= 0 : 100/(length(ydata)-1) : 100;
        plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             'LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Local electricty source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('TURB','Solar PV') 
        %save result 
        plot_fname=['el_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot FED primary energy with and without investment
        
        %duration curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'FED_PE0'));
        load(strcat(path_Data,'FED_PE'));
        ydata=FED_PE0(1:8760)/1000;
        ydata2=FED_PE(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE use [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('Base case','fixed Panna1')
        %save result 
        plot_fname=['FED_PE_PE0_duration'];
        fsave_figure(path_Figures,plot_fname);
        
        %time series plot, base case
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)         
        load(strcat(path_Data,'FED_PE0'));
        ydata=FED_PE0(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE use [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %ylim([0 30])
        legend('FED PE use - base case')
        %save result 
        plot_fname=['FED_PE0'];
        fsave_figure(path_Figures,plot_fname);
        
        %time series curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'FED_PE'));
        ydata=FED_PE(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE use [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %ylim([0 30])
        legend('FED PE use - fixed Panna1')
        %save result 
        plot_fname=['FED_PE'];
        fsave_figure(path_Figures,plot_fname);
        
        %percentage change in PE use in the FED system
        fprintf('*********REDUCTION IN THE FED PRIMARY ENERGY USE********** \n')
        FED_pPE=(1-sum(FED_PE)/sum(FED_PE0));
        fprintf('Change in total FED PE use (New/Base) = %d \n\n', FED_pPE);
        %% PLot FED CO2 emission with and without investment
        
        %duration curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'FED_CO20'));
        load(strcat(path_Data,'FED_CO2'));
        ydata=FED_CO20(1:8760)/1000;
        ydata2=FED_CO2(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        %ylim([0 2500])
        legend('Base case','fixed Panna1')
        %save result 
        plot_fname=['FED_CO2_CO20_duration'];
        fsave_figure(path_Figures,plot_fname);
        
        %time series curve, base case
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'FED_CO2'));        
        ydata=FED_CO20(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %ylim([0 2500])
        legend('FED CO2 emission - base case')
        %save result 
        plot_fname=['FED_CO20'];
        fsave_figure(path_Figures,plot_fname);
        
        %time series curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'FED_CO2'));        
        ydata=FED_CO2(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %ylim([0 2500])
        legend('FED CO2 emission - fixed Panna1')
        %save result 
        plot_fname=['FED_CO2'];
        fsave_figure(path_Figures,plot_fname);
        
        %percentage change in peak CO2 emission in the FED system
        fprintf('*********REDUCTION IN THE FED PEAK CO2 EMISSION********** \n')
        FED_pCO2_peak=(1-max(FED_CO2)/max(FED_CO20));
        fprintf('Change in THE FED peak co2 emission (New/Base) = %d \n\n', FED_pCO2_peak);
        %percentage change in CO2 peak hours in the FED system (this figure make sence if FED_pCO2_peak is posetive)
        fprintf('*********REDUCTION IN THE FED PEAK HOUR CO2 EMISSION********** \n')
        FED_pCO2_peakh=0.95/(max(FED_CO2)/max(FED_CO20));
        fprintf('Change in THE FED peak co2 emission (New/Base) = %d \n\n', FED_pCO2_peakh);
        %percentage change in total CO2 emission in the FED system
        fprintf('*********REDUCTION IN THE FED TOTAL CO2 EMISSION********** \n')
        FED_pCO2_tot=1-sum(FED_CO2)/sum(FED_CO20);
        fprintf('Change in THE FED total co2 emission (New/Base) = %d \n\n', FED_pCO2_tot);
        %% PLot variation of energy stored in TES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'TES_en'));
        ydata=TES_en/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        LineThickness=4;
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('TES [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %save result 
        plot_fname=['TES_en'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot variation of energy stored in the shallow part of BITES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'BTES_Sen'));
        ydata=BTES_Sen/1000;
        xdata=(1:length(ydata))/(24*30); 
        area(xdata,ydata,'EdgeColor','none')
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BITES_{en} - Shallow [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        ylim([0 inf])
        %save result 
        plot_fname=['BITES_Sen'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot variation of energy stored in the deep part of BITES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'BTES_Den'));
        ydata=BTES_Den/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        %plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
        %plot(xdata,ydata,'LineWidth',LineThickness); 
        area(xdata,ydata,'EdgeColor','none')
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BITES_{en} - Deep [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        ylim([0 inf])
        %save result 
        plot_fname=['BITES_Den'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot BITES investments (feasible buildings for investment)
        
        %shallow storage
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'B_BITES'));
        load(strcat(path_Data,'BTES_Scap'));
        ydata=BTES_Scap.*B_BITES';
        xdata=1:30;
        bar(xdata,ydata)
        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('BTES_{cap} Shallow [kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 30])
        %ylim([0 2])
        %save result 
        plot_fname=['BITES_Scap'];
        fsave_figure(path_Figures,plot_fname);
        
        %Deep storage
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'BTES_Dcap'));
        ydata=BTES_Dcap.*B_BITES';
        xdata=1:30;
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('BTES_{cap} Deep [kWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 30])
        %ylim([0 2])
        %save result 
        plot_fname=['BITES_Dcap'];
        fsave_figure(path_Figures,plot_fname);
        %% Feasible PV capacities 
         
        %Roof        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_roof'));
        ydata=PV_cap_roof;
        %xdata=1:30;
        bar(ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Roof [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 72])
        %ylim([0 72])        
        %save result 
        plot_fname=['PV_Roofcap'];
        fsave_figure(path_Figures,plot_fname);
        
        %Wall        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_facade'));
        ydata=PV_cap_facade;
        %xdata=1:30;
        bar(ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Wall [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 72])
        %ylim([0 2])
        %save result 
        plot_fname=['PV_Wallcap'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot variation of energy stored in the BES
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        load(strcat(path_Data,'BES_en'));        
        ydata=BES_en/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;        
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BES [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 12])
        %save result 
        plot_fname=['BES_en'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot Variable cost and fuel cost of local production units
        
        %Fuel cost
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        load(strcat(path_Data,'fuel_cost'));
        load(strcat(path_Data,'q_Pana1'));
        load(strcat(path_Data,'q_P2'));
        temp_fCost=zeros(8760,2);
        uf_cost=fuel_cost';
        temp_fCost(:,1)=q_Pana1*uf_cost(1,7);
        temp_fCost(:,2)=q_P2*uf_cost(1,8);
        fCost0=sum(q_P1*uf_cost(1,7))/1000;
        ydata=sum(temp_fCost,1)/1000;
        xdata=(1:length(ydata))/(24*30);                
        bar(ydata);
        xlabel('Local generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Fuel cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'Panna1','Panna2'},'FontName','Times New Roman','FontSize',11)
        %save result 
        plot_fname=['fuel_cost'];
        fsave_figure(path_Figures,plot_fname);
        
        fprintf('                    Total fuel cost = %d kSEK \n', sum(ydata))
        fprintf('                    ===========================                     \n\n')
        
        %Variable cost
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        load(strcat(path_Data,'var_cost')); 
        load(strcat(path_Data,'BES_dis'));
        load(strcat(path_Data,'q_P2'));
        load(strcat(path_Data,'k_AAC'));
        
        uv_Cost=var_cost';
        temp_varCost=zeros(8760,9);
        temp_varCost(:,1)=q_HP*uv_Cost(1,2);
        temp_varCost(:,2)=BES_dis*uv_Cost(1,3);
        temp_varCost(:,3)=q_Pana1*uv_Cost(1,7);
        varCost0=sum(q_P1*uv_Cost(1,7));
        temp_varCost(:,4)=q_P2*uv_Cost(1,8);
        temp_varCost(:,5)=e_TURB*uv_Cost(1,9);
        temp_varCost(:,6)=k_AbsC*uv_Cost(1,10);
        temp_varCost(:,7)=k_AbsCInv*uv_Cost(1,11);
        temp_varCost(:,8)=k_AAC*uv_Cost(1,12);
        temp_varCost(:,9)=k_RM*uv_Cost(1,13);
        ydata=sum(temp_varCost,1)/1000;
        xdata=(1:length(ydata))/(24*30);                
        %area(xdata,ydata,'EdgeColor','none');
        bar(ydata');
        xlabel('Local Generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Varibale cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'HP','BES','Panna1','Panna2','TURB','AbsC','AbsCInv','AAC','RM'},'FontName','Times New Roman','FontSize',11)
        %save result 
        plot_fname=['var_cost'];
        fsave_figure(path_Figures,plot_fname);
        
        fprintf('                    Total variable cost = %d kSEK \n', sum(ydata))
        fprintf('                    ===========================                     \n\n')
        optCost=sum(sum(temp_varCost))/1000 + sum(sum(temp_fCost))/1000;
        optCost0=fCost0+varCost0;
        fprintf('                    Total change in operation cost = %d \n', optCost/optCost0)
        fprintf('                    ===========================                     \n\n')
        %legend('HP','BES','Panna1','Panna2','TURB','AbsC','AbsCInv','AAC','RM')
        %% Investment options
        load(strcat(path_Data,'invCost_P2'));
        load(strcat(path_Data,'invCost_TURB'));
        load(strcat(path_Data,'AbsCInv_cap'));
        load(strcat(path_Data,'invCost_AbsCInv'));
        load(strcat(path_Data,'invCost_RMMC'));
        load(strcat(path_Data,'HP_cap'));
        load(strcat(path_Data,'invCost_HP'));
        load(strcat(path_Data,'TES_cap'));
        load(strcat(path_Data,'invCost_TES'));
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
        load(strcat(path_Data,'B_BITES'));
        load(strcat(path_Data,'BTES_Scap'));
        load(strcat(path_Data,'BTES_Dcap'));
        load(strcat(path_Data,'invCost_BITES'));
        tot_BITES_cap=sum(BTES_Scap.*B_BITES' + BTES_Dcap.*B_BITES');        
        fprintf('Total Building inertia thermal capacity [MW]= %d, BITES Investment cost = %d MSEK \n',tot_BITES_cap, invCost_BITES/10^6)
        fprintf('                    ===========================                     \n\n')
        %Roof Capacity = %d kW, Facade Capacity = %d kW, Investment cost = %d MSEK \n',PV_cap_roof,PV_cap_facade, invCost_PV/10^6
        %%
        load(strcat(path_Data,'invCost_PV'));
        load(strcat(path_Data,'BES_cap'));
        load(strcat(path_Data,'invCost_BES'));
        fprintf('Investment in New Solar PV \n')
        fprintf('Roof Capacity [kw]= ')
        fprintf(' %d ',PV_cap_roof)
        fprintf('\n')
        fprintf('Total roof capacity = %d MW \n',sum(PV_cap_roof)/1000)
        fprintf('Facade Capacity [kw]= ')
        fprintf(' %d ',PV_cap_facade)
        fprintf('\n')
        fprintf('Total facade capacity = %d MW \n',sum(PV_cap_facade)/1000)
        fprintf('Total PV capacity (Roof + Wall) = %d MW \n',(sum(PV_cap_facade)+sum(PV_cap_roof))/1000)
        fprintf('Total investment cost on solar PV = %d MSEK \n',invCost_PV/10^6)
        fprintf('                    ===========================                     \n\n')
        fprintf('Investment in Battery Energy Storage \n BES Capacity = %d kW, BES Investment cost = %d MSEK \n',BES_cap, invCost_BES/10^6)
        fprintf('                    ===========================                     \n\n')
        %% Total investment cost in the FED system
        load(strcat(path_Data,'invCost'));
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
toc
%% Convert the data into daily mean

data0=el_exGrid;
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
properties.axelFontsize = 15;
Font_Size=properties.axelFontsize;
lgnd_size=1;
LineWidth=1;

LineThickness=0.1;

figure('Units','centimeters','PaperUnits','centimeters',...
       'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
       'PaperSize',properties.PaperSize)

ydata=data;
duration= 0 : 100/(length(ydata)-1) : 100;
xdata=(1:length(ydata))/(12);
%plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
%plot(duration(1:8760),sort(ydata(1:8760),'descend'),'-.r',...
%     duration(1:8760),sort(ydata2(1:8760),'descend'),'g','LineWidth',LineThickness);
%plot(time,ydata,'LineWidth',LineThickness);
area(xdata,ydata);
xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
ylabel('Electricty sorce [%]','FontSize',Font_Size,'FontName','Times New Roman')
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
xlim([0 12])
ylim([0 100])
legend('Biomass','Coal', 'Gas','Hydro', 'Nuclear', 'Oil', 'Solar', 'Wind', 'Geothermal', 'Unknown')
%legend('ANG HP1 ','ANG HP2','ANG HP3','SÄV HP1 + RK1','SÄV HP2',...
%        'SÄV HP3 (H1) + RK2','ROS HP2','ROS HP3','ROS HP4','ROS HP5',...
%        'ROS LK1 + del i RK1', 'ROS LK2 + del i RK1', 'RYA HP6',...
%        'RYA HP7', 'RYA VP','RYA KVV','TYN HVC','HÖG KVV NM1-3','Spillvärme' )
%ylim([0 3])
%DTyp=['NO'; 'SE'; 'DK'; 'FI'; 'EE'; 'LV'; 'LT'];
%NPVComp={'C1'; 'C2'; 'C3'; 'C4'; 'C5'};
%% save plot
return
folder_name='D:\PhD project\PhD\Report\Thesis\figures\phd_ch05\';
plot_fname=['ME_C2_gen_cor1_D1eqD2'];
fsave_figure(folder_name,plot_fname);


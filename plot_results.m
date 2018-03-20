   
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
    %set desired option
    option='mintotCost\'; %option can be 'mintotCOst', 'mintotPE', 'mintotCCO2' or 'mintotPECO2'
    path=strcat('Sim_Results\',option);
    file_name='GtoM_mintotPE_AHinv_HP';
    gdxData=strcat(path,file_name);       
    %% Get parameters and variables from a GDX file 
        
    PROCESS_DATA = 0;
    while PROCESS_DATA==1
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
    % uels for moths options
    m=get_uels('Sim_Results\uels\m','m'); 
    %% Set the path for the extracted data to be saved in 
    
    path_Data=strcat(path,'Data\'); 
    path_Data_base='Sim_Results\Sim_Results_base\Data\';
    %% Unit total cost
        
    utot_cost=gdx2mat(gdxData,'utot_cost',{sup_unit,h});
    save(strcat(path_Data,'utot_cost'),'utot_cost');
    %% Monthly peak demand charge, el grid
         
    PT_exG=gdx2mat(gdxData,'PT_exG',m);
    save(strcat(path_Data,'PT_exG'),'PT_exG');
    %% Peak demand charge, DH
         
    PT_DH=struct('name','PT_DH');
    PT_DH=rgdx(gdxData,PT_DH);
    PT_DH=PT_DH.val;
    save(strcat(path_Data,'PT_DH'),'PT_DH');
    %% System total cost and annualized investment cost
    
    %Fixed cost for exisiting units 
    fix_cost_existing=struct('name','fix_cost_existing');
    fix_cost_existing=rgdx(gdxData,fix_cost_existing);
    fix_cost_existing=fix_cost_existing.val;
    save(strcat(path_Data,'fix_cost_existing'),'fix_cost_existing'); 
    
    %variable cost for existing units 
    var_cost_existing=struct('name','var_cost_existing');
    var_cost_existing=rgdx(gdxData,var_cost_existing);
    var_cost_existing=var_cost_existing.val;
    save(strcat(path_Data,'var_cost_existing'),'var_cost_existing');
    
    %Fixed cost for new units 
    fix_cost_new=struct('name','fix_cost_new');
    fix_cost_new=rgdx(gdxData,fix_cost_new);
    fix_cost_new=fix_cost_new.val;
    save(strcat(path_Data,'fix_cost_new'),'fix_cost_new'); 
    
    %variable cost for existing units 
    var_cost_new=struct('name','var_cost_new');
    var_cost_new=rgdx(gdxData,var_cost_new);
    var_cost_new=var_cost_new.val;
    if isempty(var_cost_new)
       var_cost_new=0; 
    end
    save(strcat(path_Data,'var_cost_new'),'var_cost_new');
    
    tot_opn_cost=fix_cost_existing + var_cost_existing + fix_cost_new + var_cost_new;
    save(strcat(path_Data,'tot_opn_cost'),'tot_opn_cost');
    %% Electricty, heating and cooling demand data used as inputs in the simulation     
    
    %electricity demand in the FED system    
    el_demand=gdx2mat(gdxData,'el_demand',{h,i});
    h_demand=gdx2mat(gdxData,'h_demand',{h,i});
    c_demand=gdx2mat(gdxData,'c_demand',{h,i});
    c_demand_AH=gdx2mat(gdxData,'c_demand_AH',{h,i_AH});
    save(strcat(path_Data,'el_demand'),'el_demand'); 
    save(strcat(path_Data,'h_demand'),'h_demand');
    save(strcat(path_Data,'c_demand'),'c_demand');
    save(strcat(path_Data,'c_demand_AH'),'c_demand_AH');    
    %% Electricity and heat price and out door temprature
    
    el_price=gdx2mat(gdxData,'el_price',h);
    el_sell_price=gdx2mat(gdxData,'el_sell_price',h);
    h_price=gdx2mat(gdxData,'h_price',h);
    tout=gdx2mat(gdxData,'tout',h);
    save(strcat(path_Data,'el_price'),'el_price');
    save(strcat(path_Data,'el_sell_price'),'el_sell_price');
    save(strcat(path_Data,'h_price'),'h_price');
    save(strcat(path_Data,'tout'),'tout');
    %% Area of roofs and walls of buildings in the FED system 
    
    area_facade_max=gdx2mat(gdxData,'area_facade_max',BID);
    area_roof_max=gdx2mat(gdxData,'area_roof_max',BID);
    e_existPV=gdx2mat(gdxData,'e_existPV',h);    %electricity from a kW of a PV
    save(strcat(path_Data,'area_facade_max'),'area_facade_max');
    save(strcat(path_Data,'area_roof_max'),'area_roof_max');
    save(strcat(path_Data,'e_existPV'),'e_existPV');
    %% FED PE use and CO2 emission base and simulated case
    
    FED_PE=gdx2mat(gdxData,'FED_PE',h);
    FED_CO2=gdx2mat(gdxData,'FED_CO2',h);
    save(strcat(path_Data,'FED_PE'),'FED_PE');
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
    
    h_B1=gdx2mat(gdxData,'qB1',h);
    h_F1=gdx2mat(gdxData,'qF1',h);
    fuel_P1=gdx2mat(gdxData,'fuel_P1',h);
    h_Pana1=gdx2mat(gdxData,'h_Pana1',h);
    save(strcat(path_Data,'h_B1'),'h_B1');
    save(strcat(path_Data,'h_F1'),'h_F1');
    save(strcat(path_Data,'fuel_P1'),'fuel_P1');
    save(strcat(path_Data,'h_Pana1'),'h_Pana1');
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
    h_P2=gdx2mat(gdxData,'h_P2',h);
    save(strcat(path_Data,'h_P2'),'h_P2');
    %heating output from P2 to DH
    h_P2=gdx2mat(gdxData,'h_P2',h);
    save(strcat(path_Data,'h_P2'),'h_P2');

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
    h_TURB=gdx2mat(gdxData,'h_TURB',h);
    save(strcat(path_Data,'h_TURB'),'h_TURB');
    %% Get results from Absorbtion Chiller
    
    %heating input to the existing Absorbtion chiller
    h_AbsC=gdx2mat(gdxData,'h_AbsC',h);
    save(strcat(path_Data,'h_AbsC'),'h_AbsC');
    %cooling output from the existing Absorbtion chiller
    c_AbsC=gdx2mat(gdxData,'c_AbsC',h);
    save(strcat(path_Data,'c_AbsC'),'c_AbsC');
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
    h_AbsCInv=gdx2mat(gdxData,'h_AbsCInv',h);
    save(strcat(path_Data,'h_AbsCInv'),'h_AbsCInv');
    %cooling output from the new Absorbtion chiller
    c_AbsCInv=gdx2mat(gdxData,'c_AbsCInv',h);
    save(strcat(path_Data,'c_AbsCInv'),'c_AbsCInv');
    %% Get results from refrigerating machines
    
    %Elecricity demand by the refrigerator system in AH building
    el_RM=gdx2mat(gdxData,'el_RM',h);
    save(strcat(path_Data,'el_RM'),'el_RM');
    %Cooling generated by the refrigerator system in AH building
    c_RM=gdx2mat(gdxData,'c_RM',h);
    save(strcat(path_Data,'c_RM'),'c_RM');
    %Elecricity demand by the new refrigerator system
    e_RMInv=gdx2mat(gdxData,'e_RMInv',h);
    save(strcat(path_Data,'e_RMInv'),'e_RMInv');
    %Cooling generated by the new refrigerator system
    c_RMInv=gdx2mat(gdxData,'c_RMInv',h);
    save(strcat(path_Data,'c_RMInv'),'c_RMInv');    
    % Capacity od the new RM
    RMInv_cap=struct('name','RMInv_cap');    
    RMInv_cap=rgdx(gdxData,RMInv_cap);
    RMInv_cap=RMInv_cap.val;
    save(strcat(path_Data,'RMInv_cap'),'RMInv_cap');
    %investment cost in the new RM
    invCost_RMInv=struct('name','invCost_RMInv');    
    invCost_RMInv=rgdx(gdxData,invCost_RMInv);
    invCost_RMInv=invCost_RMInv.val;
    save(strcat(path_Data,'invCost_RMInv'),'invCost_RMInv');
    %Binary decission variable to invest in the MMC connection (is 1 if invested, 0 otherwise)
    RMMC_inv=struct('name','RMMC_inv');    
    RMMC_inv=rgdx(gdxData,RMMC_inv);
    RMMC_inv=RMMC_inv.val;
    save(strcat(path_Data,'RMMC_inv'),'RMMC_inv');
    %investment cost in the MMC connection
    invCost_RMMC=struct('name','invCost_RMMC');    
    invCost_RMMC=rgdx(gdxData,invCost_RMMC);
    invCost_RMMC=invCost_RMMC.val;
    save(strcat(path_Data,'invCost_RMMC'),'invCost_RMMC');
    %Elecricity demand by the refrigerator system in nonAH building
    e_RMMC=gdx2mat(gdxData,'e_RMMC',h);
    save(strcat(path_Data,'e_RMMC'),'e_RMMC');
    %Cooling generated by the refrigerator system in nonAH building
    c_RMMC=gdx2mat(gdxData,'c_RMMC',h); 
    save(strcat(path_Data,'c_RMMC'),'c_RMMC');
    %Heat generated by the refrigerator system in AH building
    h_RMMC=gdx2mat(gdxData,'h_RMMC',h);        
    save(strcat(path_Data,'h_RMMC'),'h_RMMC');
    %% Get results from Ambient Air Cooler (AAC)
    
    %Elecricity demand by the AAC
    e_AAC=gdx2mat(gdxData,'e_AAC',h);
    save(strcat(path_Data,'e_AAC'),'e_AAC');
    %Cooling generated by the AAC
    c_AAC=gdx2mat(gdxData,'c_AAC',h);
    save(strcat(path_Data,'c_AAC'),'c_AAC');
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
    h_HP=gdx2mat(gdxData,'h_HP',h);
    save(strcat(path_Data,'h_HP'),'h_HP');
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
    %Binary decission variable to invest in the BITES (is 1 if invested, 0 otherwise)
    B_BITES=gdx2mat(gdxData,'B_BITES',i);
    save(strcat(path_Data,'B_BITES'),'B_BITES');
    %investment cost in the BITES
    invCost_BITES=struct('name','invCost_BITES');    
    invCost_BITES=rgdx(gdxData,invCost_BITES);
    invCost_BITES=invCost_BITES.val;
    save(strcat(path_Data,'invCost_BITES'),'invCost_BITES');
    %investment cost in the BAC
    invCost_BAC=struct('name','invCost_BAC');    
    invCost_BAC=rgdx(gdxData,invCost_BAC);
    invCost_BAC=invCost_BAC.val;
    save(strcat(path_Data,'invCost_BAC'),'invCost_BAC');
    %Binary decission variable to invest in the BAC (is 1 if invested, 0 otherwise)
    B_BAC=gdx2mat(gdxData,'B_BAC',i);
    save(strcat(path_Data,'B_BAC'),'B_BAC');    
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
    %% Building Advanced Control (BAC)
    
    %BAC energy saving
    h_BAC_savings=gdx2mat(gdxData,'h_BAC_savings',{h,i});
    save(strcat(path_Data,'h_BAC_savings'),'h_BAC_savings');
    
    %Binary decission variable to invest in BAC
    B_BAC=gdx2mat(gdxData,'B_BAC',i);
    save(strcat(path_Data,'B_BAC'),'B_BAC');
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
    %Electricty from PV (existing)
    e_existPV=gdx2mat(gdxData,'e_existPV',h);
    save(strcat(path_Data,'e_existPV'),'e_existPV');
    %Electricty from PV (new)
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
    
    %Electricty import to AH system
    e_imp_AH=gdx2mat(gdxData,'e_imp_AH',h);
    save(strcat(path_Data,'e_imp_AH'),'e_imp_AH');
    %Electricty export from AH system
    e_exp_AH=gdx2mat(gdxData,'e_exp_AH',h);
    save(strcat(path_Data,'e_exp_AH'),'e_exp_AH');
    %Electricty export to non-AH system
    e_imp_nonAH=gdx2mat(gdxData,'e_imp_nonAH',h);
    save(strcat(path_Data,'e_imp_nonAH'),'e_imp_nonAH');
    %Heat import to AH system
    h_imp_AH=gdx2mat(gdxData,'h_imp_AH',h);
    save(strcat(path_Data,'h_imp_AH'),'h_imp_AH');
    %Heat export from AH system
    h_exp_AH=gdx2mat(gdxData,'h_exp_AH',h);
    save(strcat(path_Data,'h_exp_AH'),'h_exp_AH');
    %Heat import to nonAH system
    h_imp_nonAH=gdx2mat(gdxData,'h_imp_nonAH',h);
    save(strcat(path_Data,'h_imp_nonAH'),'h_imp_nonAH');
    %Cooling import to the new FED system
    c_DC=gdx2mat(gdxData,'C_DC',h);
    save(strcat(path_Data,'c_DC'),'c_DC');
    %% Total investment cost
    
    invCost=struct('name','invCost');    
    invCost=rgdx(gdxData,invCost);
    invCost=invCost.val;
    save(strcat(path_Data,'invCost'),'invCost');
    %% VAriable and fuel cost     
    
    %electricity demand in the FED system
    price=gdx2mat(gdxData,'price',{sup_unit,h});
    fuel_cost=gdx2mat(gdxData,'fuel_cost',{sup_unit,h});
    var_cost=gdx2mat(gdxData,'var_cost',{sup_unit,h});
    save(strcat(path_Data,'price'),'price');
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
        txt='Simulated case';   %Legend text for a scenario
        % intialize plot properties
        properties=finit_plot_properties;   %initialise plot properties
        properties.legendFontsize = 1;
        properties.labelFontsize = 1;
        properties.axelFontsize = 20;
        Font_Size=properties.axelFontsize;
        lgnd_size=1;
        LineWidth=1;
        LineThickness=1; 
        path_Data=strcat(path,'Data\');
        path_Figures=strcat(path,'Figures\');
        colour_map = [0,   0,   1
                      0,   1,   0
                      1,   0,   0
                      0,   1,   1
                      1,   0,   1
                      0,   0,   0.5
                      0,   0.5, 0
                      0.5, 0,   0
                      0,   0.5, 0.5
                      0.5, 0.5, 0
                      0.5, 0.5, 0.5];
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('PE factor of external electricity grid','Location','southwest')
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('CO_2 factor of external electricity grid','Location','southwest')
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        legend('PE factor of external DH','Location','northwest')
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])    
        ylim([0 inf])
        legend('CO_2 factor of external DH','Location','southwest')
        grid
        %save result 
        plot_fname=['CO2_DH'];
        fsave_figure(path_Figures,plot_fname);
        %% Plot import  and export
        
        %Net Electricity import AH, simulated
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'e_imp_AH'));
        load(strcat(path_Data,'e_exp_AH'));
        ydata=e_imp_AH-e_exp_AH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Net AH el import - Simulated')
        grid
        %save result 
        plot_fname=['net_ah_el_import_sim'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Electricity import nonAH, simulated
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'e_imp_nonAH'));
        ydata=e_imp_nonAH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Non-AH el import - Simulated')
        grid
        %save result 
        plot_fname=['nonah_el_import_sim'];
        fsave_figure(path_Figures,plot_fname);         
        %%
        %Net Heat import AH, simulated
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'h_imp_AH'));
        load(strcat(path_Data,'h_exp_AH'));
        ydata=h_imp_AH-h_exp_AH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heating [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Net AH heat import - Simulated','Location','northwest')
        grid
        %save result 
        plot_fname=['net_ah_h_import_sim'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Heat import nonAH, simulated
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'h_imp_nonAH'));
        ydata=h_imp_nonAH;
        xdata=(1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);        
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heating [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Non-AH heat import - Simulated')
        grid
        %save result 
        plot_fname=['nonah_h_import_sim'];
        fsave_figure(path_Figures,plot_fname);
        %% Local generation 
        
        %el
        load(strcat(path_Data,'e_existPV'));
        load(strcat(path_Data,'e_PV'));
        load(strcat(path_Data,'e_TURB'));        
        ydata=e_existPV + e_PV + e_TURB;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,'LineWidth',LineThickness);       
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Total local el production','Location','northwest')
        grid
        %save result 
        plot_fname=['el_tot_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %%        
        %Heat
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        %h_imp_AH0=load('Sim_Results\Sim_Results_base\Data\e_imp_AH');
        %h_imp_AH0=h_imp_AH0.h_imp_AH;
        load(strcat(path_Data,'H_VKA1'));
        load(strcat(path_Data,'H_VKA4'));
        load(strcat(path_Data,'h_Pana1'));        
        load(strcat(path_Data,'h_P2'));
        load(strcat(path_Data,'h_HP'));
        
        ydata=h_Pana1 + H_VKA1 + H_VKA4 + h_P2 + h_HP;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,'LineWidth',LineThickness);       
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heating [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Total local production')
        grid
        %save result 
        plot_fname=['heat_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Cooling
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        %load(strcat(path_Data,'k_DH'));
        load(strcat(path_Data,'C_VKA1'));
        load(strcat(path_Data,'C_VKA4'));
        load(strcat(path_Data,'c_AbsC'));
        load(strcat(path_Data,'c_AbsCInv'));
        load(strcat(path_Data,'c_RM'));
        load(strcat(path_Data,'c_RMInv'));
        load(strcat(path_Data,'c_RMMC'));
        load(strcat(path_Data,'c_AAC'));
        load(strcat(path_Data,'c_HP'));
        
        %ydata=zeros(length(C_VKA1),1);
        ydata=C_VKA1 + C_VKA4 + c_AbsC + c_AbsCInv + c_RM + c_RMInv + c_RMMC + c_AAC + c_HP;        
        xdata=(1:length(ydata))/(24*30);                
        plot(xdata,ydata,'LineWidth',LineThickness);       
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Total local production')
        grid
        %save result 
        plot_fname=['cooling_import_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        % Stacked plots of local production 
        %%        
        %Electricity
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'e_PV'));
        load(strcat(path_Data,'e_TURB'));
        
        ydata=[e_existPV e_PV e_TURB];
        xdata=(1:length(ydata))/(24*30);        
        %b=bar(xdata,[e_existPV e_PV],'stacked','EdgeColor','non','LineWidth',1.5);        
        %b(1).Parent.Parent.Colormap = colour_map;
        %area(xdata,ydata,'EdgeColor','none') 
        b=area(xdata,ydata,'EdgeColor','none');  
        b(1).Parent.Parent.Colormap = colour_map(1:3,:);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Electricity [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Existing PV','New PV','TURB')
        grid
        %save result 
        plot_fname=['el_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Heat
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'H_VKA1'));
        load(strcat(path_Data,'H_VKA4'));
        load(strcat(path_Data,'h_Pana1'));
        load(strcat(path_Data,'h_P2'));
        load(strcat(path_Data,'h_HP'));
        
        ydata=[h_Pana1 H_VKA1 H_VKA4 h_P2 h_HP];       
        xdata=(1:length(ydata))/(24*30);
        b=area(xdata,ydata,'EdgeColor','none');
        b(1).Parent.Parent.Colormap = colour_map(1:5,:);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Heating [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('Boiler1','VKA1', 'VKA4' ,'Boiler2', 'HP','Location','north')
        grid
        %save result 
        plot_fname=['heat_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %%
        % Cooling, area plot
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)       
               
        ydata=[C_VKA1 C_VKA4 c_AbsC c_AbsCInv c_RM c_RMInv  c_RMMC c_AAC c_HP];        
        xdata=(1:length(ydata))/(24*30);
        b=area(xdata,ydata,'EdgeColor','none');
        b(1).Parent.Parent.Colormap = colour_map(1:9,:);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        legend('VKA1','VKA4', 'AbsC', 'AbsInv', 'RM','RMInv','RMMC','AAC','HP','Location','northwest')
        grid
        %save result 
        plot_fname=['cooling_locProduction'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot heat sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        ydata=H_VKA1;
        ydata2=H_VKA4;
        ydata3=h_Pana1;
        ydata4=h_P2;
        ydata5=h_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        b=plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'LineWidth',LineThickness);
        b(1).Parent.Parent.Colormap = colour_map(1:5,:);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Local heat source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','Boiler1','Boiler2','HP')
        grid
        %save result 
        plot_fname=['heating_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot cooling sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=C_VKA1;
        ydata2=C_VKA4;
        ydata3=c_AbsC;
        ydata4=c_AbsCInv;
        ydata5=c_RM;
        ydata55=c_RMInv;
        ydata6=c_RMMC;
        ydata7=c_AAC;
        ydata8=c_HP;
        duration= 0 : 100/(length(ydata)-1) : 100;
        b=plot(duration,sort(ydata,'descend'),'--',duration,sort(ydata2,'descend'),':',...
             duration,sort(ydata3,'descend'),'-.',duration,sort(ydata4,'descend'),...
             duration,sort(ydata5,'descend'),'-.', duration,sort(ydata55,'descend'),'-.',duration,sort(ydata6,'descend'),...
             duration,sort(ydata7,'descend'),'-.',duration,sort(ydata8,'descend'),'LineWidth',LineThickness);
        b(1).Parent.Parent.Colormap = colour_map(1:9,:);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Cooling source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('VKA1','VKA4','AbsC','AbsCInv','RM','RMInv','RMMC','AAC','HP')
        grid
        %save result 
        plot_fname=['cooling_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot electricty sources 
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        ydata1=e_existPV;
        ydata2=e_PV;
        ydata3=e_TURB;
        duration= 0 : 100/(length(ydata1)-1) : 100;
        plot(duration,sort(ydata1,'descend'),'-.',duration,sort(ydata2,'descend'),'--',duration,sort(ydata3,'descend'),':',...
             'LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Local electricty source [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        legend('Existing PV','New PV','TURBINE')
        grid
        %save result 
        plot_fname=['el_locProduction_duration'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot FED primary energy with and without investment        
        
        %duration curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
        FED_PE0=FED_PE0.FED_PE;
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
        legend('Base case',txt)
        grid
        %save result 
        plot_fname=['FED_PE_PE0_duration'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %time series plot, base case
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)         
        FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
        FED_PE0=FED_PE0.FED_PE;        
        ydata=FED_PE0(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('PE use [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        %ylim([0 30])
        legend('FED PE use - base case')
        grid
        %save result 
        plot_fname=['FED_PE0'];
        fsave_figure(path_Figures,plot_fname);
        %%
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        %ylim([0 30])
        legend(strcat('FED PE use - ',txt))
        grid
        %save result 
        plot_fname=['FED_PE'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %percentage change in PE use in the FED system
        fprintf('*********CHANGE IN THE FED PRIMARY ENERGY USE********** \n')
        FED_pPE=(sum(FED_PE)/sum(FED_PE0)-1);
        fprintf('Change in total FED PE use (New/Base) = %d \n\n', FED_pPE);
        %% PLot FED CO2 emission with and without investment
        
        %duration curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        FED_CO20=load('Sim_Results\Sim_Results_base\Data\FED_CO2');
        FED_CO20=FED_CO20.FED_CO2;
        load(strcat(path_Data,'FED_CO2'));
        ydata=FED_CO20(1:8760)/1000;
        ydata2=FED_CO2(1:8760)/1000;
        duration= 0 : 100/(length(ydata)-1) : 100;
        
        plot(duration,sort(ydata,'descend'),'-.r',...
            duration,sort(ydata2,'descend'),'g','LineWidth',LineThickness);
        xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO_2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        xlim([0 100])
        ylim([-1000 2000])
        legend('Base case',txt)
        grid
        %save result 
        plot_fname=['FED_CO2_CO20_duration'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %time series curve, base case
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'FED_CO2'));        
        ydata=FED_CO20(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO_2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([-1000 2000])
        legend('FED CO2 emission - base case')
        grid
        %save result 
        plot_fname=['FED_CO20'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %time series curve
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)        
        load(strcat(path_Data,'FED_CO2'));        
        ydata=FED_CO2(1:8760)/1000;
        xdata= (1:length(ydata))/(24*30);
        
        plot(xdata,ydata,'LineWidth',LineThickness);
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('CO_2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([-1000 2000])
        legend(strcat('FED CO2 emission - ',txt))
        grid
        %save result 
        plot_fname=['FED_CO2'];
        fsave_figure(path_Figures,plot_fname);
        
        %percentage change in peak CO2 emission in the FED system
        fprintf('*********CHANGE IN THE FED TOTAL CO2 EMISSION********** \n')
        FED_pCO2_tot=sum(FED_CO2)/sum(FED_CO20)-1;
        fprintf('Change in THE FED total co2 emission (New/Base) = %d \n\n', FED_pCO2_tot);
        fprintf('*********REDUCTION IN THE FED PEAK CO2 EMISSION********** \n')
        load('CO2ref');
        dCO20=max(FED_CO20)-CO2ref;
        dCO2=max(FED_CO2)-CO2ref;
        FED_pCO2_peak= (dCO2/dCO20)-1;%(CO2ref/max(FED_CO20)-max(FED_CO2)/max(FED_CO20)-1);
        fprintf('Change in THE FED peak co2 emission (New/Base) = %d \n\n', FED_pCO2_peak);
        %percentage change in CO2 peak hours in the FED system (this figure make sence if FED_pCO2_peak is posetive)
        %fprintf('*********CHANGE IN THE FED PEAK HOUR CO2 EMISSION********** \n')
        %FED_pCO2_peakh=((max(FED_CO2)/max(FED_CO20))-1)/0.05;
        %fprintf('Change in THE FED peak co2 emission (New/Base) = %d \n\n', FED_pCO2_peakh);
        %percentage change in total CO2 emission in the FED system        
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        grid
        %save result 
        plot_fname=['BITES_Den'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot BITES investments (feasible buildings for investment)
        
        %shallow storage
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'B_BITES'));
        load(strcat(path_Data,'B_BAC'));
        load(strcat(path_Data,'BTES_Scap'));
        B_applicable=[1 2 3 4 6 8 10 11 13 14 16 17 18 19 20 21 22 23 25 26 31 32 33 35];
        ydata1=BTES_Scap.*B_BITES';
        ydata=ydata1(B_applicable);
        xdata=1:length(ydata);
        
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('BTES_{cap} Shallow [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',13)
        set(gca,'XTick',xdata(1:1:end))
        set(gca,'XTickLabel',{'Kemi','Vassa1','Vassa2-3','Vassa4-15','Bibliotek',...
            'NyaMatte','Kraftcentral','Lokalkontor','Cadministration','GamlaMatte','HA','HB','Elkraftteknik',...
            'HC','Maskinteknik','Fysik_Origo','MC2','Edit','Keramforskning',...
            'Fysik_Soliden','VOV1','Arkitektur','VOV2','Chabo'})
        xtickangle(90)
        box off
        %xlim([1 35])
        %ylim([0 2])
        grid
        %save result 
        plot_fname=['BITES_Scap'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Deep storage
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'BTES_Dcap'));
        ydata2=BTES_Dcap.*B_BITES';
        ydata=ydata2(B_applicable);
        xdata=1:length(ydata);
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('BTES_{cap} Deep [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',13)
        set(gca,'XTick',xdata(1:1:end))
        set(gca,'XTickLabel',{'Kemi','Vasa_1','Vasa_{2-3}','Vasa_{4-15}','Bibliotek',...
            'NyaMatte','Kraftcentral','Lokalkontor','Cadministration','GamlaMatte','HA','HB','Elkraftteknik',...
            'HC','Maskinteknik','Fysik_Origo','MC2','Edit','Keramforskning',...
            'Fysik_Soliden','VOV_1','Arkitektur','VOV_2','Chabo'})        
        xtickangle(90)
        box off
        %xlim([0.7 25.7])
        %ylim([0 2])
        grid
        %save result 
        plot_fname=['BITES_Dcap'];
        fsave_figure(path_Figures,plot_fname);
        %% Energy saving from BAC
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'h_BAC_savings'));
        ydata=h_BAC_savings/1000;
        time=(1:length(ydata))/(24*30);
        xdata=time;
        
        area(xdata,ydata,'EdgeColor','none')
        xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('BAC saving [MWh]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        ylim([0 inf])
        grid
        %save result 
        plot_fname=['BAC_saving'];
        fsave_figure(path_Figures,plot_fname);
        %% Feasible PV capacities 
         
        %Roof        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_roof'));
        ydata=PV_cap_roof;
        xdata=1:72;
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Roof [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',13)
        set(gca,'XTick',xdata(1:2:end))
        %xtickangle(90)
        box off
        %xlim([1 72])
        %ylim([0 72])
        grid
        %save result 
        plot_fname=['PV_Roofcap'];
        fsave_figure(path_Figures,plot_fname);
        
        %Wall        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_facade'));
        ydata=PV_cap_facade;
        xdata=1:72;
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Wall [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',13)
        set(gca,'XTick',xdata(1:2:end))
        %xtickangle(90)
        box off
        %xlim([1 72])
        %ylim([0 2])
        grid
        %save result 
        plot_fname=['PV_Wallcap'];
        fsave_figure(path_Figures,plot_fname);
        %% Edited PV 
        %WALL
        PV_cap_roof_edit=zeros(33,1);
        PV_cap_roof_edit(1)=PV_cap_roof(53)+PV_cap_roof(54)+PV_cap_roof(55);
        PV_cap_roof_edit(2)=PV_cap_roof(41);
        PV_cap_roof_edit(3)=PV_cap_roof(58)+PV_cap_roof(59); %VASSA2-4
        PV_cap_roof_edit(4)=PV_cap_roof(13)+PV_cap_roof(14)+PV_cap_roof(3)+PV_cap_roof(2)+PV_cap_roof(7)+PV_cap_roof(42)+PV_cap_roof(16)+PV_cap_roof(15)+PV_cap_roof(17);
        PV_cap_roof_edit(5)=PV_cap_roof(71);
        PV_cap_roof_edit(6)=PV_cap_roof(45);
        PV_cap_roof_edit(7)=PV_cap_roof(30)+PV_cap_roof(31)+PV_cap_roof(34);
        PV_cap_roof_edit(8)=PV_cap_roof(12)+PV_cap_roof(46);
        PV_cap_roof_edit(9)=PV_cap_roof(8)+PV_cap_roof(20)+PV_cap_roof(22)+PV_cap_roof(38)+PV_cap_roof(39); %Studentbostader
        PV_cap_roof_edit(10)=PV_cap_roof(28);
        PV_cap_roof_edit(12)=PV_cap_roof(11)+PV_cap_roof(24);
        PV_cap_roof_edit(13)=PV_cap_roof(25)+PV_cap_roof(57);
        PV_cap_roof_edit(14)=PV_cap_roof(62)+PV_cap_roof(63)+PV_cap_roof(64)+PV_cap_roof(65)+PV_cap_roof(68);
        PV_cap_roof_edit(15)=PV_cap_roof(1);
        PV_cap_roof_edit(16)=PV_cap_roof(35);
        PV_cap_roof_edit(17)=PV_cap_roof(33);
        PV_cap_roof_edit(18)=PV_cap_roof(36);
        PV_cap_roof_edit(19)=PV_cap_roof(9)+PV_cap_roof(18)+PV_cap_roof(60);
        PV_cap_roof_edit(20)=PV_cap_roof(56);
        PV_cap_roof_edit(21)=PV_cap_roof(43)+PV_cap_roof(47)+PV_cap_roof(52);
        PV_cap_roof_edit(22)=PV_cap_roof(6)+PV_cap_roof(44);
        PV_cap_roof_edit(23)=PV_cap_roof(29);
        PV_cap_roof_edit(24)=PV_cap_roof(40);
        PV_cap_roof_edit(25)=PV_cap_roof(50);
        PV_cap_roof_edit(26)=PV_cap_roof(51);
        PV_cap_roof_edit(27)=PV_cap_roof(72);
        PV_cap_roof_edit(28)=PV_cap_roof(66)+PV_cap_roof(67);
        PV_cap_roof_edit(29)=PV_cap_roof(61);
        PV_cap_roof_edit(30)=PV_cap_roof(10)+PV_cap_roof(23)+PV_cap_roof(49);
        PV_cap_roof_edit(31)=PV_cap_roof(48);
        PV_cap_roof_edit(32)=PV_cap_roof(27);
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_roof'));
        ydata=PV_cap_roof_edit;
        xdata=1:length(ydata);
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Roof [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',10)
        set(gca,'XTick',xdata(1:1:end))
        set(gca,'XTickLabel',{'Kemi','Vasa_1','Vasa_{2-3}','Vasa_{4-15}','Phus','Bibliotek','SSPA','NyaMatte','Studentbostader',...
            'Kraftcentral','Lokalkontor','Karhus','Cadministration','GamlaMatte','Gibraltar_herrgard','HA','HB',...
            'Elkraftteknik','HC','Maskinteknik','Fysik-Origo','MC2','Edit','Polymerteknologi','Keramforskning',...
            'Fysik-Soliden','Idelara','CTP','JSP','VOV_1','Arkitektur','VOV_2','Chabo'})
        xtickangle(90)
        %xtickangle(90)
        box off
        %xlim([1 72])
        %ylim([0 72])
        grid
        
        %WALL
        PV_cap_facade_edit=zeros(33,1);
        PV_cap_facade_edit(1)=PV_cap_facade(53)+PV_cap_facade(54)+PV_cap_facade(55);
        PV_cap_facade_edit(2)=PV_cap_facade(41);
        PV_cap_facade_edit(3)=PV_cap_facade(58)+PV_cap_facade(59); %VASSA2-4
        PV_cap_facade_edit(4)=PV_cap_facade(13)+PV_cap_facade(14)+PV_cap_facade(3)+PV_cap_facade(2)+PV_cap_facade(7)+PV_cap_facade(42)+PV_cap_facade(16)+PV_cap_facade(15)+PV_cap_facade(17);
        PV_cap_facade_edit(5)=PV_cap_facade(71);
        PV_cap_facade_edit(6)=PV_cap_facade(45);
        PV_cap_facade_edit(7)=PV_cap_facade(30)+PV_cap_facade(31)+PV_cap_facade(34);
        PV_cap_facade_edit(8)=PV_cap_facade(12)+PV_cap_facade(46);
        PV_cap_facade_edit(9)=PV_cap_facade(8)+PV_cap_facade(20)+PV_cap_facade(22)+PV_cap_facade(39)+PV_cap_facade(39); %Studentbostader
        PV_cap_facade_edit(10)=PV_cap_facade(28);
        PV_cap_facade_edit(12)=PV_cap_facade(11)+PV_cap_facade(24);
        PV_cap_facade_edit(13)=PV_cap_facade(25)+PV_cap_facade(57);
        PV_cap_facade_edit(14)=PV_cap_facade(62)+PV_cap_facade(63)+PV_cap_facade(64)+PV_cap_facade(65)+PV_cap_facade(68); %GAMLAMATTE
        PV_cap_facade_edit(15)=PV_cap_facade(1);
        PV_cap_facade_edit(16)=PV_cap_facade(35);
        PV_cap_facade_edit(17)=PV_cap_facade(33);
        PV_cap_facade_edit(18)=PV_cap_facade(36);
        PV_cap_facade_edit(19)=PV_cap_facade(9)+PV_cap_facade(18)+PV_cap_facade(60);
        PV_cap_facade_edit(20)=PV_cap_facade(56);
        PV_cap_facade_edit(21)=PV_cap_facade(43)+PV_cap_facade(47)+PV_cap_facade(52);
        PV_cap_facade_edit(22)=PV_cap_facade(6)+PV_cap_facade(44);
        PV_cap_facade_edit(23)=PV_cap_facade(29);
        PV_cap_facade_edit(24)=PV_cap_facade(40);
        PV_cap_facade_edit(25)=PV_cap_facade(50);
        PV_cap_facade_edit(26)=PV_cap_facade(51);
        PV_cap_facade_edit(27)=PV_cap_facade(72);
        PV_cap_facade_edit(28)=PV_cap_facade(66)+PV_cap_facade(67);
        PV_cap_facade_edit(29)=PV_cap_facade(61);
        PV_cap_facade_edit(30)=PV_cap_facade(10)+PV_cap_facade(23)+PV_cap_facade(49);
        PV_cap_facade_edit(31)=PV_cap_facade(48);
        PV_cap_facade_edit(32)=PV_cap_facade(27);
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        load(strcat(path_Data,'PV_cap_roof'));
        ydata=PV_cap_facade_edit;
        xdata=1:length(ydata);
        bar(xdata,ydata)        
        xlabel('Buildings []','FontSize',Font_Size,'FontName','Times New Roman')        
        ylabel('PV Capacity-Wall [kW]','FontSize',Font_Size,'FontName','Times New Roman')
        set(gca,'FontName','Times New Roman','FontSize',10)
        set(gca,'XTick',xdata(1:1:end))
        set(gca,'XTickLabel',{'Kemi','Vasa_1','Vasa_{2-3}','Vasa_{4-15}','Phus','Bibliotek','SSPA','NyaMatte','Studentbostader',...
            'Kraftcentral','Lokalkontor','Karhus','Cadministration','GamlaMatte','Gibraltar_herrgard','HA','HB',...
            'Elkraftteknik','HC','Maskinteknik','Fysik-Origo','MC2','Edit','Polymerteknologi','Keramforskning',...
            'Fysik-Soliden','Idelara','CTP','JSP','VOV_1','Arkitektur','VOV_2','Chabo'})
        xtickangle(90)
        %xtickangle(90)
        box off
        %xlim([1 72])
        %ylim([0 72])
        grid
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
        set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
        box off
        xlim([0 12])
        grid
        %save result 
        plot_fname=['BES_en'];
        fsave_figure(path_Figures,plot_fname);
        %% PLot Variable cost and fuel cost of local production units
                
        %Fuel cost, base case
        h_Pana10=load('Sim_Results\Sim_Results_base\Data\h_Pana1');
        h_Pana10=h_Pana10.h_Pana1;
        h_Pana20=load('Sim_Results\Sim_Results_base\Data\h_P2');
        h_Pana20=h_Pana20.h_P2;
        load(strcat(path_Data,'fuel_cost'));   
        temp_fCost0=zeros(8761,2);
        uf_cost=fuel_cost';        
        temp_fCost0(:,1)=h_Pana10*uf_cost(1,8);
        temp_fCost0(:,2)=h_Pana20*uf_cost(1,9);
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=sum(temp_fCost0,1)/1000;             
        bar(ydata);
        xlabel('Local generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Fuel cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        legend('Fuel cost - Base case');
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'Boiler1','Boiler2'},'FontName','Times New Roman','FontSize',11)
        grid
                
        fprintf('                    Total fuel cost, Base case = %d kSEK \n', sum(ydata))
        fprintf('                    ===========================                     \n\n')
        %save result 
        plot_fname=['fuel_cost_base'];
        fsave_figure(path_Figures,plot_fname);
        %%        
        %Fuel cost, simulated
        load(strcat(path_Data,'fuel_cost'));
        load(strcat(path_Data,'h_Pana1'));
        load(strcat(path_Data,'h_P2'));        
        temp_fCost=zeros(8761,2);
        uf_cost=fuel_cost';        
        temp_fCost(:,1)=h_Pana1*uf_cost(1,8);
        temp_fCost(:,2)=h_P2*uf_cost(1,9);
        %fCost0=sum(q_P1*uf_cost(1,7))/1000; % fixed in the base case need
        %to be calculated to make the comparision
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        
        ydata=sum(temp_fCost,1)/1000;             
        bar(ydata);
        xlabel('Local generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Fuel cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        legend('Fuel cost - Simulated');
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'Boiler1','Boiler2'},'FontName','Times New Roman','FontSize',11)
        grid
                
        fprintf('                    Total fuel cost, Simulated = %d kSEK \n', sum(ydata))
        fprintf('                    ===========================                     \n\n')
        
        %save result 
        plot_fname=['fuel_cost_sim'];
        fsave_figure(path_Figures,plot_fname);
        %% 
        %Variable cost, Base case                  
        load(strcat(path_Data,'price'))
        load(strcat(path_Data,'var_cost'));
        load(strcat(path_Data,'utot_cost'));
        e_imp_AH0=load('Sim_Results\Sim_Results_base\Data\e_imp_AH');
        e_imp_AH0=e_imp_AH0.e_imp_AH;
        e_imp_nonAH0=load('Sim_Results\Sim_Results_base\Data\e_imp_nonAH');
        e_imp_nonAH0=e_imp_nonAH0.e_imp_nonAH;
        h_imp_AH0=load('Sim_Results\Sim_Results_base\Data\h_imp_AH');
        h_imp_AH0=h_imp_AH0.h_imp_AH;
        h_imp_nonAH0=load('Sim_Results\Sim_Results_base\Data\h_imp_nonAH');
        h_imp_nonAH0=h_imp_nonAH0.h_imp_nonAH;
        h_exp_AH0=load('Sim_Results\Sim_Results_base\Data\h_exp_AH');
        h_exp_AH0=h_exp_AH0.h_exp_AH;

        c0_AbsC=load('Sim_Results\Sim_Results_base\Data\c_AbsC');
        c0_AbsC=c0_AbsC.c_AbsC;
        c0_AAC=load('Sim_Results\Sim_Results_base\Data\c_AAC');
        c0_AAC=c0_AAC.c_AAC;
        h0_VKA1=load('Sim_Results\Sim_Results_base\Data\H_VKA1');
        h0_VKA1=h0_VKA1.H_VKA1;
        h0_VKA4=load('Sim_Results\Sim_Results_base\Data\H_VKA4');
        h0_VKA4=h0_VKA4.H_VKA4;
        
        %uv_Cost=var_cost';
        utot_cost=utot_cost';
        temp_varCost0=zeros(8761,10);        
        temp_varCost0(:,1)=h0_VKA1*utot_cost(1,2)+h0_VKA4*utot_cost(1,2);
        temp_varCost0(:,3)=h_Pana10*utot_cost(1,8);
        temp_varCost0(:,6)=c0_AbsC*utot_cost(1,11);
        temp_varCost0(:,7)=c0_AAC*utot_cost(1,13);
        
        price=price';
        
        temp_varCost0(:,9)=(e_imp_AH0(:)+e_imp_nonAH0(:)).*utot_cost(:,15); %uv_Cost(:,15);
        temp_varCost0(:,10)=(h_imp_AH0(:)+h_imp_nonAH0(:)).*utot_cost(:,16)-(h_exp_AH0(:)).*0.3;
        ydata0=sum(temp_varCost0,1)/1000;
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        bar(ydata0');
        xlabel('Local Generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Variable cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        legend('Variable cost - Base case','Location','northwest');
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'HP','BES','B1','B2','TURB','AbsC','AAC','RM','extG','DH'},'FontName','Times New Roman','FontSize',11)
        grid;        
        
        %load fixed costs in the base case
        load('Sim_Results\Sim_Results_base\Data\fix_cost_existing');
        load('Sim_Results\Sim_Results_base\Data\fix_cost_new');
        tot_fix_cost0=fix_cost_existing + fix_cost_new;
        fprintf('                    Total fixed cost (Base case)= %d kSEK \n', sum(tot_fix_cost0)/1000)
        fprintf('                    ===========================                     \n\n')        
        
        %load variable costs in the base case
        load('Sim_Results\Sim_Results_base\Data\var_cost_existing');
        load('Sim_Results\Sim_Results_base\Data\var_cost_new');
        tot_var_cost0=var_cost_existing + var_cost_new;
        fprintf('                    Total variable cost (Base case)= %d kSEK \n', sum(tot_var_cost0)/1000)
        fprintf('                    ===========================                     \n\n')
        
        %save result 
        plot_fname=['var_cost_base'];
        fsave_figure(path_Figures,plot_fname);
        %%
        %Variable cost, Simulated
        load(strcat(path_Data,'el_sell_price'))
        load(strcat(path_Data,'BES_dis'));
        load(strcat(path_Data,'h_P2'));
        load(strcat(path_Data,'c_AAC'));
        load(strcat(path_Data,'H_VKA1'));
        load(strcat(path_Data,'H_VKA4'));
        load(strcat(path_Data,'e_imp_AH'));
        load(strcat(path_Data,'e_imp_nonAH'));
        load(strcat(path_Data,'e_exp_AH'));
        load(strcat(path_Data,'h_imp_AH'));
        load(strcat(path_Data,'h_imp_nonAH'));
        load(strcat(path_Data,'h_exp_AH'));
        
        %uv_Cost=var_cost';
        temp_varCost=zeros(8761,10);
        temp_varCost(:,1)=h_HP*utot_cost(1,2)+H_VKA1*utot_cost(1,2)+H_VKA4*utot_cost(1,2);
        temp_varCost(:,2)=BES_dis*utot_cost(1,3);
        temp_varCost(:,3)=h_Pana1*utot_cost(1,8);
        temp_varCost(:,4)=h_P2*utot_cost(1,9);
        temp_varCost(:,5)=e_TURB*utot_cost(1,10);
        temp_varCost(:,6)=c_AbsC*utot_cost(1,11) + c_AbsCInv*utot_cost(1,12);
        temp_varCost(:,7)=c_AAC*utot_cost(1,13);
        temp_varCost(:,8)=c_RM*utot_cost(1,14);
        
        %Real el import and export 
        net_e_imp=e_imp_AH-e_exp_AH;
        real_e_imp=zeros(length(net_e_imp),1);
        real_e_exp=zeros(length(net_e_imp),1);
        real_e_imp(net_e_imp>=0)=net_e_imp(net_e_imp>=0);
        real_e_exp(net_e_imp<0)=net_e_imp(net_e_imp<0);
        temp11=real_e_imp(:).*utot_cost(:,15) + e_imp_nonAH0(:).*utot_cost(:,15) + real_e_exp(:).*el_sell_price(:);
        
        %Real el import and export
        net_h_imp=h_imp_AH-h_exp_AH;
        real_h_imp=zeros(length(net_h_imp),1);
        real_h_exp=zeros(length(net_h_imp),1);
        real_h_imp(net_h_imp>=0)=net_h_imp(net_h_imp>=0);
        real_h_exp(net_h_imp<0)=net_h_imp(net_h_imp<0);   
        temp22=real_h_imp(:).*utot_cost(:,16) + h_imp_nonAH0(:).*utot_cost(:,16) + real_h_exp(:).*0.3;
        
        temp_varCost(:,9)=temp11;  %(e_imp_AH(:) + e_imp_nonAH(:)).*price(:,15)-(e_exp_AH(:)).*el_sell_price(:);
        temp_varCost(:,10)=temp22; %(h_imp_AH(:) + h_imp_nonAH(:)).*price(:,16)-(h_exp_AH(:)).*0.3;
        ydata=sum(temp_varCost,1)/1000;
        
        figure('Units','centimeters','PaperUnits','centimeters',...
            'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
            'PaperSize',properties.PaperSize)
        bar(ydata');
        xlabel('Local Generating units []','FontSize',Font_Size,'FontName','Times New Roman')
        ylabel('Variable cost [kSEK]','FontSize',Font_Size,'FontName','Times New Roman')
        legend('Variable cost - Simulated','Location','northwest');
        set(gca,'FontName','Times New Roman','FontSize',Font_Size)
        box off
        %xlim([0 12])
        set(gca,'XTickLabel',{'HP','BES','B1','B2','TURB','AbsC','AAC','RM','extG','DH'},'FontName','Times New Roman','FontSize',11)
        grid
        
        %load variable costs, simulated
        load(strcat(path_Data,'fix_cost_existing'));
        load(strcat(path_Data,'fix_cost_new'));
        tot_fix_cost=fix_cost_existing + fix_cost_new;
        fprintf('                    Total fixed cost, Simulated = %d kSEK \n', sum(tot_fix_cost)/1000)
        fprintf('                    ===========================                     \n\n')
        %% Only var_cost_existing is affected, calculate existing variable cost in MATLAB to avoid import and export at the same time 
        %load fixed costs, simulated
        %load(strcat(path_Data,'var_cost_existing'));

        %Re-calculating var_cost_existing
        temp1=e_imp_AH(:).*price(:,15)-e_exp_AH(:).*el_sell_price(:);
        temp2=h_imp_AH(:).*price(:,16)-(h_exp_AH(:)).*0.3;   
        var_cost_existing_mat=var_cost_existing-(temp1+temp2)+(temp11+temp22);
        %%
        load(strcat(path_Data,'var_cost_new'));
        tot_var_cost=var_cost_existing_mat + var_cost_new;
        fprintf('                    Total variable cost, Simulated = %d kSEK \n', sum(tot_var_cost))
        fprintf('                    ===========================                     \n\n')   
        
        %save result 
        plot_fname=['var_cost_sim'];
        fsave_figure(path_Figures,plot_fname);
        %% Annual total operation cost
        
        tot_opn_cost0=load('Sim_Results\Sim_Results_base\Data\tot_opn_cost');
        tot_opn_cost0=tot_opn_cost0.tot_opn_cost;        
        load(strcat(path_Data,'tot_opn_cost'));        
        
        %optCost0=fCost0+varCost0;
        fprintf('                    Total operation cost = %d kSEK\n', tot_opn_cost/1000)
        fprintf('                    ===========================                     \n\n')
        fprintf('                    Total operation cost (Base case) = %d kSEK\n', tot_opn_cost0/1000)
        fprintf('                    ===========================                     \n\n')
        fprintf('                    Percentage change in operation cost = %d []\n', ((tot_opn_cost/tot_opn_cost0))-1)
        fprintf('                    ===========================                     \n\n')
        %legend('HP','BES','Panna1','Panna2','TURB','AbsC','AbsCInv','AAC','RM')
        %% Investment options
        load(strcat(path_Data,'invCost_P2'));
        load(strcat(path_Data,'invCost_TURB'));
        load(strcat(path_Data,'AbsCInv_cap'));
        load(strcat(path_Data,'invCost_AbsCInv'));
        load(strcat(path_Data,'invCost_RMMC'));
        load(strcat(path_Data,'RMInv_cap'));
        load(strcat(path_Data,'invCost_RMInv'));
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
        fprintf('Investment in New RM \n Capacity = %d kW, Investment cost = %d MSEK\n', RMInv_cap, invCost_RMInv/10^6)
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
        load(strcat(path_Data,'invCost_BAC'));
        tot_BITES_cap=sum(BTES_Scap.*B_BITES' + BTES_Dcap.*B_BITES');        
        fprintf('Building inertia thermal, Number of Buildings= %d, Capacity [MW]= %d, BITES Investment cost = %d MSEK \n',sum(B_BITES), tot_BITES_cap, invCost_BITES/10^6)
        fprintf('Building Advanced Control, Number of Buildings= %d, BAC Investment cost = %d MSEK \n', sum(B_BAC), invCost_BAC/10^6)
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
        break;         
    end    
    break;
end
toc
return
%% Comparision of results

tot_PE=[10   11.6   9.8
        7.6  12.3  -10
        7.6  12    -10.3
        30   13    -9.7];
tot_CO2=[13    1    15
         17.7  1.1  23
         16.8  1.3  23
         18    2    24];
max_CO2=[-8.4   1     1
         34.7   17.6  43.6
          38.5  1.6   41.6
          4     19    43]; 
opn_Cost=[18.4  19    18.4
          18    19    21.8
          18    19    21.9
          15    18.7  22];
%% Convert the data into daily mean
ydata=[C_VKA1 C_VKA4 k_AbsC k_AbsCInv k_RM k_RMMC k_AAC c_HP]; 
data0=ydata;
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
colour_map = [0,   0,   1
              0,   0,   0.8
              0,   0,   0.6
              0,   0,   0.4
              0,   0,   0.2
              0,   1,   0
              0,   0.8,   0
              0,   0.6,   0
              0,   0.4,   0
              0,   0.2,   0
              1,   0,   0
              0.8,   0,   0
              0,   1,   1 
              1,   0,   1
              0,   0,   0.5
              0,   0.5, 0
              0.5, 0,   0
              0,   0.5, 0.5
              0.5, 0.5, 0
              0.5, 0.5, 0.5];

LineThickness=0.1;

figure('Units','centimeters','PaperUnits','centimeters',...
       'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
       'PaperSize',properties.PaperSize)

%[e0_VKA1 e0_VKA4 e0_AAC el_pv] [q0_AbsC q0_VKA1 q0_VKA4 q_P1]
load('Sim_Results\Sim_Results_base\Data\h_price');
    
ydata=heat_DH;
duration= 0 : 100/(length(ydata)-1) : 100;
xdata=(1:length(ydata))/(24*30);
%plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
%plot(duration(1:8760),sort(ydata(1:8760),'descend'),'-.r',...
%     duration(1:8760),sort(ydata2(1:8760),'descend'),'g','LineWidth',LineThickness);
%plot(xdata,ydata,'LineWidth',LineThickness);
b=area(xdata,ydata,'EdgeColor','none');  
b(1).Parent.Parent.Colormap = colour_map;
xlabel('Time [Months]','FontSize',Font_Size,'FontName','Times New Roman')
ylabel('GE heat generation mix [MW]','FontSize',Font_Size,'FontName','Times New Roman')
%ylabel('PE [kWh_{PE}/kWh]','FontSize',Font_Size,'FontName','Times New Roman')
%legend('VKA1 el demand','VKA4 el demand','AAC el demand','PV el generation')
%legend('Boiler1 heat gen','VKA1 heat gen','VKA4 heat gen','AbsC heat gen')
%legend('GE district heating price')
%set(gca,'XTickLabel',{'2','4', '6','8','10','12'},'FontName','Times New Roman','FontSize',Font_Size)

set(gca,'XTickLabel',{'Mar','May','Jul','Sep','Nov','Jan',''})
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
grid
xlim([0 12])
%xlim([xdata(1) 30])
ylim([0 inf])

%legend('Biomass','Coal', 'Gas','Hydro', 'Nuclear', 'Oil', 'Solar', 'Wind', 'Geothermal', 'Unknown')
legend('ANG HP1 ','ANG HP2','ANG HP3','SÄV HP1 + RK1','SÄV HP2',...
       'SÄV HP3 (H1) + RK2','ROS HP2','ROS HP3','ROS HP4','ROS HP5',...
       'ROS LK1 + del i RK1', 'ROS LK2 + del i RK1', 'RYA HP6',...
       'RYA HP7', 'RYA VP','RYA KVV','TYN HVC','HÖG KVV NM1-3','RENOVA','Spillvärme' )
%ylim([0 3])
%DTyp=['NO'; 'SE'; 'DK'; 'FI'; 'EE'; 'LV'; 'LT'];
%NPVComp={'C1'; 'C2'; 'C3'; 'C4'; 'C5'};
%% save plot
return
folder_name='D:\PhD project\PhD\Report\Thesis\figures\phd_ch05\';
plot_fname=['ME_C2_gen_cor1_D1eqD2'];
fsave_figure(folder_name,plot_fname);


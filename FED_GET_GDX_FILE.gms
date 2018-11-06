********************************************************************************
*-----------------------GENERATE or GET GDX FILES-------------------------------
*-------------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GET INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*-If there is change in any of the input data (see the parameter list below), run 'FED_GENERATE_GDX_FILE' to update 'FED_INPUT_DATA'
*----------------Load input parameters of the model-----------------------------

*----------Building IDs---------------------------------------------------------
set B_ID           Building ID
;

$GDXIN MtoG.gdx
$LOAD B_ID
$GDXIN
Alias (B_ID, i) ;
*-----------Simulation time, Bites and BAC investments--------------------------
set h              SIMULATION TIME
    BITES_Inv(i)   used for fixed BITES inv option
    BAC_Inv(i)     used for fixed BAC inv option
    BTES_properties  Building Inertia TES properties
;
$GDXIN MtoG.gdx
$LOAD h
$LOAD BITES_Inv
$LOAD BAC_Inv
$LOAD BTES_properties
$GDXIN

*-----------DH heating nodes----------------------------------------------------
set DH_Node_ID     District heating network node names
;
$GDXIN MtoG.gdx
$LOAD DH_Node_ID
$GDXIN

PARAMETERS
           DH_node_transfer_limits(h,DH_Node_ID) Transfer limits MWh per h for DH nodes
;
$GDXIN MtoG.gdx
$LOAD DH_node_transfer_limits
$GDXIN

set DHNodeToB_ID(DH_Node_ID, B_ID)  Mapping between district heating nodes and buildings /Fysik.(O0007001, O3060132, O0007006, O3060133, O0011001, O0007005, O0013001),
                                                                                          Bibliotek.O0007017,
                                                                                          Maskin.(O0007028,O0007888),
                                                                                          EDIT.(O0007012,O0007024,O0007018,O0007022,O0007025,O0007021,SSPA,Studentbostader),
                                                                                          VoV.(Karhus_CFAB,Karhus_studenter,O0007019,O0007023,O0007026,O0007027),
                                                                                          Eklanda.O0007040/
*ITGYMNASIET belongs to Fysik node
*-----------DC heating nodes----------------------------------------------------
set DC_Node_ID    District cooling network node names
;
$GDXIN MtoG.gdx
$LOAD DC_Node_ID
$GDXIN

PARAMETERS
           DC_node_transfer_limits(h,DC_Node_ID) Transfer limits MWh per h for DC nodes
;
$GDXIN MtoG.gdx
$LOAD DC_node_transfer_limits
$GDXIN

set DCNodeToB_ID(DC_Node_ID, B_ID)  Mapping between district cooling nodes and buildings /VoV.(O0007019,O0007023,O0007026,O0007027),
                                                                                          Maskin.(O0007028,O0007888,O0007022,O0007025),
                                                                                          EDIT.(O0007012,O0007024,O0007018,O0007021),
                                                                                          Fysik.(O0007001, O0007006, O3060133, O0011001, O0007005),
                                                                                          Kemi.(O3060132,O0013001)/

*--------------Building catagories based on how energy is supplied--------------
set i_AH_el(i) buildings considered in the FED system connected the AH(Akadamiskahus) el netwrok
    i_nonAH_el(i) buildings considered in the FED system not connected to the AH(Akadamiskahus) el netwrok
    i_AH_h(i) buildings considered in the FED system connected to the AH(Akadamiskahus) heat netwrok
    i_nonAH_h(i) buildings considered in the FED system not connected to the AH(Akadamiskahus) heat netwrok
    i_AH_c(i) buildings considered in the FED system connected to the AH(Akadamiskahus) cooling netwrok
    i_nonAH_c(i) buildings considered in the FED system not connected to the AH(Akadamiskahus) cooling netwrok
    i_nonBITES(i)         Buildings not applicable for BITES
;
$GDXIN MtoG.gdx
$LOAD i_AH_el
$LOAD i_nonAH_el
$LOAD i_AH_h
$LOAD i_nonAH_h
$LOAD i_AH_c
$LOAD i_nonAH_c
$LOAD i_nonBITES
$GDXIN
*---------------Buses IDs of electrical network, Admittance matrix & current limits----------------------*
set Bus_IDs;

$GDXIN MtoG.gdx
$LOAD Bus_IDs
$GDXIN
alias(Bus_IDs,j);
set BusToB_ID(Bus_IDs,B_ID)  Mapping between buses and buildings /15.O3060133, 5.O3060132, 21.O0007001, 11.(O0011001,O0013001,O0007005),
                                                 20.(O0007008,O0007888), 9.(O0007017,O0007006), 34.(O0007022,O0007025,O0007028), 32.(O0007024,O0007018,Studentbostader),
                                                 40.(O0007012,O0007021,O0007014), 30.O0007040, 24.(O0007019,Karhus_CFAB,Karhus_studenter), 26.(O0007023,O0007026), 28.(O0007027,O0007043)/
;
parameter Sb Base power (KW) /1000/;
parameter Ib Base current (A) /54.98/;
Parameter bij(Bus_IDs,j)
Parameter gij(Bus_IDs,j)
Parameter bii(Bus_IDs)
Parameter Y(Bus_IDs,j)  elements magnitudes of admittance matrix
Parameter Theta(Bus_IDs,j)   elements angles of admittance matrix
Parameter currentlimits(Bus_IDs,j) current limits
$GDXIN Input_dispatch_model\AdmittanceMatrix.gdx
$load gij
$load bij
$load bii
$LOAD currentlimits
$GDXIN
*----------------Solar PV data--------------------------------------------------
SET
    BID        Building IDs used for PV calculations
;
$GDXIN MtoG.gdx
$LOAD BID
$GDXIN

SET
    PV_B_ID_roof_Inv(B_ID)   Buildings where solar PV invetment is made - roof
    PV_B_ID_facade_Inv(B_ID) Buildings where solar PV invetment is made - facade
;
$GDXIN MtoG.gdx
$LOAD PV_B_ID_roof_Inv
$LOAD PV_B_ID_facade_Inv
$GDXIN
alias(PV_B_ID_roof_Inv,r);
alias(PV_B_ID_facade_Inv,f);

Parameter PV_roof_cap_Inv(B_ID) Invested PV capacity-roof
          PV_facade_cap_Inv(B_ID) Invested PV capacity-facade
          PV_inverter_PF_Inv            Invested PV roof inverters power factor
;
$GDXIN MtoG.gdx
$LOAD PV_roof_cap_Inv
$LOAD PV_facade_cap_Inv
$load PV_inverter_PF_Inv
$GDXIN

set BusToBID(Bus_IDs,BID)   Mapping between buses and BIDs
/15.(6,44), 5.(54,55,53,4), 21.(52,43,47), 11.(40,50,51), 20.28, 9.(12,46,45), 34.(56,32,37,33,35),
 32.(29,9,19,20,22,8), 40.(18,60,1,36), 30.(68,70,69,62,65), 24.(57,25,24,11), 26.(10,48,49), 28.(23,27,75)/
;
*----------------PREPARE THE FULL INPUT DATA------------------------------------
SET
    m   Number of month                   /1*24/
    d   Number of days                    /1*730/
;

*----------------load date vectors for power tariffs----------------------------
PARAMETERS  HoD(h,d)      Hour of the day
PARAMETERS  HoM(h,m)      Hour of the month
;
$GDXIN Input_dispatch_model\FED_date_vector.gdx
$LOAD HoD
$LOAD HoM
$GDXIN

PARAMETERS
            G_facade(h,B_ID)       irradiance on building facades
            area_facade_max(B_ID)  irradiance on building facades
            G_roof(h,B_ID)         irradiance on building facades
            area_roof_max(B_ID)    irradiance on building facades
;
$GDXIN Input_dispatch_model\IRRADIANCE_DATA.gdx
$LOAD G_facade
$LOAD area_facade_max
$LOAD G_roof
$LOAD area_roof_max
$GDXIN
********************************************************************************

*-------------------Measured data in the base case------------------------------
PARAMETERS
            qB1(h)         Heat out from boiler 1 (Panna1)
            qF1(h)         Heat out from FGC (Panna1)
            el_VKA1_0(h)   el used by VKA1 in the base case
            el_VKA4_0(h)   el used by VKA4 in the base case
            el_AAC_0(h)    el used by the AAC in the base case
            h_AbsC_0(h)    heat used by the AbsC in the base case
;
$GDXIN MtoG.gdx
$LOAD qB1
$LOAD qF1
$LOAD el_VKA1_0
$LOAD el_VKA4_0
$LOAD el_AAC_0
$LOAD h_ABsC_0
$GDXIN

*-----------Forcasted Demand data from MATLAB-----------------------------------
PARAMETERS
           el_demand(h,B_ID)    ELECTRICITY DEMAND IN THE FED BUILDINGS
           h_demand(h,B_ID)     Heating DEMAND IN THE FED BUILDINGS
           c_demand(h,B_ID)     Cooling DEMAND IN THE FED BUILDINGS
           cool_demand(h)       Total cooling demand
           heat_demand(h)       Total heat demand
           elec_demand(h)       Total elec. demand
;
$GDXIN MtoG.gdx
$LOAD el_demand
$LOAD h_demand
$LOAD c_demand
$GDXIN
*Must be deleted
el_demand(h,i_nonAH_el)=0;
*-----------Forcasted energy prices from MATLAB---------------------------------
PARAMETERS
           el_price(h)       ELECTRICTY PRICE IN THE EXTERNAL GRID
           el_cirtificate(h) Electricity cirtificate for selling renewable energy sek per kwh
           h_price(h)        Heat PRICE IN THE IN THE EXTERNAL DH SYSTEM
;
$GDXIN MtoG.gdx
$LOAD el_price
$LOAD el_cirtificate
$LOAD h_price
$GDXIN

*-----------Forcasted outdoor temprature from MATLAB----------------------------
PARAMETERS
            tout(h)               OUT DOOR TEMPRATTURE
;
$GDXIN MtoG.gdx
$LOAD tout
$GDXIN

*-----------BITES model from MATLAB---------------------------------------------
PARAMETERS
            BTES_model(BTES_properties,i) BUILDING INERTIA TES PROPERTIES
;
$GDXIN MtoG.gdx
$LOAD BTES_model
$GDXIN

*-----------P1P2 dispatchability from MATLAB------------------------------------
PARAMETERS
            P1P2_dispatchable(h)          Period during which P1 and P2 are dispatchable
;
$GDXIN MtoG.gdx
$LOAD P1P2_dispatchable
$GDXIN

*-----------BAC saving period from MATLAB---------------------------------------
PARAMETERS
            BAC_savings_period(h)         Period in which BAC-energy savings are active
;
$GDXIN MtoG.gdx
$LOAD BAC_savings_period
$GDXIN

*-----------DH export season from MATLAB----------------------------------------
PARAMETERS
            DH_export_season(h)           Period in which DH exports are payed for
;
$GDXIN MtoG.gdx
$LOAD DH_export_season
$GDXIN

*---------Simulation option settings--------------------------------------------
PARAMETERS
            min_totCost_0      Option to run the base case scenario by minimizing tot cost
            min_totCost        Option to minimize total cost
            min_totPE          OPtion to minimize tottal PE use
            min_totCO2         OPtion to minimize total CO2 emission
            synth_baseline     Option for synthetic baseline
;
$GDXIN MtoG.gdx
$LOAD min_totCost_0
$LOAD min_totCost
$LOAD min_totPE
$LOAD min_totCO2
$load synth_baseline
$GDXIN

*---------CO2 and PE factors----------------------------------------------------
PARAMETERS
            CO2_peak_ref       reference peak CO2 emission
            CO2_max            Maximum CO2 emission in the base case
            PE_tot_ref         reference total PE use
            CO2F_PV            CO2 factor of solar PV
            PEF_PV             PE factor of solar PV
            CO2F_P1            CO2 factor of Panna1 (P1)
            PEF_P1             PE factor of Panna1 (P1)
            CO2F_P2            CO2 factor of Panna2 (P2)
            PEF_P2             PE factor of Panna2 (P2)
            CO2F_exG(h)        CO2 factor of the electricity grid
            PEF_exG(h)         PE factor of the electricity grid
            CO2F_DH(h)         CO2 av. factor of the district heating grid
            PEF_DH(h)          PE av. factor of the district heating grid
            MA_CO2F_DH(h)      CO2 marginal factor of the district heating grid
            MA_PEF_DH(h)       PE marginal factor of the district heating grid
            MA_CO2F_exG(h)     CO2 marginal factor of the electrical grid
            MA_PEF_exG(h)      PE marginal factor of the electrical grid
            max_exG_prev       max exG of previous dispatch
            MA_Cost_DH         DH marginal cost
;
$GDXIN MtoG.gdx
*$LOAD CO2_max
*$LOAD CO2_peak_ref
*$LOAD PE_tot_ref
$LOAD CO2F_PV
$LOAD PEF_PV
$LOAD CO2F_P1
$LOAD PEF_P1
$LOAD CO2F_P2
$LOAD PEF_P2
$LOAD CO2F_exG
$LOAD PEF_exG
$LOAD CO2F_DH
$LOAD PEF_DH
$LOAD MA_CO2F_DH
$LOAD MA_PEF_DH
$load MA_PEF_exG
$load MA_CO2F_exG
$load max_exG_prev
$load MA_Cost_DH
$GDXIN
*-----------Investmet limit----------------------------------------------------
parameters
            inv_lim            Maximum value of the investment in SEK
;
$GDXIN MtoG.gdx
$LOAD inv_lim
$GDXIN

*--------------Choice of investment options to consider-------------------------
PARAMETERS
         opt_fx_inv   option to fix investments
         opt_fx_inv_RMMC      options to fix the RMMC investment
         opt_fx_inv_AbsCInv_cap capacity of the new AbsChiller
         opt_fx_inv_P2        options to fix the P2 investment
         opt_fx_inv_TURB      options to fix the TURB investment
         opt_fx_inv_HP_cap    Capacity of the fixed new HP
         opt_fx_inv_RMInv_cap Capacity of the fixed new RM
         opt_fx_inv_TES_cap   capacity of the new TES
         opt_fx_inv_BES       options to fix investment in new BES
         opt_fx_inv_BES_cap   capacity of the new BES
         opt_fx_inv_BES_maxP    power factor limit of the new BES
         opt_fx_inv_BFCh       options to fix investment in new BFCh
         opt_fx_inv_BFCh_cap   capacity of the new BFCh
         opt_fx_inv_BFCh_maxP    power factor limit of the new BFCh
         opt_marg_factors        option to choose between marginal and average factors
;
$GDXIN MtoG.gdx
$LOAD opt_fx_inv
$LOAD opt_fx_inv_RMMC
$LOAD opt_fx_inv_AbsCInv_cap
$LOAD opt_fx_inv_P2
$LOAD opt_fx_inv_TURB
$LOAD opt_fx_inv_HP_cap
$LOAD opt_fx_inv_RMInv_cap
$LOAD opt_fx_inv_TES_cap
$LOAD opt_fx_inv_BES
$LOAD opt_fx_inv_BES_cap
$LOAD opt_fx_inv_BFCh
$LOAD opt_fx_inv_BFCh_cap
$LOAD opt_fx_inv_BES_maxP
$load opt_fx_inv_BFCh_maxP
$load opt_marg_factors
$GDXIN

*-------Initial SoC of Storage systems------*
Parameters
      opt_fx_inv_BES_init   BES Init. SoC
      opt_fx_inv_BFCh_init  BFCh Init. SoC
      opt_fx_inv_TES_init    TES Init. SoC
      opt_fx_inv_BTES_S_init  BTES_S Init. SoC
      opt_fx_inv_BTES_D_init  BTES_D Init. SoC
      Pana1_prev_disp
      Panna1
      FGC
      import
      export
      VKA1_prev_disp
      VKA4_prev_disp
      AAC_prev_disp
;
$GDXIN MtoG.gdx
$lOAD opt_fx_inv_BES_init
$lOAD opt_fx_inv_BFCh_init
$lOAD opt_fx_inv_TES_init
$lOAD opt_fx_inv_BTES_S_init
$lOAD opt_fx_inv_BTES_D_init
$load Pana1_prev_disp
$load Panna1
$load import
$load export
$load FGC
$load VKA1_prev_disp
$load VKA4_prev_disp
$load AAC_prev_disp
$GDXIN
*the combination is used to comment out sections codes inside
*$Ontext
parameters
B_Heating_cost(h,i)             heating cost of buildings
B_Electricity_cost(h,i_AH_el)   electricity cost of building
B_Cooling_cost(h,i_AH_c)       cooling cost of buildings
;
*$Offtext


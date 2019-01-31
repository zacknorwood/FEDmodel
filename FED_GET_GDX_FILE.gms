********************************************************************************
*-----------------------GENERATE or GET GDX FILES-------------------------------
*-------------------------------------------------------------------------------

*THIS ROUTINE IS USED TO READ INPUT DATA FROM MtoG USED IN THE MAIN MODEL IN GDX FORMAT

*----------Building IDs---------------------------------------------------------
set
    BID           Building ID used to define load points
h                SIMULATION TIME;

$GDXIN MtoG.gdx
$LOAD BID
$LOAD h

$GDXIN

*-----------Simulation time, BTES and BAC investments and parameters-----------
set
    BTES_Inv(BID)     used for fixed BTES inv option
    BAC_Inv(BID)       used for fixed BAC inv option
    BTES_properties  Building Inertia TES properties
;
parameter
    opt_fx_inv_BTES   Parameter used to indicate investment in BTES
    opt_fx_inv_BAC     Parameter used to indicate investment in BAC
;

$GDXIN MtoG.gdx
$LOAD BTES_Inv
$LOAD opt_fx_inv_BTES
$LOAD BAC_Inv
$LOAD opt_fx_inv_BAC
$LOAD BTES_properties
$GDXIN

*-----------DH heating nodes and mapping of the nodes with buildings------------
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

set DHNodeToBID(DH_Node_ID, BID)  Mapping between district heating nodes and buildings /Fysik.(O0007001, O3060132, O0007006, O3060133, O0011001, O0007005, O0013001),
                                                                                          Bibliotek.O0007017,
                                                                                          Maskin.(O0007028,O0007888),
                                                                                          EDIT.(O0007012,O0007024,O0007018,O0007022,O0007025,O0007021,SSPA,Studentbostader),
                                                                                          VoV.(Karhus_CFAB,Karhus_studenter,O0007019,O0007023,O0007026,O0007027),
                                                                                          Eklanda.O0007040/
*ITGYMNASIET belongs to Fysik node
*-----------DC heating nodes and mapping of nodes with buildings----------------
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

set DCNodeToBID(DC_Node_ID, BID)  Mapping between district cooling nodes and buildings /VoV.(O0007019,O0007023,O0007026,O0007027, Karhus_CFAB, Karhus_studenter),
                                                                                          Maskin.(O0007028,O0007888,O0007022,O0007025),
                                                                                          EDIT.(O0007012,O0007024,O0007018,O0007021),
                                                                                          Fysik.(O0007001, O0007006, O3060133, O0011001, O0007005),

                                                                                          Kemi.(O3060132,O0013001)/
;
*-------slack data and historical import and export data------------------------
PARAMETERS
           c_DC_slack(h)     DC_slack bus data
           h_DH_slack(h)     Slack bus for the DH
           el_exG_slack(h)   Slack bus for the external grid
           h_exp_AH_hist(h)  Historical exported heat AH
           h_imp_AH_hist(h)  Historical imported heat AH
;
$GDXIN MtoG.gdx
$LOAD c_DC_slack
$LOAD h_DH_slack
$LOAD el_exG_slack
$LOAD h_exp_AH_hist
$LOAD h_imp_AH_hist
$GDXIN

*--------------Building catagories based on how energy is supplied--------------
set BID_AH_el(BID)    buildings considered in the FED system connected the AH(Akadamiskahus) el netwrok
    BID_nonAH_el(BID) buildings considered in the FED system not connected to the AH(Akadamiskahus) el netwrok
    BID_AH_h(BID)     buildings considered in the FED system connected to the AH(Akadamiskahus) heat netwrok
    BID_nonAH_h(BID)  buildings considered in the FED system not connected to the AH(Akadamiskahus) heat netwrok
    BID_AH_c(BID)     buildings considered in the FED system connected to the AH(Akadamiskahus) cooling netwrok
    BID_nonAH_c(BID)  buildings considered in the FED system not connected to the AH(Akadamiskahus) cooling netwrok
    BID_nonBTES(BID) Buildings not applicable for BTES
;
$GDXIN MtoG.gdx
$LOAD BID_AH_el
$LOAD BID_nonAH_el
$LOAD BID_AH_h
$LOAD BID_nonAH_h
$LOAD BID_AH_c
$LOAD BID_nonAH_c
$LOAD BID_nonBTES
$GDXIN
*----Buses IDs of electrical network, Admittance matrix & current limits-------*
set BusID;

$GDXIN MtoG.gdx
$LOAD BusID
$GDXIN
alias(BusID,j);
set BusToBID(BusID,BID)  Mapping between buses and buildings
                             /15.O3060133, 5.O3060132, 21.O0007001, 11.(O0011001,O0013001,O0007005),
                              20.(O0007008,O0007888), 9.(O0007017,O0007006), 34.(O0007022,O0007025,O0007028), 32.(O0007024,O0007018,Studentbostader),
                              40.(O0007012,O0007021,O0007014), 30.O0007040, 24.(O0007019,Karhus_CFAB,Karhus_studenter), 26.(O0007023,O0007026), 28.(O0007027,O0007043)/
;
parameter Sb Base power (KW) /1000/;
parameter Ib Base current (A) /54.98/;
Parameter bij(BusID,j)
Parameter gij(BusID,j)
Parameter bii(BusID)
Parameter Y(BusID,j)             elements magnitudes of admittance matrix
Parameter Theta(BusID,j)         elements angles of admittance matrix
Parameter currentlimits(BusID,j) current limits
$GDXIN Input_dispatch_model\AdmittanceMatrix.gdx
$load gij
$load bij
$load bii
$LOAD currentlimits
$GDXIN

*----------------Solar PV data--------------------------------------------------
SET
    PVID        Building IDs used for PV calculations
;
$GDXIN MtoG.gdx
$LOAD PVID
$GDXIN

SET
    PVID_roof(PVID)   Buildings where solar PV invetment is made - roof
    PVID_facade(PVID) Buildings where solar PV invetment is made - facade
;
$GDXIN MtoG.gdx
$LOAD PVID_roof
$LOAD PVID_facade
$GDXIN

Parameter PV_roof_cap(PVID) Invested PV capacity-roof
          PV_facade_cap(PVID) Invested PV capacity-facade
*          PV_inverter_PF_Inv(PVID)            Invested PV roof inverters power factor
;
$GDXIN MtoG.gdx
$LOAD PV_roof_cap
$LOAD PV_facade_cap
*$load PV_inverter_PF_Inv
$GDXIN

*set BusToBID(BusID,BID)   Mapping between buses and BIDs
*                            /15.(6,44), 5.(54,55,53,4), 21.(52,43,47), 11.(40,50,51), 20.28, 9.(12,46,45), 34.(56,32,37,33,35),
*                             32.(29,9,19,20,22,8), 40.(18,60,1,36), 30.(68,70,69,62,65), 24.(57,25,24,11), 26.(10,48,49), 28.(23,27,75)/
;

*----------------PREPARE THE FULL INPUT DATA------------------------------------
SET
    m   Number of month                   /1*24/
    d   Number of days                    /1*731/
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
            G_facade(h,PVID)       irradiance on building facades
            area_facade_max(PVID)  irradiance on building facades
            G_roof(h,PVID)         irradiance on building facades
            area_roof_max(PVID)    irradiance on building facades
;
$GDXIN MtoG.gdx
$LOAD G_facade
$LOAD G_roof
$GDXIN
********************************************************************************

*-------------------Measured data in the base case------------------------------
PARAMETERS
            qB1(h)         Heat out from boiler 1 (Boiler1)
            qF1(h)         Heat out from FGC (Boiler1)
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

*-----------forecasted Demand data from MATLAB-----------------------------------
PARAMETERS
           el_demand(h,BID)    ELECTRICITY DEMAND IN THE FED BUILDINGS
           h_demand(h,BID)     Heating DEMAND IN THE FED BUILDINGS
           c_demand(h,BID)     Cooling DEMAND IN THE FED BUILDINGS
           cool_demand(h)       Total cooling demand
           heat_demand(h)       Total heat demand
           elec_demand(h)       Total elec. demand
;
$GDXIN MtoG.gdx
$LOAD el_demand
$LOAD h_demand
$LOAD c_demand
$GDXIN
*-----------forecasted energy prices from MATLAB---------------------------------
PARAMETERS
           el_price(h)       ELECTRICTY PRICE IN THE EXTERNAL GRID
           el_certificate(h) Electricity certificate for selling renewable energy (SEK per kWh)
           h_price(h)        Heat PRICE IN THE IN THE EXTERNAL DH SYSTEM
;
$GDXIN MtoG.gdx
$LOAD el_price
$LOAD el_certificate
$LOAD h_price
$GDXIN

*-----------forecasted outdoor temprature from MATLAB----------------------------
PARAMETERS
            tout(h)               OUTDOOR TEMPERATURE
;
$GDXIN MtoG.gdx
$LOAD tout
$GDXIN

*-----------BTES model from MATLAB---------------------------------------------
PARAMETERS
            BTES_model(BTES_properties,BID) BUILDING INERTIA TES PROPERTIES
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
            BAC_savings_factor(h)         Savings factor for BAC
;
$GDXIN MtoG.gdx
$LOAD BAC_savings_period
$LOAD BAC_savings_factor
$GDXIN

*-----------DH export season from MATLAB----------------------------------------
PARAMETERS
            DH_export_season(h)           Period in which DH exports are payed for
;
$GDXIN MtoG.gdx
$LOAD DH_export_season
$GDXIN

*-----------DH heating season from MATLAB---------------------------------------
PARAMETERS
            DH_heating_season(h)           Period in which DH exports are payed for
;
$GDXIN MtoG.gdx
$LOAD DH_heating_season
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
            CO2F_Boiler1            CO2 factor of Boiler1 (P1)
            PEF_Boiler1             PE factor of Boiler1 (P1)
            CO2F_Boiler2            CO2 factor of Boiler2 (P2)
            PEF_Boiler2             PE factor of Boiler2 (P2)
            CO2F_exG(h)        CO2 factor of the electricity grid
            PEF_exG(h)         PE factor of the electricity grid
            CO2F_DH(h)         CO2 av. factor of the district heating grid
            PEF_DH(h)          PE av. factor of the district heating grid
*            MA_CO2F_DH(h)      CO2 marginal factor of the district heating grid
*            MA_PEF_DH(h)       PE marginal factor of the district heating grid
*            MA_CO2F_exG(h)     CO2 marginal factor of the electrical grid
*            MA_PEF_exG(h)      PE marginal factor of the electrical grid
*            max_exG_prev       max exG of previous dispatch
            MA_Cost_DH         DH marginal cost
;
$GDXIN MtoG.gdx
$LOAD CO2F_PV
$LOAD PEF_PV
$LOAD CO2F_Boiler1
$LOAD PEF_Boiler1
$LOAD CO2F_Boiler2
$LOAD PEF_Boiler2
$LOAD CO2F_exG
$LOAD PEF_exG
$LOAD CO2F_DH
$LOAD PEF_DH
*$LOAD MA_CO2F_DH
*$LOAD MA_PEF_DH
*$load MA_PEF_exG
*$load MA_CO2F_exG
*$load max_exG_prev
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
         opt_fx_inv             option to fix investments
         opt_fx_inv_RMMC        options to fix the RMMC investment
         opt_fx_inv_AbsCInv_cap capacity of the new AbsChiller
         opt_fx_inv_Boiler2          options to fix the P2 investment
         opt_fx_inv_TURB        options to fix the TURB investment
         opt_fx_inv_HP_cap      Capacity of the fixed new HP
         opt_fx_inv_RMInv_cap   Capacity of the fixed new RM
         opt_fx_inv_TES_cap     capacity of the new TES
         opt_fx_inv_BES         options to fix investment in new BES
         opt_fx_inv_BES_cap     capacity of the new BES
         opt_fx_inv_BES_maxP    power factor limit of the new BES
         opt_fx_inv_BFCh        options to fix investment in new BFCh
         opt_fx_inv_BFCh_cap    capacity of the new BFCh
         opt_fx_inv_BFCh_maxP   power factor limit of the new BFCh
*         opt_marg_factors       option to choose between marginal and average factors
;
$GDXIN MtoG.gdx
$LOAD opt_fx_inv
$LOAD opt_fx_inv_RMMC
$LOAD opt_fx_inv_AbsCInv_cap
$LOAD opt_fx_inv_Boiler2
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
*$load opt_marg_factors
$GDXIN

*-------Initial SoC of Storage systems------*
Parameters
      opt_fx_inv_BES_init    BES Init. SoC
      opt_fx_inv_BFCh_init   BFCh Init. SoC
*      opt_fx_inv_TES_init    TES Init. SoC
      opt_fx_inv_BTES_S_init(h,BID) BTES_S Init. SoC
      opt_fx_inv_BTES_D_init(h,BID) BTES_D Init. SoC
      Boiler1_prev_disp      Boiler1 previous dispatch
      Boiler2_prev_disp      Boiler2 previous dispatch
*      Boiler1                 Boiler1 forecast?
*      FGC                    FGC forecast?
*      import                 Import forecast?
*      export                 Export forecast?
*      VKA1_prev_disp         Previous dispatch of VKA1
*      VKA4_prev_disp         Previous dispatch of VKA4
*      AAC_prev_disp          Previous dispatch of AAC
;
$GDXIN MtoG.gdx
$load opt_fx_inv_BES_init
$load opt_fx_inv_BFCh_init
*$load opt_fx_inv_TES_init
$load opt_fx_inv_BTES_S_init
$load opt_fx_inv_BTES_D_init
$load Boiler1_prev_disp
$load Boiler2_prev_disp
*$load Boiler1
*$load import
*$load export
*$load FGC
*$load VKA1_prev_disp
*$load VKA4_prev_disp
*$load AAC_prev_disp
$GDXIN
*the combination is used to comment out sections codes inside

parameters
B_Heating_cost(h,BID)             heating cost of buildings
B_Electricity_cost(h,BID_AH_el)   electricity cost of building
B_Cooling_cost(h,BID_AH_c)        cooling cost of buildings
;




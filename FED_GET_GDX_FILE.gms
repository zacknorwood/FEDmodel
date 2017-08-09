******************************************************************************
*-----------------------GENERATE or GET GDX FILES-------------------------------
*-------------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GET INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*-If there is change in any of the input data (see the parameter list below), run 'FED_GENERATE_GDX_FILE' to update 'FED_INPUT_DATA'
*----------------Load input parameters of the model-----------------------------
SET h0  length of the input data in hours
    b0  buildings considered in the FED system
    m0  Number of month
    d0  Number of days
    BID Building IDs used for PV calculations
    BTES_properties0  Building Inertia TES properties
;

$GDXIN FED_INPUT_DATA.gdx
$LOAD h0
$LOAD b0
$LOAD m0
$LOAD d0
$LOAD BID
$LOAD BTES_properties0
$GDXIN

*load date vectors for power tariffs
PARAMETERS  HoD(h0,d0)        Hour of the day
            HoM(h0,m0)        Hour of the month
            el_demand0(h0,b0) ELECTRICITY DEMAND IN THE FED BUILDINGS
            q_demand0(h0,b0)  Heating DEMAND IN THE FED BUILDINGS
            k_demand0(h0,b0)  Heating DEMAND IN THE FED BUILDINGS
            el_price0(h0)     ELECTRICTY PRICE IN THE EXTERNAL GRID
            q_price0(h0)      ELECTRICTY PRICE IN THE IN THE EXTERNAL DH SYSTEM
            tout0(h0)         OUT DOOR TEMPRATTURE
            G_facade(h0,BID)  irradiance on building facades
            area_facade_max(BID) irradiance on building facades
            G_roof(h0,BID)    irradiance on building facades
            area_roof_max(BID) irradiance on building facades
            nPV_el0(h0)       ELECTRICTY OUTPUT FROM A UNIT PV PANAEL
            BTES_model0(BTES_properties0,b0) BUILDING INERTIA TES PROPERTIES
            PEF_DH0(h0)       PE FACTOR of external DH system
            PEF_exG0(h0)      PE FACTOR of external electrical system
            CO2F_DH0(h0)      CO2 FACTOR of external DH system
            CO2F_exG0(h0)     CO2 FACTOR of external ELECTRICTY GRID

;
$GDXIN FED_INPUT_DATA.gdx
$LOAD HoD
$LOAD HoM
$LOAD el_demand0
$LOAD q_demand0
$LOAD k_demand0
$LOAD el_price0
$LOAD q_price0
$LOAD tout0
$LOAD G_facade
$LOAD area_facade_max
$LOAD G_roof
$LOAD area_roof_max
$LOAD nPV_el0
$LOAD BTES_model0
$GDXIN
display el_demand0,q_demand0, k_demand0;

parameters  FED_PE_base        Primary energy use in the FED system in the base case
            FED_CO2Peak_base   Peak CO2 emission in the FED system in the base case
            CO2F_PV            CO2 factor of solar PV
            PEF_PV             PE factor of solar PV
            CO2F_P1            CO2 factor of Panna1 (P1)
            PEF_P1             PE factor of Panna1 (P1)
            CO2F_P2            CO2 factor of Panna1 (P2)
            PEF_P2             PE factor of Panna1 (P2)
            CO2F_exG(h0)       CO2 factor of the electricity grid
            PEF_exG(h0)        PE factor of the electricity grid
            CO2F_DH(h0)        CO2 factor of the electricity grid
            PEF_DH(h0)         PE factor of the electricity grid
            q_p1_TB0(h0)       PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
            q_p1_FGC0(h0)      SECONDARY HEAT PRODUCED FROM THE THERMAL BOILER (FUEL GAS CONDENCER)
            fuel_P1(h0)        Input fuel of THE THERMAL BOILER
            min_totCost        Option to minimize total cost
            min_invCost        OPtion to minimize investment cost
            min_totCO2         OPtion to minimize total CO2 emission
            CO2_ref            Reference value of CO2 peak
            inv_lim            Maximum value of the investment in SEK
;
$GDXIN MtoG.gdx
$LOAD FED_PE_base
$LOAD FED_CO2Peak_base
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
$LOAD q_p1_TB
$LOAD q_p1_FGC
$LOAD fuel_P1
$LOAD min_totCost
$LOAD min_invCost
$LOAD min_totCO2
$LOAD CO2_ref
$LOAD inv_lim
$GDXIN

display min_totCost,min_invCost, min_totCO2
        HoD, HoM,
        el_demand0, q_demand0, k_demand0,
        q_p1_TB0, q_p1_FGC0,
        el_price0, q_price0, tout0,
        G_facade, area_facade_max, G_roof, area_roof_max, nPV_el0,
        BTES_model0,
        FED_PE_base, FED_CO2Peak_base,
        CO2F_PV, PEF_PV, CO2F_P1, PEF_P1, CO2F_P2, PEF_P2,
        CO2F_exG,PEF_exG,CO2F_DH,PEF_DH;

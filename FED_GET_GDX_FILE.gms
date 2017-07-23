******************************************************************************
*-----------------------GENERATE GDX FILES------------------------------------
*-----------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GET INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA-------------------------------
SET h0  length of the input data in hours /H1*H8760/
    b0  number of buildings considered    /1*30/
    m0  Number of month                  /M1*M12/
    d0  Number of days                   /D1*D365/

    BTES_properties0  Building Inertia TES properties
                      /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                      kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/
;

*load date vectors for power tariffs
PARAMETERS  HoD(h0,d0)        Hour of the day
PARAMETERS  HoM(h0,m0)        Hour of the month
PARAMETERS  el_demand0(h0,b0) ELECTRICITY DEMAND IN THE FED BUILDINGS
PARAMETERS  q_demand0(h0,b0)  Heating DEMAND IN THE FED BUILDINGS
PARAMETERS  k_demand0(h0,b0)  Heating DEMAND IN THE FED BUILDINGS
Parameter   q_p1_DH0(h0)      PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
Parameter   q_p1_FGC0(h0)     SECONDARY HEAT PRODUCED FROM THE THERMAL BOILER (FUEL GAS CONDENCER)
Parameter   el_price0(h0)     ELECTRICTY PRICE IN THE EXTERNAL GRID
Parameter   q_price0(h0)      ELECTRICTY PRICE IN THE IN THE EXTERNAL DH SYSTEM
Parameter   tout0(h0)         OUT DOOR TEMPRATTURE
PARAMETERS  G_facade(h0,BID)  irradiance on building facades
PARAMETERS  area_facade_max(BID) irradiance on building facades
PARAMETERS  G_roof(h0,BID)    irradiance on building facades
PARAMETERS  area_roof_max(BID) irradiance on building facades
Parameter   nPV_el0(h0)       ELECTRICTY OUTPUT FROM A UNIT PV PANAEL
parameter   BTES_model0(BTES_properties0,b0) BUILDING INERTIA TES PROPERTIES
Parameter   PEF_DH0(h0)       PE FACTOR of external DH system
Parameter   PEF_exG0(h0)      PE FACTOR of external electrical system
Parameter   CO2F_DH0(h0)      CO2 FACTOR of external DH system
Parameter   CO2F_exG0(h0)     CO2 FACTOR of external ELECTRICTY GRID

;
$GDXIN FED_INPUT_DATA.gdx
$LOAD HoD
$LOAD HoM
$LOAD el_demand0
$LOAD q_demand0
$LOAD k_demand0
$LOAD q_p1_DH0
$LOAD q_p1_FGC0
$LOAD el_price0
$LOAD q_price0
$LOAD tout0
$LOAD nPV_el0
$LOAD BTES_model0
$GDXIN

parameters  FED_PE_base        Primary energy use in the FED system in the base case
            FED_CO2Peak_base   Peak CO2 emission in the FED system in the base case
            CO2F_exG(h0)       CO2 factor of the electricity grid
            PEF_exG(h0)        PE factor of the electricity grid
            CO2F_DH(h0)       CO2 factor of the electricity grid
            PEF_DH(h0)        PE factor of the electricity grid
;
$GDXIN MtoG.gdx
$LOAD FED_PE_base
$LOAD FED_CO2Peak_base
$LOAD CO2F_exG
$LOAD PEF_exG
$LOAD CO2F_DH
$LOAD PEF_DH
$GDXIN

display FED_PE_base, FED_CO2Peak_base,CO2F_exG,PEF_exG,CO2F_DH,PEF_DH;



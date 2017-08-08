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

*----------------Load input parameters of the model-----------------------------
SET h0  length of the input data in hours /1*8760/
    b0  buildings considered in the FED system    /O0007001-Fysikorigo, O0007005-Polymerteknologi
                                           O0007006-NyaMatte,  O0007012-Elkraftteknik,
                                           O0007014-GibraltarHerrgrd, O0007017-Chalmersbibliotek,
                                           O0007018-Idelra,  O0007019-CentralaAdministrationen,
                                           O0007021-HrsalarHC,  O0007022-HrsalarHA,
                                           O0007023-Vg-och-vatten1,   O0007024-EDIT,
                                           O0007025-HrsalarHB,   O0007026-Arkitektur,
                                           O0007027-Vg-och-vatten2, O0007028-Maskinteknik,
                                           O0007040-GamlaMatte,  O0007043-PhusCampusJohanneberg,
                                           O0007888-LokalkontorAH, O0011001-FysikSoliden,
                                           O0013001-Keramforskning, O3060132-Kemi-och-bioteknik-cfab,
                                           O3060133-FysikMC2,  O3060150_1-Krhuset,
                                           O3060137-CTP,  O3060138-JSP, O3060101-Vasa1,
                                           O3060102_3-Vasa-2-3, O3060104_15-Vasa-4-15, O4002700-Chabo
                                          /
    m0  Number of month                  /1*12/
    d0  Number of days                   /1*365/
    BID Building IDs used for PV calculations /1*70/

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
Parameter   q_p1_TB0(h0)      PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
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
$LOAD q_p1_TB0
$LOAD q_p1_FGC0
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
            min_totCost        Option to minimize total cost
            min_invCost        OPtion to minimize investment cost
            min_totCO2         OPtion to minimize total CO2 emission
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
$LOAD min_totCost
$LOAD min_invCost
$LOAD min_totCO2
$GDXIN

display HoD, HoM,
        el_demand0, q_demand0, k_demand0,
        q_p1_TB0, q_p1_FGC0,
        el_price0, q_price0, tout0,
        G_facade, area_facade_max, G_roof, area_roof_max, nPV_el0,
        BTES_model0,
        FED_PE_base, FED_CO2Peak_base,
        CO2F_PV, PEF_PV, CO2F_P1, PEF_P1, CO2F_P2, PEF_P2,
        CO2F_exG,PEF_exG,CO2F_DH,PEF_DH;

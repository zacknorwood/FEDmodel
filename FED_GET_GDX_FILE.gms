********************************************************************************
*-----------------------GENERATE or GET GDX FILES-------------------------------
*-------------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GET INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*-If there is change in any of the input data (see the parameter list below), run 'FED_GENERATE_GDX_FILE' to update 'FED_INPUT_DATA'
*----------------Load input parameters of the model-----------------------------

SET h0         length of the input data in hours
    i          buildings considered in the FED system
    m          Number of month
    d          Number of days
    BID        Building IDs used for PV calculations
    BTES_properties  Building Inertia TES properties
;

$GDXIN Input_data_FED_SIMULATOR\FED_INPUT_DATA.gdx
$LOAD h0
$LOAD i
$LOAD m
$LOAD d
$LOAD BID
$LOAD BTES_properties
$GDXIN

set i_AH_el(i) buildings considered in the FED system connected the AH el netwrok
                                          /Kemi, Phus,
                                           Bibliotek, NyaMatte, Studentbostader, Kraftcentral,
                                           Lokalkontor, Karhus_CFAB, CAdministration, GamlaMatte, Gibraltar_herrgard,
                                           HA, HB, Elkraftteknik, HC, Maskinteknik,
                                           Fysik_Origo, MC2, Edit, Polymerteknologi, Keramforskning,
                                           Fysik_Soliden, Idelara,
                                           VOV1, Arkitektur, VOV2, Karhus_studenter
                                          /
    i_nonAH_el(i) buildings considered in the FED system not connected the AH el netwrok
                                          /Vassa1, Vassa2-3, Vassa4-15,
                                           SSPA,
                                           CTP, Karhuset, JSP,
                                           Chabo
                                          /
    i_AH_h(i) buildings considered in the FED system connected the AH heat netwrok
                                          /Kemi, Phus,
                                           Bibliotek, SSPA, NyaMatte, Studentbostader, Kraftcentral,
                                           Lokalkontor, Karhus_CFAB, CAdministration, GamlaMatte,
                                           HA, HB, Elkraftteknik, HC, Maskinteknik,
                                           Fysik_Origo, MC2, Edit, Polymerteknologi, Keramforskning,
                                           Fysik_Soliden, Idelara,
                                           VOV1, Arkitektur, VOV2, Karhus_studenter
                                          /
    i_nonAH_h(i) buildings considered in the FED system not connected the AH heat netwrok
                                          /Vassa1, Vassa2-3, Vassa4-15,
                                           Gibraltar_herrgard,
                                           CTP, Karhuset, JSP,
                                           Chabo
                                          /
    i_AH_c(i) buildings considered in the FED system connected the AH cooling netwrok
                                          /Kemi, Phus,
                                           Bibliotek, NyaMatte, Kraftcentral,
                                           Lokalkontor, Karhus_CFAB, CAdministration,
                                           HA, HB, Elkraftteknik, HC, Maskinteknik,
                                           Fysik_Origo, MC2, Edit, Keramforskning,
                                           Fysik_Soliden, Idelara,
                                           VOV1, Arkitektur, VOV2, Karhus_studenter
                                          /
    i_nonAH_c(i) buildings considered in the FED system not connected the AH cooling netwrok
                                          /Vassa1, Vassa2-3, Vassa4-15,
                                           Studentbostader, SSPA,
                                           Polymerteknologi,
                                           GamlaMatte, Gibraltar_herrgard,
                                           CTP, Karhuset, JSP,
                                           Chabo
                                          /
    i_nonBITES(i)         Buildings not applicable for BITES
                                         / Phus, SSPA, Studentbostader, Karhus_CFAB,
                                           Gibraltar_herrgard, Polymerteknologi,Idelara,
                                           CTP, Karhuset, JSP, Karhus_studenter
                                         /
;
*********************SET THE SIMULATION TIME HERE*******************************
set h(h0) SIMULATION TIME /1*8760/;

PARAMETERS  HoD(h,d)       Hour of the day
            HoM(h,m)       Hour of the month
            el_demand(h,i) ELECTRICITY DEMAND IN THE FED BUILDINGS
            h_demand(h,i)  Heating DEMAND IN THE FED BUILDINGS
            c_demand(h,i)  Cooling DEMAND IN THE FED BUILDINGS
            el_price(h)    ELECTRICTY PRICE IN THE EXTERNAL GRID
            h_price(h)     Heat PRICE IN THE IN THE EXTERNAL DH SYSTEM
            tout(h)               OUT DOOR TEMPRATTURE
            G_facade(h,BID)       irradiance on building facades
            area_facade_max(BID)  irradiance on building facades
            G_roof(h,BID)         irradiance on building facades
            area_roof_max(BID)    irradiance on building facades
            nPV_el(h)             ELECTRICTY OUTPUT FROM A UNIT PV PANAEL
            BTES_model(BTES_properties,i) BUILDING INERTIA TES PROPERTIES
;
$GDXIN Input_data_FED_SIMULATOR\FED_INPUT_DATA.gdx
$LOAD HoD
$LOAD HoM
$LOAD el_demand
$LOAD h_demand
$LOAD c_demand
$LOAD el_price
$LOAD h_price
$LOAD tout
$LOAD G_facade
$LOAD area_facade_max
$LOAD G_roof
$LOAD area_roof_max
$LOAD nPV_el
$LOAD BTES_model
$GDXIN

parameters  FED_PE0            Primary energy use in the FED system in the base case
            FED_CO20           Peak CO2 emission in the FED system in the base case
            CO2F_PV            CO2 factor of solar PV
            PEF_PV             PE factor of solar PV
            CO2F_P1            CO2 factor of Panna1 (P1)
            PEF_P1             PE factor of Panna1 (P1)
            CO2F_P2            CO2 factor of Panna2 (P2)
            PEF_P2             PE factor of Panna2 (P2)
            CO2F_exG(h)       CO2 factor of the electricity grid
            PEF_exG(h)        PE factor of the electricity grid
            CO2F_DH(h)        CO2 factor of the district heating grid
            PEF_DH(h)         PE factor of the district heating grid
            q_p1_TB(h)        Heat generated by the boiler Panna1
            q_p1_FGC(h)       Heat generated by the flue gas condenser connected to Panna1
            P1_eff             Efficiency of Panna1 (assumed to be the same for the boiler and condenser)
            fuel_P1(h)        Input fuel to Panna1
*            q0_AbsC(h)        Input heat to the existing AbsC
*            e0_AAC(h)         Input electricty to the existing Ambient Air Cooler
*            e0_VKA1(h)        Input electricty to the existing heat pump (VKA1)
*            e0_VKA4(h)        Input electricty to the existing heat pump (VKA4)
            min_totCost0       Option for base case calculation
            min_totCost        Option to minimize total cost
            min_totPE          OPtion to minimize tottal PE use
            min_totCO2         OPtion to minimize total CO2 emission
            min_totPECO2       OPtion to minimize both total PE use and CO2 emission
            min_peakCO2        OPtion to minimize peak CO2 emission
            CO2_ref            Reference value of CO2 peak
            inv_lim            Maximum value of the investment in SEK
            p1_dispach         Option to dispatch Panna1 or not
;
$GDXIN MtoG.gdx
$LOAD FED_PE0
$LOAD FED_CO20
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
$LOAD P1_eff
*$LOAD q0_AbsC
*$LOAD e0_AAC
*$LOAD e0_VKA1
min_totCost0 = 0;
*$LOAD e0_VKA4
*$LOAD min_totCost0

$LOAD min_totCost
$LOAD min_totPE
$LOAD min_totCO2
$LOAD min_totPECO2
$LOAD min_peakCO2
$LOAD CO2_ref
$LOAD inv_lim
$LOAD p1_dispach
$GDXIN



$Ontext

$Offtext

******************************************************************************
*-----------------------GENERATE GDX FILES------------------------------------
*-----------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GENERATE INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA-------------------------------
SET h0 length of the input data in hours /1*8760/
    b0 buildings considered in the FED system
                                          /O0007001-Fysikorigo, O0007005-Polymerteknologi
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
    BID Building IDs used for PV calculations /1*70, 75, 76/
;
display BID
*----------------load date vectors for power tariffs----------------------------
PARAMETERS  HoD(h0,d0)      Hour of the day
PARAMETERS  HoM(h0,m0)      Hour of the month
;
$GDXIN Input_data_FED_SIMULATOR\FED_date_vector.gdx
$LOAD HoD
$LOAD HoM
$GDXIN
display HoD, HoM;
*----------------Load FED electricty demand-------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_el_demand.xlsx par=el_demand0 rng=el_demand_2016_gams!A1:AE8761
PARAMETERS  el_demand0(h0,b0)      ELECTRICITY DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_el_demand.gdx
$LOAD el_demand0
$GDXIN
el_demand0(h0,b0)=1000*el_demand0(h0,b0);
display el_demand0;
*----------------Load FED heat demand-------------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_heat_demand.xlsx par=q_demand0 rng=heat_demand_2016_gams!A1:AE8761
PARAMETERS  q_demand0(h0,b0)      Heating DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_heat_demand.gdx
$LOAD q_demand0
$GDXIN
q_demand0(h0,b0)=1000*q_demand0(h0,b0);
display q_demand0;
*----------------Load FED cooling demand----------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_cooling_demand.xlsx par=k_demand0 rng=cooling_demand_2016_gams!A1:AE8761
PARAMETERS  k_demand0(h0,b0)      COOLING DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_cooling_demand.gdx
$LOAD k_demand0
$GDXIN
k_demand0(h0,b0)=1000*k_demand0(h0,b0);
display k_demand0;
*----------------HEAT GENERATION FROM THERMAL BOILER (TB) AND FUEL GAS CONDENCER (FGC)

*$call =xls2gms "I=Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx" R=tb_2016_est_gams!A4:B8765 "O=q_P1_TB0.gdx"
*Parameter q_P1_TB0(h0) PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
*/
*$include q_P1_TB0.gdx
*/;
*display q_P1_TB0;

*$call =xls2gms "I=Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx" R=fgc_2016_est_gams!A4:B8765 "O=q_P1_FGC0.gdx"
*Parameter q_P1_FGC0(h0) SECONDARY HEAT PRODUCED FROM THE THERMAL BOILER
*/
*$include q_P1_FGC0.gdx
*/;
*display q_P1_FGC0;
*----------------ELECTRICITY PRICE----------------------------------------------

$call =xls2gms "I=Input_data_FED_SIMULATOR\el_heat_price_2016.xlsx" R=el_price_2016_gams!A2:B8761 "O=el_price0.gdx"
Parameter el_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include el_price0.gdx
/;
display el_price0;
*----------------HEAT PRICE-----------------------------------------------------

*$call =xls2gms "I=Input_data_FED_SIMULATOR\el_heat_price_2016.xlsx" R=heat_price_2012_gams!A2:B8761 "O=q_price0.gdx"
Parameter q_price0(h0) HEAT PRICE IN THE EXTERNAL DH SYSTEM
q_price0(h0)           heat price by Goteborg Energi in 2016 sek per kWh
          /1*2184       0.519
           2185*2904    0.357
           2905*6576    0.099
           6577*8040    0.357
           8041*8760    0.519
          /
;
*/
*$include q_price0.gdx
*/;
display q_price0;
*----------------outdoor temprature---------------------------------------------

$call =xls2gms "I=Input_data_FED_SIMULATOR\tout_2016.xlsx" R=tout_2016_gams!A2:E8761 "O=tout0.gdx"
Parameter tout0(h0) outdoor temperature as obtained from metry
/
$include tout0.gdx
/;
display tout0;
*----------------PV data--------------------------------------------------------

*Load facade solar irradiance
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceFacades.xlsx Squeeze=N par=G_facade rng='TotalFlux(kWhperm2)'!A1:BU8785 trace=3
PARAMETERS  G_facade(h0,BID) irradiance on building facades;
$GDXIN irradianceFacades.gdx
$LOAD G_facade
$GDXIN
display G_facade;

*Load facade areas
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceFacades.xlsx o=FacadesArea.gdx par=area_facade_max cdim=1 rng=='Area(m2)'!A1:BT2 trace=3
PARAMETERS  area_facade_max(BID) area of building facades;
$GDXIN FacadesArea.gdx
$LOAD area_facade_max
$GDXIN
display area_facade_max;

*Load roof solar irradiance
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceRoofs.xlsx Squeeze=N par=G_roof rng='TotalFlux(kWhperm2)'!A1:BU8785 trace=3
PARAMETERS  G_roof(h0,BID) irradiance on building roofs;
$GDXIN irradianceRoofs.gdx
$LOAD G_roof
$GDXIN
display G_roof;

*Load roof areas
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceRoofs.xlsx o=RoofsArea.gdx par=area_roof_max cdim=1 rng=='Area(m2)'!A1:BT2 trace=3
PARAMETERS  area_roof_max(BID) area of building roof;
$GDXIN RoofsArea.gdx
$LOAD area_roof_max
$GDXIN
display area_roof_max;

*Normalized PV irradiance used for existing PV
$call =xls2gms "I=Input_data_FED_SIMULATOR\pv_data.xlsx" R=Irradiance!A2:B8760 "O=nPV_el0.gdx";
Parameter nPV_el0(h0) Electricty generated by a PV having 1 kW capacity
/
$include nPV_el0.gdx;
/;
display nPV_el0;
*----------------Building INERTIA storage parameters(=BS_cap, BD_cap, BS_ch_max, BS_dis_max,)

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\UFO_TES.xlsx par=BTES_model0 rng=BITES_gams!A1:AE10
set
    BTES_properties0  Building Inertia TES properties
                         /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                          kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/;

parameter BTES_model0(BTES_properties0,b0);
$GDXIN UFO_TES.gdx
$LOAD BTES_model0
$GDXIN
display BTES_model0;
**********************xxxxxxxxxxxxxxxxxxxxxxxxxxxx******************************

*----------------Store input data as GDX to be used in the rest of the routines-
execute_unload 'Input_data_FED_SIMULATOR\FED_INPUT_DATA'
                            h0, b0, m0, d0, BID, BTES_properties0,
                            HoD, HoM,
                            el_demand0, q_demand0, k_demand0,
                            el_price0, q_price0,
                            tout0,
                            nPV_el0,
                            G_facade, area_facade_max, G_roof, area_roof_max,
                            BTES_model0;




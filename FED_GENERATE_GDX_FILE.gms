******************************************************************************
*-----------------------GENERATE GDX FILES--------------------------------------
*-------------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GENERATE INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA------------------------------------
SET h0 length of the input data in hours  /1*17520/
    i buildings considered in the FED system
                                          /Kemi, Vassa1, Vassa2-3, Vassa4-15, Phus,
                                           Bibliotek, SSPA, NyaMatte, Studentbostader, Kraftcentral,
                                           Lokalkontor, Karhus_CFAB, CAdministration, GamlaMatte, Gibraltar_herrgard,
                                           HA, HB, Elkraftteknik, HC, Maskinteknik,
                                           Fysik_Origo, MC2, Edit, Polymerteknologi, Keramforskning,
                                           Fysik_Soliden, Idelara, CTP, Karhuset, JSP,
                                           VOV1, Arkitektur, VOV2, Karhus_studenter, Chabo
                                          /
    m   Number of month                   /1*24/
    d   Number of days                    /1*730/
    BID Building IDs used for PV calculations /1*70, 75, 76/
;

*----------------load date vectors for power tariffs----------------------------

PARAMETERS  HoD(h0,d)      Hour of the day
PARAMETERS  HoM(h0,m)      Hour of the month
;
$GDXIN Input_data_FED_SIMULATOR\FED_date_vector.gdx
$LOAD HoD
$LOAD HoM
$GDXIN
*----------------Load FED electricty demand-------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_el_demand_new.xlsx par=el_demand rng=2016_2017_el_gams!A1:AJ17520
PARAMETERS  el_demand(h0,i)      ELECTRICITY DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_el_demand_new.gdx
$LOAD el_demand
$GDXIN
*----------------Load FED heat demand-------------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_heat_demand_new.xlsx par=h_demand rng=2016_2017_h_gams!A1:AJ17520
PARAMETERS  h_demand(h0,i)      Heating DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_heat_demand_new.gdx
$LOAD h_demand
$GDXIN
*----------------Load FED cooling demand----------------------------------------

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\FED_cooling_demand_new.xlsx par=c_demand rng=2016_2017_c_gams!A1:AJ17520
PARAMETERS  c_demand(h0,i)      Cooling DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_cooling_demand_new.gdx
$LOAD c_demand
$GDXIN
*----------------HEAT GENERATION FROM THERMAL BOILER (TB) AND FUEL GAS CONDENCER (FGC)

$call =xls2gms "I=Input_data_FED_SIMULATOR\Panna1 2016-2017.xls" R=2016_2017_qB!A4:B17523 "O=qB1.gdx"
Parameter qB1(h0) PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
/
$include qB1.gdx
/;
qB1(h0)=1000*qB1(h0);
$call =xls2gms "I=Input_data_FED_SIMULATOR\Panna1 2016-2017.xls" R=2016_2017_qF!A4:B17523 "O=qF1.gdx"
Parameter qF1(h0) PRIMARY HEAT PRODUCED FROM THE FUEL GAS CONDENCER
/
$include qF1.gdx
/;
qF1(h0)=1000*qF1(h0);
Parameter h_P1(h0) Total HEAT PRODUCED FROM Panna1
;
h_P1(h0)=qB1(h0) + qF1(h0);
*----------------ELECTRICITY PRICE----------------------------------------------

$call =xls2gms "I=Input_data_FED_SIMULATOR\el_price_2016-2017.xlsx" R=el_price_gams!A2:B17521 "O=el_price.gdx"
Parameter el_price(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include el_price.gdx
/;

*******el cirtificate price*****************************************************
Parameter el_cirtificate(h0) Electricity cirtificate for selling renewable energy sek per kwh
el_cirtificate(h0)           Electricity cirtificate for selling renewable energy sek per kwh
          /1*745       0.0277
           746*1441    0.0181
           1442*2185   0.021
           2186*2905   0.0216
           2906*3648   0.0201
           3649*4369   0.0168
           4370*5113   0.0169
           5114*5857   0.018
           5858*6577   0.0179
           6578*7321   0.0365
           7322*8041   0.0349
           8042*8760   0.0313
           8761*8935   0.0277
           8936*9631   0.0181
           9632*10375  0.021
           10376*11095 0.0216
           11096*11838 0.0201
           11839*12559 0.0168
           12560*13303 0.0169
           13304*14047 0.018
           14048*14768 0.0179
           14769*15512 0.0365
           15513*16232 0.0349
           16233*17520 0.0313
          /
;

*----------------HEAT PRICE-----------------------------------------------------

Parameter h_price(h0) HEAT PRICE IN THE EXTERNAL DH SYSTEM
h_price(h0)           heat price by Goteborg Energi in 2016 (NB: 2017 is a copy of 2016) sek per kWh
          /1*2184       0.519
           2185*2904    0.357
           2905*6576    0.099
           6577*8040    0.357
           8041*8760    0.519
           8761*10944   0.519
           10945*11664  0.357
           11665*15336  0.099
           15337*16800  0.357
           16801*17520  0.519
          /
;
*----------------outdoor temprature---------------------------------------------

$call =xls2gms "I=Input_data_FED_SIMULATOR\tout_2016-2017_new.xlsx" R=tout_2016-2017_gams!A2:B17521 "O=tout.gdx"
Parameter tout(h0) outdoor temperature as obtained from metry
/
$include tout.gdx
/;
*----------------PV data--------------------------------------------------------

*Load facade solar irradiance
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceFacades.xlsx Squeeze=N par=G_facade rng='TotalFlux(kWhperm2)'!A1:BU17520 trace=3
PARAMETERS  G_facade(h0,BID) irradiance on building facades;
$GDXIN irradianceFacades.gdx
$LOAD G_facade
$GDXIN

*Load facade areas
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceFacades.xlsx o=FacadesArea.gdx par=area_facade_max cdim=1 rng=='Area(m2)'!A1:BT2 trace=3
PARAMETERS  area_facade_max(BID) area of building facades;
$GDXIN FacadesArea.gdx
$LOAD area_facade_max
$GDXIN

*Load roof solar irradiance
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceRoofs.xlsx Squeeze=N par=G_roof rng='TotalFlux(kWhperm2)'!A1:BU17520 trace=3
PARAMETERS  G_roof(h0,BID) irradiance on building roofs;
$GDXIN irradianceRoofs.gdx
$LOAD G_roof
$GDXIN

*Load roof areas
$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\irradianceRoofs.xlsx o=RoofsArea.gdx par=area_roof_max cdim=1 rng=='Area(m2)'!A1:BT2 trace=3
PARAMETERS  area_roof_max(BID) area of building roof;
$GDXIN RoofsArea.gdx
$LOAD area_roof_max
$GDXIN


*Normalized PV irradiance used for existing PV
*$call =xls2gms "I=Input_data_FED_SIMULATOR\pv_data_2016-2017.xlsx" R=Irradiance!A2:B8760 "O=nPV_el.gdx"
*Parameter nPV_el(h0) Electricty generated by a PV having 1 kW capacity
*/
*$include nPV_el.gdx
*/;

*----------------Building INERTIA storage parameters(=BS_cap, BD_cap, BS_ch_max, BS_dis_max,)

$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\UFO_TES_new.xlsx par=BTES_model rng=BITES_gams!A1:AE10
set
    BTES_properties  Building Inertia TES properties
                         /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                          kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/;

parameter BTES_model(BTES_properties,i);
$GDXIN UFO_TES_new.gdx
$LOAD BTES_model
$GDXIN
*----------------Building Advanced Control parameters---------------------------
$call =xls2gms "I=Input_data_FED_SIMULATOR\BAC_parameters.xlsx" R=BAC_gams!B2:C17520 "O=BAC_savings_period.gdx"

Parameter BAC_savings_period(h0) BAC savings period

/
$include BAC_savings_period.gdx
/;


*----------------DH Export period-----------------------------------------------
$call =xls2gms "I=Input_data_FED_SIMULATOR\DH_export_season.xlsx" R=DH_export_season!B2:C17520 "O=DH_export_season.gdx"
Parameter DH_export_season(h0) DH Export season indicating when exports are payed
/
$include DH_export_season.gdx
/;


*----------------P1 and P2 dispatchable-----------------------------------------
$call =xls2gms "I=Input_data_FED_SIMULATOR\P1P2_dispatchable.xlsx" R=P1P2_dispatchable!B2:C17520 "O=P1P2_dispatchable.gdx"
Parameter P1P2_dispatchable(h0) Time series dictating when P1 and P2 are dispatchable
/
$include P1P2_dispatchable.gdx
/;

*$CALL GDXXRW.EXE Input_data_FED_SIMULATOR\BAC_parameters.xlsx o=BAC_savings_period.gdx par=BAC_savings_period cdim=1 rng=='BAC_gams'!C2:C17521 trace=3
*PARAMETERS  BAC_savings_period(h0) Period indicating when savings from BAC are possible;
*$GDXIN BAC_savings_period.gdx
*$LOAD BAC_savings_period
*$GDXIN

*$CALL =xls2gms "I=Input_data_FED_SIMULATOR\BAC_parameters.xlsx" R=BAC_gams!B2:C17521 "O=BAC_savings_period.gdx"
*parameter
*         BAC_savings_period(h0) Period indicating when savings from BAC are possible
*/
*$include BAC_savings_period.gdx
*/;
**********************xxxxxxxxxxxxxxxxxxxxxxxxxxxx******************************

*-----------Store input data as GDX to be used in the rest of the routines------
execute_unload 'Input_data_FED_SIMULATOR\FED_INPUT_DATA'
                            i, BID, h0, m, d, BTES_properties,
                            HoD, HoM,
                            el_demand, h_demand, c_demand,
                            qB1, qF1, h_P1,
                            el_cirtificate, el_price, h_price, tout,
                            G_facade, area_facade_max, G_roof, area_roof_max,
                            BTES_model, BAC_savings_period, BAC_savings_period, DH_export_season, P1P2_dispatchable;;

$Ontext

$Offtext


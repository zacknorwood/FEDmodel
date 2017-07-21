******************************************************************************
*-----------------------GENERATE GDX FILES------------------------------------
*-----------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GENERATE OR PREPARE INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA-------------------------------
SET h0 length of the input data in hours /H1*H8760/
    b0  number of buildings considered    /1*30/
    m0  Number of month                  /M1*M12/
    d0  Number of days                   /D1*D365/
    BID Building IDs used for PV calculations /1*70/
;
*load date vectors for power tariffs
PARAMETERS  HoD(h0,d0)      Hour of the day
PARAMETERS  HoM(h0,m0)      Hour of the month
;
*$GDXIN FED_date_vector.gdx
*$LOAD HoD
*$LOAD HoM
*$GDXIN

*Load FED el demand
$CALL GDXXRW.EXE FED_el_demand.xlsx par=el_demand0 rng=el_demand_2016_gams!A1:AE8761
PARAMETERS  el_demand0(h0,b0)      ELECTRICITY DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_el_demand.gdx
$LOAD el_demand0
$GDXIN
display el_demand0;

*Load FED heat demand
$CALL GDXXRW.EXE FED_heat_demand.xlsx par=q_demand0 rng=heat_demand_2016_gams!A1:AE8761
PARAMETERS  q_demand0(h0,b0)      Heating DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_heat_demand.gdx
$LOAD q_demand0
$GDXIN
display q_demand0;

*Load FED cooling demand
$CALL GDXXRW.EXE FED_cooling_demand.xlsx par=k_demand0 rng=cooling_demand_2016_gams!A1:AE8761
PARAMETERS  k_demand0(h0,b0)      Heating DEMAND IN THE FED BUILDINGS
;
$GDXIN FED_cooling_demand.gdx
$LOAD k_demand0
$GDXIN
display k_demand0;

*HEAT GENERATION FROM THERMAL BILER (TB) AND FUEL GAS CONDENCER (FGC)
$call =xls2gms "I=FED_Base_Heat.xlsx" R=tb_2016_est_gams!A4:B8765 "O=q_tb_2016.gdx"
Parameter q_tb_2016(h0) PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
/
$include q_tb_2016.gdx
/;
display q_tb_2016;

$call =xls2gms "I=FED_Base_Heat.xlsx" R=fgc_2016_est_gams!A4:B8765 "O=q_fgc_2016.gdx"
Parameter q_fgc_2016(h0) SECONDARY HEAT PRODUCED FROM THE THERMAL BOILER
/
$include q_fgc_2016.gdx
/;
display q_fgc_2016;

*ELECTRICITY PRICE
$call =xls2gms "I=el_heat_price_2016.xlsx" R=el_price_2016_gams!A2:B8761 "O=el_price0.gdx"
Parameter el_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include el_price0.gdx
/;
display el_price0;

*HEAT PRICE
$call =xls2gms "I=el_heat_price_2016.xlsx" R=heat_price_2012_gams!A2:B8761 "O=q_price0.gdx"
Parameter q_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include q_price0.gdx
/;
display q_price0;

*outdoor temprature
$call =xls2gms "I=tout_2016.xlsx" R=tout_2016_gams!A2:E8761 "O=tout0.gdx"
Parameter tout0(h0) heat demand in buildings as obtained from metrys for
/
$include tout0.gdx;
/;
display tout0;

*Load facade solar irradiance
$CALL GDXXRW.EXE irradianceFacades.xls Squeeze=N par=G_facade rng='TotalFlux(kWhperm2)'!A1:BS8785 trace=3
PARAMETERS  G_facade(h0,BID) irradiance on building facades;
$GDXIN irradianceFacades.gdx
$LOAD G_facade
$GDXIN
display G_facade;

*Load facade areas
$CALL GDXXRW.EXE irradianceFacades.xls o=irradianceFacadesArea.gdx par=area_facade_max cdim=1 rng=='Area(m2)'!A1:BR2 trace=3
PARAMETERS  area_facade_max(BID) irradiance on building facades;
$GDXIN irradianceFacadesArea.gdx
$LOAD area_facade_max
$GDXIN
display area_facade_max;

*Load roof solar irradiance
$CALL GDXXRW.EXE irradianceRoofs.xls Squeeze=N par=G_roof rng='TotalFlux'!A1:BS8785 trace=3
PARAMETERS  G_roof(h0,BID) irradiance on building facades;
$GDXIN irradianceRoofs.gdx
$LOAD G_roof
$GDXIN
display G_roof;

*Load roof areas
$CALL GDXXRW.EXE irradianceRoofs.xls o=irradianceRoofsArea.gdx par=area_roof_max cdim=1 rng=='Area(m2)'!A1:BR2 trace=3
PARAMETERS  area_roof_max(BID) irradiance on building facades;
$GDXIN irradianceRoofsArea.gdx
$LOAD area_roof_max
$GDXIN
display area_roof_max;

*Normalized PV irradiance used for existing PV
$call =xls2gms "I=pv_data.xlsx" R=Irradiance!A2:B8760 "O=nPV_ird0.gdx";
Parameter nPV_ird0(h0) heat demand in buildings as obtained from metrys for
/
$include nPV_ird0.gdx;
/;
display nPV_ird0;

*Building INERTIA storage parameters(=BS_cap, BD_cap, BS_ch_max, BS_dis_max,)
$CALL GDXXRW.EXE UFO_TES.xlsx par=BTES_model0 rng=BITES_gams!A1:AE10
set
    BTES_properties0  Building Inertia TES properties
                         /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                          kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/;

parameter BTES_model0(BTES_properties0,b0);
$GDXIN UFO_TES.gdx
$LOAD BTES_model0
$GDXIN
display BTES_model0;

*-----------External grid PE factor-----------------------------------
$call =xls2gms "I=ext_PEF.xlsx" R=PEF_DH!A2:B8761 "O=PEF_DH0.gdx";
Parameter PEF_DH0(h0)  PE of external DH system
/
$include PEF_DH0.gdx;
/;
display PEF_DH0;

$call =xls2gms "I=ext_PEF.xlsx" R=PEF_extG!A2:B8761 "O=PEF_exG0.gdx";
Parameter PEF_exG0(h0)  PE of external electrical system
/
$include PEF_exG0.gdx;
/;
display PEF_exG0;

*-----------External grid CO2 factor-----------------------------------
$call =xls2gms "I=ext_CO2F.xlsx" R=CO2F_DH!A2:B8761 "O=CO2F_DH0.gdx";
Parameter CO2F_DH0(h0)  PE of external DH system
/
$include CO2F_DH0.gdx;
/;
display CO2F_DH0;

$call =xls2gms "I=ext_CO2F.xlsx" R=CO2F_extG!A2:B8761 "O=CO2F_exG0.gdx";
Parameter CO2F_exG0(h0)  PE of external DH system
/
$include CO2F_exG0.gdx;
/;
display CO2F_exG0;


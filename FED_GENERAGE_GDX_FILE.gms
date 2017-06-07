******************************************************************************
*-----------------------GENERATE GDX FILES------------------------------------
*-----------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GENERATE OR PREPARE INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA-------------------------------
SET h0 length of the input data in hours /H1*H8760/
    b0  number of buildings considered    /1*12/;

*Energy at compus(=heat_demand, electricity_demand, cooling_demand) each with a dimenssion of 8760x12
$CALL GDXXRW.EXE Energy_at_campus.xlsx par=heat_demand0 rng=Heating!A2:M8762 par=el_demand0 rng=Electricity!A2:M8762 par=cooling_demand0 rng=Cooling!A2:M8762
PARAMETERS heat_demand0(h0,b0)    HEAT DEMAND IN THE BUILDINGS
           el_demand0(h0,b0)      ELECTRICITY DEMAND IN THE BUILDINGS
           cooling_demand0(h0,b0) COOLING DEMAND IN THE BUILDINGS
;
$GDXIN Energy_at_campus.gdx
$LOAD heat_demand0
$LOAD el_demand0
$LOAD cooling_demand0
$GDXIN

display heat_demand0, el_demand0, cooling_demand0;

*ELECTRICITY PRICE
$call =xls2gms "I=input_origin.xls" R=first!D3:E8762 "O=el_price0.gdx"
Parameter el_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include el_price0.gdx
/;
display el_price0;

*HEAT PRICE
$call =xls2gms "I=input_origin.xls" R=first!R3:S8762 "O=heat_price0.gdx"
Parameter heat_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include heat_price0.gdx
/;
display heat_price0;

*outdoor temprature
$call =xls2gms "I=Energy_at_campus.xlsx" R=tout!A3:E8762 "O=temp_out0.gdx";
Parameter temp_out0(h0) heat demand in buildings as obtained from metrys for
/
$include temp_out0.gdx;
/;
display temp_out0;

*Normalized PV irradiance
$call =xls2gms "I=pv_data.xlsx" R=Irradiance!A1:B8760 "O=nPV_ird0.gdx";
Parameter nPV_ird0(h0) heat demand in buildings as obtained from metrys for
/
$include nPV_ird0.gdx;
/;
display nPV_ird0;

*TES Data
$call =xls2gms "I=input_origin.xls" R=first!K3:L8762 "O=TES_dis_max0.gdx"
Parameter TES_dis_max0(h0) Maximum TES discharging capacity at a given time
/
$include TES_dis_max0.gdx
/;
display TES_dis_max0;

$call =xls2gms "I=input_origin.xls" R=first!N3:O8762 "O=TES_ch_max0.gdx"
Parameter TES_ch_max0(h0) Maximum TES charging capacity at a given time
/
$include TES_ch_max0.gdx
/;
display TES_ch_max0;

*Building storage parameters(=BS_cap, BD_cap, BS_ch_max, BS_dis_max,)
$CALL GDXXRW.EXE Building_TES_model.xlsx par=BTES_model0 rng=BTES_data!A2:K14
set
    BTES_properties0  Building termal properties
                         /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                          kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/;

parameter BTES_model0(b0,BTES_properties0);
$GDXIN Building_TES_model.gdx
$LOAD BTES_model0
$GDXIN
display BTES_model0;

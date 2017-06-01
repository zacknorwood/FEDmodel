******************************************************************************
*-----------------------GENERATE GDX FILES------------------------------------
*-----------------------------------------------------------------------------

*THIS ROUTINE IS USED TO GENERATE OR PREPARE INPUT DATA USED IN THE MAIN MODEL IN GDX FORMAT

*----------------PREPARE THE FULL INPUT DATA-------------------------------
SET h0 length of the input data in hours /H1*H8760/
    i0  number of buildings considered    /1*12/;

*Energy at compus(=heat_demand, electricity_demand, cooling_demand) each with a dimenssion of 8760x12
$CALL GDXXRW.EXE C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\Energy_at_campus.xlsx par=heat_demand0 rng=Heating!A2:M8762 par=el_demand0 rng=Electricity!A2:M8762  par=cooling_demand0 rng=Cooling!A2:M8762
PARAMETERS heat_demand0(h0,i0)    HEAT DEMAND IN THE BUILDINGS
           el_demand0(h0,i0)      ELECTRICITY DEMAND IN THE BUILDINGS
           cooling_demand0(h0,i0) COOLING DEMAND IN THE BUILDINGS;
$GDXIN Energy_at_campus.gdx
$LOAD heat_demand0
$LOAD el_demand0
$LOAD cooling_demand0
$GDXIN

*ELECTRICITY PRICE
$call =xls2gms "I=C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\input_origin.xls" R=first!D3:E8762 "O=el_price0.gdx"
Parameter el_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include el_price0.gdx
/;

*HEAT PRICE
$call =xls2gms "I=C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\input_origin.xls" R=first!R3:S8762 "O=heat_price0.gdx"
Parameter heat_price0(h0) ELECTRICTY PRICE IN THE SYSTEM
/
$include heat_price0.gdx
/;

*outdoor temprature
$call =xls2gms "I=C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\Energy_at_campus.xlsx" R=tout!A3:E8762 "O=temp_out0.gdx";
Parameter temp_out0(h0) heat demand in buildings as obtained from metrys for
/
$include temp_out0.gdx;
/;

*Building storage parameters(=BS_cap, BD_cap, BS_ch_max, BS_dis_max,)
$CALL GDXXRW.EXE C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\Building_TES_model.xlsx par=BTES_model0 rng=BTES_data!A2:K14
set
    BTES_properties0  Building termal properties
                         /BS_cap, BD_cap, BS_ch_cap1, BS_ch_cap2,
                          BS_dis_cap1,  BS_dis_cap2, k_BS_loss1,
                          K_BS_loss2,   K_BD_loss,   K_BS_BD/;

parameter BTES_model0(i0,BTES_properties0);
$GDXIN Building_TES_model.gdx
$LOAD BTES_model0
$GDXIN

*------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR--------------------------------------
*------------------------------------------------------------------------------

$Include FED_Initialize
$Include FED_Variables
$Include FED_Equations

*CASE WITH HP, TES, MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************

option reslim = 5000;
*// Set the max resource usage
OPTION PROFILE=3;
*// To present the resource usage
*option workmem=1024;
option threads = -2
*// Leave two cores unused by GAMS

model total
/
ALL
/;
SOLVE total using MIP minimizing TC;

display cooling_demand;
*execute_unload "power_grid.gdx" P_DH, P_elec;
*execute_unload "power_technologies.gdx" P_DH, P_HP, P_CHP, TES_out, TES_in;
*execute_unload "indoor_temperature" T_in;


*execute_unload "Demand_2016.gdx" heat_demand, elec_demand;


*execute_unload "ind_temp.gdx" T_in.l;
*execute 'gdxxrw.exe ind_temp.gdx var=T_in.L';

$ontext
file results /results.dat/ ;
put results;
put 'district heating Results'// ;
put  @24, 'P_DH', @48, 'P_HP', @72, 'fuel', @96, 'Ped'
loop((i,h), put n.tl, @24, P_DH.l(i,h):8:4, @48, P_HP.l(i,h):8:4, @72, fuel.l(i,h):8:4, @96, Ped.l(i,h):8:4  /);
$offtext















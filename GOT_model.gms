*------------------------------------------------------------------------------*
*---------------------------DISTRICT HEATING SYSTEM model----------------------*
*------------------------------------------------------------------------------*
$Include GOT_sets
$Include GOT_input
$Include GOT_declare
$Include GOT_define

option mip=cplex;
option limrow = 2;
option limcol = 2;
option solprint = off;
option optcr = 0;
option threads = 15;
option savepoint = 1;
option reslim = 100000000000000;
*DH_optimization.optfile = 1;
model DH_optimization /all/;


*$ontext
*Electricity price 2012*
parameter cost_el_case1(hours) /
$call =xls2gms "I=input_origin.xls" R=first!D3:E2192 "O=case1.inc";
$include case1.inc;
/;
   cost_el(hours) = cost_el_case1(hours);

solve DH_optimization using mip minimizing z;





















*display z.l, cost_heat.l, q_final.l, p_chp.l, TES_BS_en.l, TES_BS_in.l, TES_BS_out.l, TES_BD_en.l, u.l, y.l, q_final_CHP.l, el_with_REC.l, total_start_up.l;
*display '---------------------------------------------------------------------------';

$ontext
execute_unload 'GE_1yr_newRYA_TES_Build_case1.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=TES_BS_en           rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=TES_BD_en           rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=TES_BS_in           rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=TES_BS_out          rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case1.gdx   o=GE_1yr_newRYA_TES_Build_case1.xlsx   var=link_BS_BD          rng=storage!N3   rdim=1"
;
*$offtext



*$ontext
*Electricity price 2030 wind 15TWh*
parameter cost_el_case2(hours) /
*$call =xls2gms "I=GOT_win_1y_new.xls" R=input_winter!G3:H8762 "O=case2.inc";
*$include case2.inc;
/;
   cost_el(hours) = cost_el_case2(hours);

solve DH_optimization using mip minimizing z;
*display z.l, cost_heat.l, q_final.l, p_chp.l, es.l, qs.l, u.l, y.l, gen_on_trans.l, gen_off_trans.l, q_final_CHP.l, el_with_REC.l;
*display '---------------------------------------------------------------------------';

execute_unload 'GE_1yr_newRYA_TES_Build_case2.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=TES_BS_en              rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=TES_BD_en              rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=TES_BS_in             rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=TES_BS_out             rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case2.gdx   o=GE_1yr_newRYA_TES_Build_case2.xlsx   var=link_BS_BD             rng=storage!N3   rdim=1"
;



*Electricity price 2030 wind 26TWh*
parameter cost_el_case3(hours) /
*$call =xls2gms "I=GOT_win_1y_new.xls" R=input_winter!J3:K8762 "O=case3.inc";
*$include case3.inc;
/;
   cost_el(hours) = cost_el_case3(hours);

solve DH_optimization using mip minimizing z;
*display z.l, cost_heat.l, q_final.l, p_chp.l, es.l, qs.l, u.l, y.l, gen_on_trans.l, gen_off_trans.l, q_final_CHP.l, el_with_REC.l;
*display '---------------------------------------------------------------------------';

execute_unload 'GE_1yr_newRYA_TES_Build_case3.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=TES_BS_en              rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=TES_BD_en              rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=TES_BS_in             rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=TES_BS_out             rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case3.gdx   o=GE_1yr_newRYA_TES_Build_case3.xlsx   var=link_BS_BD             rng=storage!N3   rdim=1"
;



*Electricity price 2030 wind 50TWh*
parameter cost_el_case4(hours) /
*$call =xls2gms "I=GOT_win_1y_new.xls" R=input_winter!M3:N8762 "O=case4.inc";
*$include case4.inc;
/;
   cost_el(hours) = cost_el_case4(hours);

solve DH_optimization using mip minimizing z;
*display z.l, cost_heat.l, q_final.l, p_chp.l, es.l, qs.l, u.l, y.l, gen_on_trans.l, gen_off_trans.l, q_final_CHP.l, el_with_REC.l;
*display '---------------------------------------------------------------------------';

execute_unload 'GE_1yr_newRYA_TES_Build_case4.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=TES_BS_en              rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=TES_BD_en              rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=TES_BS_in             rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=TES_BS_out             rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case4.gdx   o=GE_1yr_newRYA_TES_Build_case4.xlsx   var=link_BS_BD             rng=storage!N3   rdim=1"
;



*Electricity price 2030 wind 70TWh*
parameter cost_el_case5(hours) /
*$call =xls2gms "I=GOT_win_1y_new.xls" R=input_winter!P3:Q8762 "O=case5.inc";
*$include case5.inc;
/;
   cost_el(hours) = cost_el_case5(hours);

solve DH_optimization using mip minimizing z;
*display z.l, cost_heat.l, q_final.l, p_chp.l, es.l, qs.l, u.l, y.l, gen_on_trans.l, gen_off_trans.l, q_final_CHP.l, el_with_REC.l;
*display '---------------------------------------------------------------------------';

execute_unload 'GE_1yr_newRYA_TES_Build_case5.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=TES_BS_en              rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=TES_BD_en              rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=TES_BS_in             rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=TES_BS_out             rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case5.gdx   o=GE_1yr_newRYA_TES_Build_case5.xlsx   var=link_BS_BD             rng=storage!N3   rdim=1"
;
*$offtext


*$ontext
*Electricity price 2030 wind 70TWh NO NUC*
parameter cost_el_case6(hours) /
*$call =xls2gms "I=GOT_win_1y_new.xls" R=input_winter!S3:T8762 "O=case6.inc";
*$include case6.inc;
/;
   cost_el(hours) = cost_el_case6(hours);

solve DH_optimization using mip minimizing z;
*display z.l, cost_heat.l, q_final.l, p_chp.l, es.l, qs.l, u.l, y.l, gen_on_trans.l, gen_off_trans.l, q_final_CHP.l, el_with_REC.l;
*display '---------------------------------------------------------------------------';

execute_unload 'GE_1yr_newRYA_TES_Build_case6.gdx'
z
cost_heat
total_start_up
el_with_REC
q_final, hours, prod_unit
p_chp, hours, chp
q_final_CHP, hours, chp
u, hours, prod_unit
y, hours, prod_unit
gen_on_trans, hours, prod_unit
gen_off_trans, hours, prod_unit
TES_BS_en, hours
TES_BD_en, hours
TES_BS_in, hours
TES_BS_out, hours
link_BS_BD, hours
;

execute  "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=z                   rng=heat_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=cost_heat           rng=heat_prod!C2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=total_start_up      rng=heat_prod!E2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=q_final             rng=heat_prod!A4"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=q_final_CHP         rng=el_prod!B3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=p_chp               rng=el_prod!I3"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=el_with_REC         rng=el_prod!A2"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=TES_BS_en              rng=storage!B3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=TES_BD_en              rng=storage!E3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=TES_BS_in             rng=storage!H3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=TES_BS_out             rng=storage!K3   rdim=1"
         "gdxxrw   GE_1yr_newRYA_TES_Build_case6.gdx   o=GE_1yr_newRYA_TES_Build_case6.xlsx   var=link_BS_BD             rng=storage!N3   rdim=1"
;
$offtext

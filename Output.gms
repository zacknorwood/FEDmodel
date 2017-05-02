execute_unload 'GE_TESBuild_jan_mar.gdx'
z
syst_cost
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
TES_BS_in, hours
TES_BS_out, hours
TES_BD_en, hours
link_BS_BD, hours
losses_BS, hours
losses_BD, hours
;

execute  "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=z               rng=heat_prod!A2"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=syst_cost       rng=heat_prod!B2"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=cost_heat       rng=heat_prod!C2"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=q_final         rng=heat_prod!A4"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=q_final_CHP     rng=el_prod!B3"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=p_chp           rng=el_prod!I3"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=el_with_REC     rng=el_prod!A2"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=total_start_up  rng=heat_prod!D2"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=TES_BS_en       rng=storage!A3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=TES_BS_in       rng=storage!D3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=TES_BS_out      rng=storage!G3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=TES_BD_en       rng=storage!J3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=link_BS_BD      rng=storage!M3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=losses_BS       rng=storage!P3   rdim=1"
         "gdxxrw  GE_TESBuild_jan_mar.gdx   o=GE_TESBuild_jan_mar.xlsx   var=losses_BD       rng=storage!S3   rdim=1"
;


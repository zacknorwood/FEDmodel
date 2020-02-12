--------------------------------------------------------------------------------
--------------------------How to run the model----------------------------------
--------------------------------------------------------------------------------

1) Open RUN_FED_DS.m
2) Choose the desirable objective function weighting factorr
	a) min_totCost (alpha in equation (1) in the article)
	b) min_totCO2  (beta in equation (1) in the article)
3) Run Run_DED_DS.m
4) The results from the simulation can be found in the results folder

--------------------------------------------------------------------------------
-------------------------------------Notes--------------------------------------
--------------------------------------------------------------------------------

- The units names are not the same as in the paper. For more info, please check the comments in "FED_equations.gms"
- To see the optimization equations, please check "FED_equations.gms".
- The parameters used in the optimization can be found in "FED_Initialize.gms".
- The variables definition used in the optimization can be found in "FED_Variables".
- To see the emission factor calculations, check "get_CO2PE_exGrids.mat" and "New El and DH Allocation Method (IPCC) 2019-09-24.xlsx".

--------------------------------------------------------------------------------
------------------------------Contact information-------------------------------
--------------------------------------------------------------------------------
David Steen - david.steen@chalmers.se 
Zack Norwood - donkey@berkeley.edu 
Nima Mirzaei Alavijeh - nima.mirzaei@chalmers.se


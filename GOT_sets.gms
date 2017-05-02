*------------------------------------------------------------------------------*
*------------------------Göteborg DISTRICT HEATING SYSTEM----------------------*
*------------------------------------------------------------------------------*

* ST1, Preem, Renova - waste heat,    RYA_HP - heat pumps,
* SAV_CHP - wood chips fired CHP,     RYA_CHP - natural gas fired CHP,    HOG_CHPs - natural gas fired CHPs (3 units combined),
* RYA_HOBs - pellet fired HOBs,       ANG_HOBs - biooil fired HOBs,
* SAV_HOBs - natural gas fired HOBs,  ROS_HOB4 - natural gas fired HOB,
* ROS_HOB_1-3 - oil fired HOBs,       TYN_HOB - oil fired HOBs (2 units combinde)

sets
         hours time steps in single day resolution             /H1*H2190/
         hours_win(hours)  winter days                         /H1*H2190/
         hours_cost(hours)  hours to be optimized              /H1*H1854/

         prod_unit production units                            /ST1,       Preem,    Renova,
                                                                SAV_CHP,   RYA_CHP, HOG_CHP,
                                                                RYA_HP1-2, RYA_HP3-4,
                                                                RYA_HOB1,  RYA_HOB2,
                                                                SAV_HOB1,  SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,
                                                                ROS_HOB1/

         indust(prod_unit) subset of ind. waste heat units     /ST1, Preem/

         chp(prod_unit)   subset of CHP units                  /SAV_CHP,  RYA_CHP, HOG_CHP/

         chp2(chp)  subset of CHPs with constant alpha         /SAV_CHP,  HOG_CHP/

         HP(prod_unit)    subset of heat pumps                 /RYA_HP1-2, RYA_HP3-4/

         hob(prod_unit)   subset of units excluding CHP        /ST1, Preem, Renova,
                                                                RYA_HP1-2, RYA_HP3-4,
                                                                RYA_HOB1, RYA_HOB2,
                                                                SAV_HOB1, SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,
                                                                ROS_HOB1/

         hob1(prod_unit)  subset of units excluding CHP and HPs/ST1, Preem, Renova,
                                                                RYA_HOB1, RYA_HOB2,
                                                                SAV_HOB1, SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,
                                                                ROS_HOB1/

         burn(prod_unit) subset of units excluding HPs         /ST1,       Preem,
                                                                SAV_CHP,   RYA_CHP, HOG_CHP
                                                                RYA_HOB1,  RYA_HOB2,
                                                                SAV_HOB1,  SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,
                                                                ROS_HOB1/

         wood(prod_unit)     subset of units with minimum on times        /RYA_HOB1, RYA_HOB2/
         ramp(prod_unit)     subset of units with ramp limits             /ST1, Preem, Renova, SAV_CHP/


alias(hours,hours2);


parameters

         max_gen_win(prod_unit)    maximum heat generation of each prod_unit in each hour in MW
                                   /ST1 85,       Preem 60,      Renova 185,
                                   SAV_CHP 110,   RYA_CHP 295,   HOG_CHP 14,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 50,   RYA_HOB2 50,
                                   SAV_HOB1 90,   SAV_HOB2 60,   ROS_HOB4 140,
                                   ANG_HOB1 105,
                                   ROS_HOB1 440/

         max_gen_sum(prod_unit)    maximum heat generation of each prod_unit in each hour in MW
                                   /ST1 85,       Preem 60,      Renova 130,
                                   SAV_CHP 110,   RYA_CHP 295,   HOG_CHP 14,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 50,   RYA_HOB2 50,
                                   SAV_HOB1 90,   SAV_HOB2 60,   ROS_HOB4 140,
                                   ANG_HOB1 105,
                                   ROS_HOB1 440/

         min_gen(prod_unit)        minimum heat generation of each prod_unit in each hour in MW
                                   /ST1 35,       Preem 15,      Renova 0,
                                   SAV_CHP 25,    RYA_CHP 50,    HOG_CHP 3,
                                   RYA_HP1-2 0,   RYA_HP3-4 0,
                                   RYA_HOB1 25,   RYA_HOB2 25,
                                   SAV_HOB1 20,   SAV_HOB2 20,   ROS_HOB4 30,
                                   ANG_HOB1 15,
                                   ROS_HOB1 20/

         etta_tot(prod_unit)       constant prod_unit efficiency
                                   /ST1 1,        Preem 1,       Renova 1,
                                   SAV_CHP 1.11,  RYA_CHP 0.91,  HOG_CHP 0.79,
                                   RYA_HP1-2 3.6, RYA_HP3-4 3.15,
                                   RYA_HOB1 0.92, RYA_HOB2 0.92,
                                   SAV_HOB1 1.01, SAV_HOB2 0.90, ROS_HOB4 0.97,
                                   ANG_HOB1 0.90,
                                   ROS_HOB1 0.98/

         ramp_heat_par(prod_unit)  ramp up limit for each prod_unit in MW per HOUR
                                   /ST1 25,       Preem 7.5,     Renova 92.5,
                                   SAV_CHP 42.5,  RYA_CHP 245,   HOG_CHP 11,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 25,   RYA_HOB2 25,
                                   SAV_HOB1 70,   SAV_HOB2 40,   ROS_HOB4 110,
                                   ANG_HOB1 90,
                                   ROS_HOB1 120/

*CHP related parameters*

         max_el(chp)               /RYA_CHP 245/
         min_el(chp)               /RYA_CHP 41.5/
         ramp_el_par(chp)          /RYA_CHP 203.5/
         const_alpha(chp2)         /SAV_CHP 0.12,     HOG_CHP 0.93/


*financial parameters*

         fuel_cost(prod_unit)      fuel cost in SEK per MWh
                                   /SAV_CHP 209,   RYA_CHP 230,   HOG_CHP 230,
                                   RYA_HOB1 292,  RYA_HOB2 292,
                                   SAV_HOB1 230,  SAV_HOB2 230,  ROS_HOB4 230,
                                   ANG_HOB1 600,
                                   ROS_HOB1 542/

         var_cost(prod_unit)       variable O&M cost for CHP units in SEK per MWh of heat produced
                                   /ST1 10,       Preem 10,      Renova 10,
                                   SAV_CHP 87,    RYA_CHP 22,    HOG_CHP 22,
                                   RYA_HP1-2 20,  RYA_HP3-4 20,
                                   RYA_HOB1 28,   RYA_HOB2 28,
                                   SAV_HOB1 15,   SAV_HOB2 15,   ROS_HOB4 15,
                                   ANG_HOB1 15,
                                   ROS_HOB1 15/

         en_tax(prod_unit)         energy tax for CHP units in SEK per MWh(fuel)
                                   /RYA_CHP 25,    HOG_CHP 25,
                                   RYA_HP1-2 290, RYA_HP3-4 290,
                                   SAV_HOB1 82,   SAV_HOB2 82,   ROS_HOB4 82,
                                   ROS_HOB1 82/


         CO2_factor(prod_unit)     energy tax for CHP units in SEK per MWh(fuel)
                                   /SAV_HOB1 0.2,  SAV_HOB2 0.2,  ROS_HOB4 0.2,
                                    ROS_HOB1 0.28/


         start_up_cost(prod_unit)  cost of starting up the prod_unit in SEK
                                   /SAV_CHP 200000, RYA_CHP 400000/;
scalar
         CO2_cost                  price of CO2                          /950/;


parameter
         tot_cost(prod_unit)   total cost calculated;
         tot_cost(prod_unit) = fuel_cost(prod_unit) + var_cost(prod_unit) +  en_tax(prod_unit) + CO2_cost*CO2_factor(prod_unit);


scalars
         TES_BS_en_int     Shallow TES level at the first modelling hour  /1/
         TES_BD_en_int     Deep TES level at the first modelling hour     /1/
         REC_price         renewable energy certificate price             /168/
         BS_BD_coef        BS_BD energy flow coefficient in MWh per h     /180/
         TES_BS_cap        Shallow TES maximum capacity in MWh            /278/
         TES_BD_cap        Deep TES maximum capacity in MWh               /1758/

         disch_eff         TES discharging efficiency               /1/
         ch_eff            TES charging efficiency                  /1/
         time_const_BS     time constant of the Shallow storage     /115/
         time_const_BD     time constant of the Deep storage        /267/

*        natural gas fired RYA CHP1 production boundaries in MW
         P_R1 /245/
         P_R2 /245/
         P_R3 /0/
         Q_R1 /0/
         Q_R2 /295/
         Q_R3 /1/;


















$ontext
 prod_unit production units                            /ST1,       Preem,    Renova,
                                                                SAV_CHP,   RYA_CHP1, RYA_CHP2, RYA_CHP3, HOG_CHP,
                                                                RYA_HP1-2, RYA_HP3-4,
                                                                RYA_HOB1,  RYA_HOB2,
                                                                SAV_HOB1,  SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,  ANG_HOB2, ANG_HOB3,
                                                                ROS_HOB1,  ROS_HOB2, ROS_HOB3, TYN_HOB/

         indust(prod_unit) subset of ind. waste heat units     /ST1, Preem/

         chp(prod_unit)   subset of CHP units                  /SAV_CHP,  RYA_CHP1, RYA_CHP2, RYA_CHP3, HOG_CHP/
         chp_RYA(chp)                                          /RYA_CHP1, RYA_CHP2, RYA_CHP3/
         chp2(chp)  subset of CHPs with constant alpha         /SAV_CHP,  HOG_CHP/

         HP(prod_unit)    subset of heat pumps                 /RYA_HP1-2, RYA_HP3-4/

         hob(prod_unit)   subset of units excluding CHP        /ST1, Preem, Renova,
                                                                RYA_HP1-2, RYA_HP3-4,
                                                                RYA_HOB1, RYA_HOB2,
                                                                SAV_HOB1, SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1, ANG_HOB2, ANG_HOB3,
                                                                ROS_HOB1, ROS_HOB2, ROS_HOB3, TYN_HOB/

         hob1(prod_unit)  subset of units excluding CHP and HPs/ST1, Preem, Renova,
                                                                RYA_HOB1, RYA_HOB2,
                                                                SAV_HOB1, SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1, ANG_HOB2, ANG_HOB3,
                                                                ROS_HOB1, ROS_HOB2, ROS_HOB3, TYN_HOB/

         burn(prod_unit) subset of units excluding HPs         /ST1,       Preem,
                                                                SAV_CHP,   RYA_CHP1, RYA_CHP2, RYA_CHP3, HOG_CHP
                                                                RYA_HOB1,  RYA_HOB2,
                                                                SAV_HOB1,  SAV_HOB2, ROS_HOB4,
                                                                ANG_HOB1,  ANG_HOB2, ANG_HOB3,
                                                                ROS_HOB1,  ROS_HOB2, ROS_HOB3, TYN_HOB/

         wood(prod_unit)     subset of units with minimum on times        /RYA_HOB1, RYA_HOB2/
         ramp(prod_unit)     subset of units with ramp limits             /ST1, Preem, Renova, SAV_CHP/

alias(hours,hours2);

parameters

         max_gen_win(prod_unit)    maximum heat generation of each prod_unit in each hour in MW
                                   /ST1 85,       Preem 60,      Renova 185,
                                   SAV_CHP 110,   RYA_CHP1 105,  RYA_CHP2 95, RYA_CHP3 95, HOG_CHP 14,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 50,   RYA_HOB2 50,
                                   SAV_HOB1 90,   SAV_HOB2 60,   ROS_HOB4 140,
                                   ANG_HOB1 35,   ANG_HOB2 35,   ANG_HOB3 35,
                                   ROS_HOB1 140,  ROS_HOB2 140,  ROS_HOB3 140, TYN_HOB 20/

         max_gen_sum(prod_unit)    maximum heat generation of each prod_unit in each hour in MW
                                   /ST1 85,       Preem 60,      Renova 130,
                                   SAV_CHP 110,   RYA_CHP1 105,  RYA_CHP2 95, RYA_CHP3 95, HOG_CHP 14,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 50,   RYA_HOB2 50,
                                   SAV_HOB1 90,   SAV_HOB2 60,   ROS_HOB4 140,
                                   ANG_HOB1 35,   ANG_HOB2 35,   ANG_HOB3 35,
                                   ROS_HOB1 140,  ROS_HOB2 140,  ROS_HOB3 140, TYN_HOB 20/

         min_gen(prod_unit)        minimum heat generation of each prod_unit in each hour in MW
                                   /ST1 35,       Preem 15,      Renova 0,
                                   SAV_CHP 25,    RYA_CHP1 50,   RYA_CHP2 25, RYA_CHP3 30, HOG_CHP 3,
                                   RYA_HP1-2 0,   RYA_HP3-4 0,
                                   RYA_HOB1 25,   RYA_HOB2 25,
                                   SAV_HOB1 20,   SAV_HOB2 20,   ROS_HOB4 30,
                                   ANG_HOB1 15,   ANG_HOB2 15,   ANG_HOB3 15,
                                   ROS_HOB1 20,   ROS_HOB2 20,   ROS_HOB3 20, TYN_HOB 8/

         etta_tot(prod_unit)       constant prod_unit efficiency
                                   /ST1 1,        Preem 1,       Renova 1,
                                   SAV_CHP 1.11,  RYA_CHP1 0.91, RYA_CHP2 0.91, RYA_CHP3 0.91, HOG_CHP 0.79,
                                   RYA_HP1-2 3.6, RYA_HP3-4 3.15,
                                   RYA_HOB1 0.92, RYA_HOB2 0.92,
                                   SAV_HOB1 1.01, SAV_HOB2 0.90, ROS_HOB4 0.97,
                                   ANG_HOB1 0.90, ANG_HOB2 0.90, ANG_HOB3 0.90,
                                   ROS_HOB1 0.98, ROS_HOB2 0.98, ROS_HOB3 0.98, TYN_HOB 0.89/

         ramp_heat_par(prod_unit)  ramp up limit for each prod_unit in MW per HOUR
                                   /ST1 25,       Preem 7.5,     Renova 92.5,
                                   SAV_CHP 42.5,  RYA_CHP1 55,   RYA_CHP2 70, RYA_CHP3 60, HOG_CHP 11,
                                   RYA_HP1-2 60,  RYA_HP3-4 100,
                                   RYA_HOB1 25,   RYA_HOB2 25,
                                   SAV_HOB1 70,   SAV_HOB2 40,   ROS_HOB4 110,
                                   ANG_HOB1 20,   ANG_HOB2 20,   ANG_HOB3 20,
                                   ROS_HOB1 120,  ROS_HOB2 120,  ROS_HOB3 120,  TYN_HOB 12/

*CHP related parameters*

         max_el(chp_RYA)           /RYA_CHP1 87.15,   RYA_CHP2 78.85,   RYA_CHP3 78.85/
         min_el(chp_RYA)           /RYA_CHP1 41.5,    RYA_CHP2 20.75,   RYA_CHP3 24.9/
         ramp_el_par(chp_RYA)      /RYA_CHP1 45.65,   RYA_CHP2 58.1,    RYA_CHP3 53.95/
         const_alpha(chp2)         /SAV_CHP 0.12,     HOG_CHP 0.93/


*financial parameters*

         fuel_cost(prod_unit)      fuel cost in SEK per MWh
                                   /ST1 0,        Preem 0,       Renova 0,
                                   SAV_CHP 209,   RYA_CHP1 230,  RYA_CHP2 230, RYA_CHP3 230, HOG_CHP 230,
                                   RYA_HP1-2 0,   RYA_HP3-4 0,
                                   RYA_HOB1 292,  RYA_HOB2 292,
                                   SAV_HOB1 230,  SAV_HOB2 230,  ROS_HOB4 230,
                                   ANG_HOB1 600,  ANG_HOB2 600,  ANG_HOB3 600,
                                   ROS_HOB1 542,  ROS_HOB2 542,  ROS_HOB3 542, TYN_HOB 542/

         var_cost(prod_unit)       variable O&M cost for CHP units in SEK per MWh of heat produced
                                   /ST1 10,       Preem 10,      Renova 10,
                                   SAV_CHP 87,    RYA_CHP1 22,   RYA_CHP2 22,  RYA_CHP3 22, HOG_CHP 22,
                                   RYA_HP1-2 20,  RYA_HP3-4 20,
                                   RYA_HOB1 28,   RYA_HOB2 28,
                                   SAV_HOB1 15,   SAV_HOB2 15,   ROS_HOB4 15,
                                   ANG_HOB1 15,   ANG_HOB2 15,   ANG_HOB3 15,
                                   ROS_HOB1 15,   ROS_HOB2 15,   ROS_HOB3 15,  TYN_HOB 15/
*/SAV_CHP 87,   RYA_CHP 22,   HOG_CHP 22/

         en_tax(prod_unit)         energy tax for CHP units in SEK per MWh(fuel)
$offtext
$ontext
                                   /ST1 0,        Preem 0,       Renova 0,
                                   SAV_CHP 0,     RYA_CHP1 25,   RYA_CHP2 25,  RYA_CHP3 25, HOG_CHP 25,
                                   RYA_HP1-2 290, RYA_HP3-4 290,
                                   RYA_HOB1 0,    RYA_HOB2 0,
                                   SAV_HOB1 82,   SAV_HOB2 82,   ROS_HOB4 82,
                                   ANG_HOB1 0,    ANG_HOB2 0,    ANG_HOB3 0,
                                   ROS_HOB1 82,   ROS_HOB2 82,   ROS_HOB3 82,  TYN_HOB 82/
*/SAV_CHP 0,    RYA_CHP 25,   HOG_CHP 25/

         CO2_factor(prod_unit)     energy tax for CHP units in SEK per MWh(fuel)
                                   /ST1 0,        Preem 0,       Renova 0,
                                   SAV_CHP 0,     RYA_CHP1 0,    RYA_CHP2 0, RYA_CHP3 0, HOG_CHP 0,
                                   RYA_HP1-2 0,   RYA_HP3-4 0,
                                   RYA_HOB1 0,    RYA_HOB2 0,
                                   SAV_HOB1 0.2,  SAV_HOB2 0.2,  ROS_HOB4 0.2,
                                   ANG_HOB1 0,    ANG_HOB2 0,    ANG_HOB3 0,
                                   ROS_HOB1 0.28, ROS_HOB2 0.28, ROS_HOB3 0.28,  TYN_HOB 0.28/
*/SAV_CHP 0,    RYA_CHP 25,   HOG_CHP 25/

         start_up_cost(prod_unit)  cost of starting up the prod_unit in SEK
                                   /SAV_CHP 200000, RYA_CHP1 150000, RYA_CHP2 125000, RYA_CHP3 125000, HOG_CHP 0/;
scalar
         CO2_cost                  price of CO2                          /950/;


parameter
         tot_cost(prod_unit)   total cost calculated;
         tot_cost(prod_unit) = fuel_cost(prod_unit) + var_cost(prod_unit) +  en_tax(prod_unit) + CO2_cost*CO2_factor(prod_unit);


*parameter

* losses in DH network are accounted since load is based on real life heat production, thus heat loss coefficient is "0".
* eff_tank    storage tank's (network) heat loss coefficient - 1 percent in 10 days;
* eff_tank = 1-(0.01/240);


scalars
         TES_BS_en_int     Shallow TES level at the first modelling hour  /139/
         TES_BD_en_int     Deep TES level at the first modelling hour     /879/
         REC_price         renewable energy certificate price             /168/
         BS_BD_coef        BS_BD energy flow coefficient in MWh per h     /180/
         TES_BS_cap        Shallow TES maximum capacity in MWh            /278/
         TES_BD_cap        Deep TES maximum capacity in MWh               /1758/

         disch_eff         TES discharging efficiency               /1/
         ch_eff            TES charging efficiency                  /1/
         time_const_BS     time constant of the Shallow storage     /50/
         time_const_BD     time constant of the Deep storage        /300/

*--------Storage tank parameters-------*
*         energy_coef       TES loss coefficient related to the energy stored (taken from David Steen's paper for LT section) /0.00057/
*         static_coef       TES static loss coefficient (taken from David Steen's paper for LT section)                       /0.00056/
*         Cp                Specific heat capacity water in kJ per kgK  /4.2/
*         density           Density of water in kg per qubic meter      /1000/
*         Vol               TES volume                                  /27000/
*         TES_cap           TES capacity in MWh                     /1000/
*         Tmax              Maximal TES temperature                 /65/
*         Tmin              Minimal TES temperature                 /40/


*        natural gas fired RYA CHP1 production boundaries in MW
         P_R1 /87.15/
         P_R2 /87.15/
         P_R3 /0/
         Q_R1 /0/
         Q_R2 /105/
         Q_R3 /0.83/

*        natural gas fired RYA CHP2 production boundaries in MW
         P_S1 /78.85/
         P_S2 /78.85/
         P_S3 /0/
         Q_S1 /0/
         Q_S2 /95/
         Q_S3 /0/

*        natural gas fired RYA CHP3 production boundaries in MW
         P_H1 /78.85/
         P_H2 /78.85/
         P_H3 /0/
         Q_H1 /0/
         Q_H2 /95/
         Q_H3 /0.83/;
$offtext

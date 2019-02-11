*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************
*--------------IMPORT INPUT DATA TO THE MODEL-----------------------------------
$Include FED_GET_GDX_FILE

*--------------SET PARAMETRS OF PRODUCTION active UNITS in the FED system-------
set
         sup_unit   supply units /PV, HP, BES, TES, BTES, BAC , RMMC, P1, P2, TURB, AbsC, AbsCInv, AAC, RM, exG, DH, CHP, RMInv, RGK1/
         inv_opt    investment options /PV, HP, BES, TES, BTES,BAC, RMMC, P2, TURB, AbsCInv, RMInv/
;

************ the technical limit of import/export on heat and electricty is based on feedback from AH
Parameter
        DH_max_cap  Maximum capacity of import from the external district heating system /12000/
        exG_max_cap Maximum capacity of import from the external electricty system /10000/
*DH_export_season(h) Season during which pricing for DH exports possible
;

************ Capacities of the units in the FED system
Parameter
*RM capacity at AH is set to 900kW which the capacity of RM at Kemi (2*450 kW)
         cap_sup_unit(sup_unit)   operational capacity of the existing units
                     /PV 65, P1 8000, AbsC 2300, AAC 1000, RM 900, RMMC 4200, RGK1 1200/
;

*************** different costs of the investment options
* Investment costs source WP4_D4.2.1 prestudy report, except absorption chiller and HP from Danish Energy Agency, year 2015 cost: https://ens.dk/sites/ens.dk/files/Analyser/technology_data_catalogue_for_energy_plants_-_aug_2016._update_june_2017.pdf
* PV 7600000+3970000 SEK / 265+550 kW = 14 196, BES 1200000 SEK / 200 kWh = 6000, P2 46000000 / 6000000 = 7666, Turb 1800000 SEK / 800 kW = 2250
* Exchange rate 2015: Eur to SEK = 9.36;
* HP 700 * 9.36 = 6552 , AbsC 600 * 9.36 * 1.7/0.75= 5616
* RMInv 100 �/kW *9.36 = 936 - https://ec.europa.eu/energy/sites/ener/files/documents/Report%20WP2.pdf
* Absorption chiller source: https://ec.europa.eu/energy/sites/ener/files/documents/Report%20WP2.pdf
* Abs cost: 300 �/kW * 9.36 = 2808
* BAC costs from AH/CFAB estimates, calculated as average per building cost subtracted with the cost of BTES capability
*    makes sense because BAC is a more advanced version of the BTES system.
Parameter
         cost_inv_opt(inv_opt)    Cost of the investment options in SEK per kW or kWh for battery or SEK per unit or building in the case of BTES RMMC P2 and Turbine
                     /PV 14196, BES 6000, HP 6552, BTES 35000, BAC 315333, RMMC 500000, P2 46000000, TURB 1800000, AbsCInv 2808, RMInv 936/
;

*******Lifetimes source Danish Energy Agency: https://ens.dk/sites/ens.dk/files/Analyser/technology_data_catalogue_for_energy_plants_-_aug_2016._update_june_2017.pdf
* BAC - Building Advanced Control is assumed to have same lifetime as BTES
Parameter
         lifT_inv_opt(inv_opt)    Life time of investment options
                     /PV 30, BES 15, HP 25, TES 30, BTES 15, BAC 15 ,RMMC 25, P2 30, TURB 30, AbsCInv 25, RMInv 25/;

***************Existing units***************************************************

*--------------Existing Thermal boiler constants and parameters (P1)------------
*This data is imported from MATLAB and stored in MtoG
Parameter
*          h_P1(h)     Total heat output from P1
          P1_eff      Effeciency of P1
          P1_cap      Capacity of Boiler 1 in kW excluding flue gas condecer /8000/
          P1_max      Maximum output from P1 /6000/
          P1_min      Minimum output from P1 /3000/
;
P1_eff=0.9;

*---------------Flue gas condencer------------------------
Parameters
          RGK1_eff   Effeciency of flue gas condencer /0.4/
          RGK1_cap   Capacity of flue gas condenceer /1000/
          RGK1_max   Maximum output from the flue gas condencer /1000/
          RGK1_min   Minimum output from the flue gas condencer /500/
;

*--------------VKA4 constants and parameters------------------------------------
* Maximum electricty input and the coefficients for VKA1 and VKA4 corresponds to the 800 kW heating capacity for each machine
*Calculated from historical data
*COP calculated from historical data (on dropbox) max heating capacity
*(800kW) from BDAB "Utredning ackumulatortank KC 4.0"
* "Effektiv kylanvändning chalmersfastigheter" BDAB states cooling production of 400-500 kW
* Model implementation limits cooling production to 480 kW
scalar
         VKA1_H_COP            Heating coefficient of performance for VKA1/3/
         VKA1_C_COP            Cooling coefficient of performance for VKA1/1.8/
         VKA1_el_cap           Maximum electricity usage by VKA1/266/
;

*--------------VKA4 constants and parameters------------------------------------
*COP calculated from historical data (on dropbox) max heating capacity
*(800kW) from BDAB "Utredning ackumulatortank KC 4.0", in model max heat generation is 780kW
* "Effektiv kylanvändning chalmersfastigheter" BDAB states cooling production of 400-500 kW
* Model implementation limits cooling production to 510 kW
scalar
         VKA4_H_COP            Heating coefficient of performance for VKA4/3/
         VKA4_C_COP            Cooling coefficient of performance for VKA4/1.8/
         VKA4_el_cap           Maximum electricity usage by VKA4/266/
;

*--------------AbsC(Absorbition Refrigerator), cooling source-------------------
* Source for these numbers?
scalar
         AbsC_COP Coefficent of performance of AbsC /0.5/
         AbsC_el_COP Electrical Coefficient of Performance of AbsC /22/
         AbsC_min_prod Minimum production while on of AbsC /290/
;

*--------------AAC(Ambient Air Cooler), cooling source--------------------------
* Source Per
scalar
         AAC_COP Coefficent of performance of AAC /10/
         AAC_eff Efficiency of AAC /0.95/
         AAC_TempLim Temperature limit of AAC/12/
;

*--------------Refrigerator Machines, cooling source----------------------------
scalar
      RM_COP Coefficent of performance of RM /2/
      RM_eff Coefficent of performance of RM /0.95/
;

*--------------Cold water basin at maskin, cold storage-------------------------
* Source communications with Per
* charging and discharging efficiencies are assumed values
scalar
         CWB_max_cap_kwh     Maximum capacity available /814/
         CWB_chr_eff         Cold Water Basin charging efficiency /0.95/
         CWB_dis_eff         Cold Water Basin discharging efficiency /0.95/
         CWB_ch_max          Maximum charging rate in kWh per hour /203.5/
         CWB_dis_max         Maximum discharge rate in kWh per hour /35/
         CWB_en_init         Initial charge state of CWB /0/
;

**************Investment options************************************************
*----------------Absorption Chiller Investment----------------------------------
* source Uhttps://ec.europa.eu/energy/sites/ener/files/documents/Report%20WP2.pdf
scalar
         AbsCInv_COP    Coefficient of performance for absorption cooling investment /0.5/
;

*----------------Boiler 2  ------------------------------------------------------
scalar
      P2_eff                 Efficiency of P2 /0.9/
      P2_cap                 Capacity of P2 /6000/
      P2_max                 Maximum output from P2 /6000/
      P2_min                 Minimum output from P2 /1000/
      P2_hourly_ramprate     hourly maximum ramp rate /4000/
      P2_reseach_prod        Heat output during research /1500/
      P2_power_to_heat_ratio power to heat ratio of P2 and turbine /0.2/
;

*----------------Refurbished turbine for Boiler 2  ------------------------------
scalar
* turbine efficiency from Danish energy agency reports
      TURB_eff Efficiency of turbine /0.25/
* Max turbine output from AH WP4.2 report
      TURB_cap Maximum power output of turbine /800/
;

*--------------MC2 Refrigerator Machines, cooling source------------------------
* Real capacity of RMMC is 4200 but since MC2 internal cooling demand isn't
* accounted for RMMC capacity is here decreased by 600 kW
scalar
* Source, historical data, from Chalmersfastigheter energiförsörjning campus johanneberg (BDAB)
* RMMC_cap value is a technical capacity limit of the connetion, according to AH
      RMCC_H_COP Coefficient of performance for RM /3/
      RMCC_C_COP Coefficient of performance for RM /1.94/
      RMMC_cap Maximum cooling capacity for RM in kW/500/
;

*--------------Refrigeration machine investment---------------------------------
* Source https://ec.europa.eu/energy/sites/ener/files/documents/Report%20WP2.pdf
Parameter
         RMInv_COP COP of refrigeration machine /4/
;

*--------------PV data----------------------------------------------------------
scalar
      Tstc Temperature at standard temperature and conditions in degree Celsius /25/
      Gstc Irradiance at standard temperature and conditions in kW per m^2 /1/
      PV_cap_density kW per m^2 for a mono-Si PV module e.g. Sunpower SPR-E20-327 dimensions 1.558*1.046 of 327Wp /0.20065/
      eta_Inverter efficiency of solar PV inverter and balance of system /0.96/
      coef_temp_PV coefficient coupling irradiance and PV temperature /0.035/
;

set coefs Coefficient numbering for PV calculations /1*6/
parameter
      coef_Si(coefs) Si solar PV coefficient
      /1 -0.017162, 2 -0.040289, 3 -0.004681, 4 0.000148, 5 0.000169, 6 0.000005/
;

parameter
      Gekv_roof(h,PVID) Equivalent irradiance parameter for solar PV on roof in kW per m^2
      Gekv_facade(h,PVID) Equivalent irradiance parameter for solar PV on facade in kW per m^2
      Tmod_roof(h,PVID) Module temperature roof in Celsius
      Tmod_facade(h,PVID) Module temperature facade in Celsius
      Tekv_roof(h,PVID) Equivalent temperature parameter for solar PV on roof
      Tekv_facade(h,PVID) Equivalent temperature parameter for solar PV on facade
      PV_power_roof(h,PVID) Power per watt peak roof (dimensionless parameter)
      PV_power_facade(h,PVID) Power per watt peak facade (dimensionless parameter)

;
      Gekv_roof(h,PVID)=abs(G_roof(h,PVID))/Gstc;
      Gekv_facade(h,PVID)=abs(G_facade(h,PVID))/Gstc;

      Tmod_roof(h,PVID)=tout(h)+coef_temp_PV*G_roof(h,PVID);
      Tmod_facade(h,PVID)=tout(h)+coef_temp_PV*G_facade(h,PVID);

      Tekv_roof(h,PVID)=Tmod_roof(h,PVID) - Tstc;
      Tekv_facade(h,PVID)=Tmod_facade(h,PVID) - Tstc;

      PV_power_roof(h,PVID) $ ((Gekv_roof(h,PVID) ne 0)) =   Gekv_roof(h,PVID)*
                                                        (1 + coef_Si('1')*log10(Gekv_roof(h,PVID))
                                                        + coef_Si('2')*sqr(log10(Gekv_roof(h,PVID)))
                                                        + coef_Si('3')*Tekv_roof(h,PVID)
                                                        + coef_Si('4')*Tekv_roof(h,PVID)*log10(Gekv_roof(h,PVID))
                                                        + coef_Si('5')*Tekv_roof(h,PVID)*sqr(log10(Gekv_roof(h,PVID)))
                                                        + coef_Si('6')*sqr(Tekv_roof(h,PVID)));

     PV_power_facade(h,PVID) $ (Gekv_facade(h,PVID) ne 0) = Gekv_facade(h,PVID)*
                                                         (1 + coef_Si('1')*log10(Gekv_facade(h,PVID))
                                                          + coef_Si('2')*sqr(log10(Gekv_facade(h,PVID)))
                                                          + coef_Si('3')*Tekv_facade(h,PVID)
                                                          + coef_Si('4')*Tekv_facade(h,PVID)*log10(Gekv_facade(h,PVID))
                                                          + coef_Si('5')*Tekv_facade(h,PVID)*sqr(log10(Gekv_facade(h,PVID)))
                                                          + coef_Si('6')*sqr(Tekv_facade(h,PVID)));

*--------------HP constants and parameters (an investment options)-------------
*[COP and eff values need to be checked]
scalar
* HP_H_COP=3,1 and HP_C_COP=2,19 are from AH based on new investment
* HP_H_COP=3,15 and HP_C_COP=2,5 Heat pump efficiencies from Danish Energy Agency, year 2015 cost: https://ens.dk/sites/ens.dk/files/Analyser/technology_data_catalogue_for_energy_plants_-_aug_2016._update_june_2017.pdf
         HP_H_COP       Coefficent of performance for heat of the Heat Pump (HP)/3.10/
         HP_C_COP       Coefficent of performance for cooling of the Heat Pump (HP)/2.19/
;

*--------------TES constants and parameters-------------------------------------
scalar
         TES_chr_eff           TES charging efficiency /0.95/
         TES_dis_eff           TES discharging efficiency/0.95/
         TES_max_cap           Maximum capacity available in m3/1000/
         TES_density           Energy density at 35C temp diff according to BDAB/39/
         TES_fx_cost           Fixed cost attributable to TES investment/4404119/
         TES_vr_cost           Variable cost attributable to TES investment/1887/
         TES_dis_max           Maximum discharge rate in kWh per h/23000/
         TES_ch_max            Maximum charge rate in kWh per h/11000/
         TES_hourly_loss_fac   Hourly loss factor/0.999208093/
;

*--------------Building storage characteristics---------------------------------
scalar
         BTES_chr_eff           BTES charging efficiency /0.95/
         BTES_dis_eff           BTES discharging efficiency/0.95/
;
Parameters
         BTES_Sen_int(BID)      Initial energy stored in the shalow medium of the building
         BTES_Den_int(BID)      Initial energy stored in the deep medium of the building
         BTES_Sdis_eff        Discharge efficiency of the shallow medium
         BTES_Sch_eff         Charging efficiency of the shallow medium
         BTES_Sch_max(h,BID)    maximum charging limit
         BTES_Sdis_max(h,BID)   maximum discharging limit
         BTES_kSloss(BID)      loss coefficient-shallow
         BTES_kDloss(BID)      loss coefficient-deep
;

BTES_Sdis_eff=0.95;
BTES_Sch_eff=0.95;

BTES_Sch_max(h,BID)=1000*Min(BTES_model('BTES_Sch_hc',BID), BTES_model('BTES_Esig',BID)*Max(Min(tout(h) - (-16),15 - (-16)),0));
BTES_Sdis_max(h,BID)=1000*Min(BTES_model('BTES_Sdis_hc',BID), BTES_model('BTES_Esig',BID)*Max(Min(15 - tout(h),15 - (-16)),0));

*[BTES_kSloss needs to be modified since it has different values during day and night]
*here, it is assumed that BTES_kSloss is the same and the value for the day is used, which means that the loss is over estimated
BTES_kSloss(BID)= BTES_model('kloss_Sday',BID);
BTES_kDloss(BID)= BTES_model('kloss_D',BID);

*--------------BAC parameters---------------------------------------------------
*scalar
*         BAC_savings_factor      Savings from BAC /0.2/
*;

*--------------Battery storage characteristics----------------------------------
scalar
         BES_ch_eff    Charging efficiency /0.95/
         BES_dis_eff   Discharding efficiency /0.95/
         BES_min_SOC   Minimum State of charge /0.20/
         BFCh_ch_eff    Charging efficiency /0.95/
         BFCh_dis_eff   Discharding efficiency /0.95/
         BFCh_min_SOC   Minimum State of charge /0.20/
;

*--------------set building energy demands--------------------------------------
Parameter
         el_demand_AH(h,BID_AH_el)       el demand of AH buildings
         el_demand_nonAH(h,BID_nonAH_el) el demand of non-AH buildings
         h_demand_AH(h,BID_AH_h)         heat demand of AH buildings
         h_demand_nonAH(h,BID_nonAH_h)   heat demand of non-AH
         c_demand_AH(h,BID_AH_c)         cool demand of AH buildings
         c_demand_nonAH(h,BID_nonAH_c)   cool demand of non-AH buildings
;

el_demand_AH(h,BID_AH_el)=el_demand(h,BID_AH_el);
el_demand_nonAH(h,BID_nonAH_el)=el_demand(h,BID_nonAH_el);

h_demand_AH(h,BID_AH_h)=h_demand(h,BID_AH_h);
h_demand_nonAH(h,BID_nonAH_h)=h_demand(h,BID_nonAH_h);

c_demand_AH(h,BID_AH_c)=c_demand(h,BID_AH_c);
c_demand_nonAH(h,BID_nonAH_c)=c_demand(h,BID_nonAH_c);

*--------------unit total cost for all the generating units---------------------
parameter
         price(sup_unit,h)       unit market price of energy
         fuel_cost(sup_unit,h)   fuel cost per kWh production
         var_cost(sup_unit,h)    variable cost O&M per kWh energy produced excluding the cost of the primary fuel
         fix_cost(sup_unit)      annual fixed cost per kW capacity of production
         en_tax(sup_unit,h)      energy tax of a production unit
         co2_cost(sup_unit,h)    CO2 cost
         utot_cost(sup_unit,h)   unit total cost of every production unit
         PT_cost(sup_unit)       Power tariff SEK per kW per month
         el_sell_price(h)        Sell price for electricty
         el_buy_price(h)         Buy price for electricty
         net_tariff              Network tariff   /0.31/
* 0.31SEK/kWh is grid tariff per kWh from Goteborg Energi home page;
         el_profit_margin_buy    Average electric utility buying profit margin (SEK per kWh)  /0.011/
* 0.011SEK/kWh is the average profit for GE for large customers buying electricity, and 0.019 SEK/kWh for selling.
         el_profit_margin_sell   Average electric utility selling profit margin (SEK per kWh)  /0.019/
         guarantee_origin        guarantee of origin "ursprungsgaranti" /0.01/
         quota_elcertificate     "kvotplikt" /0.305/
         el_tax                   Electricity tax    /0.325/
         EUR_to_SEK_2015 Exchange rate EUR to SEK in 2015 /9.36/
         kilo Factor of 1000 conversion to kW from MW for example /1000/
;

* Purchase price from the external grid (not including taxes which is included later in utot_cost) is the spot price plus the net tariff plus the average profit + electricity certificate price multiplied by the quota.
price('exG',h)= el_price(h) + net_tariff + el_profit_margin_buy + quota_elcertificate * el_certificate(h);

* This is the real time price in the FED system based on marginal units, h_price(h) is the price using the normal GE tariffs.
price('DH',h)= MA_Cost_DH(h);

* This price must be lower than the buy price: spot price - profit margin + el certificate price (since everything is renewable in FED) + guarantee of origin
el_sell_price(h) =el_price(h) - el_profit_margin_sell +  el_certificate(h) + guarantee_origin;

*the data 0.186 kr/kWh is obtained from Energimyndigheten 2015 wood chips for District Heating Uses
*woodchip cost of 0.353 kr/kWh is obtained from AH
fuel_cost('CHP',h)= 0.353;

* Divided by efficiency to get actual fuel use when multiplying with heat output
fuel_cost('P1',h)=0.353;
*0.186/P1_eff;

fuel_cost('RGK1',h)=0.353;

*0.186/RGK1_eff;
*fuel_cost('P1',h)=0.186*fuel_P1(h)/q_P1(h);
* Divided by efficiency to get actual fuel use when multiplying with heat output

fuel_cost('P2',h)=0.353;
*0.186/P2_eff;

var_cost(sup_unit,h)=0;
fix_cost(sup_unit)=0;

* No data in Danish Energy Agency report for TES tank storage, assume costs zero
* No data in Danish Energy Agency report for BTES building thermal energy, assume costs zero
* HP variable O&M exclusive electricity costs
var_cost('HP',h)= 2 / kilo * EUR_to_SEK_2015;
fix_cost('HP')= 2000 / kilo * EUR_to_SEK_2015;
* Refrigerating machine assumed same as HP for both variable and O&M and fixed costs
var_cost('RM',h)= var_cost('HP',h);
fix_cost('RM')= fix_cost('HP');
var_cost('CHP',h)= 3.9 / kilo * EUR_to_SEK_2015;
fix_cost('CHP')= 29000 / kilo * EUR_to_SEK_2015;
* No data on turbine separate from CHP, assume total O&M costs same as variable for CHP
var_cost('TURB',h)= 3.9 / kilo * EUR_to_SEK_2015;
* variable costs of PV are assumed 0.
fix_cost('PV')= 12540 / kilo * EUR_to_SEK_2015;
* No data on fixed costs for wood chip boilers, included in variable O&M costs.
var_cost('P1',h)= 5.4 / kilo * EUR_to_SEK_2015;
*var_cost('RGK1',h)= 5.4 / kilo * EUR_to_SEK_2015; ???
var_cost('P2',h)= 5.4 / kilo * EUR_to_SEK_2015;
* AbsC variable O&M inclusive electricity, adjusted by COP for absorption heating compared to cooling factors
var_cost('AbsC',h)= 0.9 / kilo * AbsC_COP * EUR_to_SEK_2015;
fix_cost('AbsC')= 3000 / kilo * EUR_to_SEK_2015;
* AbsCInv variable O&M inclusive electricity, adjusted by COP for absorption heating compared to cooling factors
var_cost('AbsCInv',h)= 0.9 / kilo * AbsCInv_COP * EUR_to_SEK_2015;
fix_cost('AbsCInv')= 3000 / kilo * EUR_to_SEK_2015;
* No data on ambient air chillers, assume same as absorption heater for both variable O&M and fixed costs
var_cost('AAC',h)= 0.9 / kilo * EUR_to_SEK_2015;
fix_cost('AAC')= 3000 / kilo * EUR_to_SEK_2015;
* No data in Danish Energy Agency report for lithium ion, assume costs same as for NaS
var_cost('BES',h)= 5.3 / kilo * EUR_to_SEK_2015;
fix_cost('BES')= 51000 / kilo * EUR_to_SEK_2015;
* Data for RMInv same as for HP
var_cost('RMInv',h)= var_cost('HP',h);
fix_cost('RMInv')= fix_cost('HP');

*From Göteborg Energi homepage, tax on a kWh electricity purchased in SEK
en_tax(sup_unit,h)=0;
en_tax('exG',h)=el_tax;

co2_cost(sup_unit,h)=0;
*Power tariffs from Göteborg Energi
PT_cost(sup_unit)=0;
PT_cost('exG')=0;
*According to GE 35.4;
PT_cost('DH')=452;

utot_cost(sup_unit,h)=price(sup_unit,h) + fuel_cost(sup_unit,h)
                      + var_cost(sup_unit,h) + en_tax(sup_unit,h);
*--------------FED PE and CO2 targets-------------------------------------------

scalar
         PE_lim     Desired or limiting value of PE
         dCO2       Delta CO2
         CO2_lim    Desired or limiting value of CO2
;

*--------------Limit on investment----------------------------------------------
$Ontext

$Offtext



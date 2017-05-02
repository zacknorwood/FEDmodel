*------------------------------------------------------------------------------*
*------------------------Göteborg DISTRICT HEATING SYSTEM----------------------*
*------------------------------------------------------------------------------*

parameter heat_load(hours)   heat load for each hour in MWh per hour
/
$call =xls2gms "I=input_origin.xls" R=first!A3:B2192 "O=heat_load.inc";
$include heat_load.inc;
/;


parameter cost_el(hours)   electricity cost each hour in SEK per MWh;


parameter TES_BS_max_discharge(hours)   maximum discharge rate of the Shallow TES depending on outdoor temperature
/
$call =xls2gms "I=input_origin.xls" R=first!K3:L2192 "O=TES_max_discharge.inc";
$include TES_max_discharge.inc;
/;


parameter TES_BS_max_charge(hours)   maximum charge rate of the Shallow TES depending on outdoor temperature
/
$call =xls2gms "I=input_origin.xls" R=first!N3:O2192 "O=TES_max_charge.inc";
$include TES_max_charge.inc;
/;


*$ontext
table min_time(hours,prod_unit) minimum on-off time for each unit
$call =xls2gms "I=input_origin.xls" R=first!R2:U2192 "O=minimum_time.inc";
$include minimum_time.inc;
;

*$ontext

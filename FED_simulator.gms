*CASE WITH HP, TES, MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************
set
h                     Number of hours in a year/1*8760/
i                     buildings/1*12/
building_properties   Thermal resistance (degree C per KW) and capacitance (KWh per degree C) of the building/r_w, ca/
*head2                 technology name and annualised investment cost/name, cost/
;

alias(i,j);


option reslim = 5000;              // Set the max resource usage
OPTION PROFILE=3;                 // To present the resource usage
*option workmem=1024;


scalar
COP                   Coefficent of performance of the Heat Pump (HP)/4/
chr                   charging efficiency /0.95/
dis                   discharging efficiency/0.95/
alpha                 ratio between heat and electricity produced/0.7/
eta                   efficiency/0.95/
fuel_price            fuel price in SEK per KWh/100/
C_price               carbon price for fuel burnt in SEK per KWH/10/
max_dis_rate_TES      maximum discharge rate of TES/0.2/
max_chr_rate_TES      maximum charge rate of TES/0.2/

;

parameters
heat_demand(i,h) heat demand in buildings as obtained from metrys for 2016
cool_demand(i,h) cool demand in buildings as obtained from metrys for 2016
elec_demand(i,h) electricity demand in buildings as obtained from metrys for 2016
temp(h)
heat_price(h)
elec_price(h)
;

$GDXIN   D:\Forskning\FED\simuleringsmodell\abc.gdx
$LOAD temp=temp
$LOAD heat_price=heat
$LOAD elec_price=elec
$GDXIN

*$GDXIN   D:\Forskning\FED\simuleringsmodell\demand_2016.gdx
*$LOAD heat_demand
**$LOAD cool_demand
*$LOAD elec_demand
*$GDXIN

$GDXIN   D:\Forskning\FED\simuleringsmodell\heat_test.gdx
$LOAD heat_demand=heating
*$LOAD cool_demand
$LOAD elec_demand=electricity
$GDXIN
display heat_demand;

*until we have date we dont include cooling
cool_demand(i,h)=0;

PARAMETERS
switch_DR        switch to decide whether to use building inertia or not
switch_HP        switch to decide whether whether to operate HP or not
switch_TES       switch to decide whether whether to operate TES or not
switch_CHP       switch to decide whether to operate CHP or not
switch_trans     switch to decide whether to operate transmission or not
q(h)             hour
;

*assigning values to parameters     ?????????
q(h)=1;

*use of switch to determine whether HP, CHP, TES should operate or not****************
switch_DR=1;
switch_HP=1;
switch_TES=1;
switch_CHP=1;
switch_trans=1;


******************************************************************
*** Building data extraxted from buildings thermal power signature

*1-maskingränd edit
*2-kemigården 1 fysik origa 3
*3-chalmersplatsen 4 administration
*4-hörsalar hb
*5-hörsalsvägen 7 maskinteknik
*6-hörsalsvägen 11 elteknik
*7-kemigården 1 fysik origa 1
*8-sven hultins gata 6
*9-sven hultins gata 8 väg
*10-tvärgata 1 biblioteket
*11-tvärgata 3 mathematiska
*12-tvärgata 6 lokalkontor

Table p_data(i,building_properties) inherent physical property of the building
                          r_w              ca
1                         .08             60000
2                         .34             20000
3                         .51             10000
4                         .945            7000
5                         .05             55000
6                         .355            16000
7                         .28             23000
8                         .156            47500
9                         .122            41200
10                        .53             20000
11                        .369            15000
12                        1.29            3000
;

*******************************************************************



$ontext
table technology(n1,head2) technology with annualised investment cost
                 name                       cost
1                 HP                         50
2                CHP                         50
3                TES                         50
display technology ;
$offtext

**********  Capacity in DH system **********************************************
Table trans_capa_heat(i,j) transmission capacity that export or import to other areas[KW]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      100     400      0       0       0       0       0       0       0       0       0
2       100      0       0      300      0       0       0       0       0       0       0       0
3       200      0       0       0      100      0       0       0       0       0       0       0
4        0      300      0       0       0      300      0       0       0       0       0       0
5        0       0      100      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      50
11       0       0       0       0       0       0       0       0      200      0       0      10
12       0       0       0       0       0       0       0       0       0      50      10       0
;

**********  Capacity in electricity system **********************************************
Table trans_capa_elec(i,j) transmission capacity that export or import to other areas[KW]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      100     400      0       0       0       0       0       0       0       0       0
2       100      0       0      300      0       0       0       0       0       0       0       0
3       200      0       0       0      100      0       0       0       0       0       0       0
4        0      300      0       0       0      300      0       0       0       0       0       0
5        0       0      100      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      50
11       0       0       0       0       0       0       0       0      200      0       0      10
12       0       0       0       0       0       0       0       0       0      50      10       0
;


$ontext
Table price(o,p) transmission price export or import to other areas[SEK per KWh]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      150     200      0       0       0       0       0       0       0       0       0
2        75      0       0      330      0       0       0       0       0       0       0       0
3       200      0       0       0      200      0       0       0       0       0       0       0
4        0      330      0       0       0      300      0       0       0       0       0       0
5        0       0      200      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      320
11       0       0       0       0       0       0       0       0      200      0       0      170
12       0       0       0       0       0       0       0       0       0      320     170      0
;
$offtext

variable
TC                   total cost
T_in(i,h)            indoor room temperature
P_DH(i,h)            heat power input from grid
P_DC(i,h)            cooling from district cooling system
P_elec(i,h)          electrical power input from grid
cost_el(i,h)         price of electrical energy
heat_demand_DR(i,h)  demand response of the building
trans_heat(i,j,h)    actual heat transmission from 'i' to 'j' at any instant h
r(i,h)               sum of heat transmission at any instant n
trans_elec(i,j,h)    actual electricity transmission from 'i' to 'j' at any instant h
s(i,h)               sum of electricity transmission at any instant n
capa_HP(i)           capacity of HP
capa_TES(i)          maximum value of charge for a building
capa_CHP(i)          maximum capacity of CHP plant
;

positive variable
P_chr_TES(i,h)       charge power from TES
P_dis_TES(i,h)       discharge power from TES
P_HP(i,h)            power available in HP
P_CHP(i,h)           power available in CHP
E_TES(i,h)           energy content of TES at any instant
;

****** setting indoor temperature limits *****
T_in.up(i,h) = 24;
T_in.lo(i,h) = 19;
T_in.fx(i,'1')=21;

trans_heat.up(i,j,h)=trans_capa_heat(i,j)*10000;
trans_heat.lo(i,j,h)= -trans_capa_heat(i,j)*10000;

trans_elec.up(i,j,h)=trans_capa_elec(i,j)*10000;
trans_elec.lo(i,j,h)= -trans_capa_elec(i,j)*10000;


*P_chr_TES.up(i,h)=20;
*P_dis_TES.up(i,h)=20;

P_DH.fx(i,h)=0;
P_elec.fx(i,h)=0;
P_DH.up('1',h)=10000000000000;
*P_DH.lo('1',n)=-10000;
P_elec.up('1',h)=1000000;
*P_elec.lo('1',n)=-10000;


********* Limits on CHP **************
capa_chp.fx(i)=600;
*capa_chp.fx('1')=600;
P_CHP.up(i,h)=600;
P_CHP.lo(i,h)=0;

********* Limits on HP ************
*capa_hp.fx(i)=0;
*capa_hp.fx('1')=600;
capa_hp.up(i)=1000;
*capa_hp.up('1')=100;

******** Limits on TES **********
capa_TES.up(i)=1000;
*capa_TES.up('1')=100;

********* Limits on heat_demand DR ************
heat_demand_DR.fx(i,h)=heat_demand(i,h)$(switch_DR ne 1);


equation
total_cost      with aim to minimize total cost
indoor_temp1    indoor temperature as a function of outdoor temperature and power input
*indoor_temp2    represents indoor temperature at last hour
capacity_HP     for determining capacity of HP
capacity_CHP    for determining the capacity of CHP
capacity_TES    for determining the capacity of TES
heating         heating supply-demand balance
cooling         Balance equation cooling
electrical      electrical supply-demand balance
Energy_TES      Amount of energy contained in TES at any instant
Energy1_TES     Amount of energy at first and last hour is same
trans1          transmission of heat is one direction is negative of transmission in other direction
*trans2          transmission of electricity is one direction is negative of transmission in other direction
*trans3          sum of heat transmission to a building
*trans4          sum of electricity transmission to a building
discharge       instantaneous discharge of building
charge          instantaneous charge of the building
*heating_DR      Set heat demand for case without DR
;


**************** Objective function ***********************
total_cost..
TC     =e=     sum((i,h), P_DH(i,h)*heat_price(h)+P_elec(i,h)*elec_price(h)+P_CHP(i,h)*fuel_price)
             + sum(i,switch_HP*capa_HP(i)*50+switch_CHP*capa_CHP(i)*100+switch_TES*capa_TES(i)*50);


******* Demand supply balance for heating *******
heating(i,h)..
heat_demand_DR(i,h) =e= P_DH(i,h) +
                     P_HP(i,h)*switch_HP +
                     (dis*P_dis_TES(i,h)-P_chr_TES(i,h)/chr)*switch_TES +
                     P_CHP(i,h)/((1+alpha)*eta)*switch_CHP +
                     sum(j,trans_heat(i,j,h)*q(h))*switch_trans;

*heat_demand_DR(i,h) =e= P_DH(i,h)+P_HP(i,h)*switch_HP+(dis*P_dis_TES(i,h)-P_chr_TES(i,h)/chr)*switch_TES+P_CHP(i,h)/((1+alpha)*eta)*switch_CHP+sum(p,trans_heat(i,j,h)*q(n))*switch_trans;
*demand_DR(i,h) =e= P_DH(i,h)+P_HP(i,h)+(dis*P_dis_TES(i,h)-P_chr_TES(i,h)/chr)*switch_TES+P_CHP(i,h)/((1+alpha)*eta)*switch_CHP+sum(p,trans(i,j,h)*q(n));

*heating_DR(i,h)..
*heat_demand_DR(i,h) =e= heat_demand(i,h)$(switch_DR ne 1);


******* Demand supply balance for cooling *******
cooling(i,h)..
cool_demand(i,h) =e= P_DC(i,h);

******* Demand supply balance for electricity *******
electrical(h)..
sum(i,elec_demand(i,h)) =e= sum(i,P_elec(i,h) +
                     switch_CHP*alpha*P_CHP(i,h)/((1+alpha)*eta) -
                     switch_HP*P_HP(i,h)/COP);
*electrical(i,h)..
*elec_demand(i,h) =e= P_elec(i,h) +
*                     switch_CHP*alpha*P_CHP(i,h)/((1+alpha)*eta) -
*                     switch_HP*P_HP(i,h)/COP +
*                     sum(j, trans_elec(i,j,h)*q(h))*switch_trans;


**** Building flexibility/indoor temperature ***********
indoor_temp1(i,h)$(ord(h) ne card(h))..
T_in(i,h+1) =l= (temp(h+1)+(heat_demand_DR(i,h)+0.9*elec_demand(i,h))*p_data(i,'r_w')-(temp(h+1)+
                (heat_demand_DR(i,h)+0.9*elec_demand(i,h))*p_data(i,'r_w')-T_in(i,h))*exp(-1/(p_data(i,'r_w')*p_data(i,'ca'))))$(switch_DR eq 1)
                 + 21$(switch_DR ne 1);


******** Transmission equations******
trans1(i,j,h)$(trans_capa_heat(i,j) ne 0)..
trans_heat(i,j,h) =e= -trans_heat(j,i,h);

*trans2(i,j,h)..
*trans_elec(i,j,h) =e= -trans_elec(j,i,h);

*******What is this for?
*trans3(i,h)..
*r(i,h)=e=sum(j, trans_heat(i,j,h));
*trans4(i,h)..
*s(i,h)=e=sum(j, trans_elec(i,j,h));


********** HP equations **************
* P_HP is the heat output from the HP
capacity_HP(i,h)..
P_HP(i,h) =l= capa_HP(i);

********** TES equations *************
Energy_TES(i,h)$(ord(h) ne card(h))..
E_TES(i,h+1) =e= E_TES(i,h)+P_chr_TES(i,h+1)-P_dis_TES(i,h+1);

Energy1_TES(i,h)$(ord(h) eq card(h))..
E_TES(i,'1') =e= E_TES(i,h);

discharge(i,h)..
P_dis_TES(i,h) =l= max_dis_rate_TES*E_TES(i,h);

charge(i,h)..
P_chr_TES(i,h) =l= max_chr_rate_TES*E_TES(i,h);

capacity_TES(i,h)..
E_TES(i,h) =l= capa_TES(i);



*********** CHP equations *************
* Output to objective P_chp, P_chp
* Input Efficiency CHP, heat/electricity share alpha

capacity_CHP(i,h)..
P_CHP(i,h) =l= capa_CHP(i);
*P_CHP_heat(i,h) =l= capa_CHP_heat(i);
*P_CHP_elect(i,h) =l= capa_CHP_elect(i);
*P_CHP_heat(i,h)=P_CHP*(1/alpha)*eta_CHP


model total
/
ALL
/;
SOLVE total using LP minimizing TC;

display
P_DH.l
P_elec.l
T_in.l
TC.l
P_HP.l
E_TES.l
P_dis_TES.l
P_chr_TES.l
P_CHP.l
*heat_demand_DR.l
capa_HP.l
capa_TES.l
capa_CHP.l
trans_heat.l
*r.l
trans_elec.l
*s.l
heat_demand
elec_demand
;


*execute_unload "power_grid.gdx" P_DH, P_elec;
execute_unload "power_technologies.gdx" P_DH, P_HP, P_CHP, P_dis_TES, P_chr_TES;
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

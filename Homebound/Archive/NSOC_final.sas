*TABLE 5 NSOC;

libname NSOC '\\home\users$\lawk02\Documents\NHATS\Zipped\NSOC_Round_1_National_Study_of_Caregiving_Files_SAS';
libname NHATSRD1 '\\home\users$\lawk02\Documents\NHATS\Zipped\R1';

*merging sensitive file to SP file;
proc sort data=NHATSRD1.Nhats_round_1_sp_file;
by spid;
run;

proc sort data=Nhatsrd1.Nhats_round_1_sp_sen_dem_file;
by spid;
run;

data round1_sp;
merge NHATSRD1.Nhats_round_1_sp_file Nhatsrd1.Nhats_round_1_sp_sen_dem_file;
by spid;
run;

data round1_sp;
set round1_sp;

*Nursing home = removed;
if r1dresid=4 then delete;
/*0.completely*/
levelzero = 0;
if mo1outoft = 5 then levelzero = 1;
/*1.mostly*/
levelone = 0;
if mo1outoft = 4 then levelone = 1;
/*2.neverbyself*/
leveltwo = 0;
if (mo1outoft = 1 and mo1outslf = 4) or (mo1outoft = 2 and mo1outslf = 4) or (mo1outoft = 3 and mo1outslf = 4) then leveltwo = 1;
/*3.needs help and/or has difficulty
generate needs help*/
needshelp = 0;
if mo1outhlp = 1 and mo1outslf ~= 4 then needshelp = 1;
/*generate has difficulty*/
difficult = 0;
if mo1outdif = 2 or mo1outdif = 3 or mo1outdif = 4 or mo1outdif = -8 then difficult = 1;
/*generate needs help and/or has difficulty*/
helpdiff = 0;
if needshelp = 1 or difficult = 1 then helpdiff = 1;
/*generate level 3*/
levelthree = 0;
if (mo1outoft =1 and helpdiff = 1) or (mo1outoft =2 and helpdiff = 1) or (mo1outoft = 3 and helpdiff = 1) then levelthree = 1;
/*4.low freq, no help or difficulty*/
independent = 0;
if mo1outhlp = 2 and mo1outdif = 1 then independent = 1;
/*5.high frequency*/ 
levelfour = 0;
if mo1outoft = 3 and independent = 1 then levelfour = 1;
levelfive = 0;
if (mo1outoft = 1 and independent = 1) or (mo1outoft = 2 and independent = 1) then levelfive= 1; 

if levelzero  = 1 then homebound = 1;
if levelone = 1 then homebound = 1;
if leveltwo = 1 then homebound = 2;
if levelthree = 1 then homebound = 2;
if levelfour = 1 then homebound = 3;
if levelfive = 1 then homebound = 3;

if levelzero  = 1 then homebound2 = 1;
if levelone = 1 then homebound2 = 2;
if leveltwo = 1 then homebound2 = 3;
if levelthree = 1 then homebound2 = 4;
if levelfour = 1 then homebound2 = 5;
if levelfive = 1 then homebound2 = 6;

if homebound2=1 or homebound2=2 then homebound3=1;	*homebound;
if homebound2=3 then homebound3=2;					*semi, never by self;
if homebound2=4 then homebound3=3;					*semi, needs help;
if homebound2=5 or homebound2=6 then homebound3=4;	*not homebound;

if homebound=. then delete;

*selfcare activities, eating, bathing, toileting, dressing;
selfcare_num=0;
if sc1deathelp = 2 then selfcare_num=selfcare_num+1; 
if sc1dbathhelp = 2 then selfcare_num=selfcare_num+1;
if sc1dtoilhelp = 2 then selfcare_num=selfcare_num+1;
if sc1ddreshelp = 2 then selfcare_num=selfcare_num+1;

selfcare=0;
if selfcare_num=0 then selfcare=1; *no assistance;
	else if selfcare_num=1 or selfcare_num=2 then selfcare=2; *1-2 assistance;
	else if selfcare_num=>3 then selfcare=3;	*>3 assistance;
if sc1deathelp in (-1,3,8) and sc1dbathhelp in (-1,3,8) and sc1dtoilhelp in (-1,3,8) and sc1ddreshelp in (-1,3,8) then selfcare=9;

*household activities, laundry, shop, meal bank;
hh_act_num=0;
if ha1dlaunsfdf=1 then hh_act_num=hh_act_num+1;
if ha1dshopsfdf=1 then hh_act_num=hh_act_num+1;
if ha1dmealsfdf=1 then hh_act_num=hh_act_num+1;
if ha1dbanksfdf=1 then hh_act_num=hh_act_num+1;

hh_act=0;
if hh_act_num=0 then hh_act=1;
	else if hh_act_num=1 or hh_act_num=2 then hh_act=2;
	else if hh_act_num=>3 then hh_act=3;
if ha1dlaunsfdf in (-1,5,7,8) and ha1dshopsfdf in (-1,5,7,8) and ha1dmealsfdf in (-1,5,7,8) and ha1dbanksfdf in (-1,5,7,8) then hh_act=9;

*Mobility;
if mo1douthelp=2 or mo1dinsdhelp=2 or mo1dbedhelp=2 then mobility=1; else mobility=2;

*Medical care activities;
med_num=0;
if mc1dmedssfdf=1 then med_care=1;
	else if mc1dmedssfdf in(2,3,6) then med_care=2;
	else if mc1dmedssfdf in(7,8,9) then med_care=9;

*Any assistance with activities;
if selfcare in(2,3) or hh_act in(2,3) or ha1dmealwhl=1 or mobility=1 or med_care=1 then any_assist=1;
	else any_assist=2;

*Marital status;
marital=0;
if hh1martlstat in(1,2)then marital=1;				*Married or living with a partner;
	else if hh1martlstat in (3,4) then marital=2;	*Separated or divored;
	else if hh1martlstat=5 then marital=3;			*Widowed;
	else if hh1martlstat=6 then marital=4;			*Never married;
	else marital = 9;								*DKRF;

format homebound homeboundf.;
format homebound3 homebound3f.;
format any_assist mobility med_care with_assistf.;
format marital maritalf.;
format selfcare hh_act assistance_numf.;
run;

data SPwithHB (keep=SPID homebound homebound2 homebound3 w1anfinwgt0 w1varstrat w1varunit);
set round1_sp;
run;

proc sort data=SPwithHB;
by SPID;
run;

proc sort data=Nsoc.Nsoc_round_1_sp_tracker_file;
by spid;
run;

data NSOC_SPwithHB;
merge Nsoc.Nsoc_round_1_sp_tracker_file(in=a) SPwithHB(in=b);
by spid;
if b=1;

NSOC_participate=0;
if fl1dnsoccomp>0 then NSOC_participate=1;
run;

*Sample number of care recipients;
proc surveyfreq data=NSOC_SPwithHB;
tables homebound3*NSOC_participate/cl;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
where NSOC_participate=1;
run;

*Sample caregivers;
proc sort data=Nsoc.Round1_cg;
by SPID;
run;

data NSOC_CGwithHB;
merge Nsoc.Round1_cg(in=a) SPwithHB(in=b);
by spid;
if a=1;

*assigning relationship group of helpers;
if c1relatnshp=2 then relationship=1; *spouse;
	else if c1relatnshp in(3, 4) and op1dage not in (-8, -7, -1, 1) then relationship=2;	*Adult child;
	else if c1relatnshp in(3, 4) and op1dage in (-8, -7, -1, 1) then relationship=3;	*Other relatives;
	else if (c1relatnshp =>5 and op1relatnshp<=29) or op1relatnshp=91 then relationship=3;	*Other relatives;
	else if c1relatnshp in (35, 36) then relationship=4;	*Friends or neighbors;
	else if c1relatnshp = 31 then relationship=5;	*Paid caregiver;
	else if c1relatnshp= -1 then relationship=.;
	else relationship = 6;
*Year of help;
if cdc1hlpyrs=>0 and cdc1hlpyrs<=1 then help_yr=1; *1 or less;
else if cdc1hlpyrs=2 or cdc1hlpyrs=3 then help_yr=2; *2-3;
else if cdc1hlpyrs=4 or cdc1hlpyrs=5 then help_yr=3; *4-5;
else if cdc1hlpyrs>5 then help_yr=4; *6 or more;
else help_yr=5;



format relationship relationshipf.;
format help_yr help_yrf.;
run;

*Number of caregivers based on NSOC participation;
proc surveyfreq data=NSOC_CGwithHB;
tables homebound3/cl;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
run;

proc sort data=NSOC_CGwithHB;
by homebound3;
run;

*Caregiver relationship;
proc surveyfreq data=NSOC_CGwithHB;
tables relationship/cl;
by homebound3;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
run;

*Duration of care (years);
proc surveyfreq data=NSOC_CGwithHB;
tables help_yr/cl;
by homebound3;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
run;

proc freq data=NSOC_CGwithHB ;
tables cdc1hlphrsdy*homebound3;
run;

*Mean hours of care per  type of helper;
*Need to remove duplicate by using nodukey;
proc sql;
create table CG_hours as
select SPID, homebound3, relationship, w1cgfinwgt0, c1varstrat, c1varunit,cdc1hlphrsdy from NSOC_CGwithHB where homebound3>0 and cdc1hlphrsdy>=0;
quit;

proc sort data=CG_hours;
by homebound3;
run;

proc surveymeans data=CG_hours mean sum STD;
var cdc1hlphrsdy;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
by homebound3;
where relationship=1; *Spouse;
run;

proc surveymeans data=CG_hours mean sum STD;
var cdc1hlphrsdy;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
by homebound3;
where relationship=2; *Child;
run;

proc surveymeans data=CG_hours mean sum STD;
var cdc1hlphrsdy;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
by homebound3;
where relationship=3; *Other relative;
run;

proc surveymeans data=CG_hours mean sum STD;
var cdc1hlphrsdy;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
by homebound3;
where relationship>3; *other non-relative;
run;

*Live with recipient... require OP1PRSNINHH from OP file;

proc sql;
create table OP_file as
select spid, OPID, OP1PRSNINHH from Nhatsrd1.Nhats_round_1_op_file_v2;
quit;

proc sort data=OP_file;
by spid opid;
run;

proc sort data=Nsoc_cgwithhb;
by spid opid;
run;

data NSOC_CGwithHBop;
merge OP_file Nsoc_cgwithhb (in=a);
by spid opid;
if a=1;
run;

proc sort data=NSOC_CGwithHBop;
by homebound3;
run;

proc surveyfreq data=NSOC_CGwithHBop;
tables op1prsninhh;
weight w1cgfinwgt0;
stratum c1varstrat ;
cluster c1varunit;
by homebound3;
run;

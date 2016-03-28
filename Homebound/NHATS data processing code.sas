libname derived "\\home\users$\lawk02\Documents\NHATS\Derived dataset";
libname NHATSRD1 'E:\nhats\data\NHATS Public\round_1';

proc import out=NHATSRD1.Nhats_round_1_sp_file
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File.dta"
			replace;
run;
proc import out=NHATSRD1.NHATS_Round_1_SP_Sen_Dem_File
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NHATS_Round_1_SP_Sen_Dem_File.dta"
			replace;
run;

*merging sensitive file to SP file;
proc sort data=NHATSRD1.Nhats_round_1_sp_file;
by spid;
run;

proc sort data=NHATSRD1.NHATS_Round_1_SP_Sen_Dem_File;
by spid;
run;

data round1_sp;
merge NHATSRD1.Nhats_round_1_sp_file Nhatsrd1.Nhats_round_1_sp_sen_dem_file;
by spid;
run;


*# of helpers per older adult (how many OPID per SPID);
*Getting homebound status from round 1 file;

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

proc freq data=round1_sp;
table homebound3;
run;
data test;
set round1_sp (keep = spid homebound3);
run;
proc sql;
create table test1
as select a.spid, a.homebound_cat, a.wave ,b.homebound3
from nhats_rg a
left join test b
on a.spid = b.spid;
quit;
data test1;
set test1;
if wave = 1;
run;
data test2;
set test1;
if homebound_cat = . and homebound3 ~= .;
run;

data test3;
set round1_sp (keep = spid homebound3  mo1outoft mo1outslf mo1outhlp mo1outdif needshelp helpdiff difficult independent) ;
if spid = 10009011;
run;

*Total number of helpers;
*# of observation = # of helpers;
*Sp_op1, SP homebound status merged to OP;
data Sp_op1;
set derived.Sp_op;
if homebound2=1 or homebound2=2 then homebound3=1;	*homebound;
if homebound2=3 then homebound3=2;					*semi, never by self;
if homebound2=4 then homebound3=3;					*semi, needs help;
if homebound2=5 or homebound2=6 then homebound3=4;	*not homebound;

if homebound=. then delete;
if op1ishelper=1;

*assigning relationship group of helpers;
if op1relatnshp=2 then relationship=1; *spouse;
	else if op1relatnshp in(3, 4) and op1dage not in (-8, -7, -1, 1) then relationship=2;	*Adult child;
	else if op1relatnshp in(3, 4) and op1dage in (-8, -7, -1, 1) then relationship=3;	*Other relatives;
	else if (op1relatnshp =>5 and op1relatnshp<=29) or op1relatnshp=91 then relationship=3;	*Other relatives;
	else if op1relatnshp in (35, 36) then relationship=4;	*Friends or neighbors;
	else if op1relatnshp = 31 then relationship=5;	*Paid caregiver;
	else if op1relatnshp= -1 then relationship=.;
	else relationship = 6;
if relationship in (1,2,3,4,6) then CG_paid=1;	*family, unpaid;
	else if relationship=5 then CG_paid=2;		*Paid caregiver;

if relationship in (1,2,3,4,6) then unpaid_cg=1;	*family, unpaid;
if relationship=5 then paid_cg=1;		*Paid caregiver;

*Assistance provided per type of helper;
if op1outhlp=1 or op1insdhlp=1 or op1bedhlp=1 then MO=1; else MO=0;
if op1eathlp=1 or op1bathhlp=1 or op1toilhlp=1 or op1dreshlp=1 then SC=1;else SC=0;
if op1launhlp=1 or op1shophlp=1 or op1mealhlp=1 or op1bankhlp=1 or op1moneyhlp=1 then HA=1; else HA=0;
if op1dochlp=1 or op1dochlpmst=1 or op1insurhlp=1 then MC=1; else MC=0;
if MO=1 and SC=1 and HA=1 and MC=1 then all_assist=1; else all_assist=0;


format cg_paid cg_paidf.;
format relationship relationshipf.;
format homebound3 homebound3f.;
run;


proc sort data=Sp_op1;
by homebound3;
run;

*count of paid/nonpaid caregiver by SPID as output;
proc freq data=sp_op1;
tables SPID*unpaid_cg/out=unpaid_cg noprint;
by homebound3;
where unpaid_cg=1;
run;

proc freq data=sp_op1;
tables SPID*paid_cg/out=paid_cg noprint;
by homebound3;
where paid_cg=1;
run;

*count of helpers as output;
proc freq data=Sp_op1;
table SPID/out=helper noprint;
by homebound3;
run;

data unpaid_cg;
set unpaid_cg;
unpaid_cg_num=count;
run;

data paid_cg;
set paid_cg;
paid_cg_num=count;
run;

data helper;
set helper;
helper=count;
run;

*include zero for descriptive stat;
proc sort data=round1_sp;
by SPID;
run;

proc sort data=helper;
by SPID;
run;

proc sort data=unpaid_cg;
by SPID;
run;

proc sort data=paid_cg;
by SPID;
run;

*# of helper merged into SP file;
data total_helpers;
merge round1_sp(in=a) helper (in=b) unpaid_cg (in=c) paid_cg (in=d);
by SPID;
if a;

helpers_cat=0;
if helper=. or helper=0 then helpers_cat=1;
if helper>0 and helper<4 then helpers_cat=2;
if helper>=4 and helper <7 then helpers_cat=3;
if helper>=7 then helpers_cat=4; 

unpaid_cg_cat=0;
if unpaid_cg_num=. then unpaid_cg_cat=1;
	else if unpaid_cg_num=1 then unpaid_cg_cat=2;
	else if unpaid_cg_num=2 then unpaid_cg_cat=3;
	else if unpaid_cg_num=>3 then unpaid_cg_cat=4;

paid_cg_cat=0;
if paid_cg_num=. then paid_cg_cat=1;
	else if paid_cg_num=1 then paid_cg_cat=2;
	else if paid_cg_num=2 then paid_cg_cat=3;
	else if paid_cg_num=>3 then paid_cg_cat=4;

marital=0;
if hh1martlstat in(1,2)then marital=1;				*Married or living with a partner;
	else if hh1martlstat in (3,4) then marital=2;	*Separated or divored;
	else if hh1martlstat=5 then marital=3;			*Widowed;
	else if hh1martlstat=6 then marital=4;			*Never married;
	else marital = 9;								*DKRF;

format marital maritalf.;
format unpaid_cg_cat paid_cg_cat cg_numf.;
format helpers_cat helpers_catf.;
run;


*Mean  hours of care per  type of helper;
*Need to remove duplicate;
proc sql;
create table hours as
select SPID, homebound3, sum(op1numhrsday) as sumhour from Sp_op1 where homebound3>0 and op1numhrsday>=0 group by SPID ;
quit;

proc sort data=hours nodupkey;
by SPID;
run;

*Mean number of helpers per activity, n (std) ;
proc sql;
create table SP_help as
select SPID, homebound3, sum(MO) as sum_mo, sum(SC) as sum_sc, sum(HA) as sum_ha, sum(MC) as sum_mc, w1anfinwgt0, w1varstrat,w1varunit
from sp_op1 where homebound3>0
group by SPID;
quit;

proc sort data=SP_help nodupkey;
by SPID;
run;





data SP_help2;
set SP_help;
if (sum_mo and sum_sc and sum_ha and sum_mc)>0 then allhelp=1; else allhelp=0;
if sum_mo > 0 then mo=1; else mo=0;
if sum_sc > 0 then sc=1; else sc=0;
if sum_ha > 0 then ha=1; else ha=0;
if sum_mc > 0 then mc=1; else mc=0;
run;

proc sort data=SP_help2;
by homebound3;
run;





libname ko "E:\nhats\data\Projects\Caregivers";
libname nhats "E:\nhats\data\NHATS working data";

/*imported raw OP database from round 1*/

proc import out=nhats_r1_OP
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_OP_File_old.dta"
			replace;
run;

/*checking frequencies on various variables (Scratch work)*/
proc means data=nhats_r1_op;
var op1numhrsday;
run;

/*Checking for duplicates for OP*/
proc sort data=nhats_r1_op;
by spid opid;
run;
proc sort data=nhats_r1_op out=test nodupkey;
by spid opid;
run;
/*there are none*/

/*Defining the "Helpers" as those who answered the Helper Question as "Yes" (NHATS Helpers form: BOX HL1)*/
data helpers;
set nhats_r1_op;
if op1ishelper = 1;
run;

data nhats_complete;
set nhats.nhats_wave1_all_obs;
if complete = 1;
run;
proc sql;
create table helpers0
as select a.*, b.opid, b.op1relatnshp,b.op1numhrsday,b.op1numdayswk,b.op1numdaysmn,b.op1paidhelpr, b.op1dhrsmth, b.op1ishelper, b.op1paidhelpr, b.op1helpsched,
b.op1insdhlp, b.op1bedhlp, b.op1launhlp, b.op1shophlp, b.op1mealhlp, b.op1bankhlp, b.op1eathlp, b.op1bathhlp, b.op1toilhlp, b.op1dreshlp, b.op1medshlp
from nhats_complete a
left join helpers b
on a.spid = b.spid;
quit;
proc freq data=helpers0;
table op1ishelper op1paidhelpr op1ishelper*op1paidhelpr;
run;

data helpers1;
set helpers0;
if op1dhrsmth = 9999 then op1dhrsmth = .;
if op1dhrsmth < 0 then op1dhrsmth = .;
if died = . then delete;
/*paid caregiver*/
op_is_paid = .;
if op1paidhelpr = 1 then op_is_paid = 1;
if op1paidhelpr = 2 then op_is_paid = 0;
/*Relationship with SP: 1 is spouse, 2 is daughter, 3 is son, 4 is other relatives, 5 is paid caregiver, 6 is other non-relatives*/
op_relationship_cat = .;
if op1relatnshp = 2 then op_relationship_cat = 1;
if op1relatnshp = 3 |  op1relatnshp = 5 | op1relatnshp = 7 then op_relationship_cat = 2;
if op1relatnshp = 4 |  op1relatnshp = 6 | op1relatnshp = 8 then op_relationship_cat = 3;
if (op1relatnshp >= 9 and op1relatnshp <= 29) OR op1relatnshp = 91 then op_relationship_cat = 4;
/*Paid Caregiver. Only those we know who got paid is added as the paid caregiver*/
if ((op1relatnshp >= 30 and op1relatnshp <= 40) OR op1relatnshp = 92) AND op_is_paid = 1 then op_relationship_cat = 5;
if ((op1relatnshp >= 30 and op1relatnshp <= 40) OR op1relatnshp = 92) AND (op_is_paid = 0|op_is_paid=.) then op_relationship_cat = 6;
/*dummy variables*/
op_relationship_cat1 = (op_relationship_cat=1);
op_relationship_cat2 = (op_relationship_cat=2);
op_relationship_cat3 = (op_relationship_cat=3);
op_relationship_cat4 = (op_relationship_cat=4);
op_relationship_cat5 = (op_relationship_cat=5);
op_relationship_cat6 = (op_relationship_cat=6);


/*total hours worked*/
total_hours_day = op1numhrsday + 0;
if total_hours_day < 0 then total_hours_day = .;
total_hours_week = op1numdayswk + 0;
if total_hours_week < 0 then total_hours_week = .;
total_days_month = op1numdaysmn + 0;
if total_days_month < 0 then total_days_month = .;
/*if the cargiver was a regular then you calculated it days a week per day and multiply that by 4*/
if op1helpsched = 1 then total_hours = total_hours_week * total_hours_day * 4;
/*if they were not a regular than you calculated the total days in the month by total hours*/
if op1helpsched ~= 1 then total_hours = total_days_month * total_hours_day;

run;

data test;
set helpers1 (keep = spid opid op1helpsched op1numhrsday op1numdayswk op1numdaysmn total_hours op1dhrsmth);
run;

proc means data=helpers1;
class spouse;
var total_hours;
run;
/*checking dummy variables*/
proc freq data=helpers1;
table op_relationship_cat1 op_relationship_cat2 op_relationship_cat3 op_relationship_cat4 op_relationship_cat5;
run;
/** ADLs and IADLs **/
proc freq data=helpers1;
table op1insdhlp op1bedhlp op1launhlp op1shophlp op1mealhlp op1bankhlp op1eathlp
op1bathhlp op1toilhlp op1dreshlp op1medshlp;
run;
%let varlist = insd bed laun shop meal bank eat bath toil dres meds;
%macro adl_iadl;
%let i = 1;
%let var = %scan(&varlist,&i);
%do %while(&var ne );
data helpers1;
set helpers1;
%if &var = insd | &var = bed | &var = eat | &var =  bath| &var =  toil| &var =  dres %then %do;
op_adl_&var. = .;
if op1&var.hlp = 1 then op_adl_&var. = 1;
if op1&var.hlp ~= 1 then op_adl_&var. = 0;
%end;
%if &var = laun | &var = shop | &var = meal | &var =  bank | &var =  meds %then %do;
op_iadl_&var. = .;
if op1&var.hlp = 1 then op_iadl_&var. = 1;
if op1&var.hlp ~= 1 then op_iadl_&var. = 0;
%end;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%end;
%mend;
%adl_iadl();
quit;
data helpers1;
set helpers1;
if  op_adl_eat = 1 | op_adl_bath = 1 | op_adl_toil = 1 | op_adl_dres = 1 | op_adl_insd = 1 | op_adl_bed = 1  then any_adl = 1;
if any_adl = . then any_adl = 0;
if op_iadl_laun = 1 | op_iadl_shop = 1 | op_iadl_meal = 1 | op_iadl_bank = 1 |  op_iadl_meds = 1 then any_iadl = 1;
if any_iadl = . then any_iadl = 0;
run;


proc freq data=helpers1;
table total_hours op_relationship_cat op_relationship_cat*op_is_paid /  missing;
run;

/*code 9999 = missing*/
data test_9999;
set helpers1;
if op1dhrsmth = 9999;
run;
/*no one is above normal amount of hours. 744 = 31(days in mos) * 24(hours in day) */
data test_extreme;
set helpers1;
if op1dhrsmth > 744;
run;
/*Ask Katherine about the distribution*/
proc univariate data=helpers1;
var op1dhrsmth;
histogram;
run;

proc freq data=helpers1;
table op1dhrsmth total_hours;
run;
proc sort data=helpers1;
by spid opid;
run;
proc freq data=helpers1;
table w1anfinwgt0 ;
run;


data helpers2;
set helpers1;
retain hours_helped count_helpers num_spouse num_daug num_son num_oth_fam num_paid_cg num_other_nofam;
by spid opid;
hours_helped = sum(hours_helped, op1dhrsmth);
count_helpers = count_helpers + 1;
num_spouse = num_spouse + op_relationship_cat1;
num_daug = num_daug + op_relationship_cat2;
num_son = num_son + op_relationship_cat3;
num_oth_fam = num_oth_fam + op_relationship_cat4;
num_paid_cg = num_paid_cg + op_relationship_cat5;
num_other_nofam = num_other_nofam + op_relationship_cat6;
if first.spid then do;
hours_helped = op1dhrsmth;
if op1ishelper = . then count_helpers = 0;
if op1ishelper ~= . then count_helpers = 1;
num_spouse = op_relationship_cat1;
num_daug = op_relationship_cat2;
num_son = op_relationship_cat3;
num_oth_fam = op_relationship_cat4;
num_paid_cg = op_relationship_cat5;
num_other_nofam = op_relationship_cat6;
end;
if last.spid;
log_hours_helped = log(hours_helped + 1);
num_helper_cat = .;
if count_helpers = 0 then num_helper_cat = 0;
if count_helpers >= 1 and count_helpers <=3 then num_helper_cat = 1;
if count_helpers >= 4 and count_helpers <=6 then num_helper_cat = 2;
if count_helpers >= 7 then num_helper_cat = 3;

if num_spouse = 0 then spouse_i = 0;
if num_spouse >= 1 then spouse_i = 1;
if num_daug = 0 then daug_i = 0;
if num_daug >= 1 then daug_i = 1;
if num_son = 0 then son_i = 0;
if num_son >= 1 then son_i = 1;
if num_oth_fam = 0 then oth_fam_i = 0;
if num_oth_fam >= 1 then oth_fam_i = 1;
if num_paid_cg = 0 then paid_cg_i = 0;
if num_paid_cg >= 1 then paid_cg_i = 1;
if num_other_nofam = 0 then oth_nofam_i = 0;
if num_other_nofam >= 1 then oth_nofam_i = 1;
run;

data test;
set helpers2 (keep = spid opid count_helpers total_hours op1dhrsmth hours_helped);
run;

data test1;
set helpers2 (keep = spid opid num_spouse num_daug num_son num_oth_fam num_paid_cg num_other_nofam op_relationship_cat1-op_relationship_cat6);
run;
proc freq data=helpers2;
table num_spouse num_daug num_son num_oth_fam num_paid_cg num_other_nofam;
run;
proc freq data=helpers2;
table spouse_i daug_i son_i oth_fam_i paid_cg_i oth_nofam_i;
run;
proc means data=helpers2;
var hours_helped;
run;

/*
proc univariate data=helpers2;
var hours_helped log_hours_helped;
histogram;
run;
/*checking hours on those who are missing*/
/*data missing;
set helpers2;
if hours_helped = .;
run;
/*take the first 10 people missing hours*/
/*data test_missing;
set helpers1;
if spid = 10000119 or spid = 10000172 or spid = 10000204 or spid = 10000401 or spid = 10000541 or spid = 10000621 or spid = 10000856 or spid = 10000874 or spid = 10000898 or spid = 10001131;
run;
*/
proc export data=helpers1 outfile = "E:\nhats\data\Projects\Caregivers\Helpers.dta" dbms = dta replace;
run;
proc export data=helpers2 outfile = "E:\nhats\data\Projects\Caregivers\Helpers1.dta" dbms = dta replace;
run;
/*
ods rtf body = "E:\nhats\projects\Caregivers_KO\10212015\SAS_Helper_Output.rtf";
ods html close;
ods html;
proc sql;
select sum(count_helpers) as Total_Helpers_All
from helpers2;
quit;
proc sql;
select sum(count_helpers) as Total_Helpers_Survived
from helpers2
where died = 0;
quit;
proc sql;
select sum(count_helpers) as Total_Helpers_Died
from helpers2
where died = 1;
quit;
proc sql;
select sum(count_helpers) as Total_Helpers_Died
from helpers2
where died = .;
quit;
proc freq data=helpers2;
title "Number of people who died";
table died;
run;
proc means data=helpers2 n missing mean median std min max;
title "Mean/Median number of Helpers of all Patients";
var count_helpers;
run;
proc means data=helpers2 n missing mean median std min max;
title "Mean/Median number of Helpers per Group";
class died;
var count_helpers;
run;
proc freq data=helpers2;
title "Categories of Num. Helpers per Adult (ALL PATIENTS)";
table num_helper_cat;
run;
proc freq data=helpers2;
title "Categories of Num. Helpers per Adult (Survived)";
where died = 0;
table num_helper_cat;
run;
proc freq data=helpers2;
title "Categories of Num. Helpers per Adult (Died)";
where died = 1;
table num_helper_cat;
run;
proc freq data=helpers2;
title "Categories of Num. Helpers per Adult (Died)";
where died = .;
table num_helper_cat;
run;
proc means data=helpers2 n missing mean median std min max;
title "Total Mean hours of help per older adult (ALL Patients)";
var hours_helped;
run;
proc means data=helpers2 n missing mean median std min max;
title "Total Mean Hours of help per older adult per group";
class died;
var hours_helped;
run;
proc ttest data=helpers2;
title "T-Test for Mean Hours (just a look)";
class died;
var log_hours_helped;
run;
ods rtf close;
*/

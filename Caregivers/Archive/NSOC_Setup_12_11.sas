libname ko "E:\nhats\data\Projects\Caregivers";
libname nhats "E:\nhats\data\NHATS working data";


/************************** NSOC DATA SETUP ********************************/

proc import out = RAW_NSOC
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NSOC_Round_1_File_v2_old.dta"
			replace;
run;
proc freq data=raw_nsoc;
table c1dintdays;
run;
proc import out = RAW_OP
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_OP_File_old.dta"
			replace;
run;
proc import out = RAW_OP_SENSITIVE
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NHATS_Round_1_OP_Sen_Dem_File_old.dta"
			replace;
run;
proc import out = NSOC_SP_Tracker
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NSOC_Round_1_SP_Tracker_File.dta"
			replace;
run;
proc import out = NSOC_OP_Tracker
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NSOC_Round_1_OP_Tracker_File.dta"
			replace;
run;
proc import out=raw_nhats_r1
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File_old.dta"
			replace;
run; 
proc import out=raw_nhats_r2_sens
			datafile = "E:\nhats\data\NHATS Sensitive\r2_sensitive\NHATS_Round_2_SP_Sen_Dem_File.dta"
			replace;
run;

/**Final NSOC Database**/
data final_nhats;
set nhats.Nhats_wave1_all_obs;
run;
proc freq data=final_nhats;
table died cs1dreconcil;
run;

proc freq data = RAW_OP;
table op1prsninhh op1martlstat op1numchldrn op1ishelper op1sppayshlp cs1dreconcil;
run;
proc freq data = raw_op_sensitive;
table op1age op1catgryage;
run;

/*Adding in the OP Demographics to the NSOC dataset*/
proc sql;
create table raw_nsoc1
as select a.*, b.op1prsninhh, b.op1martlstat, b.op1numchldrn, b.op1ishelper, b.op1sppayshlp, b.op1leveledu, b.op1prsninhh,
c.op1age, c.op1catgryage, d.hh1livwthspo, d.cs1dreconcil, d.hh1martlstat, d.hh1dhshldnum, d.died, d.died_24, d.complete, d.ADL_IADL_ind
from raw_nsoc a
left join raw_op b
on a.spid = b.spid
and a.opid = b.opid
left join raw_op_sensitive c
on a.spid = c.spid
and a.opid = c.opid
left join final_nhats d
on a.spid = d.spid;
quit;

proc freq data= raw_nsoc1;
table op1prsninhh op1martlstat op1numchldrn op1ishelper op1sppayshlp op1age op1catgryage op1leveledu cs1dreconcil hh1martlstat hh1dhshldnum chd1educ
c1relatnshp chd1martstat chi1medicare cca1hwget2sp op1prsninhh hh1livwthspo cca1hlpothin;
run;

proc freq data=raw_nsoc1;

table cec1wrk4pay;
run;
proc freq data=nsoc;
table cg_spouse;
run;
data nsoc;
set raw_nsoc1;

/*** Drop the variations of the NSOC Weight Variable. Use primarily "w1cgfinwgt0" for full Sample ***/

drop w1cgfinwgt1 - w1cgfinwgt56;

/*female variable*/
cg_female = .;
if c1dgender = 1 then cg_female = 0;
if c1dgender = 2 then cg_female = 1;

/*Creating Spouse Variable */
cg_spouse = .;
if c1relatnshp = 2 then cg_spouse = 1;
if c1relatnshp ~= 2 then cg_spouse = 0;
/*Relationship Categorical Variable. If Spouse then Cat = 1, if any form of their child (bio, in-law, step) then cat = 2 others are equal to 0*/
cg_relationship_cat = 3;
if c1relatnshp = 2 then cg_relationship_cat = 1;
if c1relatnshp >= 3 and c1relatnshp <= 8 then cg_relationship_cat = 2;
/*antoher categorical: 1 = spouse, 2 = daughter (any), 3 = son (any), 4 = any relative, 5 = other non-relative*/
cg_relationship_cat1 = .;
if c1relatnshp = 2 then cg_relationship_cat1 = 1;
if c1relatnshp = 3 |  c1relatnshp = 5 | c1relatnshp = 7 then cg_relationship_cat1 = 2;
if c1relatnshp = 4 |  c1relatnshp = 6 | c1relatnshp = 8 then cg_relationship_cat1 = 3;
if (c1relatnshp >= 9 and c1relatnshp <= 29) OR c1relatnshp = 91 then cg_relationship_cat1 = 4;
if (c1relatnshp >= 30 and c1relatnshp <= 39) OR c1relatnshp = 92 then cg_relationship_cat1 = 5;

/*gathering total hours a day/week/month/other */
total_hours_day = cdc1hlphrsdy + 0;
if total_hours_day < 0 then total_hours_day = .;
total_hours_week = cdc1hlpdyswk + 0;
if total_hours_week < 0 then total_hours_week = .;
total_days_month = cdc1hlpdysmt + 0;
if total_days_month < 0 then total_days_month = .;
total_hours_other = cdc1hlphrlmt + 0;
if total_hours_other < 0 then total_hours_other = .;
other_flag = 0;
if cdc1hlphrmvf ~= 1 then other_flag=1;
/*if the cargiver was a regular then you calculated it days a week per day and multiply that by 4*/
if cdc1hlpsched = 1 then total_hours = total_hours_week * total_hours_day * 4;
/*if they were not a regular than you calculated the total days in the month by total hours*/
if cdc1hlpsched ~= 1 then total_hours = total_days_month * total_hours_day;
if other_flag = 1 then total_hours = total_hours_other;

/* LIVING CHILDREN MISSING DATA */
Any_Living_Children_SP = 0;
if cs1dreconcil ~= 3 then Any_Living_Children_SP = 1;
Any_Living_Children_CG = .;
if chd1chldlvng = 2 then Any_Living_Children_CG = 0;
if chd1chldlvng = 1 then Any_Living_Children_CG = 1;
if cg_spouse = 1 then cg_living_children = Any_Living_Children_SP;
if cg_spouse = 0 then cg_living_children = Any_Living_Children_CG;
drop Any_Living_Children_SP Any_Living_Children_CG;

/*MARITAL STATUS MISSING DATA */
if cg_spouse = 1 then cg_Marital_status = hh1martlstat;
if cg_spouse = 0 then cg_marital_status = chd1martstat;
if cg_marital_status = . then cg_Marital_Status =op1martlstat; 
cg_marr_part_ind = .;
if cg_marital_status = 1 or cg_marital_status = 2 then cg_marr_part_ind = 1;
if cg_marital_status >= 3 then cg_marr_part_ind = 0;

/*NUMBER IN HOUSEHOLD */
if cg_spouse = 1 then cg_total_in_hh = hh1dhshldnum;
if cg_spouse = 0 then cg_total_in_hh = chd1numinhh;
if cg_total_in_hh < 0 then cg_total_in_hh = .;

/*EDUCATION OF CAREGIVER */
if cg_spouse = 1 then cg_educ = op1leveledu;
if cg_spouse = 0 then cg_educ = chd1educ;
if cg_educ < 0 then cg_educ = .;
cg_gt_hs = .;
if cg_educ >= 4 then cg_gt_hs = 1;
if cg_educ < 4 and cg_educ >= 0 then cg_gt_hs = 0;

/* Caregiver Medicare */
cg_medicare = .;
if chi1medicare = 1 then cg_medicare = 1;
if chi1medicare = 2 then cg_medicare = 0;

/* Lives with SP */
if cg_spouse = 1 then cg_lives_with_SP = hh1livwthspo;
if cg_spouse = 0 then cg_lives_with_sp = op1prsninhh;
if cg_lives_with_SP < 0 then cg_lives_with_sp = .;

run;
proc freq data=nsoc;
table cg_relationship_cat1 cpp1wrk4pay cec1wrk4pay;
run;
proc print data = nsoc (obs = 100);
where cec1wrk4pay = 2;
var cec1wrk4pay cec1ownbusns cec1unpdwrk cec1misswork cec1look4wrk cec1hrsweek cec1hrslstwk cec1hrslast;
run;
data test;
set nsoc (keep = spid op1prsninhh hh1livwthspo c1relatnshp cg_spouse cg_lives_with_sp);
run;
proc freq data=nsoc;
table
che1hrtattck che1othheart che1arthrits che1diabetes che1lungdis
che1cancer cca1hwoftpc cca1hwofthom cca1hwoftshp cca1hwoftchs
cca1hlpbnkng cca1hlpmed cca1hlpmdapt cca1hlpspkdr cca1hlpordmd
cca1hlpinsrn cca1hlpdiet cca1hlpfeet cca1hlpskin cca1hlpexrcs
cca1hlpteeth cca1hlpmdtk cca1hlpshot

cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1exhaustd cac1toomuch cac1notime cac1uroutchg
cac1diffinc cac1diffemo cac1diffphy che1fltltin;
run;

proc format;
value yesno_ 1 = "Yes"
			 0 = "No"
			 . = "Missing";
value cat1_  1 = "Every Day"
			 2 = "Most Days"
			 3 = "Some Days"
			 4 = "Rarely"
			 5 = "Never";
value cat1a_ 1 = "Every/Most/Some Days"
			 0 = "Rarely/Never";
value cat2_  1 = "Very Much"
			 2 = "Somewhat"
			 3 = "Not So Much";
value cat2a_ 1 = "Very Much/Somewhat"
			 0 = "Not So Much";
value cat3_  1 = "Not At All"
			 2 = "Several Days"
			 3 = "More Than Half The Days"
			 4 = "Nearly Every Day";
value cat3a_ 0 = "Not At All"
			 1 = "At least Sever Days";
run;
option nospool;
proc freq data=nsoc;
table che1sleeptrb trb_back_sleep;
run;
%let varlist = che1hrtattck che1othheart che1arthrits che1diabetes che1lungdis che1cancer che1pain che1brethprb che1lowenrgy  che1lost10lb che1highbld che1osteoprs che1seeing che1hearing;
%let varlist1 = ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer ever_pain ever_breath_prob ever_low_enrgy  lost_10_lbs_yr ever_high_bp
ever_osteoperosis ever_diff_seeing ever_diff_hearing;
%macro ever_disease;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 0; 
run;
proc freq data=nsoc;
table &var &var1;
format &var1 yesno_.;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%ever_disease;

%let varlist = che1fltltlin che1fltdown che1fltnervs che1fltworry;
%let varlist1 = felt_lit_interest felt_depressed felt_nervous felt_worry;
%macro ever_disease1;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );

data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 2;
if &var = 3 then &var1 = 3;
if &var = 4 then &var1 = 4;
&var1._di = .;
if &var = 2 or &var = 3 or &var = 4 then &var1._di = 1;
if &var = 1 then &var1._di = 0;

run;
proc freq data=nsoc;
table &var &var1 &var1._di;
format &var1 cat3_. &var1._di cat3a_.;
run;

%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%ever_disease1;

%let varlist = che1health che1painlmt che1brethlmt che1enrgylmt cca1hwoftpc cca1hwofthom cca1hwoftshp cca1hwoftchs che1sleeptrb;
%let varlist1 =  self_health pain_lim_act breath_lim_act enrgy_lim_act help_personal_care help_get_around help_shopping help_chores trb_back_sleep;
%macro help1;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 2;
if &var = 3 then &var1 = 3;
if &var = 4 then &var1 = 4;
if &var = 5 then &var1 = 5;
&var1._di = .;
if &var = 1 or &var = 2 or &var = 3 then &var1._di = 1;
if &var = 4 or &var = 5 then &var1._di = 0;

run;
proc freq data=nsoc;
table &var &var1 &var1._di;
format &var1 cat1_. &var1._di cat1a_.;
run;

%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%help1;

%let varlist = cca1hlpbnkng cca1hlpmed cca1hlpmdapt cca1hlpspkdr cca1hlpordmd cca1hlpinsrn cca1hlpothin cca1hlpdiet cca1hlpfeet cca1hlpskin cca1hlpexrcs cca1hlpteeth cca1hlpmdtk cca1hlpshot cse1frfamhlp cpp1wrk4pay;
%let varlist1 = help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help work_4_pay;
%macro help2;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 0; 
run;
proc freq data=nsoc;
table &var &var1;
format &var1 yesno_.;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%help2;

%let varlist = cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1exhaustd cac1toomuch cac1notime cac1uroutchg;
%let varlist1 = gain_more_conf gain_deal_better gain_closer2SP gain_more_satisfied neg_exhausted neg_too_much neg_no_time neg_no_routine;
%macro gain_neg;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 2;
if &var = 3 then &var1 = 3;
&var1._di = .;
if &var = 1 or &var = 2 then &var1._di = 1;
if &var = 3 then &var1._di = 0;
run;
proc freq data=nsoc;
table &var &var1 &var1._di;
format &var1 cat2_. &var1._di cat2a_.;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%gain_neg;
option spool;
proc freq data=nsoc;
table cac1diffinc cac1diffinlv;
run;
%let varlist = cac1diffinc cac1diffemo cac1diffphy;
%let varlist1 = diff_financial diff_emotional diff_physical;
%macro difficulty;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 0; 
run;
proc freq data=nsoc;
table &var &var1;
format &var1 yesno_.;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%difficulty;
%let varlist = cac1diffinlv cac1diffemlv cac1diffphlv;
%let varlist1 = diff_financial_lv diff_emotional_lv diff_physical_lv;
%let varlist2 = cac1diffinc cac1diffemo cac1diffphy;
ods rtf body = "E:\nhats\data\Projects\Caregivers\logs\diffculty_levels.rtf";
%macro difficulty1;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%let var2 = %scan(&varlist2, &i);
%do %while(&var ne );

data nsoc;
set nsoc;
&var1 = .;
if &var2 = 2 then &var1 = 0;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 2;
if &var = 3 then &var1 = 3;
if &var = 4 then &var1 = 4;
if &var = 5 then &var1 = 5;
&var1._di = .;
if &var2 = 2 then &var1._di = 0;
if &var = 1 or &var = 2 or &var = 3 then &var1._di = 0;
if &var = 4 or &var = 5 then &var1._di = 1;
run;
proc freq data=nsoc;
table &var &var1 &var1._di;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%let var2 = %scan(&varlist2, &i);
%end;
%mend;
%difficulty1;
ods rtf close;

%let varlist = cdc1hlpsched cdc1hlpyrpls;
%let varlist1 = help_regular_sched help_longer_than_yr;
%macro misc_binary;
%let i = 1;
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%do %while(&var ne );
data nsoc;
set nsoc;
&var1 = .;
if &var = 1 then &var1 = 1;
if &var = 2 then &var1 = 0; 
run;
proc freq data=nsoc;
table &var &var1;
format &var1 yesno_.;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%let var1 = %scan(&varlist1, &i);
%end;
%mend;
%misc_binary;

/*
proc sql;
create table nsoc1
as select a.*, b.cg_age as age1, b.dem_3_cat, b.sr_gad2_anxiety, b.sr_phq2_depressed
from nsoc a
left join nsoc_rg b
on a.spid = b.spid and a.opid = b.opid;
quit;
proc freq data=nsoc_rg;
table dem_3_cat sr_gad2_anxiety sr_phq2_depressed;
run;
proc freq data=nsoc1;
table dem_3_cat sr_gad2_anxiety sr_phq2_depressed;
run; 
*/
data ko.nsoc_raw1;
set nsoc;
run;
proc freq data=ko.nsoc_raw1;
table diff_physical_lv_di;
run;

/*****AGE CATEGORIES********/


/*Bringing in raw OP, but change to bring in the final OP: TO DO LATER*/
proc import out = RAW_OP_SENS
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NHATS_Round_1_OP_Sen_Dem_File_old.dta"
			replace;
run;
proc freq data=raw_op_sens;
table op1catgryage;
run;

data nsoc;
set ko.nsoc_raw1;
run;
proc freq data=nsoc;
table chd1cgbrthyr;
run;

/*bring in variables regarding year and month of brith.*/
proc sql;
create table raw_op_sens1
as select a.*, b.op1dage, b.op1dcatgryag, c.chd1cgbrthmt, c.chd1cgbrthyr
from raw_op_sens a
left join raw_op b
on a.spid = b.spid and
a.opid = b.opid
left join nsoc c
on a.spid = c.spid and
a.opid = c.opid;
quit;
proc freq data=raw_op_sens1;
where op1catgryage < 0;
table op1dage;
run;
proc freq data=raw_op_sens1;
where op1age<=0 and op1catgryage < 0;
table chd1cgbrthyr;
run;
/*all op continuous variable have some sort of categorical variable*/
proc means data=raw_op_sens1 n nmiss mean median min max std;
where op1dage >0;
var op1age;
run;

data test;
set raw_op_sens1;
if op1dage = 1;
run;


/*AGE CATEGORIES
1 - UNDER 20
2 - 20-24
3 - 25-29
4 - 30-34
5 - 35-39
6 - 40-44
7 - 45-49
8 - 50-54
9 - 55-59
10 - 60-64
11 - 65-69
12 - 70-74
13 - 75-79
14 - 80-84
15 - 85-89
16 - 90 +
*/

data raw_op_sens2;
set raw_op_sens1;
/*use the regular categorical variable and add in sensitive categories for the ones that are missing*/
if op1dage < 0 and op1catgryage >0 then op1dage = op1catgryage;
if op1dage <0 then op1dage = .;
if op1dage >16 then op1dage = 16;


if chd1cgbrthyr > 0 then cg_age_approx = 2011 - chd1cgbrthyr;

/*based on categories*/

if cg_age_approx < 20 and cg_age_approx > 0 and op1dage = . then op1dage = 1;
if cg_age_approx >= 20 and cg_age_approx <=24 and op1dage = . then op1dage = 2;
if cg_age_approx >= 25 and cg_age_approx <=29 and op1dage = .  then op1dage = 3;
if cg_age_approx >= 30 and cg_age_approx <=34 and op1dage = .  then op1dage = 4;
if cg_age_approx >= 35 and cg_age_approx <=39 and op1dage = .  then op1dage = 5;
if cg_age_approx >= 40 and cg_age_approx <=44 and op1dage = .  then op1dage = 6;
if cg_age_approx >= 45 and cg_age_approx <=49 and op1dage = .  then op1dage = 7;
if cg_age_approx >= 50 and cg_age_approx <=54 and op1dage = .  then op1dage = 8;
if cg_age_approx >= 55 and cg_age_approx <=59 and op1dage = .  then op1dage = 9;
if cg_age_approx >= 60 and cg_age_approx <=64 and op1dage = .  then op1dage = 10;
if cg_age_approx >= 65 and cg_age_approx <=69 and op1dage = .  then op1dage = 11;
if cg_age_approx >= 70 and cg_age_approx <=74 and op1dage = .  then op1dage = 12;
if cg_age_approx >= 75 and cg_age_approx <=79 and op1dage = .  then op1dage = 13;
if cg_age_approx >= 80 and cg_age_approx <=84 and op1dage = .  then op1dage = 14;
if cg_age_approx >= 85 and cg_age_approx <=89 and op1dage = .  then op1dage = 15;
if cg_age_approx >= 90 and op1dage = .  then op1dage = 16;


rename op1dage = cg_age_cat;
run;
proc freq data=raw_op_sens2;
table cg_age_cat ;
run;


proc sql;
create table nsoc_w_age
as select a.*, b.cg_age_cat
from nsoc a
left join raw_op_sens2 b
on a.spid = b.spid
and a.opid = b.opid;
quit;
proc freq data=nsoc_w_age;
table cg_age_cat ;
run;
proc freq data=nsoc_w_age;
where cg_age_cat = .;
table cg_spouse;
run;

data nsoc1;
set nsoc_w_age;
run;

proc means data=nsoc_pay;
var cec1hrsweek cec1hrslstwk;
run;

data nsoc_pay;
set nsoc1 ;
/*paid last week variable binary 1/0*/
paid_last_week = cec1wrk4pay;
if cec1wrk4pay < 0 then paid_last_week = .;
if cec1wrk4pay = 2 | cec1wrk4pay = 3 then paid_last_week = 0;

if cec1hrslstwk < 0 then cec1hrslstwk = .;
if cec1wrk4pay = 1 then paid_hours = cec1hrslstwk;


if paid_hours <=20 and paid_hours~= . then paid_hours_cat = 0;
if paid_hours >=21 and paid_hours<=39 then paid_hours_cat = 1;
if paid_hours >=40 then paid_hours_cat = 2;
/*if they didn't work last week then their paid hours is 0 and their category is zero*/
if paid_last_week = 0 then paid_hours = 0;
if paid_last_week = 0 then paid_hours_cat = 0;
run;
ods rtf body = "E:\nhats\projects\Caregivers_KO\11242015\Pay_Hours.rtf";
proc freq data=nsoc_pay;
table cec1wrk4pay paid_last_week paid_hours_cat paid_hours;
run;
proc means data=nsoc_pay;
var paid_hours;
run;
ods rtf close;
data nsoc1;
set nsoc_pay;
run;



proc freq data=nsoc1;
table che1fltltlin;
run;
data nsoc_phq_gad;
set nsoc1;
if che1fltltlin >= 0 then cg_depr_pqq1 = che1fltltlin;
if che1fltdown >= 0 then cg_depr_pqq2 = che1fltdown;
if che1fltnervs >= 0 then cg_depr_gad1 = che1fltnervs;
if che1fltworry >= 0 then cg_depr_gad2 = che1fltworry;
cg_depr_pqq1 = cg_depr_pqq1-1;
cg_depr_pqq2 = cg_depr_pqq2-1;
cg_depr_gad1 = cg_depr_gad1-1;
cg_depr_gad2 = cg_depr_gad2-1;
cg_phq2_score = sum(cg_depr_pqq1, cg_depr_pqq2);
cg_gad2_score = sum(cg_depr_gad1, cg_depr_gad2);
cg_phq2_depressed = .;
if cg_phq2_score >= 3 then cg_phq2_depressed = 1;
else if cg_phq2_score < 3 and cg_phq2_score ~= . then cg_phq2_depressed = 0;
cg_gad2_anxiety = .;
if cg_gad2_score >= 3 then cg_gad2_anxiety = 1;
else if cg_gad2_score < 3 and cg_gad2_score ~= . then cg_gad2_anxiety = 0;
run;
ods rtf body = "E:\nhats\projects\Caregivers_KO\11242015\PHG_GAD.rtf";
proc freq data=nsoc_phq_gad;
table cg_depr_pqq1 cg_depr_pqq2 cg_depr_gad1 cg_depr_gad2 cg_phq2_score cg_gad2_score cg_phq2_depressed cg_gad2_anxiety;
run;
ods rtf close;

data nsoc1;
set nsoc_phq_gad;
run;
proc freq data=nsoc1;
table diff_physical_lv_di;
run;


proc freq data=nsoc1;
table cca1lstmhlpd;
run;

data flag_no_help_month;
set nsoc1;
if cca1hlplstyr = 1 then flag_no_help_mth = 1;
run;
proc freq data=flag_no_help_month;
table flag_no_help_mth;
run;

data nsoc1;
set flag_no_help_month;
run;
proc freq data=nsoc1;
table diff_physical_lv_di;
run;

/*************************** HALF WAY POINT SAVE **********************************/

data nhats.nsoc1_half;
set nsoc1;
run;

/*************************** HALF WAY POINT SAVE **********************************/

proc freq data=nhats.nhats_wave1_all_obs;
table died;
run;
proc sql;
create table raw_op_sp_dies
as select a.*, b.died, c.op1dnsoc as nsoc_eligible
from raw_op a
left join  nhats.nhats_wave1_all_obs b
on a.spid = b.spid
left join nsoc_op_tracker c
on a.spid = c.spid and a.opid = c.opid;
quit;
proc freq data=raw_op_sp_dies;
table died nsoc_eligible;
run;
data raw_op_sp_dies1;
set raw_op_sp_dies;
if died ~= .;
run;
proc freq data=raw_op_sp_dies1;
table died nsoc_eligible;
run;
proc sort data=nsoc1 out=nsoc1a;
by spid opid;
run;
data nsoc_helper_num;
set nsoc1a;
if died ~= .;
by spid opid;
retain informal_nsoc_comp informal_nsoc_comp_i;
informal_nsoc_comp = informal_nsoc_comp + 1;
if first.spid then do ;
informal_nsoc_comp = 1;
informal_nsoc_comp_i = 1;
end;
run;

data test;
set nsoc_helper_num (keep = spid opid informal_nsoc_comp informal_nsoc_comp_i);
run;
proc freq data = nsoc_helper_num;
table informal_nsoc_comp informal_nsoc_comp_i;
run;
data nsoc_helper_num1;
set nsoc_helper_num;
by spid opid;
if last.spid;
run;
proc freq data = nsoc_helper_num1;
table informal_nsoc_comp informal_nsoc_comp_i;
run; 

proc sql;
create table raw_op_inf_cg
as select a.*, b.informal_nsoc_comp, c.informal_nsoc_comp_i
from raw_op_sp_dies1 a
left join nsoc_helper_num1 b
on a.spid = b.spid
left join nsoc_helper_num c
on a.spid = c.spid and a.opid = c.opid;
quit;
proc freq data=raw_op_inf_cg;
table op1relatnshp informal_nsoc_comp informal_nsoc_comp_i nsoc_eligible;
run;
data test;
set raw_op_inf_cg (keep = spid opid nsoc_eligible informal_nsoc_comp informal_nsoc_comp_i);
run;
data raw_op_inf_cg1;
set raw_op_inf_cg;
/*if they did not complete the NSOC then set them as "0"*/
if informal_nsoc_comp_i = . then informal_nsoc_comp_i = 0;
/*Only include the SPs that had at least one of the caregivers that completed the NSOC interview*/
if informal_nsoc_comp ~= .;
/*helpers who were NSOC eligible but were not interviewed*/
if nsoc_eligible >= 1 and nsoc_eligible <=5 then nsoc_eligible_i = 1;
if nsoc_eligible_i ~= 1 then nsoc_eligible_i = 0;
/*Note which person is a qualified "helper"*/
all_helpers = .;
if op1ishelper = 1 then all_helpers = 1;
if all_helpers ~= 1 then all_helpers = 0;
/*Is any family*/
is_family = .;
if (op1relatnshp >=1 and op1relatnshp <= 29 )|op1relatnshp=91 then is_family = 1;
if is_family ~= 1 then is_family = 0;
/*paid indicator*/
helper_informal = .;
/*if it's -1 then it's bc of the spouse. Check Box HL5. Spouse is considered as Unpaid Helper. */
if all_helpers = 0 then helper_informal = 0;
if all_helpers = 1 and is_family = 1 then helper_informal = 1;
if all_helpers = 1 and op1paidhelpr = -1 then helper_informal = 1;
if all_helpers = 1 and is_family = 0 and op1paidhelpr = 2 /*(answered No)*/ then helper_informal = 1;
if all_helpers = 1 and is_family = 0 and (op1paidhelpr = 1) then helper_informal = 0;
/*helper family CHANGED in 12/10/2015 from being actual family to indication of them being unpaid. */
all_helper_family = .;
if all_helpers = 1 and helper_informal = 1 then all_helper_family = 1;
if all_helper_family ~= 1 then all_helper_family = 0;
run;
proc freq data=raw_op_inf_cg1;
table all_helpers all_helper_family helper_informal ;
run;
proc freq data=raw_op_inf_cg1;
table helper_informal*op1relatnshp;
run;
proc freq data=raw_op_inf_cg1;
where helper_informal = .;
table all_helpers is_family op1paidhelpr op1relatnshp;
run;
/*
data test;
set raw_op_inf_cg1 (keep = spid opid op1ishelper op1paidhelpr op1relatnshp);
run;
proc freq data=test;
table op1relatnshp op1ishelper op1paidhelpr;
run;
data test1;
set test;
if op1ishelper = 1;
run;
proc freq data=test1;
table op1relatnshp op1paidhelpr;
run;
proc freq data=raw_op_inf_cg1;
table op1relatnshp is_family informal_nsoc_comp informal_nsoc_comp_i nsoc_eligible all_helpers all_helper_family is_imm_family all_helper_imm_family;
run;
data test;
set raw_op_inf_cg1 (keep = spid opid nsoc_eligible informal_nsoc_comp informal_nsoc_comp_i nsoc_eligible_i op1ishelper all_helpers all_helper_family);
run;
proc sort data=test;
by spid opid;
run;
proc sort data=raw_op_inf_cg1;
by spid opid;
run;
*/
data raw_op_inf_cg2;
set raw_op_inf_cg1;
by spid opid;
retain informal_nsoc_elig all_helper_tot all_helper_family_tot ;
informal_nsoc_elig = informal_nsoc_elig + nsoc_eligible_i;
all_helper_tot = all_helper_tot + all_helpers;
all_helper_family_tot = all_helper_family_tot + all_helper_family;
if first.spid then do;
informal_nsoc_elig = nsoc_eligible_i;
all_helper_tot=all_helpers;
all_helper_family_tot = all_helper_family;
end;
run;
proc freq data=raw_op_inf_cg2;
table all_helper_family_tot;
run;
data test1;
set raw_op_inf_cg2 (keep = spid opid nsoc_eligible helper_informal informal_nsoc_comp informal_nsoc_comp_i nsoc_eligible_i op1ishelper all_helpers informal_nsoc_elig all_helper_tot all_helper_family_tot);
run;
data raw_op_inf_cg3;
set raw_op_inf_cg2;
by spid opid;
if last.spid;
diff_helper = all_helper_tot - informal_nsoc_comp;
run;
proc freq data=raw_op_inf_cg3;
table diff_helper;
run;
data test3;
set raw_op_inf_cg3 (keep = spid opid nsoc_eligible helper_informal informal_nsoc_comp informal_nsoc_comp_i nsoc_eligible_i op1ishelper all_helpers informal_nsoc_elig all_helper_tot all_helper_family_tot );
run;
ods rtf body = "E:\nhats\data\Projects\Caregivers\logs\Total_Helper.rtf";
proc freq data=raw_op_inf_cg3;
table informal_nsoc_comp  all_helper_tot diff_helper all_helper_family_tot;
run;
ods rtf close;

proc sql;
create table nsoc_helpers
as select a.*, b.informal_nsoc_comp, b.informal_nsoc_elig, b.all_helper_tot, b.all_helper_family_tot
from nsoc1 a 
left join raw_op_inf_cg3 b
on a.spid = b.spid;
quit;

proc freq data=nsoc_helpers;
table informal_nsoc_comp informal_nsoc_elig all_helper_tot all_helper_family_tot ;
run;
proc sql;
create table nsoc_helpers0
as select a.*, b.helper_informal
from nsoc_helpers a
left join raw_op_inf_cg1 b
on a.spid = b.spid and
a.opid = b.opid;
quit;
proc freq data=nsoc_helpers0;
table helper_informal;
run;

data test(keep = spid);
set nsoc_helpers ;
if all_helper_tot = 1;
run;
data nsoc_helpers1;
set nsoc_helpers0;
/*solo CG in da houuuuuse*/
solo_cg = 0;
if all_helper_tot = 1 then solo_cg = 1;
/*No Other Family Member*/
solo_cg_fam = .;
if helper_informal = 1 and all_helper_family_tot = 1 then solo_cg_fam = 1;
if helper_informal = 1 and all_helper_family_tot > 1 then solo_cg_fam = 0;
if helper_informal = 0 and all_helper_family_tot = 0 then solo_cg_fam = 1;
if helper_informal = 0 and all_helper_family_tot > 0 then solo_cg_fam = 0;
run;

proc freq data=nsoc_helpers1;
table helper_informal is_imm_family solo_cg solo_cg_fam ;
run;
proc freq data=nsoc_helpers1;
where helper_informal = 1;
table all_helper_family_tot;
run;
proc freq data=nsoc_helpers1;
table informal_nsoc_comp all_helper_tot;
run;

/************* ONLY EOL Helpers *****************/

data nsoc_helpers2;
set nsoc_helpers1;
if died = 1;
run;
ods rtf body = "E:\nhats\data\Projects\Caregivers\logs\Solo_Caregiver_Numbers.rtf";
proc freq data=nsoc_helpers2;
table solo_cg_fam  ;
run;
proc freq data=nsoc_helpers2;
where solo_cg_fam = 1;
table all_helper_tot all_helper_family_tot;
run;
proc freq data=nsoc_helpers2;
table solo_cg  ;
run;
proc freq data=nsoc_helpers2;
where solo_cg = 1;
table all_helper_tot;
run;
ods rtf close;
/************* ONLY EOL Helpers *****************/

proc sql;
create table nsoc1
as select *
from nhats.Nsoc1_half a
left join nsoc_helpers1 b
on a.spid = b.spid and a.opid = b.opid;
quit;

proc freq data=nsoc1;
table diff_physical_lv_di;
run;



/*********** Interview Date **************/

data nsoc_int_date;
set nsoc1;
int_month = c1intmonth;
if int_month >=5 then int_year = 2011;
run;

proc freq data=nsoc_int_date;
table c1intmonth int_month int_year;
run;

data raw_nhats_r2_death_dates;
set raw_nhats_r2_sens (keep = spid pd2mthdied pd2yrdied);
run;

proc sql;
create table nsoc_int2death
as select a.*, b.pd2mthdied as month_died, b.pd2yrdied as year_died
from nsoc_int_date a
left join raw_nhats_r2_death_dates b
on a.spid = b.spid;
quit;
data nsoc_int2death;
set nsoc_int2death;
if month_died = -1 then month_died = .;
if year_died = -1 then year_died = .;
run;
proc freq data=nsoc_int2death;
table died month_died year_died;
run;


/*Interview to Death*/
data nsoc_int2death1;
set nsoc_int2death;
if year_died = 1 then year_died = 2011;
if year_died = 2 then year_died = 2012;
if year_died ~= . then year_sep = year_died - int_year;
if month_died ~= . then month_sep = month_died - int_month;
if year_sep = 1 then year_sep_months = 12;
if year_sep = 0 then year_sep_months = 0;

months_to_death = year_sep_months + month_sep;
/*take out the dates that are negative. Confirmed with Katherine, we are assuming they are a fluke*/
if months_to_death < 0 then months_to_death = .;
run;
proc freq data=nsoc_int2death1;
table c1intmonth   month_died year_died year_sep month_sep year_sep_months months_to_death;
run;
data test;
set nsoc_int2death1 (keep = spid opid c1intmonth month_died year_died year_sep month_sep year_sep_months months_to_death);
if months_to_death < 0 and months_to_death ~= .;
run;
data nsoc1;
set nsoc_int2death1;
run;

/*Hours of Care additions. Could be more efficient I know. */
data dc_additions;
set nsoc1;
total_hours_month = total_hours;
if total_hours = . and cdc1hlpsched = 1 then total_hours_month = total_hours_day * total_hours_week * 4;

if cdc1hlpyrs ~= -1 then helper_num_yrs = cdc1hlpyrs;
if helper_num_yrs = . & cdc1hlpyrpls = 2 then helper_num_yrs = 0;
if helper_num_yrs = . & cdc1hlpyrst ~= -1 then helper_num_yrs = 2011 - cdc1hlpyrst;

run;
proc freq data=dc_additions;
table helper_num_yrs;
run;
proc freq data=dc_additions;
table  total_hours total_hours_month helper_num_yrs;
run;

data nsoc1;
set dc_additions;
run;

proc freq data=nsoc1;
where all_helper_tot = 1;
table  informal_nsoc_comp;
run;
proc freq data=nsoc1;
where died = 1;
table all_helper_tot cg_spouse;
run;

data indicators;
set nsoc1;
run;
data nsoc1;
set indicators;
run;

proc freq data=nsoc1;
table diff_emotional_lv_di ;
run;



/****** Living in household **********/
/****** OP1PRSNINHH is the variable for if the person is in the household ******/
/****** This is answered they answer three questions in the the NHATS Questionnaire ******/
/****** hh1livwthspo hh1proxlivsp hh1othlvhere if they answer yes or no (particularly if ******/
/****** the person also has an opid (spouse: hh1dspouseid, proxy: is1dproxyid)) then ******/
/****** then they will appear in the OP File. For those that didn't answer these questions, ******/
/****** then we can probably assume that these people don't live in the household ******/

proc sql;
create table opfile_hh1
as select a.*, b.hh1livwthspo, c.hh1proxlivsp, d.hh1othlvhere, d.hh1dlvngarrg, d.hh1livwthspo as SP_answered_spo, d.hh1proxlivsp as SP_ans_prox,d.hh1othlvhere as SP_ans_oth, d.r1dresid
from raw_op a
left join raw_nhats_r1 b
on a.spid = b.spid and a.opid = b.hh1dspouseid
left join raw_nhats_r1 c
on a.spid = c.spid and a.opid = c.is1dproxyid
left join raw_nhats_r1 d
on a.spid = d.spid;
quit;
proc freq data= opfile_hh1;
table op1prsninhh;
run;
proc freq data=opfile_hh1;
table in_hh;
run;
data opfile_hh_final;
set opfile_hh1;
lives_in_hh = .;
/*if the living arrangement says that they live with spouse and the person is the spouse then that person should be coded as a person in the hh*/
if (hh1dlvngarrg = 2 | hh1dlvngarrg = 3) and op1relatnshp = 2 then op1prsninhh = 1;
if op1prsninhh = 1 and lives_in_hh = . then lives_in_hh = 1;
if op1prsninhh = 0 and lives_in_hh = . then lives_in_hh = 0;
if op1chnotinhh = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1soclntwrk = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1contctflg = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1spcaredfr = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1ishelper = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1dflmiss = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1dsocwrkfl = 1 and lives_in_hh = . then lives_in_hh = 0;
if op1relatnshp = 37 and lives_in_hh = . then lives_in_hh = 0;
if hh1dlvngarrg = 1 and lives_in_hh = . then lives_in_hh = 0;
run;
proc freq data=opfile_hh_final;
table op1prsninhh lives_in_hh;
run;
data nsoc1;
set nsoc1;
drop lives_in_hh;
run;
proc sql; 
create table nsoc_w_hh
as select a.*, b.lives_in_hh
from nsoc1 a
left join opfile_hh_final b
on a.spid = b.spid and a.opid = b.opid;
quit;
proc freq data=nsoc_w_hh;
table lives_in_hh;
run;


data nsoc1;
set nsoc_w_hh;
run;


proc freq data=nsoc1;
table diff_emotional_lv_di ;
run;

ods rtf body = "E:\nhats\data\Projects\Caregivers\logs\solo_cg_fam_xtab_spouse.rtf";
proc freq data=nsoc1;
where died = 1;
table cg_spouse*solo_cg;
run;
proc freq data=nsoc1;
where solo_cg = 1 and died = 1;
table cg_relationship_cat;
run;
proc freq data=nsoc1;
where died = 1;
table cg_spouse*solo_cg_fam;
run;
proc freq data=nsoc1;
where solo_cg_fam = 1 and died = 1;
table cg_relationship_cat;
run;
ods rtf close;

data ko.nsoc_full;
set nsoc1;
run;
proc export data=nsoc1 outfile = "E:\nhats\data\Projects\Caregivers\nsoc_FULL.dta" dbms = dta replace;
run;

/*no lfu*/
data no_lfu;
set nsoc1;
if died = . then delete;
run;
data nsoc1;
set no_lfu;
run;

data ko.nsoc_final;
set nsoc1;
run;

proc freq data=nsoc1;
table helper_informal*c1relatnshp;
run;
proc freq data=nsoc1;
where died = 1;
table solo_cg_fam;
run;

libname nhats "E:\nhats\data\NHATS working data";

/***** Import SP NHATS Data *****/
proc import out=raw_nhats_r1
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File_old.dta";
run;
proc import out=raw_nhats_r2
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_SP_File_old.dta";
run;
proc import out=raw_nhats_r3
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_SP_File_old.dta";
run;
proc import out=nhats_r1_sen
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NHATS_Round_1_SP_Sen_Dem_File.dta";
run;
proc import out=nhats_r2_sen
			datafile = "E:\nhats\data\NHATS Sensitive\r2_sensitive\NHATS_Round_2_SP_Sen_Dem_File.dta";
run;

/***** Import OP NHATS Data *****/

proc import out=nhats_r1_OP
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_OP_File_old.dta";
run;
proc import out=nhats_r2_OP
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_OP_File_old.dta";
run;
proc import out=nhats_r3_OP
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_OP_File_old.dta";
run;
proc import out=nhats_r1_OP_sen
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NHATS_Round_1_OP_Sen_Dem_File.dta";
run;
proc import out=nhats_r2_OP_sen
			datafile = "E:\nhats\data\NHATS Sensitive\r2_sensitive\NHATS_Round_2_OP_Sen_Dem_File.dta";
run;

/***** Import Tracker Files *****/

proc import out=raw_nhats_r1_tracker
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_Tracker_File.dta";
run;
proc import out=raw_nhats_r2_tracker
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_Tracker_File.dta";
run;
proc import out=raw_nhats_r3_tracker
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_Tracker_File.dta";
run;
proc import out=nhats_nsoc_tracker
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NSOC_Round_1_SP_Tracker_File.dta";
run;

/***** NHATS/NSOC Data set from Rebecca *****/

proc import out=nhats_rg
			datafile = "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old.dta";
run;
proc export data = nhats_rg
			outfile = "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old_backup.dta"
			replace;
run;
proc export data=nhats_rg outfile = "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old.csv" dbms = csv replace label;
run;

/*************** SAMPLE CREATION ***************/

/** Died/Loss to Follow-up on Wave 2 and Wave 3 **/
proc sql;
create table nhats_died_ind
as select a.spid, a.is1resptype, b.is2resptype , b.is2reasnprx7, c.is3resptype , c.is3reasnprx7
from raw_nhats_r1 a
left join raw_nhats_r2 b
on a.spid = b.spid
left join raw_nhats_r3 c
on a.spid = c.spid;
quit;
data nhats_died_ind1;
set nhats_died_ind;

/* FROM NHATS Documentation for answering deceased question: 
"You have selected SP Decseased. If SP is STILL LIVING, select a
different option. If SP is deceased, select supress to confirm."*/
/*Died on 12 Month follow-up*/
died = 0;
if is2reasnprx7 = 1 then died = 1;
if is2reasnprx7 = -9 then died = .;
label died = "Died on 12 Month follow-up";
/*Died within 24 months*/
died_24 = 0;
if is2reasnprx7 = 1 or is3reasnprx7 = 1 then died_24 = 1;
if is2reasnprx7 = -9 or is3reasnprx7 = -9 then died_24 = .;
label died_24 = "Died within 24 months";
run;
/*frequency check*/
proc freq data=nhats_died_ind1;
table died died_24 died*died_24;
run;
/*keeping only relevant information*/
data nhats_died_ind2;
set nhats_died_ind1 (keep = spid died died_24);
run;
/*PERMANENT DATASET OF ALL DIED WITHIN WAVE 2 AND 3 OF THE SP WHO WERE IN WAVE 1*/
data nhats.died_indicator;
set nhats_died_ind2;
run;

/********* Sensitive Data Extraction ********/

data nhats_r1_sen_1;
set nhats_r1_sen;
age = r1dintvwrage;
run;
proc means data=nhats_r1_sen_1;
var age;
run;

/******* Pre-main nhats database merge *******/

proc sql;
create table raw_nhats_r1_1
as select a.*, b.died, b.died_24, c.age as age_w1
from raw_nhats_r1 a
left join nhats.died_indicator b
on a.spid = b.spid
left join nhats_r1_sen_1 c
on a.spid = c.spid;
quit;

proc freq data=raw_nhats_r1_1;
table hh1dlvngarrg;
run;

data nhats_wave1;
set raw_nhats_r1_1;

/*drop 56 weight variables*/
drop w1anfinwgt1-w1anfinwgt56;

/*Community Dwelling Variable. If the variable = "Community" or "Residential Care Resident not nursing home"*/
/*none missing from the raw database*/
community_dwelling = 0;
if r1dresid = 1 or r1dresid = 2 then community_dwelling = 1;
label community_dwelling = "SP in Community/Residential Care Resident";

/*Gender Variable*/
gender = .;
if r1dgender = 2 then gender = 1;
if r1dgender = 1 then gender = 0;
label gender = "Gender: 0 = Male, 1 = Female";

/* Education Variable. Greater than High School */
education = .;
if el1higstschl < 4 then education = 1;
if el1higstschl = 4 then education = 2;
if el1higstschl >= 5 and el1higstschl <= 7 then education = 3;
if el1higstschl >= 8 and el1higstschl <= 9 then education = 4;
label education = "Education: 1 = <HS 2 = HS 3 = Some College 4 = >= College";
gt_hs_edu = .;
if el1higstschl >= 4 then gt_hs_edu = 1;
if el1higstschl > 0  and el1higstschl < 4 then gt_hs_edu = 0;
label gt_hs_edu = "Greater than/Equal to High School";

/* White(Non-Hispanic) definition if the race variable is DK/RF then I set that as missing*/
race_cat = rl1dracehisp;
if rl1dracehisp = 5 | rl1dracehisp = 6 then race_cat = .;
label race_cat = "Race: 1 = White, 2 = Black, 3 = Other, 4 = Hispanic";
if rl1dracehisp = 1 then white = 1;
if rl1dracehisp = 2 or rl1dracehisp = 3 or rl1dracehisp = 4 then white = 0;
if rl1dracehisp = 5 or rl1dracehisp = 6 then white = .;
label white = "White (Non-Hispanic)";

/* Married Variable. All missing stays missing */
married = 0;
if hh1martlstat = 1 then married = 1;
if hh1martlstat < 0 then married = .;
label Married = "Married";

/* Living Arrangement */
living_arrang = hh1dlvngarrg;
if hh1dlvngarrg < 0 then living_arrang = .;
label living_arrang = "Living Arrangement: 1 = Alone, 2 = Spouse/Partner, 3 = S/P + Other, 4 = Other";
live_alone = .;
if living_arrang = 1 then live_alone = 1;

if living_arrang > 1 then live_alone = 0;

/*Changing ADL numbers. If the answers to ADL questions are "yes" or "can't do"*/
if ls1evdayact1 = 1 or ls1evdayact1 = 3 then adl_eating = 1;
if ls1evdayact1 = 2 then adl_eating = 0;
if ls1evdayact2 = 1 or ls1evdayact2 = 3 then adl_bed = 1;
if ls1evdayact2 = 2 then adl_bed = 0;
if ls1evdayact3 = 1 or ls1evdayact3 = 3 then adl_chair = 1;
if ls1evdayact3 = 2 then adl_chair = 0;
if ls1evdayact4 = 1 or ls1evdayact4 = 3 then adl_walk_in = 1;
if ls1evdayact4 = 2 then adl_walk_in = 0;
if ls1evdayact5 = 1 or ls1evdayact5 = 3 then adl_walk_out = 1;
if ls1evdayact5 = 2 then adl_walk_out = 0;
if ls1evdayact6 = 1 or ls1evdayact6 = 3 then adl_dress = 1;
if ls1evdayact6 = 2 then adl_dress = 0;
if ls1evdayact7 = 1 or ls1evdayact7 = 3 then adl_bathe = 1;
if ls1evdayact7 = 2 then adl_bathe = 0;
if ls1evdayact8 = 1 or ls1evdayact8 = 3 then adl_toilet = 1;
if ls1evdayact8 = 2 then adl_toilet = 0;

/*changing IADL Numbers. If the answers on First IADL (Able to?) are "No" AND if the other IADL question (Keep from?) = "Yes"*/
if ls1ableto1 = 2 and ls1diskefrm1 = 1 then iadl_meals = 1;
if ls1ableto1 = 2 and ls1diskefrm1 = 2 then iadl_meals = 0;
if ls1ableto1 = 1 then iadl_meals = 0;
if ls1ableto2 = 2 and ls1diskefrm2 = 1 then iadl_laundry = 1;
if ls1ableto2 = 2 and ls1diskefrm2 = 2 then iadl_laundry = 0;
if ls1ableto2 = 1 then iadl_laundry = 0;
if ls1ableto3 = 2 and ls1diskefrm3 = 1 then iadl_housewk = 1;
if ls1ableto3 = 2 and ls1diskefrm3 = 2 then iadl_housewk = 0;
if ls1ableto3 = 1 then iadl_housewk = 0;
if ls1ableto4 = 2 and ls1diskefrm4 = 1 then iadl_shop = 1;
if ls1ableto4 = 2 and ls1diskefrm4 = 2 then iadl_shop = 0;
if ls1ableto4 = 1 then iadl_shop = 0;
if ls1ableto5 = 2 and ls1diskefrm5 = 1 then iadl_money = 1;
if ls1ableto5 = 2 and ls1diskefrm5 = 2 then iadl_money = 0;
if ls1ableto5 = 1 then iadl_money = 0;
if ls1ableto6 = 2 and ls1diskefrm6 = 1 then iadl_meds = 1;
if ls1ableto6 = 2 and ls1diskefrm6 = 2 then iadl_meds = 0;
if ls1ableto6 = 1 then iadl_meds = 0;
if ls1ableto7 = 2 and ls1diskefrm7 = 1 then iadl_phone = 1;
if ls1ableto7 = 2 and ls1diskefrm7 = 2 then iadl_phone = 0;
if ls1ableto7 = 1 then iadl_phone = 0;


/*SUM of the ADLs. Create three categories. (0, 1/2, >=3) */
sum_adl = sum(adl_eating, adl_bed, adl_chair, adl_walk_in, adl_walk_out, adl_dress, adl_bathe, adl_toilet);
sum_adl_cat = 0;
if sum_adl = 1 or sum_adl = 2 then sum_adl_cat = 1;
if sum_adl > 2 then sum_adl_cat = 2;
if sum_adl = . then sum_adl_cat = .;
label sum_adl = "Sum of all ADLs/IADLs";
label sum_adl_cat = "Num. of ADL/IADL Category (0, 1/2, >=3)";

/* INDICATOR OF ANY ADL/IADLs. Needed for Caregiving Project with Katherine*/
ADL_IADL_ind = 0;
if adl_eating = 1| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | 
adl_bathe = 1 | adl_toilet = 1|iadl_meals = 1 | iadl_laundry = 1 | iadl_housewk = 1 | iadl_shop = 1 | 
iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1 then ADL_IADL_ind = 1;
if sum_adl = . then ADL_IADL_ind = .;
label adl_iadl_ind = "Indicator if any of ADLs/IADLs at all";



run;
proc freq data=nhats_wave1;
table community_dwelling adl_eating adl_bed adl_chair adl_walk_in adl_walk_out adl_dress adl_bathe adl_toilet
iadl_meals iadl_laundry iadl_housewk iadl_shop iadl_money iadl_meds iadl_phone white married gt_hs_edu
sum_adl sum_adl_cat ADL_IADL_ind;
run;

proc freq data=nhats_nsoc_tracker;
table fl1dnsoc fl1dnsoccomp;
run;

data nhats_nsoc_tracker1;
set nhats_nsoc_tracker;
eligible = 0;
if fl1dnsoc = 1 then eligible = 1;
complete = 0;
if fl1dnsoccomp > 0 then complete = 1;
total_caregiver_comp = fl1dnsoccomp;
if fl1dnsoccomp < 0 then total_caregiver_comp = .;
label eligible = "Eligible for NSOC interview";
label complete = "Completed Interview";
label total_caregiver_comp = "Total Caregivers that Completed Interview";
run;
proc freq data=nhats_nsoc_tracker1;
table eligible complete total_caregiver_comp;
run;

proc sql;
create table nhats_wave1_1
as select a.*, b.eligible, b.complete, b.total_caregiver_comp
from nhats_wave1 a
left join nhats_nsoc_tracker1 b
on a.spid = b.spid;
quit;

proc freq data=nhats_wave1_1;
where community_dwelling = 1;
table eligible complete total_caregiver_comp;
run;

data nhats.nhats_wave1_all_obs;
set nhats_wave1_1;
run;

data raw_nhats_r2_1;
set raw_nhats_r2;
drop w2anfinwgt1-w2anfinwgt56;
run;

proc sql;
create table nhats_wave12
as select a.spid, a.died, a.died_24, a.age_w1, a.community_dwelling, a.gender, a.education, a.gt_hs_edu, a.race_cat, a.white, a.married, a.living_arrang, a.live_alone,
a.adl_eating, a.adl_bed, a.adl_chair, a.adl_walk_in, a.adl_walk_out, a.adl_dress, a.adl_bathe, a.adl_toilet, a.iadl_meals, a.iadl_laundry, a.iadl_housewk, a.iadl_shop,
a.iadl_money, a.iadl_meds, a.iadl_phone, a.sum_adl, a.sum_adl_cat, a.ADL_IADL_ind, a.eligible, a.complete, a.total_caregiver_comp, b.*
from nhats_wave1_1 a
inner join raw_nhats_r2_1 b
on a.spid = b.spid;
quit;

data test;
set nhats.nhats_wave1_all_obs;
if ADL_IADL_ind = 1;run;
proc freq data=test;
table died;
run;


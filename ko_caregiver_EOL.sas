proc import out=raw_nhats_r1
			datafile = "E:\data\nhats\round_1\NHATS_Round_1_SP_File_old.dta";
run;
proc import out=raw_nhats_r2
			datafile = "E:\data\nhats\round_2\NHATS_Round_2_SP_File_old.dta";
run;
proc import out=raw_nhats_r3
			datafile = "E:\data\nhats\round_3\NHATS_Round_3_SP_File_old.dta";
run;
proc import out=nhats
			datafile = "E:\data\nhats\working\round_1_3_clean_helper_added_old.dta";
run;
proc import out=nsoc
			datafile = "E:\data\nhats\working\caregiver_ds_nsoc_clean_v2_old.dta";
run;
proc import out=nsoc_tracker
			datafile = "E:\data\nhats\r1_sensitive\NSOC_Round_1_SP_Tracker_File.dta";
run;
proc import out=nhats_r2_sen
			datafile = "E:\data\nhats\r2_sensitive\NHATS_Round_2_SP_Sen_Dem_File.dta";
run;

/*in the final dataset, the NLTCS questions were not there. I plan on merging these into the dataset*/
data raw_nhats_r1_1 (keep = spid ls1evdayact1-ls1evdayact8 ls1ableto1-ls1ableto7 ls1diskefrm1-ls1diskefrm7);
set raw_nhats_r1;
run;
/*wave 1 data*/
data nhats_wave1;
set nhats;
if wave = 1;
run;
/*merge the NLTCS questions to Wave 1 dataset*/
proc sql;
create table nhats_wave1_1
as select * 
from nhats_wave1 a
left join raw_nhats_r1_1 b
on a.spid = b.spid;
quit;
ods html close;
ods html;
/*check for perfect merge: Check*/
proc freq data=nhats_wave1_1;
table ls1evdayact1-ls1evdayact8 ls1ableto1-ls1ableto7 ls1diskefrm1-ls1diskefrm7;
run;
/*limit by community dwelling and create new ADL/IADL based on the questions from NLTCS*/
data nhats_wave1_2;
set nhats_wave1_1;
/*Community Dwelling Variable. If the variable = "Community" or "Residential Care Resident not nursing home"*/
if r1dresid = 1 or r1dresid = 2;
/*total number after: 7609*/

/*Changing ADL numbers. If the answers to ADL questions are "yes" or "can't do"*/
if ls1evdayact1 = 1 or ls1evdayact1 = 3 then adl_eating = 1;
if ls1evdayact1 = 2 = 3 then adl_eating = 0;
if ls1evdayact2 = 1 or ls1evdayact1 = 3 then adl_bed = 1;
if ls1evdayact2 = 2 then adl_bed = 0;
if ls1evdayact3 = 1 or ls1evdayact1 = 3 then adl_chair = 1;
if ls1evdayact3 = 2 then adl_chair = 0;
if ls1evdayact4 = 1 or ls1evdayact1 = 3 then adl_walk_in = 1;
if ls1evdayact4 = 2 then adl_walk_in = 0;
if ls1evdayact5 = 1 or ls1evdayact1 = 3 then adl_walk_out = 1;
if ls1evdayact5 = 2 then adl_walk_out = 0;
if ls1evdayact6 = 1 or ls1evdayact1 = 3 then adl_dress = 1;
if ls1evdayact6 = 2 then adl_dress = 0;
if ls1evdayact7 = 1 or ls1evdayact1 = 3 then adl_bathe = 1;
if ls1evdayact7 = 2 then adl_bathe = 0;
if ls1evdayact8 = 1 or ls1evdayact1 = 3 then adl_toilet = 1;
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

run;
/*if the person has any disability*/
data nhats_wave1_3;
set nhats_wave1_2;
if adl_eating| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | adl_bathe = 1 | iadl_meals = 1 | iadl_laundry = 1 | iadl_housewk = 1 | iadl_shop = 1 | iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1;
run;
/*sample size greatly reduced to 2007*/

/*in the NSOC data find those who are eligible "fl1dnsoc" and those who completed NSOC "fl1dnsoccomp"*/
data nsoc_tracker1;
set nsoc_tracker;
eligible = 0;
if fl1dnsoc = 1 then eligible = 1;
complete = 0;
if fl1dnsoccomp > 0 then complete = 1;
run;
/*merge with nhats*/
proc sql;
create table nhats_wave1_4
as select a.*, b.eligible, b.complete
from nhats_wave1_3 a
left join nsoc_tracker1 b
on a.spid = b.spid;
quit;
proc freq data=nhats_wave1_4;
table eligible*complete;
run;
/*if eligible and completed*/
data nhats_wave1_5;
set nhats_wave1_4;
if eligible = 1 and complete = 1;
run;
/*Look at death indicator at each round*/
proc sql; 
create table nhats_wave1_6
as select a.*, b.is2resptype as is2resptype1, b.is2reasnprx7, c.is3resptype as is3resptype1, c.is3reasnprx7
from nhats_wave1_5 a
left join raw_nhats_r2 b
on a.spid = b.spid
left join raw_nhats_r3 c
on a.spid = c.spid;
quit;
proc freq data = nhats_wave1_6;
table is2resptype1 is2reasnprx7 is3resptype1 is3reasnprx7;
run;
/*find EOL Caregivers within 12 and 24 months at end of life*/
data EOL_Caregivers_12mos;
set nhats_wave1_6;
if is2reasnprx7 = 1;
run;
data EOL_Caregivers_24mos;
set nhats_wave1_6;
if is2reasnprx7 = 1 or is3reasnprx7 = 1;
run;

/* When I did things by Date*
proc freq data=raw_nhats_r1;
table ab1datemonth ab1dateyear;
run;
proc freq data=nhats_wave1_5;
table PD2MTHDIED PD2YRDIED;
run;
data nhats_wave1_7;
set nhats_wave1_6;
interview_date = mdy(ab1datemonth, 1, ab1dateyear);
if PD2YRDIED = 1 then death_year = 2011;
if pd2yrdied = 2 then death_year = 2012;
death_date = mdy(PD2MTHDIED, 1,death_year );
format interview_date yymmd7. death_date yymmd7.;
month_diff = intck('MONTH', interview_date, death_date);
run;
proc freq data=nhats_wave1_7;
table death_year month_diff;
run;
proc freq data=nhats_wave1_7;
table ADL_EAT_HELP;
run;
*/





/*FUTURE REFERENCE: PUT DEATH IN THE BEGINNING!!!!*/

proc sql;
create table nhats_wave1_2_1
as select a.*, b.is2resptype as is2resptype1, b.is2reasnprx7, c.is3resptype as is3resptype1, c.is3reasnprx7
from nhats_wave1_2 a
left join raw_nhats_r2 b
on a.spid = b.spid
left join raw_nhats_r3 c
on a.spid = c.spid;
quit;
proc freq data = nhats_wave1_2_1;
table is2resptype1 is2reasnprx7 is3resptype1 is3reasnprx7;
run;
proc freq data=raw_nhats_r2;
where r1dresid = 1 or r1dresid = 2;
table is2resptype;
run;
proc freq data=raw_nhats_r3;
where r1dresid = 1 or r1dresid = 2;
table is3resptype;
run;
/*Caregiver with Died*/
data nhats_wave1_2_2;
set nhats_wave1_2_1;
died = 0;
if is2reasnprx7 = 1 or is3reasnprx7 = 1 then died = 1;
run;
proc freq data=nhats_wave1_2_2;
table died;
run;

data nhats_wave1_3;
set nhats_wave1_2;
if adl_eating| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | adl_bathe = 1 | iadl_meals = 1 | iadl_laundry = 1 | iadl_housewk = 1 | iadl_shop = 1 | iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1;
run;
proc sql;
create table nhats_wave1_3_1
as select a.*, b.is2resptype as is2resptype1, b.is2reasnprx7, c.is3resptype as is3resptype1, c.is3reasnprx7
from nhats_wave1_3 a
left join raw_nhats_r2 b
on a.spid = b.spid
left join raw_nhats_r3 c
on a.spid = c.spid;
quit; 
/*Caregiver, Disabled with died*/

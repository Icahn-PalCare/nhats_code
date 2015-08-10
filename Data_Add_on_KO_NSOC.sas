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
			datafile = "E:\data\nhats\working\round_1_3_clean_helper_added_old.dta" replace;
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

/*merge the NLTCS questions to Wave 1 dataset*/
proc sql;
create table nhats1
as select a.*, b.* , c.is2resptype as is2resptype1, c.is2reasnprx7, d.is3resptype as is3resptype1, d.is3reasnprx7
from nhats a
left join raw_nhats_r1 b
on a.spid = b.spid
left join raw_nhats_r2 c
on a.spid = c.spid
left join raw_nhats_r3 d
on a.spid = d.spid;
quit;
data nhats2;
set nhats1;
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

died = 0;
if is2reasnprx7 = 1 then died = 1;
died_24 = 0;
if is2reasnprx7 = 1 or is3reasnprx7 = 1 then died_24 = 1;
drop is2reasnprx7 is3reasnprx7;

white = 0;
if race_cat = 1 then white = 1;
married = 0;
if maritalstat = 1 then married = 1;
gt_hs_edu = 0;
if education ~= 1 then gt_hs_edu = 1;
label white = "White Non-Hispanic Ind.";
label married = "Married Ind.";
label gt_hs_edu = "Greater than High School Ind.";
spouse_other = 0;
if LIVEARRANG = 2 or LIVEARRANG = 3 or livearrang = 4 then spouse_other = 1;
sum_adl = sum(adl_eating, adl_bed, adl_chair, adl_walk_in, adl_walk_out, adl_dress, adl_bathe, 0);
sum_adl_cat = 0;
if sum_adl = 1 or sum_adl = 2 then sum_adl_cat = 1;
if sum_adl > 2 then sum_adl_cat = 2;
run;
ods html close;
ods html;
proc freq data=nhats2;
table /*race_cat white maritalstat married education gt_hs_edu LIVEARRANG spouse_other */sum_adl sum_adl_cat ls1evdayact1 adl_eating ls1evdayact2 adl_bed ls1evdayact3 adl_chair
ls1evdayact4 adl_walk_in ls1evdayact5 adl_walk_out ls1evdayact6 adl_dress ls1evdayact7 adl_bathe ls1evdayact8 adl_toilet ls1ableto1 ls1diskefrm1 iadl_meals ls1ableto2 ls1diskefrm2 iadl_laundry
ls1ableto3 ls1diskefrm3 iadl_housewk ls1ableto4 ls1diskefrm4 iadl_shop ls1ableto5 ls1diskefrm5 iadl_money ls1ableto6 ls1diskefrm6 iadl_meds ls1ableto7 ls1diskefrm7 iadl_phone;
run;
proc freq data=nhats2;
table died died_24;
run;
/*if the person has any disability*/
data nhats_wave1_3;
set nhats_wave1_2;
if adl_eating = 1| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | adl_bathe = 1 | iadl_meals = 1 | iadl_laundry = 1 | iadl_housewk = 1 | iadl_shop = 1 | iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1;
run;
/*data test;
set nhats_wave1_3 (keep = sum_adl adl_eating adl_bed adl_chair  adl_walk_in adl_walk_out  adl_dress  adl_bathe  iadl_meals  iadl_laundry  iadl_housewk  iadl_shop  iadl_money iadl_meds  iadl_phone );;
if sum_adl = .;
run;*/
proc freq data=nhats_wave1_3;
table sum_adl sum_adl_cat;
run;
/*sample size greatly reduced to 2020*/

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
/*find EOL Caregivers within 12 and 24 months at end of life*/
data EOL_Caregivers_12mos;
set nhats_wave1_5;
if died = 1;
run;
data EOL_Caregivers_24mos;
set nhats_wave1_5;
if DIED_24 = 1;
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


%macro table1(data);
ods html close;
ods html;
proc freq data=&data;
table female*died white*died gt_hs_edu*died married*died spouse_other*died medicaid*died srh_fp*died sr_ami_ever*died sr_heart_dis_ever*died sr_ra_ever*died
sr_diabetes_ever*died sr_lung_dis_ever*died sr_stroke_ever*died sr_cancer_ever*died sr_phq2_depressed*died dem_2_cat*died fall_last_month*died sum_adl_cat*died
reg_doc_seen*died reg_doc_homevisit*died sr_hosp_ind*died / chisq;
run;
proc ttest data=&data;
class died;
var age sr_numconditions1 sr_hosp_stays;
run;
%mend;
/*Community Dwelling Sample*/
%table1(nhats_wave1_2);
/*Community Dwelling, Chronically Disabled Sample*/
%table1(nhats_wave1_3);
/*Community Dwelling, Chronically Disabled, CAREGIVER COMPLETED, Sample*/
%table1(nhats_wave1_5);

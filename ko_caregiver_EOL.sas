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
as select a.*, b.*, c.is2resptype as is2resptype1, c.is2reasnprx7, d.is3resptype as is3resptype1, d.is3reasnprx7
from nhats_wave1 a
left join raw_nhats_r1_1 b
on a.spid = b.spid
left join raw_nhats_r2 c
on a.spid = c.spid
left join raw_nhats_r3 d
on a.spid = d.spid;
quit;
proc freq data = nhats_wave1_1;
table is2resptype1 is2reasnprx7 is3resptype1 is3reasnprx7;
run;
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

white = 0;
if race_cat = 1 then white = 1;
married = 0;
if maritalstat = 1 then married = 1;
gt_hs_edu = 0;
if education ~= 1 then gt_hs_edu = 1;
label white = "White Non-Hispanic";
label married = "Married";
label gt_hs_edu = "Greater than High School";
spouse = 0;
if LIVEARRANG = 2 or LIVEARRANG = 3 or livearrang = 4 then spouse = 1;
sum_adl = sum(adl_eating, adl_bed, adl_chair, adl_walk_in, adl_walk_out, adl_dress, adl_bathe, 0);
sum_adl_cat = 0;
if sum_adl = 1 or sum_adl = 2 then sum_adl_cat = 1;
if sum_adl > 2 then sum_adl_cat = 2;

/*Labelling stuff*/
label female = "Gender";
label spouse = "Spouse + Other";
label sum_adl_cat = "ADLs Categories";
run;
proc freq data=nhats_wave1_2;
table race_cat white maritalstat married education gt_hs_edu LIVEARRANG spouse sum_adl sum_adl_cat ls1evdayact1 adl_eating ls1evdayact2 adl_bed ls1evdayact3 adl_chair
ls1evdayact4 adl_walk_in ls1evdayact5 adl_walk_out ls1evdayact6 adl_dress ls1evdayact7 adl_bathe ls1evdayact8 adl_toilet ls1ableto1 ls1diskefrm1 iadl_meals ls1ableto2 ls1diskefrm2 iadl_laundry
ls1ableto3 ls1diskefrm3 iadl_housewk ls1ableto4 ls1diskefrm4 iadl_shop ls1ableto5 ls1diskefrm5 iadl_money ls1ableto6 ls1diskefrm6 iadl_meds ls1ableto7 ls1diskefrm7 iadl_phone;
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
as select a.*, b.eligible, b.complete, b.fl1dnsoccomp as total_caregiver_comp
from nhats_wave1_3 a
left join nsoc_tracker1 b
on a.spid = b.spid;
quit;
proc freq data=nhats_wave1_4;
table eligible*complete ;
run;
proc freq data=nhats_wave1_4;
where complete = 1;
table total_caregiver_comp;
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
proc means data=nhats_wave1_5;
var w1anfinwgt0;
run;
proc freq data=nhats_wave1_5;
table female*died;
weight ;
run;

proc format;
value yesno_ 1 = '    Yes'
			 0 = '    No'
			 . = '    Missing';
value female_ 1 = '    Female'
			  0 = '    Male'
			 . = '    Missing';
value fairpoor_ 1 = '    Fair/Poor'
				0 = '    Good/Great'
			 . = '    Missing';
value phq_ 1 = '    3+'
		   0 = '    0-2'
			 . = '    Missing';
value adl_ 2 = '    3+ ADL'
		   1 = '    1-2 ADL'
		   0 = '    IADLs Only'
			 . = '    Missing';
value overall 1 = 'Overall';
value died_ 1 = 'Died'
			0 = 'Survived';
picture pctfmt(round)low-high= ' 009.9)' (prefix='(');
run;
proc template;
define style styles.janettables;
parent=styles.minimal;

style bodyDate from bodyDate/font=('Times',8pt);
style PagesDate from PagesDate/font=('Times',8pt);
style PagesTitle from PagesTitle/font=('Times',8pt);
style SystemTitle from SystemTitle/font=('Times',8pt);
style Data from Data/font=('Times, Times, Times',8pt);
style Header from HeadersAndFooters/font=('Times, Times, Times',8pt);
style RowHeader from HeadersAndFooters/font=('Times, Times, Times',8pt);
end;
run;

proc tabulate data=nhats_wave1_2 missing order=formatted;
class died female white gt_hs_edu married spouse medicaid srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever
sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever sr_phq2_depressed dem_2_cat fall_last_month sum_adl_cat
reg_doc_seen reg_doc_homevisit sr_hosp_ind ;
var w1anfinwgt0;
classlev died female white gt_hs_edu married spouse medicaid srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever
sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever sr_phq2_depressed dem_2_cat fall_last_month sum_adl_cat
reg_doc_seen reg_doc_homevisit sr_hosp_ind /style=[cellwidth=3in asis=on];
tables female white gt_hs_edu married spouse medicaid srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever
sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever sr_phq2_depressed dem_2_cat fall_last_month sum_adl_cat
reg_doc_seen reg_doc_homevisit sr_hosp_ind,died='died'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format female female_. white yesno_. gt_hs_edu yesno_. married yesno_. spouse yesno_. medicaid yesno_. srh_fp fairpoor_. sr_ami_ever yesno_. sr_heart_dis_ever yesno_. sr_ra_ever yesno_. 
sr_diabetes_ever yesno_. sr_lung_dis_ever yesno_. sr_stroke_ever yesno_. sr_cancer_ever yesno_. sr_phq2_depressed phq_. dem_2_cat yesno_. fall_last_month yesno_. sum_adl_cat adl_.
reg_doc_seen yesno_. reg_doc_homevisit yesno_. sr_hosp_ind yesno_. died died_.;
weight w1anfinwgt0;
run;
ods rtf style=janettables file="E:\data\nhats\Projects\Caregivers\table1a.rtf";
title1 "Demographics Data";
title1;
title2;
ods rtf close;
proc freq data=nhats_wave1_2;
table female*died white*died gt_hs_edu*died married*died spouse*died medicaid*died srh_fp*died sr_ami_ever*died sr_heart_dis_ever*died sr_ra_ever*died
sr_diabetes_ever*died sr_lung_dis_ever*died sr_stroke_ever*died sr_cancer_ever*died sr_phq2_depressed*died dem_2_cat*died fall_last_month*died sum_adl_cat*died
reg_doc_seen*died reg_doc_homevisit*died sr_hosp_ind*died / chisq;
exclnpwgt =  w1anfinwgt0;
run;
proc sort data=nhats_wave1_2;
by died;
run;
ods html close;
ods html;
proc surveylogistic data=nhats_wave1_2 ;
model died = sr_hosp_stays;
run;
proc surveylogistic data=nhats_wave1_3 ;
model died = sr_hosp_stays;
run;
proc surveylogistic data=nhats_wave1_5 ;
model died = sr_hosp_stays;
run;

%macro table1(data);
ods html close;
ods html;
ods rtf body = "E:\data\nhats\Projects\Caregivers\table_info_&data..rtf";
proc sort data=&data;
by died;
run;
/*
proc freq data=&data;
table female*died white*died gt_hs_edu*died married*died spouse*died medicaid*died srh_fp*died sr_ami_ever*died sr_heart_dis_ever*died sr_ra_ever*died
sr_diabetes_ever*died sr_lung_dis_ever*died sr_stroke_ever*died sr_cancer_ever*died sr_phq2_depressed*died dem_2_cat*died fall_last_month*died sum_adl_cat*died
reg_doc_seen*died reg_doc_homevisit*died sr_hosp_ind*died / chisq;
weight w1anfinwgt0;
run;
*/
proc surveymeans data=&data mean std median t;
by died;
class died;
var age sr_numconditions1 sr_hosp_stays;
weight w1anfinwgt0;
run;

ods rtf close;
%mend;
/*Community Dwelling Sample*/
%table1(nhats_wave1_2);
/*Community Dwelling, Chronically Disabled Sample*/
%table1(nhats_wave1_3);
/*Community Dwelling, Chronically Disabled, CAREGIVER COMPLETED, Sample*/
%table1(nhats_wave1_5);

proc freq data=nsoc;
table cg_relationship_cat;
run;
data nsoc1;
set nsoc;
/*creating a family priority variable*/
family = 0;
if cg_relationship_cat = 1 then family = 2;
if cg_relationship_cat = 2 then family = 1;
if cg_relationship_cat = 3 then family = 0;
/*gathering total hours a day/week/month/other */
total_hours_day = cdc1hlphrsdy + 0;
if total_hours_day < 0 then total_hours_day = .;
total_hours_week = cdc1hlpdyswk + 0;
if total_hours_week < 0 then total_hours_week = .;
total_hours_month = cdc1hlpdysmt + 0;
if total_hours_month < 0 then total_hours_month = .;
total_hours_other = cdc1hlphrlmt + 0;
if total_hours_other < 0 then total_hours_other = .;
other_flag = 0;
if cdc1hlphrmvf ~= 1 then other_flag=1;
/*if the cargiver was a regular then you calculated it days a week per day and multiply that by 4*/
if cdc1hlpsched = 1 then total_hours = total_hours_week * total_hours_day * 4;
/*if they were not a regular than you calculated the total days in the month by total hours*/
if cdc1hlpsched ~= 1 then total_hours = total_hours_month * total_hours_day;
if other_flag = 1 then total_hours = total_hours_other;
run;
proc means data=nsoc1;
var  total_hours  ;
run;
proc freq data=nsoc1;
table family cdc1hlphrmvf other_flag;
run;
proc sort data=nsoc1;
by spid descending total_hours cdc1hlphrsdy spouse;
run;
proc sort data=nsoc1 out=nsoc2 nodupkey;
by spid;
run;

proc sql;
create table nhats_wave1_6
as select a.*, b.c1relatnshp, b.cdc1hlpsched, b.total_hours, b.total_hours_day, b.total_hours_week, b.total_hours_month, b.total_hours_other, b.family, 
b.cpp1wrk4pay as work_pay_month, b.cpp1hlpkptwk as keep_from_work, b.cpp1careothr as care_for_others, b.che1health, b.che1hrtattck, b.che1othheart, b.che1highbld,
b.che1arthrits, b.che1osteoprs, b.che1diabetes, b.che1lungdis, b.che1cancer, b.che1seeing, b.che1hearing, b.che1fltdown, b.che1fltnervs, b.che1fltworry,
b.chd1martstat, b.chd1chldlvng, b.chd1numchild, b.chd1numchu18, b.chd1educ, b.chd1cgbrthmt, b.chd1cgbrthyr, b.c1dgender, b.cec1wrk4pay, b.cec1hlpafwk1, b.chi1medicare,
b.chi1medigap, b.chi1medicaid, b.chi1privinsr, b.chi1tricare, b.chi1uninsurd, b.chi1insrtype, b.cse1frfamact, b.cca1hwoftchs, b.cca1hwoftshp, b.cca1hlpordmd, b.cca1hlpbnkng,
b.cca1cmpgrcry, b.cca1cmpordrx, b.cca1cmpbnking, b.cca1hwoftpc, b.cca1hwofthom, b.cca1hwoftdrv, b.cca1hlpmed, b.cca1hlpshot, b.ca1hlpmdtk, b.cca1hlpexrcs, b.cca1hlpdiet,
b.cca1hlpteeth, b.cca1hlpfeet, b.cca1hlpskin, b.cca1hlpmdapt, b.cca1hlpspkdr, b.cca1hlpinsrn, b.cca1hlpothnin, b.cac1joylevel, b.cac1arguelv, b.cac1spapprlv, b.cac1nerveslv,
b.cac1moreconf, b.cac1dealbetr, b.cac1closr2sp, b.cac1moresat, b.cac1diffinc, b.cac1diffemo, b.cac1diffphy, b.cac1diffinlv, b.cac1diffemlv, b.cac1diffphlv, b.cac1fmlydisa,
b.cac1exhaustd, b.cac1toomuch, b.cac1notime, b.cac1uroutchg

from nhats_wave1_5 a
left join nsoc2 b
on a.spid = b.spid;
quit;




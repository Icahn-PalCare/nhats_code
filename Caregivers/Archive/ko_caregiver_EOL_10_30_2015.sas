/******************************** IMPORT **********************************/
libname ko "E:\nhats\data\Projects\Caregivers";

proc import out=raw_nhats_r1
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File_old.dta";
run;
proc import out=raw_nhats_r2
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_SP_File_old.dta";
run;
proc import out=raw_nhats_r3
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_SP_File_old.dta";
run;
proc import out=nhats
			datafile = "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old.dta";
run;
proc import out=nsoc_rg
			datafile = "E:\nhats\data\NHATS working data\caregiver_ds_nsoc_clean_v2_old.dta";
run;
proc import out=nsoc_tracker
			datafile = "E:\nhats\data\NHATS Sensitive\r1_sensitive\NSOC_Round_1_SP_Tracker_File.dta";
run;
proc import out=nhats_r2_sen
			datafile = "E:\nhats\data\NHATS Sensitive\r2_sensitive\NHATS_Round_2_SP_Sen_Dem_File.dta";
run;

/* some of the current variables in the "final" dataset doesn't have some essential variables. I am merging them in from the raw data files*/

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



/**************************************** SAMPLE CREATION **********************************************/

proc freq data=nhats_wave1_1;
table is2reasnprx7;
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

/*Died at Round 2 or Round 3*/
died = 0;
if is2reasnprx7 = 1 then died = 1;
if is2reasnprx7 = -9 then died = .;
died_24 = 0;
if is2reasnprx7 = 1 or is3reasnprx7 = 1 then died_24 = 1;
if is2reasnprx7 = -9 or is3reasnprx7 = -9 then died_24 = .;

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
sum_adl = sum(adl_eating, adl_bed, adl_chair, adl_walk_in, adl_walk_out, adl_dress, adl_bathe, adl_toilet, 0);
sum_adl_cat = 0;
if sum_adl = 1 or sum_adl = 2 then sum_adl_cat = 1;
if sum_adl > 2 then sum_adl_cat = 2;

/*Labelling stuff*/
label female = "Gender";
label spouse = "Spouse + Other";
label sum_adl_cat = "ADLs Categories";
run;
proc freq data=nhats_wave1_2;
table died died_24 is3reasnprx7 is2reasnprx7;
run;
proc freq data=nhats_wave1_2;
table race_cat white maritalstat married education gt_hs_edu LIVEARRANG spouse sum_adl sum_adl_cat ls1evdayact1 adl_eating ls1evdayact2 adl_bed ls1evdayact3 adl_chair
ls1evdayact4 adl_walk_in ls1evdayact5 adl_walk_out ls1evdayact6 adl_dress ls1evdayact7 adl_bathe ls1evdayact8 adl_toilet ls1ableto1 ls1diskefrm1 iadl_meals ls1ableto2 ls1diskefrm2 iadl_laundry
ls1ableto3 ls1diskefrm3 iadl_housewk ls1ableto4 ls1diskefrm4 iadl_shop ls1ableto5 ls1diskefrm5 iadl_money ls1ableto6 ls1diskefrm6 iadl_meds ls1ableto7 ls1diskefrm7 iadl_phone;
run;
/*if the person has any disability*/
data nhats_wave1_3;
set nhats_wave1_2;
if adl_eating = 1| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | adl_bathe = 1 | adl_toilet = 1|iadl_meals = 1 | iadl_laundry = 1 | iadl_housewk = 1 | iadl_shop = 1 | iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1;
run;
/*sample size greatly reduced to 2024*/

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
format eligible yesno_. complete yesno_.;
run;
proc freq data=nhats_wave1_4;
where complete = 1;
table total_caregiver_comp;
run;
proc means data=nhats_wave1_4;
where complete = 1;
var total_caregiver_comp;
run;
/*if eligible and completed NSOC*/
data nhats_wave1_5;
set nhats_wave1_4;
if eligible = 1 and complete = 1;
run;
proc freq data=nhats_wave1_5;
table died;
run;
/*Sample size is 1018*/

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

/********************************************* LABELS **************************************************/

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

/*************************** SAS TO FANCY TABLES EXPERIMENT. CURRENTLY: FAILED **********************************************/

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

/*************************************************************** TABLE 1 GENERATION ************************************************/

%macro table1(data);
ods html close;
ods html;
ods rtf body = "E:\nhats\projects\Caregivers_KO\09182015\table_info_&data..rtf";
proc sort data=&data;
by died;
run;

proc freq data=&data;
table female*died white*died gt_hs_edu*died married*died spouse*died medicaid*died srh_fp*died sr_ami_ever*died sr_heart_dis_ever*died sr_ra_ever*died
sr_diabetes_ever*died sr_lung_dis_ever*died sr_stroke_ever*died sr_cancer_ever*died sr_phq2_depressed*died dem_2_cat*died fall_last_month*died sum_adl_cat*died
reg_doc_seen*died reg_doc_homevisit*died sr_hosp_ind*died / chisq;
weight w1anfinwgt0;
run;

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
proc export data=nhats_wave1_2 outfile = "E:\nhats\data\Projects\Caregivers\Caregiver_1.dta";
run;
proc export data=nhats_wave1_3 outfile = "E:\nhats\data\Projects\Caregivers\Caregiver_2.dta";
run;
proc export data=nhats_wave1_5 outfile = "E:\nhats\data\Projects\Caregivers\Caregiver_3.dta";
run;

proc freq data=nsoc;
table cg_relationship_cat;
run;

/**** setting up the primary caregiver ****/

data nsoc_rg1;
set nsoc_rg;
/*creating a family priority variable*/
priority_family = 0;
if cg_relationship_cat = 1 then priority_family = 2;
if cg_relationship_cat = 2 then priority_family = 1;
if cg_relationship_cat = 3 then priority_family = 0;
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
proc freq data=nsoc_rg;
table spouse;
run;
/*1st: by total hours a person spends then whether not the person is the spouse*/
proc sort data=nsoc_rg1;
by spid descending total_hours cg_spouse;
run;
proc sort data=nsoc_rg1;
by spid descending total_hours cdc1hlphrsdy cg_spouse;
run;
data test_rg;
set nsoc_rg1 (keep = spid opid total_hours  c1relatnshp cdc1hlphrsdy);
run;
data test2;
set nsoc_rg1 (keep = spid opid total_hours cg_spouse);
run;
proc freq data=nsoc_rg1;
table cdc1hlphrsdy;
run;
proc sort data=nsoc_rg1 out=nsoc_rg2 nodupkey;
by spid;
run;

/*final NSOC database. Getting the variables we need for merging*/

data nsoc_rg3;
set nsoc_rg2 (keep = 
/*ID*/ spid opid c1dgender c1relatnshp c1intmonth c1dintdays /*CA*/ cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin
/*DC*/ cdc1hlpdyswk cdc1hlphrmvf cdc1hlphrlmt cdc1hlpyrpls cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst /*AC*/ cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd cac1toomuch cac1notime cac1uroutchg
/*SE*/ cse1frfamact /*PP*/cpp1wrk4pay cpp1hlpkptwk cpp1careothr /*HE*/ che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing
che1hearing che1fltdown che1fltnervs che1fltworry /*HD*/ chd1martstat chd1educ chd1chldlvng chd1numchild chd1numchu18 chd1educ chd1cgbrthmt chd1cgbrthyr /*EC*/ cec1wrk4pay cec1hlpafwk1 cec1occuptn cec1worktype
/*HI*/ chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype w1cgfinwgt0 cg_female cg_relationship_cat cg_age cg_lives_with_sp cg_srh cg_srh_fp);
run;
/*old code*/
/*
proc sql;
create table nhats_wave1_6
as select a.*, b.c1relatnshp, b.cdc1hlpsched, b.total_hours, b.total_hours_day, b.total_hours_week, b.total_hours_month, b.total_hours_other, b.family, 
b.cpp1wrk4pay as work_pay_month, b.cpp1hlpkptwk as keep_from_work, b.cpp1careothr as care_for_others, b.che1health, b.che1hrtattck, b.che1othheart, b.che1highbld,
b.che1arthrits, b.che1osteoprs, b.che1diabetes, b.che1lungdis, b.che1cancer, b.che1seeing, b.che1hearing, b.che1fltdown, b.che1fltnervs, b.che1fltworry,
b.chd1martstat, b.chd1chldlvng, b.chd1numchild, b.chd1numchu18, b.chd1educ, b.chd1cgbrthmt, b.chd1cgbrthyr, b.c1dgender, b.cec1wrk4pay, b.cec1hlpafwk1, b.chi1medicare,
b.chi1medigap, b.chi1medicaid, b.chi1privinsr, b.chi1tricare, b.chi1uninsurd, b.chi1insrtype, b.cse1frfamact, b.cca1hwoftchs, b.cca1hwoftshp, b.cca1hlpordmd, b.cca1hlpbnkng,
b.cca1cmpgrcry, b.cca1cmpordrx, b.cca1cmpbnkng, b.cca1hwoftpc, b.cca1hwofthom, b.cca1hwoftdrv, b.cca1hlpmed, b.cca1hlpshot, b.cca1hlpmdtk, b.cca1hlpexrcs, b.cca1hlpdiet,
b.cca1hlpteeth, b.cca1hlpfeet, b.cca1hlpskin, b.cca1hlpmdapt, b.cca1hlpspkdr, b.cca1hlpinsrn, b.cca1hlpothin, b.cac1joylevel, b.cac1arguelv, b.cac1spapprlv, b.cac1nerveslv,
b.cac1moreconf, b.cac1dealbetr, b.cac1closr2sp, b.cac1moresat, b.cac1diffinc, b.cac1diffemo, b.cac1diffphy, b.cac1diffinlv, b.cac1diffemlv, b.cac1diffphlv, b.cac1fmlydisa,
b.cac1exhaustd, b.cac1toomuch, b.cac1notime, b.cac1uroutchg

from nhats_wave1_5 a
left join nsoc2 b
on a.spid = b.spid;
quit;
*/

/*merging nhats info with nsoc info*/
proc sql;
create table nhats_wave1_6
as select *
from nhats_wave1_5 a
left join nsoc3 b
on a.spid = b.spid;
quit;

/*variable list*/
proc sql;
create table list
as select trim(compress(name))
into :drop_vars separated by ' '
from sashelp.vcolumn
where libname = upcase('work')
and memname = upcase('nhats_wave1_6');
quit;
proc export data=list outfile = "C:\Users\leee20\Documents\list.csv" dbms = csv replace;
run;

/*deleting 2nd and 3rd round variables to leave 1st round stuff*/

data nhats_wave1_7;
set nhats_wave1_6;
drop r2dresid
is2resptype	r2d2intvrage	re2spadrsnew	re2intplace	re2newstrct	re2dadrscorr	re2dresistrct	re2dcensdiv	hc2health	hc2disescn1	hc2disescn2	hc2disescn3	hc2disescn4	
hc2disescn5	hc2disescn6	hc2disescn7	hc2disescn8	hc2disescn9	hc2disescn10	hc2brokebon1	hc2brokebon2	hc2hosptstay	hc2hosovrnht	hc2knesrgyr	hc2hipsrgyr	hc2catrsrgyr	
hc2backsrgyr	hc2hartsrgyr	hc2fllsinmth	hc2worryfall	hc2worrylimt	hc2faleninyr	hc2multifall	hc2depresan1	hc2depresan2	hc2depresan3	hc2depresan4	
hc2aslep30mn	hc2trbfalbck	hc2sleepmed	ht2placedesc	hh2marchange	hh2martlstat	hh2yrendmarr	hh2newspoprt	hh2spgender	hh2dspouage	hh2dspageall	hh2spouseduc	
hh2spoupchlp	hh2livwthspo	hh2placekind	hh2dmarstat	hh2dlvngarrg	hh2dhshldnum	hh2dhshldchd	hh2dspouseid	ss2heringaid	ss2hearphone	ss2convwradi	
ss2convquiet	ss2glasseswr	ss2seewellst	ss2seestvgls	ss2glasscls	ss2othvisaid	ss2glrednewp	ss2probchswl	ss2probspeak	ss2painbothr	ss2painlimts	
ss2painmedof	ss2painwhe1	ss2painwhe2	ss2painwhe3	ss2painwhe4	ss2painwhe5	ss2painwhe6	ss2painwhe7	ss2painwhe8	ss2painwhe9	ss2painwhe10	ss2painwhe11	ss2painwhe12	
ss2painwhe13	ss2probbreat	ss2prbbrlimt	ss2strnglmup	ss2uplimtact	ss2lwrbodstr	ss2lwrbodimp	ss2lowenergy	ss2loenlmtat	ss2prbbalcrd	ss2prbbalcnt	
pc2walk6blks	pc2walk3blks	pc2up20stair	pc2up10stair	pc2car20pnds	pc2car10pnds	pc2geonknees	pc2bendover	pc2hvobovrhd	pc2rechovrhd	pc2opnjarwhd	
pc2grspsmobj	cp2memrygood	cp2knownspyr	cp2chgthink1	cp2chgthink2	cp2chgthink3	cp2chgthink4	cp2chgthink5	cp2chgthink6	cp2chgthink7	cp2chgthink8	
cp2memcogpr1	cp2memcogpr2	cp2memcogpr3	cp2memcogpr4	cp2dad8dem	cg2speaktosp	cg2quesremem	cg2reascano1	cg2reascano2	cg2reascano3	cg2reascano4	
cg2reascano5	cg2reascano6	cg2reascano7	cg2reascano8	cg2reascano9	cg2ratememry	cg2ofmemprob	cg2memcom1yr	cg2todaydat1	cg2todaydat2	cg2todaydat3	
cg2todaydat5	cg2todaydat4	cg2todaydat6	cg2prewrdrcl	cg2dwrdlstnm	cg2wrdsrcal1	cg2wrdsrcal2	cg2wrdsrcal3	cg2wrdsrcal4	cg2wrdsrcal5	cg2wrdsrcal6	
cg2wrdsrcal7	cg2wrdsrcal8	cg2wrdsrcal9	cg2wrdsrca10	cg2dwrdimmrc	cg2dwrdinone	cg2dwrdirref	cg2wrdsntlst	cg2numnotlst	cg2probreca1	cg2probreca2	
cg2probreca3	cg2probreca4	cg2probreca5	cg2dclkdraw	cg2dclkimgcl	cg2atdrwclck	cg2presidna1	cg2presidna2	cg2presidna3	cg2presidna4	cg2vpname1	
cg2vpname2	cg2vpname3	cg2vpname4	cg2wrdsdcal1	cg2wrdsdcal2	cg2wrdsdcal3	cg2wrdsdcal4	cg2wrdsdcal5	cg2wrdsdcal6	cg2wrdsdcal7	cg2wrdsdcal8	cg2wrdsdcal9
cg2wrdsdca10	cg2dwrddlyrc	cg2dwrddnone	cg2dwrddrref	cg2wrdnotlst	cg2numwrdnot	cg2dwrd1rcl	cg2dwrd2rcl	cg2dwrd3rcl	cg2dwrd4rcl	cg2dwrd5rcl	cg2dwrd6rcl	cg2dwrd7rcl
cg2dwrd8rcl	cg2dwrd9rcl	cg2dwrd10rcl	cg2dwrd1dly	cg2dwrd2dly	cg2dwrd3dly	cg2dwrd4dly	cg2dwrd5dly	cg2dwrd6dly	cg2dwrd7dly	cg2dwrd8dly	cg2dwrd9dly	cg2dwrd10dly	mo2outoft
mo2outcane	mo2outwalkr	mo2outwlchr	mo2outsctr	mo2outhlp	mo2outslf	mo2outdif	mo2outyrgo	mo2outwout	ha2laun	ha2launslf	ha2whrmachi1	ha2whrmachi2	ha2whrmachi3
ha2whrmachi4	ha2whrmachi5	ha2whrmachi6	ha2dlaunreas	ha2laundif	ha2launoft	ha2launwout	ha2shop	ha2shopslf	ha2howpaygr1	ha2howpaygr2	ha2howpaygr3	
ha2howpaygr4	ha2howpaygr5	ha2howpaygr6	ha2howpaygr7	ha2howgtstr1	ha2howgtstr2	ha2howgtstr3	ha2howgtstr4	ha2howgtstr5	ha2howgtstr6	ha2howgtstr7
ha2howgtstr8	ha2shopcart	ha2shoplean	ha2dshopreas	ha2shopdif	ha2shopoft	ha2shopwout	ha2meal	ha2mealslf	ha2restamels	ha2oftmicrow	ha2dmealreas	ha2mealdif
ha2mealoft	ha2mealwout	ha2bank	ha2bankslf	ha2dbankreas	ha2bankdif	ha2bankoft	ha2bankwout	ha2money	ha2moneyhlp	ha2dlaunsfdf	ha2dshopsfdf	ha2dmealsfdf	
ha2dbanksfdf	ha2dmealwhl	ha2dmealtkot	sc2eatdev	sc2eatdevoft	sc2eathlp	sc2eatslfoft	sc2eatslfdif	sc2eatwout	sc2showrbat1	sc2showrbat2	sc2showrbat3
sc2bdevdec	sc2prfrshbth	sc2scusgrbrs	sc2shtubseat	sc2bathhlp	sc2bathoft	sc2bathdif	sc2bathyrgo	sc2bathwout	sc2usvartoi1	sc2usvartoi2	sc2usvartoi3	
sc2usvartoi4	sc2toilhlp	sc2toiloft	sc2toildif	sc2toilwout	sc2dresoft	sc2dresdev	sc2dreshlp	sc2dresslf	sc2dresdif	sc2dresyrgo	sc2dreswout	sc2deatdevi	sc2deathelp	
sc2deatsfdf	sc2dbathdevi	sc2dbathhelp	sc2dbathsfdf	sc2dtoildevi	sc2dtoilhelp	sc2dtoilsfdf	sc2ddresdevi	sc2ddreshelp	sc2ddressfdf	mc2meds	mc2medstrk	
mc2medsslf	mc2whrgtmed1	mc2whrgtmed2	mc2whrgtmed3	mc2whrgtmed4	mc2howpkupm1	mc2howpkupm2	mc2howpkupm3	mc2medsrem	mc2dmedsreas	mc2medsdif	mc2medsyrgo
mc2medsmis	mc2havregdoc	mc2regdoclyr	mc2hwgtregd1	mc2hwgtregd2	mc2hwgtregd3	mc2hwgtregd4	mc2hwgtregd5	mc2hwgtregd6	mc2hwgtregd7	mc2hwgtregd8	
mc2hwgtregd9	mc2ansitindr	mc2tpersevr1	mc2tpersevr2	mc2tpersevr3	mc2tpersevr4	mc2chginspln	mc2anhlpwdec	mc2dmedssfdf	sd2smokesnow	sd2numcigday	
ip2covmedcad	ip2mgapmedsp	ip2cmedicaid	ip2covtricar	ip2nginslast	ip2nginsnurs	w2anfinwgt0	w2varstrat	w2varunit	r3dresid	is3resptype	r3d2intvrage	re3spadrsnew
re3intplace	re3newstrct	re3dresistrct	re3dcensdiv	hc3health	hc3disescn1	hc3disescn2	hc3disescn3	hc3disescn4	hc3disescn5	hc3disescn6	hc3disescn7	hc3disescn8	hc3disescn9	hc3disescn10
hc3brokebon1	hc3brokebon2	hc3hosptstay	hc3hosovrnht	hc3knesrgyr	hc3hipsrgyr	hc3catrsrgyr	hc3backsrgyr	hc3hartsrgyr	hc3fllsinmth	hc3worryfall	hc3worrylimt	
hc3faleninyr	hc3multifall	hc3depresan1	hc3depresan2	hc3depresan3	hc3depresan4	hc3aslep30mn	hc3trbfalbck	hc3sleepmed	ht3placedesc	hh3marchange	hh3martlstat
hh3yrendmarr	hh3newspoprt	hh3spgender	hh3dspouage	hh3dspageall	hh3spouseduc	hh3spoupchlp	hh3livwthspo	hh3placekind	hh3dmarstat	hh3dlvngarrg	hh3dhshldnum	
hh3dhshldchd	hh3dspouseid	ss3heringaid	ss3hearphone	ss3convwradi	ss3convquiet	ss3glasseswr	ss3seewellst	ss3seestvgls	ss3glasscls	ss3othvisaid	ss3glrednewp
ss3probchswl	ss3probspeak	ss3painbothr	ss3painlimts	ss3painmedof	ss3painwhe1	ss3painwhe2	ss3painwhe3	ss3painwhe4	ss3painwhe5	ss3painwhe6	ss3painwhe7	ss3painwhe8	ss3painwhe9
ss3painwhe10	ss3painwhe11	ss3painwhe12	ss3painwhe13	ss3probbreat	ss3prbbrlimt	ss3strnglmup	ss3uplimtact	ss3lwrbodstr	ss3lwrbodimp	ss3lowenergy	
ss3loenlmtat	ss3prbbalcrd	ss3prbbalcnt	pc3walk6blks	pc3walk3blks	pc3up20stair	pc3up10stair	pc3car20pnds	pc3car10pnds	pc3geonknees	pc3bendover	pc3hvobovrhd
pc3rechovrhd	pc3opnjarwhd	pc3grspsmobj	cp3memrygood	cp3knownspyr	cp3chgthink1	cp3chgthink2	cp3chgthink3	cp3chgthink4	cp3chgthink5	cp3chgthink6	
cp3chgthink7	cp3chgthink8	cp3memcogpr1	cp3memcogpr2	cp3memcogpr3	cp3memcogpr4	cp3dad8dem	cg3speaktosp	cg3quesremem	cg3reascano1	cg3reascano2	cg3reascano3
cg3reascano4	cg3reascano5	cg3reascano6	cg3reascano7	cg3reascano8	cg3reascano9	cg3ratememry	cg3ofmemprob	cg3memcom1yr	cg3todaydat1	cg3todaydat2	
cg3todaydat3	cg3todaydat5	cg3todaydat4	cg3todaydat6	cg3prewrdrcl	cg3dwrdlstnm	cg3wrdsrcal1	cg3wrdsrcal2	cg3wrdsrcal3	cg3wrdsrcal4	cg3wrdsrcal5	
cg3wrdsrcal6	cg3wrdsrcal7	cg3wrdsrcal8	cg3wrdsrcal9	cg3wrdsrca10	cg3dwrdimmrc	cg3dwrdinone	cg3dwrdirref	cg3wrdsntlst	cg3numnotlst	cg3probreca1	
cg3probreca2	cg3probreca3	cg3probreca4	cg3probreca5	cg3dclkdraw	cg3dclkimgcl	cg3atdrwclck	cg3presidna1	cg3presidna2	cg3presidna3	cg3presidna4	cg3vpname1	
cg3vpname2	cg3vpname3	cg3vpname4	cg3wrdsdcal1	cg3wrdsdcal2	cg3wrdsdcal3	cg3wrdsdcal4	cg3wrdsdcal5	cg3wrdsdcal6	cg3wrdsdcal7	cg3wrdsdcal8	cg3wrdsdcal9	
cg3wrdsdca10	cg3dwrddlyrc	cg3dwrddnone	cg3dwrddrref	cg3wrdnotlst	cg3numwrdnot	cg3dwrd1rcl	cg3dwrd2rcl	cg3dwrd3rcl	cg3dwrd4rcl	cg3dwrd5rcl	cg3dwrd6rcl	cg3dwrd7rcl	
cg3dwrd8rcl	cg3dwrd9rcl	cg3dwrd10rcl	cg3dwrd1dly	cg3dwrd2dly	cg3dwrd3dly	cg3dwrd4dly	cg3dwrd5dly	cg3dwrd6dly	cg3dwrd7dly	cg3dwrd8dly	cg3dwrd9dly	cg3dwrd10dly	mo3outoft	
mo3outcane	mo3outwalkr	mo3outwlchr	mo3outsctr	mo3outhlp	mo3outslf	mo3outdif	mo3outyrgo	mo3outwout	ha3laun	ha3launslf	ha3whrmachi1	ha3whrmachi2	ha3whrmachi3	
ha3whrmachi4	ha3whrmachi5	ha3whrmachi6	ha3dlaunreas	ha3laundif	ha3launoft	ha3launwout	ha3shop	ha3shopslf	ha3howpaygr1	ha3howpaygr2	ha3howpaygr3	ha3howpaygr4	
ha3howpaygr5	ha3howpaygr6	ha3howpaygr7	ha3howgtstr1	ha3howgtstr2	ha3howgtstr3	ha3howgtstr4	ha3howgtstr5	ha3howgtstr6	ha3howgtstr7	ha3howgtstr8	
ha3shopcart	ha3shoplean	ha3dshopreas	ha3shopdif	ha3shopoft	ha3shopwout	ha3meal	ha3mealslf	ha3restamels	ha3mealwheel	ha3oftmicrow	ha3dmealreas	ha3mealdif	ha3mealoft	
ha3mealwout	ha3bank	ha3bankslf	ha3dbankreas	ha3bankdif	ha3bankoft	ha3bankwout	ha3money	ha3moneyhlp	ha3dlaunsfdf	ha3dshopsfdf	ha3dmealsfdf	ha3dbanksfdf	ha3dmealwhl	
ha3dmealtkot	sc3eatdev	sc3eatdevoft	sc3eathlp	sc3eatslfoft	sc3eatslfdif	sc3eatwout	sc3showrbat1	sc3showrbat2	sc3showrbat3	sc3bdevdec	sc3prfrshbth	
sc3scusgrbrs	sc3shtubseat	sc3bathhlp	sc3bathoft	sc3bathdif	sc3bathyrgo	sc3bathwout	sc3usvartoi1	sc3usvartoi2	sc3usvartoi3	sc3usvartoi4	sc3toilhlp	sc3toiloft	
sc3toildif	sc3toilwout	sc3dresoft	sc3dresdev	sc3dreshlp	sc3dresslf	sc3dresdif	sc3dresyrgo	sc3dreswout	sc3deatdevi	sc3deathelp	sc3deatsfdf	sc3dbathdevi	sc3dbathhelp	
sc3dbathsfdf	sc3dtoildevi	sc3dtoilhelp	sc3dtoilsfdf	sc3ddresdevi	sc3ddreshelp	sc3ddressfdf	mc3meds	mc3medstrk	mc3medsslf	mc3whrgtmed1	mc3whrgtmed2	
mc3whrgtmed3	mc3whrgtmed4	mc3howpkupm1	mc3howpkupm2	mc3howpkupm3	mc3medsrem	mc3dmedsreas	mc3medsdif	mc3medsyrgo	mc3medsmis	mc3havregdoc	mc3regdoclyr	
mc3hwgtregd1	mc3hwgtregd2	mc3hwgtregd3	mc3hwgtregd4	mc3hwgtregd5	mc3hwgtregd6	mc3hwgtregd7	mc3hwgtregd8	mc3hwgtregd9	mc3ansitindr	mc3tpersevr1	
mc3tpersevr2	mc3tpersevr3	mc3tpersevr4	mc3chginspln	mc3anhlpwdec	mc3dmedssfdf	sd3smokesnow	sd3numcigday	ip3covmedcad	ip3mgapmedsp	ip3cmedicaid	
ip3covtricar	ip3nginslast	ip3nginsnurs	w3anfinwgt0	w3varstrat	w3varunit	r1dbirthmth	r1dbirthyr	r1dintvwrage	hh1modob	hh1yrdob	hh1dspousage	rl1primarace	
rl1hisplatno	r2dintvwrage	hh2dspousage	r2ddeathage	pd2mthdied	pd2yrdied	yearsample	r3status	r3spstat	r3spstatdtyr	r2status	r2spstat	r2spstatdtyr;
run;


/*************************************************** SAMPLE DERIVATION *********************************************/

data nhats_wave1_1_0;
set nhats_wave1_1;
Community = 0;
if r1dresid = 1 or r1dresid = 2 then Community = 1;
run;
proc format;
value commun 1 = 'Community'
			 0 = 'Non-Community'
			 . = '    Missing';
value adlko 1 = 'Chronic Disability'
			0 = 'No Chronic Disability'
;
run; 
ods html close;
ods html;
ods rtf body = "E:\data\nhats\Projects\Caregivers\Sample_Derivation.rtf";
proc freq data = nhats_wave1_1_0;
title "Number of Community Dwelling people";
table community;
format community commun.;
run; 
data nhats_wave1_2_0;
set nhats_wave1_2;
ADL = 0;
if adl_eating = 1| adl_bed = 1 | adl_chair = 1 | adl_walk_in = 1 | adl_walk_out = 1 | adl_dress = 1 | adl_bathe = 1 | iadl_meals = 1 | iadl_laundry = 1 | 
iadl_housewk = 1 | iadl_shop = 1 | iadl_money = 1 | iadl_meds = 1 | iadl_phone = 1 then ADL = 1;
run;
proc freq data= nhats_wave1_2_0;
title "Chronic Disability based on any ADL/IADL";
format adl adlko.;
table adl;
run;
proc freq data=nhats_wave1_4;
title "NSOC Eligible and Completion";
table eligible*complete ;
format eligible yesno_. complete yesno_.;
run;
ods rtf close;

/*********************************************************** CAREGIVER FREQUENCIES *************************************/
ods html close;
ods html;
ods rtf body = "E:\nhats\data\Projects\Caregivers\NSOC.rtf";
proc freq data=nhats_wave1_7;
table che1health*died che1hrtattck*died che1othheart*died che1highbld*died che1arthrits*died che1osteoprs*died che1diabetes*died che1lungdis*died che1cancer*died
che1seeing*died che1hearing*died che1fltdown*died che1fltnervs*died che1fltworry*died chd1martstat*died chd1educ*died cec1wrk4pay*died cec1hlpafwk1*died
chi1medigap*died chi1medicaid*died chi1privinsr*died chi1tricare*died chi1uninsurd*died
cca1hwoftchs*died cca1hwoftshp*died cca1hlpordmd*died cca1hlpbnkng*died cca1cmpgrcry*died cca1cmpordrx*died cca1cmpbnkng*died cca1hwoftpc*died cca1hwofthom*died cca1hwoftdrv*died
cca1hlpmed*died cca1hlpshot*died cca1hlpmdtk*died cca1hlpexrcs cca1hlpdiet*died cca1hlpteeth*died cca1hlpfeet*died cca1hlpskin*died cca1hlpmdapt*died cca1hlpspkdr*died
cca1hlpinsrn*died cca1hlpothin*died cac1joylevel*died cac1arguelv*died cac1spapprlv*died cac1nerveslv*died cac1moreconf*died cac1dealbetr*died cac1closr2sp*died cac1moresat*died
cac1diffinc*died cac1diffemo*died cac1diffphy*died cac1diffinlv*died cac1diffemlv*died cac1diffphlv*died cac1fmlydisa*died cac1exhaustd*died cac1toomuch*died cac1notime*died cac1uroutchg*died/chisq;
run;
ods rtf close;
proc freq data=nhats_wave1_7;
table died;
run;

data ko.nhats_wave1;
set nhats_wave1_7;
run;

/******************************************************* Further Cleaning up ********************************************/

/*Getting rid of some of the negative values*/

data nhats_wave1_8;
set ko.nhats_wave1;
run;

%let varlist = c1dgender c1relatnshp c1intmonth c1dintdays cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin
cdc1hlpdyswk cdc1hlphrmvf cdc1hlphrlmt cdc1hlpyrpls cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd cac1toomuch cac1notime cac1uroutchg
cse1frfamact cpp1wrk4pay cpp1hlpkptwk cpp1careothr che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing
che1hearing che1fltdown che1fltnervs che1fltworry chd1martstat chd1chldlvng chd1numchild chd1numchu18 chd1educ chd1cgbrthmt chd1cgbrthyr cec1wrk4pay cec1hlpafwk1 cec1occuptn cec1worktype
chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype;
%macro change_neg();
%let i = 1;
%let var = %scan(&varlist,&i);
%do %while(&var ne );
data nhats_wave1_8;
set nhats_wave1_8;
if &var < 0 then &var = .;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%end;
%mend;
%change_neg();

ods rtf body = "E:\nhats\data\Projects\Caregivers\NSOC1.rtf";
proc freq data=nhats_wave1_8;
table che1health*died che1hrtattck*died che1othheart*died che1highbld*died che1arthrits*died che1osteoprs*died che1diabetes*died che1lungdis*died che1cancer*died
che1seeing*died che1hearing*died che1fltdown*died che1fltnervs*died che1fltworry*died chd1martstat*died chd1educ*died cec1wrk4pay*died cec1hlpafwk1*died
chi1medigap*died chi1medicaid*died chi1privinsr*died chi1tricare*died chi1uninsurd*died
cca1hwoftchs*died cca1hwoftshp*died cca1hlpordmd*died cca1hlpbnkng*died cca1cmpgrcry*died cca1cmpordrx*died cca1cmpbnkng*died cca1hwoftpc*died cca1hwofthom*died cca1hwoftdrv*died
cca1hlpmed*died cca1hlpshot*died cca1hlpmdtk*died cca1hlpexrcs cca1hlpdiet*died cca1hlpteeth*died cca1hlpfeet*died cca1hlpskin*died cca1hlpmdapt*died cca1hlpspkdr*died
cca1hlpinsrn*died cca1hlpothin*died cac1joylevel*died cac1arguelv*died cac1spapprlv*died cac1nerveslv*died cac1moreconf*died cac1dealbetr*died cac1closr2sp*died cac1moresat*died
cac1diffinc*died cac1diffemo*died cac1diffphy*died cac1diffinlv*died cac1diffemlv*died cac1diffphlv*died cac1fmlydisa*died cac1exhaustd*died cac1toomuch*died cac1notime*died cac1uroutchg*died/chisq;
run;
ods rtf close;

data ko.nhats_wave1_1;
set nhats_wave1_8;
run;

data nhats_wave1;
set ko.nhats_wave1_7;
run;
proc freq data=nhats_wave1_7;
table c1dgender c1relatnshp c1intmonth c1dintdays cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin
cdc1hlpdyswk cdc1hlphrmvf cdc1hlphrlmt cdc1hlpyrpls cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd cac1toomuch cac1notime cac1uroutchg
cse1frfamact cpp1wrk4pay cpp1hlpkptwk cpp1careothr che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing
che1hearing che1fltdown che1fltnervs che1fltworry chd1martstat chd1chldlvng chd1numchild chd1numchu18 chd1educ chd1cgbrthmt chd1cgbrthyr cec1wrk4pay cec1hlpafwk1 cec1occuptn cec1worktype
chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype;
run;

proc export data=nhats_wave1_7 outfile = "E:\nhats\data\Projects\Caregivers\nsoc.dta" replace;
run;

proc means data=nsoc;
var ;
run;


/*Tables Cont.*/

proc import out=nhats_r1_OP
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_OP_File_old.dta";
run;

proc means data=nhats_r1_op;
var op1numhrsday;
run;
proc sort data=nhats_r1_op;
by spid opid;
run;
proc sort data=nhats_r1_op out=test nodupkey;
by spid opid;
run;
data helpers;
set nhats_r1_op;
if op1ishelper = 1;
run;
proc sql;
create table helpers0
as select a.*, b.opid, b.op1relatnshp,b.op1numhrsday,b.op1numdayswk,b.op1numdaysmn,b.op1paidhelpr, b.op1dhrsmth, b.op1ishelper
from nhats.nhats_wave1_all_obs a
left join helpers b
on a.spid = b.spid;
quit;
proc freq data=helpers;
table op1ishelper;
run;

data helpers1;
set helpers0;
if op1dhrsmth = 9999 then op1dhrsmth = .;
if op1dhrsmth < 0 then op1dhrsmth = .;
if adl_iadl_ind = 1;
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
table died;
run;
proc sort data=helpers1;
by spid opid;
run;
data helpers2;
set helpers1;
retain hours_helped count_helpers;
by spid opid;
hours_helped = sum(hours_helped, op1dhrsmth);
count_helpers = count_helpers + 1;
if first.spid then do;
hours_helped = op1dhrsmth;
if op1ishelper = . then count_helpers = 0;
if op1ishelper ~= . then count_helpers = 1;
end;
if last.spid;
log_hours_helped = log(hours_helped + 1);
num_helper_cat = .;
if count_helpers = 0 then num_helper_cat = 0;
if count_helpers >= 1 and count_helpers <=3 then num_helper_cat = 1;
if count_helpers >= 4 and count_helpers <=6 then num_helper_cat = 2;
if count_helpers >= 7 then num_helper_cat = 3;
run;
proc univariate data=helpers2;
var hours_helped log_hours_helped;
histogram;
run;
/*checking hours on those who are missing*/
data missing;
set helpers2;
if hours_helped = .;
run;
/*take the first 10 people missing hours*/
data test_missing;
set helpers1;
if spid = 10000119 or spid = 10000172 or spid = 10000204 or spid = 10000401 or spid = 10000541 or spid = 10000621 or spid = 10000856 or spid = 10000874 or spid = 10000898 or spid = 10001131;
run;
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

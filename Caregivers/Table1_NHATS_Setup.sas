libname nhats "E:\nhats\data\NHATS working data";

proc import out=nhats_rg
			datafile = "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added_old.dta"
			replace;
run;
proc freq data=nhats_rg;
table fl1noonetalk;
run;
proc freq data=nhats_rg;
where wave = 1;
table homebound_cat;
run;
data nhats_rg;
set nhats_rg;
if spid = 10009011 then homebound_cat = 3;
run;
proc freq data=nhats_rg;
where wave = 1;
table homebound_cat;
run;
proc freq data=nhats_rg;
table ha1dmealwhl;
run;


proc means data=nhats_rg;
var lives_alone;
run;
proc freq data=nhats_rg;
where wave = 1;
table livealone;
run;

data old_nhats_w1 (keep = spid female white gt_hs_edu spouse medicaid srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever
sr_phq2_depressed dem_2_cat fall_last_month sum_adl_cat reg_doc_seen reg_doc_homevisit sr_hosp_ind  age sr_numconditions1 sr_hosp_stays homebound_cat homebound_cat1 livealone meals_wheels noone_talk restrnt_takeout);
set nhats_rg;
if wave =1;
homebound_cat1 = .;
if homebound_cat = 0 | homebound_cat = 1 then homebound_cat1 = 1;
if homebound_cat = 2 then homebound_cat1 = 2;
if homebound_cat = 3 then homebound_cat1 = 3;
if homebound_cat = 4 then homebound_cat1 = 4;

gt_hs_edu = .;
if education >= 2 then gt_hs_edu = 1;
if education  = 1 then gt_hs_edu = 0;
if education = -8 | education = -7 then gt_hs_edu = .;

meals_wheels = .;
if ha1dmealwhl = 1 then meals_wheels = 1;
if ha1dmealwhl = -1 then meals_wheels = 0;

noone_talk = .;
if fl1noonetalk = 1 then noone_talk = 1;
if fl1noonetalk = -1 then noone_talk = 0;

restrnt_takeout=.;
if ha1dmealtkot = 1 then restrnt_takeout = 1;
if ha1dmealtkot = -1 then restrnt_takeout = 0;
run;
proc freq data=old_nhats_w1;
table meals_wheels;
run;

proc sql;
create table nhats_wave1_tab1
as select a.*, b.white, b.married, b.sum_adl_cat, b.community_dwelling, b.eligible, b.complete, b.w1anfinwgt0 , b.died
from old_nhats_w1 a
left join nhats.Nhats_wave1_all_obs b
on a.spid = b.spid;
quit;
/*check if weights are the same
data test (keep = spid w1anfinwgt0 w1anfinwgt0_1);
set nhats_wave1_tab1;
run;
*/
proc freq data=nhats_wave1_tab1;
where community_dwelling = 1;
table died;
run;
proc freq data=nhats_wave1_tab1;
where community_dwelling = 1;
 table female*died white*died gt_hs_edu*died married*died medicaid*died srh_fp*died sr_ami_ever*died sr_heart_dis_ever*died sr_ra_ever*died
sr_diabetes_ever*died sr_lung_dis_ever*died sr_stroke_ever*died sr_cancer_ever*died sr_phq2_depressed*died dem_2_cat*died fall_last_month*died sum_adl_cat*died
reg_doc_seen*died reg_doc_homevisit*died sr_hosp_ind*died / chisq;
weight w1anfinwgt0;
run;


data nhats.nhats_wave1_trunc;
set nhats_wave1_tab1;
run;


proc export data=nhats_wave1_tab1 outfile = "E:\nhats\data\NHATS working data\NHATS_Table1_Caregiver_Project.dta" dbms = dta replace;
run;

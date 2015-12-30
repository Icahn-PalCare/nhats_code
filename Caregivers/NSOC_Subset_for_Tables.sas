data nsoc_ko;
set nsoc1 (keep = spid opid w1cgfinwgt0 died died_24 ADL_IADL_ind total_hours cg_medicare cg_spouse cg_living_children lives_in_hh cg_age_cat cg_relationship_cat cg_relationship_cat1 cg_gt_hs cg_female cg_Marital_status cg_educ 
ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di 
ever_pain ever_breath_prob ever_low_enrgy trb_back_sleep lost_10_lbs_yr pain_lim_act_di breath_lim_act_di enrgy_lim_act_di felt_depressed_di felt_nervous_di felt_lit_interest_di felt_worry_di
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help
gain_more_conf_di gain_deal_better_di gain_closer2SP_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di 
diff_financial diff_emotional diff_physical diff_financial_lv_di diff_emotional_lv_di diff_physical_lv_di c1relatnshp cdc1hlphrsdy op1age w1cgfinwgt0 work_4_pay self_health_di ever_high_bp ever_osteoperosis ever_diff_seeing ever_diff_hearing 
cg_phq2_depressed cg_gad2_anxiety paid_hours_cat paid_last_week lives_in_hh cg_age_cat flag_no_help_mth informal_nsoc_comp informal_nsoc_elig all_helper_tot months_to_death total_hours_month
helper_num_yrs solo_cg  all_helper_family_tot  solo_cg_fam);
/*for creating primary caregiver*/
relationship_sort = 0;
if cg_relationship_cat = 2 then relationship_sort = 1;
if cg_relationship_cat = 1 then relationship_sort = 2;
/*Pain/Breathing/Energy: Follow-up question. If the person has no problems breathing it shouldn't limit his activities*/
if ever_breath_prob = 0 then breath_lim_act_di = 0;
if ever_low_enrgy = 0 then enrgy_lim_act_di = 0;
if ever_pain = 0 then pain_lim_act_di = 0;
/*NLTCS Criteria*/
*if ADL_IADL_ind = 1;
/*if flag_no_help_mth = 1 then delete;*/

run;
proc freq data=nsoc_ko;
where died = 1;
table solo_cg_fam;
run;
proc sort data=nsoc_ko out=test nodupkey;
by spid;
run;
proc freq data=test;
table months_to_death;
run;

/*
proc freq data=nsoc_ko;
table died cg_relationship_cat relationship_sort;
run;*/
proc sort data=nsoc_ko;
by spid descending total_hours cg_relationship_cat;
run;


proc sort data=nsoc_ko out=nsoc_ko1a nodupkey;
by spid;
run;

/*putting primary caregiver into the main database*/
data nsoc_ko1a;
set nsoc_ko1a;
prim_caregiver = 1;
run;
proc sql;
create table nsoc_ko2
as select a.*, b.prim_caregiver
from nsoc_ko a
left join nsoc_ko1a b
on a.spid = b.spid
and a.opid = b.opid;
quit;
proc freq data=nsoc_ko1a;
table prim_caregiver;
run;
proc freq data=nsoc_ko2;
table prim_caregiver;
run;
data nsoc_ko2;
set nsoc_ko2;
if prim_caregiver = . then prim_caregiver = 0;
run;

/*
proc sql;
create table test
as select a.spid, a.opid, b.opid as opid1
from nsoc_ko1 a
left join nsoc_ko1a b
on a.spid = b.spid;
quit;
data test1;
set test;
opid_1 = opid + 0;
opid1_1 = opid1 + 0;
diff = opid_1 - opid1_1;
run;
proc freq data=test1;
table diff;
run;
*/
/*

data test_ko;
set nsoc_ko (keep = spid opid total_hours cg_spouse c1relatnshp cdc1hlphrsdy);
run;
data test_ko1;
set nsoc_ko1 (keep = spid opid total_hours cg_spouse c1relatnshp cdc1hlphrsdy);
run;

proc freq data=nsoc_ko1;
table died*cg_female /  missing;
weight w1cgfinwgt0;
run;

ods html close;
ods html;
%let varlist = cg_female cg_relationship_cat cg_lives_with_SP cg_living_children cg_medicare  cg_gt_hs ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection
gain_more_conf_di gain_deal_better_di gain_closer2SP_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di 
diff_finanicial diff_emotional diff_physical ;
%macro freq();
%let i = 1;
%let var = %scan(&varlist,&i);
%do %while(&var ne );
proc freq data=nsoc_ko1;
table died*&var/missing;
weight w1cgfinwgt0;
run;
proc freq data=nsoc_ko1;
table died*&var/missing;
run;
%let i = %eval(&i + 1);
%let var = %scan(&varlist,&i);
%end;
%mend;
%freq();
*/
proc export data=nsoc_ko1a outfile = "E:\nhats\data\Projects\Caregivers\nsoc_121615_noNLTCS.dta" replace dbms = dta;
run;
proc export data=nsoc_ko2 outfile = "E:\nhats\data\Projects\Caregivers\nsoc_121615_all_noNLTCS.dta" replace dbms = dta;
run;
proc freq data=nsoc_ko2;
where died = 1;
table solo_cg_fam;
run;

/********************** Katherine Additions *******************************/

/*obtaining number of caregiver numbers */
proc sort data=nsoc1 ;
by spid;
run;
data nsoc1a;
set nsoc1;
by spid;
if ADL_IADL_ind = 1;
retain n_caregivers;
n_caregivers = n_caregivers + 1;
if first.spid then n_caregivers = 1;
run;
data nsoc1b;
set nsoc1a;
by spid;
if last.spid;
run;
proc freq data=nsoc1b;
table n_caregivers;
run;

/*obtaining all information from SP from NHATS Wave 1 data*/
proc freq data=nsoc1;
table diff_emotional_lv_di ;
run;
data nsoc_ko;
set nsoc1 (keep = spid opid w1cgfinwgt0 died died_24 ADL_IADL_ind total_hours cg_medicare cg_spouse cg_living_children lives_in_hh cg_age_cat cg_relationship_cat cg_relationship_cat1 cg_gt_hs cg_female cg_Marital_status cg_educ 
ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di 
ever_pain ever_breath_prob ever_low_enrgy trb_back_sleep lost_10_lbs_yr pain_lim_act_di breath_lim_act_di enrgy_lim_act_di felt_depressed_di felt_nervous_di felt_lit_interest_di felt_worry_di
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help
gain_more_conf_di gain_deal_better_di gain_closer2SP_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di 
diff_financial diff_emotional diff_physical diff_financial_lv_di diff_emotional_lv_di diff_physical_lv_di c1relatnshp cdc1hlphrsdy op1age w1cgfinwgt0 work_4_pay self_health_di ever_high_bp ever_osteoperosis ever_diff_seeing ever_diff_hearing 
cg_phq2_depressed cg_gad2_anxiety paid_hours_cat paid_last_week lives_in_hh cg_age_cat flag_no_help_mth informal_nsoc_comp informal_nsoc_elig all_helper_tot months_to_death total_hours_month
helper_num_yrs solo_cg is_family all_helper_family_tot is_imm_family all_helper_imm_family_tot solo_cg_fam solo_cg_imm_fam
);
/*for creating primary caregiver*/
relationship_sort = 0;
if cg_relationship_cat = 2 then relationship_sort = 1;
if cg_relationship_cat = 1 then relationship_sort = 2;
cg_age = op1age;
if cg_age < 0 then cg_age = .;
/*Pain/Breathing/Energy: Follow-up question. If the person has no problems breathing it shouldn't limit his activities*/
if ever_breath_prob = 0 then breath_lim_act_di = 0;
if ever_low_enrgy = 0 then enrgy_lim_act_di = 0;
if ever_pain = 0 then pain_lim_act_di = 0;
/*NLTCS Criteria*/
*if ADL_IADL_ind = 1;
/*if flag_no_help_mth = 1 then delete;*/

run;
proc freq data=nsoc_ko;
table months_to_death;
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
proc export data=nsoc_ko1a outfile = "E:\nhats\data\Projects\Caregivers\nsoc_120815_noNLTCS.dta" replace dbms = dta;
run;
proc export data=nsoc_ko2 outfile = "E:\nhats\data\Projects\Caregivers\nsoc_120815_all_noNLTCS.dta" replace dbms = dta;
run;

/**** Arranging Spousal information and Number of hours worked ****/
/* First creating a spouse variable based on the relationship variable */
/* Calculation of the hours: Methods in Project Notes */
proc freq data=nhats_nsoc;
table c1relatnshp;
run;
/*Primary Caregiver: by total hours a person spends then whether not the person is the spouse*/
proc sort data=nhats_nsoc;
by spid descending total_hours cg_spouse;
run;
proc sort data=nhats_nsoc out=nhats_nsoc1 nodupkey;
by spid;
run;


/************************* BREAK OFF FOR CHECKS HERE. CAN SKIP BECAUSE PROBLEM RESOLVED *************/
/******* CHECKED: Those who did not fit the Criteria for Hours/Spouse are other SOLE 
Caregiver that Answered the questions.
/*those who didn't fit either criteria. Those with missing hours and no spouse.  */
data missing_spouse_hr_info;
set nhats_nsoc1;
if total_hours = . and cg_spouse = 0;
run;
proc sql;
create table missing_spouse_hr_info1
as select a.*
from nhats_nsoc a
inner join missing_spouse_hr_info b
on a.spid = b.spid;
quit;
proc sort data=missing_spouse_hr_info1;
by spid descending total_hours cg_spouse;
run;
data missing_spouse_hr_info2;
set missing_spouse_hr_info1 (keep = spid opid c1dgender c1relatnshp cg_spouse total_hours total_hours_day total_hours_week total_hours_month total_hours_other);
run;
proc sort data=missing_spouse_hr_info2 out=missing_spouse_hr_info3 nodupkey;
by spid;
run;

/********************************* CONTINUE FROM HERE ***********************************/

/*Checking number of people who died on second wave*/
proc freq data=nhats_nsoc1;
table died;
run;

/*Table 1: Demographic Information*/

proc freq data=nhats_nsoc;
table c1dgender c1relatnshp op1prsninhh op1martlstat;
run;

proc freq data=nhats_nsoc1;
table c1dgender c1relatnshp op1prsninhh chd1martstat op1martlstat chd1chldlvng chd1numchild op1ishelper op1sppayshlp op1prsninhh chd1numinhh op1leveledu;
run;

/************ EDUCATION, MARRIED, NUM LIVING IN HH and NUMBER OF CHILDREN Missing Problem *********************/

/* FROM NSOC Survey
"If preloaded CG Relationship to SP = 2, go to section EC Employment and Caregiving otherwise go to [Demographic Information]"
This means that they skip over demographic questions if you are married.
I will take the SP's (NHATS) number of children variable and impute it into the number of children for NSOC*/

/*FROM the Raw NHATS Wave 1 data*/
/*taking Num children, marital status, living children, total number in household*/ 
/*Can be manipulated to add others from the raw database*/
data SP_Demographics_Impute;
set raw_nhats_r1 (keep = spid cs1dnumchild hh1martlstat cs1dreconcil hh1dhshldnum);
run;
/*merge with the nhats/nsoc dataset*/
proc sql;
create table nhats_nsoc3
as select a.*, b.cs1dnumchild, b.hh1martlstat, b.cs1dreconcil, b.hh1dhshldnum
from nhats_nsoc1 a
left join SP_Demographics_Impute b
on a.spid = b.spid;
quit;

/*Formats for tables in the future*/
proc format;
	value mar_ 1 = "Married"
			2 = "Living with Partner"
			3 = "Separated"
			4 = "Divorced"
			5 = "Widowed"
			6 = "Never Married";
	value educ_ 1 = "No Schooling Completed"
				2 = "1-8th Grade Comp."
				3 = "9-12th Grade Comp."
				4 = "High School Graduate"
				5 = "Vocational/Technical Certificate"
				6 = "Some College"
				7 = "Associate's Degree"
				8 = "Bachelor's Degree"
				9 = "Master's/Doctoral Degree"; 
run;

/*Manipulating missing data.*/
/*Details in the Project Notes*/
data nhats_nsoc4;
set nhats_nsoc3;

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

/*NUMBER IN HOUSEHOLD */
if cg_spouse = 1 then cg_total_in_hh = hh1dhshldnum;
if cg_spouse = 0 then cg_total_in_hh = chd1numinhh;
if cg_total_in_hh < 0 then cg_total_in_hh = .;

/*EDUCATION OF CAREGIVER */
if cg_spouse = 1 then cg_educ = op1leveledu;
if cg_spouse = 0 then cg_educ = chd1educ;

run;

/*Checking for correct merge. Everything checks out*/
proc freq data=nhats_nsoc4;
table cg_spouse cs1dreconcil chd1chldlvng cg_living_children;
run;
proc freq data=nhats_nsoc4;
format cg_Marital_status mar_.;
table cg_Marital_status;
run;
proc freq data=nhats_nsoc4;
table cg_total_in_hh;
run;
proc freq data=nhats_nsoc4;
format cg_educ educ_.;
table op1leveledu chd1educ cg_educ;
run;

/******** variables in the database *********/

/*All variables*/

proc freq data=nsoc_ko;
table cdc1hlphrmvf cdc1hlpsched c1dgender c1relatnshp c1intmonth c1dintdays cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom 
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin 
cdc1hlpdyswk cdc1hlphrlmt cdc1hlpyrpls cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst cdc1hlpdysmt cdc1hlphrsdy cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv 
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd cac1toomuch cac1notime cac1uroutchg 
cse1frfamact cpp1wrk4pay cpp1hlpkptwk cpp1careothr che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing 
che1hearing che1fltdown che1fltnervs che1fltworry chd1martstat chd1chldlvng chd1numchild chd1numchu18 chd1educ chd1cgbrthmt chd1cgbrthyr cec1wrk4pay cec1hlpafwk1 cec1occuptn cec1worktype 
chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype op1prsninhh op1martlstat op1numchldrn op1ishelper op1sppayshlp op1age op1catgryage chd1numinhh op1leveledu / missing;
run;

ods rtf body = "E:\nhats\projects\Caregivers_KO\10122015\demographics_nsoc_raw.rtf";
proc freq data=nhats_nsoc2;
table c1dgender c1relatnshp cse1frfamact cpp1wrk4pay cpp1hlpkptwk cpp1careothr che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing 
che1hearing che1fltdown che1fltnervs che1fltworry chd1martstat chd1chldlvng chd1numchild chd1numchu18 chd1educ cec1wrk4pay cec1hlpafwk1 chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype /missing;
run;
ods rtf close;
ods rtf body = "E:\nhats\projects\Caregivers_KO\10122015\help_information_raw.rtf";
proc freq data= nhats_nsoc2;
table cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom 
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin /missing;
run;
ods rtf close;
ods rtf body = "E:\nhats\projects\Caregivers_KO\10122015\Gains_Neg_info_raw.rtf";
proc freq data= nhats_nsoc2;
table cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv 
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd 
cac1toomuch cac1notime cac1uroutchg/missing;
run;
ods rtf close;

ods rtf body = "E:\nhats\projects\Caregivers_KO\10122015\demographics_nsoc_raw_by_died.rtf";
proc freq data=nhats_nsoc2;
table c1dgender*died c1relatnshp*died cse1frfamact*died cpp1wrk4pay*died cpp1hlpkptwk*died cpp1careothr*died che1health*died che1hrtattck*died che1othheart*died che1highbld*died che1arthrits*died che1osteoprs*died che1diabetes*died che1lungdis*died che1cancer*died che1seeing*died 
che1hearing*died che1fltdown*died che1fltnervs*died che1fltworry*died chd1martstat*died chd1chldlvng*died chd1numchild*died chd1numchu18*died chd1educ*died cec1wrk4pay*died cec1hlpafwk1*died chi1medicare*died chi1medigap*died chi1medicaid*died chi1privinsr*died chi1tricare*died chi1uninsurd*died chi1insrtype*died /missing;
run;
ods rtf close;

ods rtf body = "E:\nhats\projects\Caregivers_KO\10122015\created_variables.rtf";
proc freq data=nhats_nsoc4;
format cg_Marital_status mar_. cg_educ educ_.;
table cg_living_children cg_spouse cg_educ cg_total_in_hh;
run;
ods rtf close;

use "E:\nhats\data\Projects\Caregivers\nsoc_110615.dta", clear

log using "E:\nhats\projects\Caregivers_KO\10302015\Tables.txt", text replace

tab cg_relationship_cat1, gen(cg_rel_cat)
tab dem_3_cat, gen(dem_cat)

local ivars cg_female cg_spouse cg_rel_cat1 cg_rel_cat2 cg_rel_cat3 cg_rel_cat4 cg_rel_cat5 cg_lives_with_SP cg_gt_hs cg_living_children cg_medicare ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer ///
ever_pain pain_lim_act ever_breath_prob breath_lim_act ever_low_enrgy enrgy_lim_act trb_back_sleep lost_10_lbs_yr dem_3_cat sr_gad2_anxiety sr_phq2_depressed dem_cat1 dem_cat2 dem_cat3 ///
help_personal_care_di help_get_around_di help_shopping_di help_chores_di help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_finanicial diff_emotional diff_physical

label var cg_rel_cat1 "Caregiver Rel: Spouse";
label var cg_rel_cat2 "Caregiver Rel: Daughter";
label var cg_rel_cat3 "Caregiver Rel: Son";
label var cg_rel_cat4 "Caregiver Rel: Other Relatives";
label var cg_rel_cat5 "Caregiver Rel: Other non-Relatives";
label var cg_female "Female Yes/No"
label var cg_spouse "Caregiver is Spouse/Adult"
label var cg_lives_with_sp "Caregiver Lives with SP"
label var cg_gt_hs "Caregiver Education"
label var cg_living_children "Any Children Missing Yes/No"
label var cg_medicare "Medicare Yes/No"
label var ever_heart_attack "Ever Heart Attack"
label var ever_heart_disease "Ever Heart Disease"
label var ever_arthritis "Ever Arthritis"
label var ever_diabetes "Ever Diabetes"
label var ever_lung_dis "Ever Lung Disease"
label var ever_cancer "Ever Cancer"
label var ever_pain "Ever Pain Last Month"
label var pain_lim_act "Pain Limit Activities?"
label var ever_breath_prob "Ever Breathing Problems"
label var breath_lim_act "Breathing Limit Activities"
label var ever_low_enrgy "Ever Low Energy"
label var enrgy_lim_act "Low Energy Limit Activities"
label var trb_back_sleep "Trouble Going back to Sleep"
label var lost_10_lbs_yr "Lost 10 pounds over year"
label var dem_cat1 "Dementia: Probable"
label var dem_cat2 "Dementia: Possible"
label var dem_cat3 "Dementia: No Dementia"
label var sr_gad2_anxiety "Anxiety (GAD 2+)"
label var sr_phq2_depressed "Depression (PHQ 2+)"
label var diff_finanicial "Financially Difficult (Yes/No)"
label var diff_emotional "Emotionally Difficult (Yes/No)"
label var diff_physical "Physically Difficult (Yes/No)"
label var help_make_appts "Help Make Appointments (Yes/No)"
label var help_speak_doc "Help Speak to Doctors (Yes/No)"
label var help_order_med "Help Order Medicine (Yes/No)"
label var help_insurance "Help Add/Change Insurance (Yes/No)"
label var help_insurance_oth "Help Other Insurance Issues (Yes/No)"
label var help_diet "Help Diet"
label var help_foot "Help Foot Care"
label var help_skin "Help Skin Care"
label var help_exercise "Help Exercises"
label var help_teeth "Help Dental Care"
label var help_medical_task "Help Manage Medical Tasks"
label var help_shots_injection "Help with Shots/Injections"
label var help_bills "Help with Bills/Manage $"
label var help_track_meds "Help Keep Track of Meds"
label var help_personal_care_di "Help with Personal Care (Every/Most/Some)"
label var help_get_around_di "Help Getting Around (Every/Most/Some)"
label var help_chores_di "Help with Housework Chores (Every/Most/Some)"
label var help_shopping_di "Help with Shopping (Every/Most/Some)"
label var friend_help "Friends of Family help?"
label var gain_more_conf_di "More Confident in Abilities (Very/Somewhat)"
label var gain_deal_better_di "Deal with Diff Situations (Very/Somewhat)"
label var gain_closer2sp_di "Closer to SP (Very/Somewhat)"
label var gain_more_satisfied_di "Satisfaction Recipient is Cared for (Very/Somewhat)"
label var neg_exhausted_di "Exhausted when you go to bed (Very/Somewhat)"
label var neg_too_much_di "More than you can handle (Very/Somewhat)"
label var neg_no_time_di "No Time for yourself (Very/Somewhat)"
label var neg_no_routine_di "No Routine (Very/Somewhat)"

local ivars cg_female cg_spouse cg_rel_cat1 cg_rel_cat2 cg_rel_cat3 cg_rel_cat4 cg_rel_cat5 cg_lives_with_SP cg_gt_hs cg_living_children cg_medicare ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer ///
ever_pain pain_lim_act ever_breath_prob breath_lim_act ever_low_enrgy enrgy_lim_act trb_back_sleep lost_10_lbs_yr dem_3_cat sr_gad2_anxiety sr_phq2_depressed dem_cat1 dem_cat2 dem_cat3 ///
help_personal_care_di help_get_around_di help_shopping_di help_chores_di help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_finanicial diff_emotional diff_physical
local cvars age1

mat test1=J(62,12,.)
local r=1
svyset [pw=w1cgfinwgt0]
tab died

foreach w in `ivars'{
sum `w'
mat test1[`r',1]= round(r(sum),0)
sum `w' [aw=w1cgfinwgt0]
mat test1[`r',2]= round(r(sum),0)
tab `w' [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',3]=row1[2,1]/r(N)*100
sum `w' if died == 0
mat test1[`r',5]= round(r(sum),0)
sum `w' if died == 0 [aw=w1cgfinwgt0]
mat test1[`r',6]= round(r(sum),0)
tab `w' if died == 0 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',7]=row1[2,1]/r(N)*100
mat test1[`r',8]= 1751 - r(N)
sum `w' if died == 1
mat test1[`r',9]= round(r(sum),0)
sum `w' if died == 1 [aw=w1cgfinwgt0]
mat test1[`r',10]=round(r(sum),0)
tab `w' if died == 1 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',11]=row1[2,1]/r(N)*100
mat test1[`r',12]=229 - r(N)
local r = `r'+1
}

local r = 41

sum cg_age [aw=w1cgfinwgt0]
mat test1[`r',1] = r(N)
mat test1[`r',2] = r(mean)
mat test1[`r',3] = r(sd)
sum cg_age if died == 0 [aw=w1cgfinwgt0]
mat test1[`r',5] = r(N)
mat test1[`r',6]=r(mean)
mat test1[`r',7]=r(sd)
sum cg_age if died == 1 [aw=w1cgfinwgt0]
mat test1[`r',9] = r(N)
mat test1[`r',10]=r(mean)
mat test1[`r',11]=r(sd)

mat rownames test1= `ivars' `cvars' 
 matlist test1
frmttable using "E:\nhats\projects\Caregivers_KO\10302015\Cargiver_Surveys3_all.rtf", statmat(test1) varlabels title("Demo") ///
ctitles ("" "ALL Sample N" "ALL Weighted N/MEAN(age)" "ALL %/SD" "N Missing" "Survivor Sample N" "Survivor Weighted N/MEAN(age)" "Survivor %/SD" "N Missing" "EOL Sample N" "EOL Weighted N/MEAN(age)" "EOL %/SD" "N Missing") ///
 store(test1)
 matlist test1
 
sum cg_relationship_cat if cg_relationship_cat == 1
sum cg_relationship_cat [aw=w1cgfinwgt0] if cg_relationship_cat == 1
tab cg_relationship_cat [aw=w1cgfinwgt0]  if cg_relationship_cat == 1, matcell(row1)
mat test1[`r',3]=row1[2,1]/r(N)*100
mat test1[`r',4]=1018 - r(N)
sum cg_relationship_cat if died == 0
mat test1[`r',5]= round(r(sum),0)
sum `w' if died == 0 [aw=w1cgfinwgt0]
mat test1[`r',6]= round(r(sum),0)
tab `w' if died == 0 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',7]=row1[2,1]/r(N)*100
mat test1[`r',8]= 867 - r(N)
sum `w' if died == 1
mat test1[`r',9]= round(r(sum),0)
sum `w' if died == 1 [aw=w1cgfinwgt0]
mat test1[`r',10]=round(r(sum),0)
tab `w' if died == 1 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',11]=row1[2,1]/r(N)*100
mat test1[`r',12]=135 - r(N)
local r = `r'+1

 svyset [pw=w1cgfinwgt0]
 local ivars cg_female cg_spouse cg_lives_with_sp cg_gt_hs cg_living_children cg_medicare ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di ///
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_finanicial diff_emotional diff_physical
 foreach w in `ivars'{
 svy: tab `w' died 
 }
svy: tab cg_relationship_cat died
 
 tab died cg_female, row

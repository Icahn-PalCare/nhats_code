use "E:\nhats\data\Projects\Caregivers\nsoc_103015.dta", clear

log using "E:\nhats\projects\Caregivers_KO\10302015\Tables.txt", text replace

local ivars cg_female cg_spouse cg_lives_with_SP cg_gt_hs cg_living_children cg_medicare ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di ///
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_finanicial diff_emotional diff_physical

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
label var gain_more_conf_di "More Confident in Abilities (Very/Somewhat)"
label var gain_deal_better_di "Deal with Diff Situations (Very/Somewhat)"
label var gain_closer2sp_di "Closer to SP (Very/Somewhat)"
label var gain_more_satisfied_di "Satisfaction Recipient is Cared for (Very/Somewhat)"
label var neg_exhausted_di "Exhausted when you go to bed (Very/Somewhat)"
label var neg_too_much_di "More than you can handle (Very/Somewhat)"
label var neg_no_time_di "No Time for yourself (Very/Somewhat)"
label var neg_no_routine_di "No Routine (Very/Somewhat)"

local ivars cg_female cg_spouse cg_lives_with_sp cg_gt_hs cg_living_children cg_medicare ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer help_personal_care_di help_get_around_di help_shopping_di help_chores_di ///
help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_insurance help_insurance_oth help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_finanicial diff_emotional diff_physical

local cvars cg_age

tab cg_female [aw=w1cgfinwgt0], matcell(row1)

mat test1=J(44,12,.)
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

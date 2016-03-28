use "E:\nhats\data\Projects\Homebound\nsoc_121615_all_noNLTCS.dta", clear

replace homebound_cat1= 3 if  spid == 10009011
by spid, sort: gen unique=_n==1
//log using "E:\nhats\data\Projects\Caregivers\logs\Tables1.txt", text replace

tab cg_relationship_cat1, gen(cg_rel_cat)
gen cg_age_cat_di = .
replace cg_age_cat_di = 1 if cg_age_cat >= 11
replace cg_age_cat_di = 0 if cg_age_cat < 11 & cg_age_cat != .
replace cg_age_cat_di = . if cg_age_cat == .
tab cg_age_cat_di
tab paid_hours_cat, gen(paid_hours_cat)

replace flag_no_help_mth = 0 if flag_no_help_mth == .
replace months_to_death = 0 if died == 0 & months_to_death == .

gen total_hours_week = total_hours_month / ((52/12))
gen trb_back_sleep_di = .
replace trb_back_sleep_di = 1 if trb_back_sleep == 1 | trb_back_sleep == 2 | trb_back_sleep == 3
replace trb_back_sleep_di = 0 if trb_back_sleep == 4 | trb_back_sleep == 5

//drop if prim_caregiver == 0

local ivars cg_female cg_age_cat_di cg_spouse cg_rel_cat1 cg_rel_cat2 cg_rel_cat3 cg_rel_cat4 cg_rel_cat5 /*cg_lives_with_sp*/ cg_gt_hs cg_living_children cg_medicare cg_medicaid work_4_pay died self_health_di ever_high_bp ever_osteoperosis ever_diff_seeing ever_diff_hearing ever_heart_attack ever_heart_disease ever_arthritis ever_diabetes ever_lung_dis ever_cancer ///
ever_pain pain_lim_act_di ever_breath_prob breath_lim_act_di ever_low_enrgy enrgy_lim_act_di trb_back_sleep_di lost_10_lbs_yr felt_depressed_di felt_nervous_di felt_lit_interest_di felt_worry_di ///
help_personal_care_di help_get_around_di help_shopping_di help_chores_di help_bills help_track_meds help_make_appts help_speak_doc help_order_med help_mob_dev help_home_safe help_paid_helpr help_insurance help_insurance_oth help_insurance_any help_diet help_foot help_skin help_exercise help_teeth help_medical_task help_shots_injection friend_help op1dochlp ///
gain_more_conf_di gain_deal_better_di gain_closer2sp_di gain_more_satisfied_di neg_exhausted_di neg_too_much_di neg_no_time_di neg_no_routine_di ///
diff_financial diff_emotional diff_physical diff_financial_lv_di diff_emotional_lv_di diff_physical_lv_di cg_phq2_depressed cg_gad2_anxiety paid_last_week paid_hours_cat1 paid_hours_cat2 paid_hours_cat3 paid_last_week lives_in_hh flag_no_help_mth    
   
local cvars cg_age helper_num_yrs total_hours_month total_hours_week all_helper_tot all_helper_family_tot months_to_death

foreach x in `ivars'{
replace `x' = . if `x' < 0
}
label define homebound_cat1 1 "Homebound" 2 "Semi (Never by Self)" 3 "Semi: Needs Help/Diff" 4 "Not Homebound"
label values homebound_cat1 homebound_cat1
gen hb_nr=homebound_cat1==1
gen hb_nbs=homebound_cat1==2
gen hb_nhhd=homebound_cat1==3
gen hb_indep=homebound_cat1==4
label var hb_nr "Never/Rarely leaves home"
label var hb_nbs "Never leaves home by self"
label var hb_nhhd "Needs  help/has diff. leaving home"
label var hb_indep "Independent, not homebound"
label var diff_financial_lv_di "Financially Difficult Level (3-5) on 1-5 scale (5=Very Difficult)"
label var diff_emotional_lv_di "Emotionally Difficult Level (3-5) on 1-5 scale (5=Very Difficult)"
label var diff_physical_lv_di "Physically Difficult Level (3-5) on 1-5 scale (5=Very Difficult))"
label var cg_age_cat_di "Caregiver Age >=65"
label var cg_rel_cat1 "Caregiver Rel: Spouse"
label var cg_rel_cat2 "Caregiver Rel: Daughter"
label var cg_rel_cat3 "Caregiver Rel: Son"
label var cg_rel_cat4 "Caregiver Rel: Other Relatives"
label var cg_rel_cat5 "Caregiver Rel: Other non-Relatives"
label var cg_female "Female Yes/No"
label var cg_spouse "Caregiver is Spouse/Adult"
label var cg_gt_hs "Caregiver Education"
label var cg_living_children "Any Children Missing Yes/No"
label var cg_medicare "Medicare Yes/No"
label var cg_medicaid "Medicaid Yes/No"
label var work_4_pay "Work for Pay?"
label var self_health_di "Self-Reported Health (Good/V.Good/Excellent)"
label var ever_high_bp "Ever High Blood Pressure"
label var ever_osteoperosis "Ever Osteoperosis"
label var ever_diff_seeing "Ever Difficult Seeing"
label var ever_diff_hearing "Ever Difficult Hearing"
label var ever_heart_attack "Ever Heart Attack"
label var ever_heart_disease "Ever Heart Disease"
label var ever_arthritis "Ever Arthritis"
label var ever_diabetes "Ever Diabetes"
label var ever_lung_dis "Ever Lung Disease"
label var ever_cancer "Ever Cancer"
label var ever_pain "Ever Pain Last Month?"
label var pain_lim_act_di "Pain Limit Activities (Yes/No)?"
label var ever_breath_prob "Ever Breathing Problem?"
label var breath_lim_act_di "Breathing Limit Activities (Yes/No)?"
label var ever_low_enrgy "Ever Low Evergy?"
label var enrgy_lim_act_di "Low Energy Limit Activities (Yes/No)?"
label var trb_back_sleep_di "Trouble Going back to Sleep"
label var lost_10_lbs_yr "Lost 10 pounds over year"
label var felt_lit_interest_di "Felt Little Interest (Yes/No)?"
label var felt_nervous_di "Felt Nervous/Anxious (Yes/No)?"
label var felt_depressed_di "Felt Depressed (Yes/No)?"
label var felt_worry_di "Felt Worried (Yes/No)?"
label var diff_financial "Financially Difficult (Yes/No)"
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
label var all_helper_tot "Total Helpers for SP"
label var lives_in_hh "CG Lives in HH"
label var paid_last_week "CG Got Paid Last Week (Yes/No)"
label var paid_hours_cat "CG Number of Hours Worked for Pay Last Week"
label var cg_phq2_depressed "CG PHQ-2 Depressed (Yes/No)"
label var cg_gad2_anxiety "CG GAD-2 Anxiety (Yes/No)"
label var flag_no_help_mth "Flag: No Help last Month, but in the last Year"
label var informal_nsoc_comp "Number of Informal Caregivers Completed"
label var informal_nsoc_elig "Number of NSOC Eligible"
label var all_helper_tot "Total Number of Helpers"
label var all_helper_family_tot "Total Number of Family  Helpers"
label var solo_cg "Only Caregiver for SP"
label var solo_cg_fam "CG has no other Family helper"
label var months_to_death "Number of Months to Death"
label var total_hours_month "Total Number of Hours worked in Month"
label var total_hours_week "Total Number of Hours worked in Week"
label var helper_num_yrs "Number of years helped"
label var prim_caregiver "Primary Caregiver Status"
label var paid_hours_cat1 "Paid Hours: <= 20"
label var paid_hours_cat2 "Paid Hours: 21 - 39"
label var paid_hours_cat3 "Paid Hours: >= 40"
label var cg_age "Average Age of Caregivers (Continuous)"
label var died "Died within 12 months"
label var help_mob_dev "Help with Mobility Devices"
label var help_home_safe "Help made SP Home safe"
label var help_paid_helpr "Help find a Paid Helper"
label var help_insurance_any "Help with any Insurance issues/adjustments"
label var op1dochlp "Sits with SP at Doctor's appt"

 svyset [pw=w1cgfinwgt0]
 svy: regress cg_age i.homebound_cat1
 svy: tab cg_spouse homebound_cat1 

local rn : word count `cvars' `ivars' one two three four


local r=1
local c=1
tab died

//Evan: if you end up looking at this. I added some (working!) inefficient code for p-values.
//Getting p-values differed based on whether or not there was weight or non-weight. I wasn't
//sure how to account for that. So I had it so I changed the code around (like I normally
//would have done anyway). If you know of something better let me know!

foreach weight in  "[aw=w1cgfinwgt0]" {
	forvalues i=1/4 {
		mat test`i'=J(`rn',3,.)	
		foreach x in `cvars' {
			sum `x'`weight' if homebound_cat1 ==`i'
			mat test`i'[`r',`c']=r(mean)
			mat test`i'[`r',`c'+1]=r(sd)
			svy: regress `x' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
			mat test`i'[`r',`c'+2]=e(p) 
			local r=`r'+1
}
		foreach x in `ivars' {
			sum `x'`weight' if homebound_cat1 ==`i'
			mat test`i'[`r',`c']=r(sum)
			mat test`i'[`r',`c'+1]=r(mean)*100
			svy: tab `x' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
			mat test`i'[`r',`c'+2]=e(p_Pear)
			local r=`r'+1	
}
	 	sum c1relatnshp`weight' if homebound_cat1==`i'
		mat test`i'[`r',`c']=r(N)
		mat test`i'[`r'+1,`c']=r(sum_w)
		preserve 
		keep if unique==1
		sum c1relatnshp`weight' if homebound_cat1==`i'
		mat test`i'[`r'+2,`c']=r(N)
		mat test`i'[`r'+3,`c']=r(sum_w)
		restore
		mat rownames test`i'=`cvars' `ivars' "Sample N" "Sample N Weighted" "Sample Unique SP" "Sample Unique SP Weighted"
		mat colnames test`i'="Mean/N `:label homebound_cat1 `i''" "SD/%" "P"
		local r=1
		frmttable, statmat(test`i') title("Sample Characteristics by 1 year Death Weighted (Full NSOC Sample)") varlabels store(tab`i') ///
		note("all p values diff btwn Never/Rarely and other Category")
}
}

frmttable using "E:\nhats\data\Projects\Homebound\logs\CG_Homebound_Table_NSOC_2_26", replay(tab1) merge(tab2) replace
frmttable using "E:\nhats\data\Projects\Homebound\logs\CG_Homebound_Table_NSOC_2_26", replay(tab3) merge(tab4) addtable

/*
frmttable using "E:\nhats\data\Projects\Homebound\logs\CG_Homebound_Table_NSOC_2_11", statmat(test`i') ctitles("" "Mean/N Homebound" "SD/%" "" "Mean/N Semi (Never by Self)" "SD/%" "P-value" "Mean/N Semi: Needs Help/Diffculty" "SD/%" "P-Value" "Mean/N Not Homebound" "SD/%" "P-value") ///
store(tab`i') sdec(2) replace varlabels  title("Sample Characteristics by 1 year Death Weighted (Full NSOC Sample)")


// if you do weights. Change the test type in the loop, change "replace" to "addtable", change the title from Unweighted to Weighted, change the loop to put in [aw=w1cgfinwgt0] in the quotes.


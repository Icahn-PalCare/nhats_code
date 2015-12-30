use "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old_trunc_lab1.dta" ,clear

gen n=1
local democvars age sr_gad2_score sr_phq2_score sr_hosp_stays  n_helpers
local demoivars female community_dwelling race_cat1 race_cat2 race_cat3 race_cat4 proxy_ivw spouse education_cat1 education_cat2 education_cat3 education_cat4 ///
income_cat1 income_cat2 income_cat3 income_cat4 medicaid medigap mc_partd tricare private_ltc otherlang ///
srh_cat1 srh_cat2 srh_cat3 srh_cat4 sr_ami_ever sr_stroke_ever sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever ///
sr_diabetes_ever sr_lung_dis_ever sr_dementia_ever dem_cat1 dem_cat2 dem_cat3 sr_gad2_anxiety sr_phq2_depressed  ///
memory fall_last_month adl_eat_help adl_bath_help adl_toil_help adl_dres_help iadl_laun_help iadl_shop_help iadl_meal_help iadl_bank_help iadl_meds_help ///
reg_doc_have reg_doc_seen reg_doc_homevisit sr_hosp_ind


foreach x of local demoivars {
	tab `x',m
	
}

gen prob_dementia=dem_3_cat==1 if dem_3_cat!=.

local rn : word count `democvars' `demoivars'

local r=1 
local c=1

mat demo=J(`rn',9,.)

foreach i in 1 2 3 {
	foreach x of local democvars {
		sum `x' if wave==`i'
		mat demo[`r',`c']=r(mean)
		mat demo[`r',`c'+1]=r(sd)
		sum n if `x'==. & wave==`i'
		mat demo[`r',`c'+2]=r(N)
		local r=`r'+1
}
	foreach x of local demoivars {
		sum `x' if wave==`i'
		mat demo[`r',`c']=r(N)
		mat demo[`r',`c'+1]=r(mean)*100
		sum n if `x'==. & wave==`i'
		mat demo[`r',`c'+2]=r(N)
		local r=`r'+1
}
	local c=`c'+3
	local r=1
}

mat rownames demo=`democvars' `demoivars'

frmttable using "E:\nhats\nhats_tab1.rtf", statmat(demo) varlabels ctitles( "" "Mean/N, W1" "SD/%" "N Missing" ///
"Mean/N, W2" "SD/%" "N Missing" "Mean/N, W3" "SD/%" "N Missing") sdec(0,2,0,0,2,0,0,2,0)

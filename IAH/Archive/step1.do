use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", replace
*use "E:\nhats\data\Projects\IAH\final_data\iah_wave1-3.dta", clear


*gen buyin6m = substr(buyin12,1,6)
*gen hmmo6m = substr(hmoind12,1,6)

duplicates drop spid wave, force
keep if community_dwelling
keep if wave<4


gen ffs_6m = 0
replace ffs_6m = 1 if cont_ffs_n_mos >=6

*keep if ffs_6m

local cvars sr_stroke_ever sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever sr_diabetes_ever sr_lung_dis_ever sr_dementia_ever

/* 
foreach x of local cvars {
tab `x' wave, col
} 
*/
 
egen c_con = anycount(`cvars'), values(1)
gen cc_flag = 0
replace cc_flag = 1 if c_con>=2
label var cc_flag "2+ Chronic Conditions"
 
local avars adl_eat_help adl_bath_help adl_toil_help adl_dres_help adl_bed_help adl_ins_help
egen adl_con = anycount(`avars'), values(1)
gen adl_flag = 0
replace adl_flag = 1 if adl_con>=2 
label var adl_flag "2+ ADL Impairment"

gen homebound = 0
replace homebound = 1 if homebound_cat==1

gen homebound_never = 0
replace homebound_never = 1 if homebound_cat==2

rename cc_flag iah_chronic
rename adl_flag iah_adl
rename ind_nonelect_adm_12m iah_nonelect

/*
*save "E:\nhats\data\Projects\IAH\final_data\iah_wave1-3.dta", replace


keep if cc_flag
keep if adl_flag
keep if ind_nonelect_adm_12m // elective hospitalization in past year


tab wave homebound
ttest tot_paid_by_mc_12m if wave==1, by(homebound)
ttest tot_paid_by_mc_12m if wave==2, by(homebound)
ttest tot_paid_by_mc_12m if wave==3, by(homebound)
ttest tot_paid_by_mc_12m, by(homebound)



tab died_12 homebound
tab died_12 homebound if wave==1
tab died_12 homebound if wave==2
tab died_12 homebound if wave==3

*saveold "E:\nhats\data\Projects\IAH\int_data\steps123.dta", version(12) replace
*/


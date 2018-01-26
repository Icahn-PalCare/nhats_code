cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\cpt+pos.dta", keepus(bflag)
cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\cpt+only.dta", keepus(cflag)
cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\pos+only.dta", keepus(posflag)



gen none = 1
replace none =0 if bflag==1 | cflag==1 |posflag==1

keep if community_dwelling==1 & ffs_6m==1

replace ind_snf_use_p12m = 0 if ind_snf_use_p12m==.

gen ind_icu_p12m = 0
replace ind_icu_p12m = 1 if icu_days_p12m>0
label var ind_icu_p12m "ICU use 12m post ivw"

label var iah_adl "IAH - 2+ ADL Impairment"
label var iah_chronic "IAH - 2+ Chronic Conditions"
label var iah_nonelect "IAH - Nonelective admission 12m pre ivw"
label var iah_pacute "IAH - Post Acute Care 12m prior"

label var tot_paid_by_mc_12m "Total Paid by Medicare 12m post ivw"
label var died_12 "Died within 12m post ivw"

local sr_con adl_eat_diff adl_eat_help adl_bath_diff adl_bath_help adl_toil_diff adl_toil_help adl_dres_diff adl_dres_help adl_ins_help adl_ins_diff adl_bed_help adl_bed_diff
foreach x of local sr_con {
tab `x'
replace `x' = 0 if `x'==.
}

label var adl_ins_diff "Difficulty getting around inside"
label var adl_bed_diff "Difficulty getting out of bed"
label var iah_all "IAH - All Criteria Met"
label var adl_eat_diff "Difficulting Eating"
label var adl_bath_diff "Difficulty bathing"
label var adl_dres_diff "Has Difficulty Dressing"

egen recent_yr = max(index_year), by(bene_id)

keep if recent_yr==index_year

save unique_nocptpos.dta, replace 

append using cpt+pos.dta
gen ind_cpt = 1

keep bene_id wave ind_cpt 

save cpt+pos.dta, replace

restore, preserve

gen northeast = 0
replace northeast = 1 if re1dcensdiv==1 | re1dcensdiv==2 | re2dcensdiv==1 | re2dcensdiv==2 | re3dcensdiv==1 | re3dcensdiv==2

gen midwest = 0
replace midwest = 1 if re1dcensdiv==3 | re1dcensdiv==4 | re2dcensdiv==3 | re2dcensdiv==4 | re3dcensdiv==3 | re3dcensdiv==4

gen west = 0
replace west = 1 if re1dcensdiv==8 | re1dcensdiv==9 | re2dcensdiv==8 | re2dcensdiv==9 | re3dcensdiv==8 | re3dcensdiv==9

gen south = 0
replace south = 1 if northeast==0 & west==0 & midwest==0

cap drop _m
*merge m:1 bene_id using cpt+pos.dta, keepus(ind_cpt)

cap drop _m

merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\annualcpt_count.dta"
drop if _m==2
label var housecalls_count "Ave. number of house calls in calendar year of interview"

replace housecalls_count = 0 if housecalls_count==.

cap drop _m
drop adl_bed_diff adl_ins_diff
cap drop _m
merge 1:1 spid wave using "E:\nhats\data\NHATS cleaned\sp_round_1_6_public_sens_only.dta", keepus(adl_bed_diff adl_ins_diff) 
keep if _m==3

cap drop _m
drop anfinwgt

merge 1:1 spid using "E:\nhats\data\NHATS cleaned\wave1.dta", keepus(anfinwgt)
keep if _m==3

svyset varunit [pweight=anfinwgt], strata(varstrat)

label var adl_bed_diff "Difficulty getting out of bed"
label var adl_ins_diff "Difficulty getting around inside"

local cvars1 age aveincome
local ivars1 female white black hisp married livealone educ_hs_ind homebound homebound_never medicaid metro_ind northeast midwest south west
local ivars2 iah_adl iah_chronic iah_nonelect iah_pacute iah_all sr_ami_ever sr_stroke_ever sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever sr_diabetes_ever sr_dementia_ever prob_dem
local ivars3 adl_eat_diff adl_eat_help adl_bath_diff adl_bath_help adl_toil_diff adl_toil_help adl_dres_diff adl_dres_help adl_ins_help adl_ins_diff adl_bed_help adl_bed_diff ind_hosp_adm_p12m ind_ed_adm_p12m ind_icu_p12m died_12
local cvars2 tot_paid_by_mc_12m housecalls_count

local rd: word count `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' 1 1 1 1

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',2,0)

local r = 1
local c = 1
foreach x of local cvars1 {
qui sum `x' if ind_cpt==1
mat tab1[`r',1] = r(mean)

qui sum `x' if ind_cpt==0
mat tab1[`r',2] = r(mean)

ttest `x', by(ind_cpt)
mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)



/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/

local ++r
}

foreach x of local ivars1 {

qui sum `x' if ind_cpt==1
mat tab1[`r',1] = r(mean)*100

qui sum `x' if ind_cpt==0
mat tab1[`r',2] = r(mean)*100

qui tab `x' ind_cpt, chi2 
mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}


foreach x of local ivars2 {

qui sum `x' if ind_cpt==1
mat tab1[`r',1] = r(mean)*100

qui sum `x' if ind_cpt==0
mat tab1[`r',2] = r(mean)*100

qui tab `x' ind_cpt, chi2
mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}



foreach x of local ivars3 {

qui sum `x' if ind_cpt==1
mat tab1[`r',1] = r(mean)*100

qui sum `x' if ind_cpt==0
mat tab1[`r',2] = r(mean)*100

qui tab `x' ind_cpt, chi2
mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}

foreach x of local cvars2 {
qui sum `x' if ind_cpt==1
mat tab1[`r',1] = r(mean)

qui sum `x' if ind_cpt==0
mat tab1[`r',2] = r(mean)

ttest `x', by(ind_cpt)
mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)
/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/

local ++r
}

sum housecalls_count if ind_cpt==1
mat tab1[`r',1]=r(min)
local ++r
mat tab1[`r',1]=r(max)
local ++r
mat tab1[`r',1]=2
local ++r


qui sum ind_cpt if ind_cpt==1
mat tab1[`r',1] = r(N)

qui sum ind_cpt if ind_cpt==0
mat tab1[`r',2] = r(N)

mat rownames tab1 = `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' "Minimum number of house calls" "Maximum number of housecalls" "Median House Calls" "Sample Size"

mat list tab1

frmttable using "E:\nhats\projects\IAH\20171219\table1.doc", replace statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-3 Community Dwelling + 6m FFS") ///
ctitles("" "CPT+POS" "No House Calls") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")

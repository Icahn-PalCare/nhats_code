use "E:\nhats\nhats_code\IAH\Archive\unique_nocptpos.dta", clear 

cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\cpt+pos.dta", keepus(bflag)
cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\cpt+only.dta", keepus(cflag)
cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\pos+only.dta", keepus(posflag)
drop homebound*
/*
preserve
capture gen none = 1
replace none =0 if bflag==1 | cflag==1 |posflag==1

keep if community_dwelling==1 & ffs_6m==1

replace ind_snf_use_p12m = 0 if ind_snf_use_p12m==.

capture gen ind_icu_p12m = 0
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

capture egen recent_yr = max(index_year), by(bene_id)

keep if recent_yr==index_year

save unique_nocptpos.dta, replace 

append using cpt+pos.dta
capture gen ind_cpt = 1

keep bene_id wave ind_cpt 

save cpt+pos.dta, replace

restore, preserve
*/
capture gen northeast = 0
replace northeast = 1 if re1dcensdiv==1 | re1dcensdiv==2 | re2dcensdiv==1 | re2dcensdiv==2 | re3dcensdiv==1 | re3dcensdiv==2

capture gen midwest = 0
replace midwest = 1 if re1dcensdiv==3 | re1dcensdiv==4 | re2dcensdiv==3 | re2dcensdiv==4 | re3dcensdiv==3 | re3dcensdiv==4

capture gen west = 0
replace west = 1 if re1dcensdiv==8 | re1dcensdiv==9 | re2dcensdiv==8 | re2dcensdiv==9 | re3dcensdiv==8 | re3dcensdiv==9

capture gen south = 0
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
merge m:1 spid wave using "E:\nhats\data\NHATS cleaned\sp_round_1_6_public_sens_only.dta", keepus(homebound* adl_bed_diff adl_ins_diff) 
keep if _m==3

cap drop _m
drop anfinwgt

merge 1:1 spid using "E:\nhats\data\NHATS cleaned\wave1.dta", keepus(anfinwgt)
keep if _m==3

levelsof homebound_cat, local(levels)
local hb
foreach l of local levels {
	gen homebound`l'=homebound_cat==`l'
	local lab : label hb `l'
	label var homebound`l' "`lab'"
	local hb `hb' homebound`l'
}

svyset varunit [pweight=anfinwgt], strata(varstrat)

label var adl_bed_diff "Difficulty getting out of bed"
label var adl_ins_diff "Difficulty getting around inside"
gen ind_one_hc=housecalls_count==1
gen ind_no_hc=housecalls_count==0
label var ind_no_hc "No housecalls"
gen ind_lt3_hc=inlist(housecalls_count,1,2)
gen ind_gt2_hc=inrange(housecalls_count,3,365)
label var ind_one_hc "Exactly one housecall"
label var ind_lt3_hc "1 or 2 housecalls"
label var ind_gt2_hc "3+ Housecalls"
local cvars1 age aveincome
local ivars1 female white black hisp married livealone rcfres educ_hs_ind reg_doc_have reg_doc_seen ///
`hb' medicaid metro_ind northeast midwest south west
local ivars2 iah_adl iah_chronic iah_nonelect iah_pacute iah_all sr_ami_ever sr_stroke_ever ///
sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever ///
sr_diabetes_ever sr_dementia_ever prob_dem
local ivars3 ind_no_hc ind_one_hc ind_lt3_hc ind_gt2_hc adl_eat_diff adl_eat_help adl_bath_diff adl_bath_help adl_toil_diff ///
adl_toil_help adl_dres_diff adl_dres_help adl_ins_help adl_ins_diff adl_bed_help ///
adl_bed_diff ind_hosp_adm_p12m ind_ed_adm_p12m ind_icu_p12m died_12
local cvars2 tot_paid_by_mc_12m housecalls_count

local rd: word count `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' 1 1 1 1 1

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',2,0)

local r = 1
local c = 1
foreach x of local cvars1 {
svy: mean `x', over(ind_cpt)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r
}

foreach x of local ivars1 {

svy: mean `x', over(ind_cpt)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy: tab `x' ind_cpt, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}


foreach x of local ivars2 {

svy: mean `x', over(ind_cpt)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy: tab `x' ind_cpt, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}



foreach x of local ivars3 {

svy: mean `x', over(ind_cpt)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy: tab `x' ind_cpt, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}

foreach x of local cvars2 {
svy: mean `x', over(ind_cpt)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/
}

sum housecalls_count if ind_cpt==1
mat tab1[`r',1]=r(min)
local ++r
mat tab1[`r',1]=r(max)
local ++r
mat tab1[`r',1]=2
local ++r


sum age if ind_cpt==1
mat tab1[`r',1] = r(N)

sum age if ind_cpt==0
mat tab1[`r',2] = r(N)
local ++r 
svy, subpop(if ind_cpt==1): mean age
mat tab1[`r',1] = e(N_subpop)

svy, subpop(if ind_cpt==0): mean age
mat tab1[`r',2] = e(N_subpop)

mat rownames tab1 = `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' ///
"Minimum number of house calls" "Maximum number of housecalls" "Median House Calls" ///
"N" "Weighted Sample Size"

mat list tab1

frmttable using "E:\nhats\data\projects\IAH\logs\table1_weighted_evan.doc", replace statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-3 Community Dwelling + 6m FFS (Weighted)") ///
ctitles("" "CPT+POS" "No House Calls") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")
gen hb=homebound1

foreach cpt in 1 0 {

local rd: word count `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' 1 1 1 1 1 

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',2,0)

local r = 1
local c = 1
foreach x of local cvars1 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r
}

foreach x of local ivars1 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}


foreach x of local ivars2 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}



foreach x of local ivars3 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}

foreach x of local cvars2 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/
}

sum housecalls_count if hb==1
mat tab1[`r',1]=r(min)
local ++r
mat tab1[`r',1]=r(max)
local ++r
mat tab1[`r',1]=2
local ++r

sum age if ind_cpt==`cpt' & hb==0
mat tab1[`r',2] = r(N)
sum age if ind_cpt==`cpt' & hb==1
mat tab1[`r',1] = r(N)

local r=`r'+1
svy, subpop(if ind_cpt==`cpt' & hb==0): mean age
mat tab1[`r',2] = e(N_subpop)
svy, subpop(if ind_cpt==`cpt' & hb==1): mean age
mat tab1[`r',1] = e(N_subpop)



mat rownames tab1 = `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' ///
"Minimum number of house calls" "Maximum number of housecalls" "Median House Calls" ///
"N" "Weighted Sample Size"

mat list tab1
local housecall "1+ Housecall"
if `cpt'==0 local housecall "No Housecalls"
frmttable using "E:\nhats\data\projects\IAH\logs\table1_weighted_evan.doc", addtable statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-3 Community Dwelling + 6m FFS (Weighted) & `housecall'") ///
ctitles("" "Homebound" "Non-Homebound") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")

}

preserve
foreach cpt in 1  {
replace hb=ind_one_hc==1
local rd: word count `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' 1 1 1 1 1 

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',2,0)

local r = 1
local c = 1
foreach x of local cvars1 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r
}

foreach x of local ivars1 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}


foreach x of local ivars2 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}



foreach x of local ivars3 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}

foreach x of local cvars2 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/
}

sum housecalls_count if hb==1
mat tab1[`r',1]=r(min)
local ++r
mat tab1[`r',1]=r(max)
local ++r
mat tab1[`r',1]=2
local ++r

sum age if ind_cpt==`cpt' & hb==0
mat tab1[`r',2] = r(N)
sum age if ind_cpt==`cpt' & hb==1
mat tab1[`r',1] = r(N)

local r=`r'+1
svy, subpop(if ind_cpt==`cpt' & hb==0): mean age
mat tab1[`r',2] = e(N_subpop)
svy, subpop(if ind_cpt==`cpt' & hb==1): mean age
mat tab1[`r',1] = e(N_subpop)



mat rownames tab1 = `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' ///
"Minimum number of house calls" "Maximum number of housecalls" "Median House Calls" ///
"N" "Weighted Sample Size"

mat list tab1
local housecall "1+ Housecall"
if `cpt'==0 local housecall "No Housecalls"
frmttable using "E:\nhats\data\projects\IAH\logs\table1_weighted_evan.doc", addtable statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-3 Community Dwelling + 6m FFS (Weighted) & `housecall'") ///
ctitles("" "One Housecall" "2+ Housecalls") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")

}
restore

preserve


foreach cpt in 1  {
gen cpt2=ind_cpt
replace ind_cpt=hb
replace hb=cpt2
//replace hb=ind_one_hc==1
local rd: word count `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' 1 1 1 1 1 

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',2,0)

local r = 1
local c = 1
foreach x of local cvars1 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r
}

foreach x of local ivars1 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}


foreach x of local ivars2 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}



foreach x of local ivars3 {

svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)*100
mat tab1[`r',2] = el(e(b),1,1)*100

svy, subpop(if ind_cpt==`cpt'): tab `x' hb, pea
mat stars[`r',1]=(e(p_Pear)<.01) + (e(p_Pear)<.05)

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)*100

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)*100
*/
local ++r
}

foreach x of local cvars2 {
svy, subpop(if ind_cpt==`cpt'): mean `x', over(hb)
mat tab1[`r',1] = el(e(b),1,2)
mat tab1[`r',2] = el(e(b),1,1)

test [`x']0 = [`x']1

mat stars[`r',1]=(r(p)<.01) + (r(p)<.05)

local ++r

/*
qui sum `x' if posflag==1
mat tab1[`r',3] = r(mean)

qui sum `x' if none==1
mat tab1[`r',4] = r(mean)
*/
}

sum housecalls_count if hb==1
mat tab1[`r',1]=r(min)
local ++r
mat tab1[`r',1]=r(max)
local ++r
mat tab1[`r',1]=2
local ++r

sum age if ind_cpt==`cpt' & hb==0
mat tab1[`r',2] = r(N)
sum age if ind_cpt==`cpt' & hb==1
mat tab1[`r',1] = r(N)

local r=`r'+1
svy, subpop(if ind_cpt==`cpt' & hb==0): mean age
mat tab1[`r',2] = e(N_subpop)
svy, subpop(if ind_cpt==`cpt' & hb==1): mean age
mat tab1[`r',1] = e(N_subpop)



mat rownames tab1 = `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' ///
"Minimum number of house calls" "Maximum number of housecalls" "Median House Calls" ///
"N" "Weighted Sample Size"

mat list tab1
local housecall "Homebound only"
if `cpt'==0 local housecall "No Housecalls"
frmttable using "E:\nhats\data\projects\IAH\logs\table1_weighted_evan.doc", addtable statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-3 Community Dwelling + 6m FFS (Weighted) & `housecall'") ///
ctitles("" "One Housecall" "2+ Housecalls") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")

}
restore



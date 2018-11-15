use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", replace

cap drop community_dwelling SP_completed

merge 1:1 spid wave using "C:\Users\rahmao03\Documents\community.dta"
cap drop _m

save "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", replace

keep if community_dwelling
keep if wave<6
cap drop bene_id 

merge m:1 spid using "E:\nhats\data\20180625 NHATS CMS Data\merged\xwalk_2016.dta" 

keep if _m==3

save "E:\nhats\data\Projects\IAH\int_data\iah_fullsample.dta", replace

/*
keep bene_id spid wave ivw_month ivw_year


saveold "E:\nhats\data\Projects\IAH\int_data\iah_ivwdates.dta", version(12) replace



use "E:\nhats\data\Projects\IAH\int_data\iah_fullsample.dta", clear

cap drop _merge

merge 1:1 spid wave using "E:\nhats\data\Projects\IAH\int_data\iah_ffs.dta", keepus(ffs_6m)
keep if _m==3

save "E:\nhats\data\Projects\IAH\final_data\iah_fullsample.dta", replace

*/

local cvars sr_stroke_ever sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever sr_diabetes_ever sr_lung_dis_ever sr_dementia_ever

 
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


save "E:\nhats\data\Projects\IAH\final_data\iah_wave1-5.dta", replace


/* *************************************************** */


use "E:\nhats\data\Projects\IAH\final_data\iah_wave1-5.dta", clear

/* merge IP rehab */
cap drop _m
merge 1:1 bene_id index_date using "E:\nhats\data\Projects\IAH\final_data\iah_rehab_flag.dta", keepus(ip_rehab snf hh)
replace ip_rehab=0 if ip_rehab==.
gen ip_rehab_only = 0
replace ip_rehab_only = 1 if ip_rehab==1 & snf==. & hh==.
label var ip_rehab "Inpatient Rehab or SNF/HH within 7 days of IP discharge, 1 yr prior to ivw"
label var ip_rehab_only "Inpatient rehab (no SNF/HH), 1 yr prior to ivw"


/* merge housecalls flag */
cap drop _m
merge 1:1 bene_id index_date using "E:\nhats\data\Projects\IAH\int_data\homecalls_90.dta"
gen hcallsb4 = 0
replace hcallsb4 = 1 if _m==3
label var hcalls " 1 or more house calls +/- 90 days of ivw"


/* house calls count */
cap drop _m
merge 1:1 bene_id index_year using "E:\nhats\data\Projects\IAH\int_data\annualcpt_count.dta"
drop if _m==2

label var housecalls_count "Ave. number of house calls in calendar year of interview"
cap drop _m

save "E:\nhats\data\Projects\IAH\int_data\iah_wave1-5.dta", replace

/* Get geographic region variables */


use "E:\nhats\data\NHATS working data\round_1_to_6.dta", clear 

keep spid wave re*dcensdiv

forvalues i=1/6 {

capture gen northeast = 0
replace northeast = 1 if re`i'dcensdiv==1 | re`i'dcensdiv==2

capture gen midwest = 0
replace midwest = 1 if re`i'dcensdiv==3 | re`i'dcensdiv==4

capture gen west = 0
replace west = 1 if re`i'dcensdiv==8 | re`i'dcensdiv==9
}

capture gen south = 0
replace south = 1 if northeast==0 & west==0 & midwest==0

cap drop re*dcensdiv

tempfile region
save "`region'"



/*
use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", clear
cap drop _m
duplicates drop spid wave, force
merge 1:1 spid wave using "`region'"
keep if _m==3
cap drop _m


save "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", replace
*/

****
use "E:\nhats\data\Projects\IAH\int_data\iah_wave1-5.dta", clear
cap drop _m
duplicates drop spid wave, force
merge 1:1 spid wave using "`region'"
keep if _m==3
cap drop _m


/*Income adjustment to $2016 dollars */
gen income_adj=0
replace income_adj= (240.007/224.939)*aveincome if wave==1
replace income_adj= (240.007/229.594)*aveincome if wave==2
replace income_adj= (240.007/232.957)*aveincome if wave==3
replace income_adj= (240.007/236.736)*aveincome if wave==4
replace income_adj= (240.007/237.017)*aveincome if wave==5

xtile income_quart_adj=income_adj, nq(4) 
sum income_adj, d

replace housecalls_count = 0 if housecalls_count==.

gen iah_rehab = 0
replace iah_rehab = 1 if ip_rehab==1 |snf==1 |hh==1

cap drop iah_all

gen iah_all = 0
replace iah_all = 1 if iah_adl==1 & iah_chronic==1 & iah_nonelect==1 & iah_rehab==1

forvalues w = 1/4 {

gen income_quart_`w' = . 
replace income_quart_`w' = income_adj if income_quart_adj==`w'
sum income_quart_`w', d
local p = 25*`w' 
local q = r(mean)
local r = round(`q',1)


label var income_quart_`w' "Ave. Income in `p'th quartile (adjusted to 2016 dollars)"
} 


/* IAH population */
keep if cont_ffs_n_mos>=6
preserve 

keep if iah_all==1
gsort spid -wave
by spid: gen ind=_n==1 
keep if ind==1 /* keep most recent wave where they had iah_all */
save "E:\nhats\data\Projects\IAH\int_data\iah_mostrecent.dta", replace
levelsof spid, local(list)
restore
gen droplist = 0
foreach x in `list' {

replace droplist=1 if spid==`x'
}

drop if droplist==1 /* drop spid for those who have iah_all */

gsort spid -wave
keep if cont_ffs_n_mos>=6
by spid: gen ind=_n==1
keep if ind==1

save "E:\nhats\data\Projects\IAH\int_data\iah_control.dta", replace

append using "E:\nhats\data\Projects\IAH\int_data\iah_mostrecent.dta"

cap drop _m

merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\homecalls_90.dta"
drop if _m==2

gen housecalls_90 = 0
replace housecalls_90 = 1 if _m==3
label var housecalls_90 "1+ housecalls +/- 90 days of ivw"

gen iah_pacute = 0
replace iah_pacute = 1 if iah_rehab==1

label var iah_pacute "IAH - Post Acute Care 12m prior"
label var iah_all "IAH - All Criteria Met"


local cvars1 age income_quart_1 income_quart_2 income_quart_3 income_quart_4 // score_community
local ivars1 female white black hisp married livealone rcfres educ_hs_ind reg_doc_have reg_doc_seen ///
homebound medicaid metro_ind northeast midwest south west
local ivars2 iah_adl iah_chronic iah_nonelect iah_pacute iah_all sr_ami_ever sr_stroke_ever ///
sr_cancer_ever sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever ///
sr_diabetes_ever sr_dementia_ever prob_dem
local ivars3 adl_eat_diff adl_eat_help adl_bath_diff adl_bath_help adl_toil_diff ///
adl_toil_help adl_dres_diff adl_dres_help adl_ins_help adl_ins_diff adl_bed_help ///
adl_bed_diff ind_hosp_adm_p12m ind_ed_adm_p12m ind_icu_p12m died_12 housecalls_90
local cvars2 tot_paid_by_mc_12m housecalls_count

local full `cvars1' `ivars1' `ivars2' `ivars3' `cvars2'

local rd: word count `full' 1

mat tab1 = J(`rd',2,.)
mat stars = J(`rd',1,0)

local r = 1
local c = 1

foreach x of local cvars1 {

sum `x' if iah_all==1
mat tab1[`r',`c'] = r(mean)

ttest `x', by(iah_all)
mat stars[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0
mat tab1[`r',`c'] = r(mean)

local --c
local ++r
}

foreach x of local ivars1 {

sum `x' if iah_all==1
mat tab1[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab1[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars2 {

sum `x' if iah_all==1
mat tab1[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab1[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars3 {

sum `x' if iah_all==1
mat tab1[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab1[`r',`c'] = r(mean)*100

local --c
local ++r

}
 
foreach x of local cvars2 {

sum `x' if iah_all==1
mat tab1[`r',`c'] = r(mean)

ttest `x', by(iah_all)
mat stars[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0
mat tab1[`r',`c'] = r(mean)

local --c
local ++r
}

sum age if iah_all==1
mat tab1[`r',1] = r(N)

sum age if iah_all==0
mat tab1[`r',2] = r(N)


mat rownames tab1= `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' N

frmttable using "E:\nhats\projects\IAH\table1_IAH.doc", replace statmat(tab1) ///
varlabels title("Table 1: IAH Unique persons per NHATS Waves 1-5 Community Dwelling + 6m FFS") ///
ctitles("" "IAH" "No IAH") sdec(2) annotate(stars) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")

mat tab2 = J(`rd',2,.)
mat stars2 = J(`rd',1,0)

local r = 1
local c = 1

foreach x of local cvars1 {

sum `x' if homebound==1
mat tab2[`r',`c'] = r(mean)

ttest `x', by(homebound)
mat stars2[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if homebound==0
mat tab2[`r',`c'] = r(mean)

local --c
local ++r
}

foreach x of local ivars1 {

sum `x' if homebound==1
mat tab2[`r',`c'] = r(mean)*100

tab `x' homebound, chi2
mat stars2[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if homebound==0 
mat tab2[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars2 {

sum `x' if homebound==1
mat tab2[`r',`c'] = r(mean)*100

tab `x' homebound, chi2
mat stars2[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if homebound==0 
mat tab2[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars3 {

sum `x' if homebound==1
mat tab2[`r',`c'] = r(mean)*100

tab `x' homebound, chi2
mat stars2[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if homebound==0 
mat tab2[`r',`c'] = r(mean)*100

local --c
local ++r

}
 
foreach x of local cvars2 {

sum `x' if homebound==1
mat tab2[`r',`c'] = r(mean)

ttest `x', by(homebound)
mat stars2[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if homebound==0
mat tab2[`r',`c'] = r(mean)

local --c
local ++r
}

sum age if homebound==1
mat tab2[`r',1] = r(N)

sum age if homebound==0
mat tab2[`r',2] = r(N)



mat rownames tab2= `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' N

frmttable using "E:\nhats\projects\IAH\table1_IAH.doc", addtable statmat(tab2) ///
varlabels title("Table 2: IAH Unique persons per NHATS Waves 1-5 Community Dwelling + 6m FFS") ///
ctitles("" "Homebound" "Not Homebound") sdec(2) annotate(stars2) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")


preserve
keep if homebound==1

mat tab3 = J(`rd',2,.)
mat stars3 = J(`rd',1,0)

local r = 1
local c = 1

foreach x of local cvars1 {

sum `x' if iah_all==1
mat tab3[`r',`c'] = r(mean)

ttest `x', by(iah_all)
mat stars3[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0
mat tab3[`r',`c'] = r(mean)

local --c
local ++r
}

foreach x of local ivars1 {

sum `x' if iah_all==1
mat tab3[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars3[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab3[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars2 {

sum `x' if iah_all==1
mat tab3[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars3[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab3[`r',`c'] = r(mean)*100

local --c
local ++r

}

foreach x of local ivars3 {

sum `x' if iah_all==1
mat tab3[`r',`c'] = r(mean)*100

tab `x' iah_all, chi2
mat stars3[`r',`c'] = (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0 
mat tab3[`r',`c'] = r(mean)*100

local --c
local ++r

}
 
foreach x of local cvars2 {

sum `x' if iah_all==1
mat tab3[`r',`c'] = r(mean)

ttest `x', by(iah_all)
mat stars3[`r',`c']= (r(p)<.01) + (r(p)<.05)

local ++c

sum `x' if iah_all==0
mat tab3[`r',`c'] = r(mean)

local --c
local ++r
}

sum age if iah_all==1
mat tab3[`r',1] = r(N)

sum age if iah_all==0
mat tab3[`r',2] = r(N)



mat rownames tab3= `cvars1' `ivars1' `ivars2' `ivars3' `cvars2' N

frmttable using "E:\nhats\projects\IAH\table1_IAH.doc", addtable statmat(tab3) ///
varlabels title("Table 3: IAH Unique persons per NHATS Waves 1-5 Community Dwelling + 6m FFS (Restricted to Homebound)") ///
ctitles("" "IAH" "Not IAH") sdec(2) annotate(stars3) asymbol(*,**) ///
note("These are unique people, and only survey data from their most recent NHATS interview was used. *p<0.05, **p<0.01")


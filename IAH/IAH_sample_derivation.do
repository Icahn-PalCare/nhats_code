use "E:\nhats\data\Projects\IAH\final_data\iah_wave1-3.dta", clear
use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", clear
merge m:1 bene_id wave using "E:\nhats\data\Projects\serious_ill\int_data\personout.dta" , ///
keep(match master) nogen
drop if bene_id=="eeeeeee3MZ3YqYe" | lml==1

gen comm=!nhres & !lml & sp_ivw==1
gen ffsmc=cont_ffs_n_mos>=6
drop sr_ami_ever 
egen n_cond=rowtotal(sr_*ever)
gen multi=n_cond>=2 if !missing(n_cond)
egen n_adl=rowtotal(adl_*help)
gen adl_2=n_adl>=2 if !missing(n_adl)

label var comm "Community dwelling" 
label var multi "2+ SR conditions (excluding AMI, depression, anxiety)"
label var adl_2 "Dependent in 2+ ADLs"
label var ffsmc "6+ months continuous FFS prior to ivw"
gen cc2=cc_all_count_1yr>=2 if !missing(cc_all_count_1yr)
gen multi2=cc2==1 | multi==1

sort spid wave
by spid: gen nhnext=nhres[_n+1]==1
label var nhnext "NH resident next wave"
gen hb=homeboun==1 
label var hb "Homebound"

gen hcc_pred=.
forvalues i=1/3 {
	sum tot_paid_by_mc_12m if cont_ffs_n_mos>=6 & wave==`i' [aw=anfin]
	replace hcc_pred=r(mean)*score_com if wave==`i'
}

local vars comm ffsmc multi adl_2 ind_nonelect_adm_12m 
local rn : word count `vars'
keep if wave<=3
mat tab=J(`rn',3,.)
local r=1
local c=1

forvalues i=1/3 {
	foreach x of local vars {
		sum `x' if wave==`i' & `x'==1
		mat tab[`r',`c']=r(N)
		drop if `x'==0 & wave==`i'
		local r=`r'+1
}
	local r=1
	local c=`c'+1
}

mat rownames tab=`vars'

frmttable using "E:\nhats\data\projects\IAH\logs\IAH_sample_derivation.rtf", ///
statmat(tab) varlabels ctitles("" "Wave 1" "Wave 2" "Wave 3") sdec(0) ///
title(IAH Sample Derivation) replace

save "E:\nhats\data\projects\IAH\final_data\IAH_sample_ebl.dta", replace

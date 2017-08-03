clear all 
set more off
capture log close

local intpath "E:\nhats\data\Projects\serious_ill\int_data"
local datapath "E:\nhats\data\Projects\serious_ill\final_data"
local logpath "E:\nhats\data\Projects\serious_ill\logs"

cd `datapath'
*log using `logpath'\table1_xwave.txt, text replace

use serious_ill_nhats_sample, clear
keep if ffs_12m==1
cap drop _m
drop if wave>=4


sort spid ivw_date

by spid: egen ivw_meet_a = min(wave) if adl_impair==1
by spid: egen ivw_meet_b = min(wave) if ser_med_illness==1
by spid: egen ivw_meet_c = min(wave) if adl_impair==1 & ser_med_illness==1

sort spid wave
by spid (wave): carryforward aveincome, replace



gen incident_a = 0
replace incident_a = 1 if ivw_meet_a==wave
*replace incident_a = 1 if adl_impair==1

gen incident_b = 0
replace incident_b = 1 if ivw_meet_b==wave
*replace incident_b = 1 if ser_med_illness==1

gen incident_c = 0
replace incident_c = 1 if ivw_meet_c==wave
*replace incident_c = 1 if adl_impair==1 & ser_med_illness==1


/*
bysort spid: egen evera=max(adl_impair==1 | ser_med_illness==1)
gsort spid -wave
by spid: drop if evera==0 & _n>1

gen awave=wave if adl_impair==1
gen bwave=wave if ser_med_illness==1
gen cwave=wave if adl_impair==1 & ser_med_illness==1

foreach x in a b c {
by spid: egen incident_`x'=min(`x'wave)
}

by spid: keep if incident_a==wave | incident_b==wave | incident_c==wave | evera==0
gen incident_none = 0
replace incident_none = 1 if evera==0 

recode incident_a incident_b incident_c (. = 0)(1/3 = 1)


*/

gen incident_none = 0
replace incident_none = 1 if criteria_a==0
*drop if wave==4
egen max_wave = max(wave), by(spid)
drop if incident_none==1 & wave!=max_wave // most recent wave where you met no criteria
*/


label var educ_hs_ind "High school"
gen incident_group=incident_a
replace incident_group=2 if incident_b==1
replace incident_group=3 if incident_c==1
rename criteria_all incident_all




*gen incident_none = 0
*replace incident_none = 1 if criteria_a==0
gen cgroupa=incident_a
gen cgroupb=incident_b
gen cgroupc=incident_c
label var incident_a "Any Functional Impairment"
label var incident_b "Any Serious Illness"
label var incident_c "Serious Illness and Functional Impairment" 
gen ind=1
drop if !incident_a & !incident_b & !incident_c & !incident_none
local cvars1 age
local cvars2 aveincome
local ivars1 female white black hisp other_race married educ_hs_ind
local ivars2 proxy  ///
medicaid medigap srh_fp adl_eat_help adl_bath_help adl_toil_help adl_dres_help ///
adl_ins_help adl_bed_help adl_independent smi_dem_ind smi_cancer_ind ///
smi_esrd_ind smi_chf_ind smi_copd_ind smi_diab_compl_ind smi_liver_ind ///
/*smi_hiv_ind smi_als_ind*/ smi_hip_ind ser_med_illness el_ge3_comorb_1yr nhres ///
incident_a incident_b incident_c
local ioutcomes ind_hosp_adm_p12m mult_ip_adm_p12m ind_ed_op_p12m  ///
ind_icu_p12m ind_hs_p12m died_12

local coutcomes ip_paid_by_mc_12m snf_paid_by_mc_12m hh_paid_by_mc_12m ///
 hs_paid_by_mc_12m pb_paid_by_mc_12m op_paid_by_mc_12m ///
 dm_paid_by_mc_12m tot_paid_by_mc_12m n_hospd_p12m
gen missingany=0
foreach i in 0 1 {
di "SP ivw=`i'"
foreach x in `cvars1' `cvars2' `ivars1' `ivars2' {
 qui  sum ind if missing(`x') & sp_ivw==`i'
if r(N)>0 {
di "`x'"
di r(N)
}
/* qui */ replace missingany=1 if `x'==.
}
}

local rn : word count `cvars1' `cvars2' `ivars1' `ivars2' n `coutcomes' `ioutcomes'
foreach i in 0 1 {
di "SP ivw=`i'"
local r=1
local c=1
mat miss=J(`rn',3,.)

foreach x in `cvars1' `cvars2' `ivars1' `ivars2' `coutcomes' `ioutcomes' {
qui sum `x' if sp_ivw==`i'
mat miss[`r',1]=r(mean)
mat miss[`r',2]=r(N)
qui  sum ind if missing(`x') & sp_ivw==`i'
mat miss[`r',3]=r(N)
local r=`r'+1
}
qui sum ind if sp_ivw==`i'
mat miss[`r',1]=r(N)

mat rownames miss=`cvars1' `cvars2' `ivars1' `ivars2' `coutcomes' `ioutcomes' N

frmttable, statmat(miss) varlabels title("Missing values") ///
ctitles( "Variable" "mean" "N" "N missing") sdec(2,0,0)
tab missingany
}
*drop if missingany
local r=1
local c=1

local rn : word count `cvars1' `cvars2' `ivars1' `ivars2' `coutcomes' `coutcomes' `ioutcomes' 1 1
di `rn'
mat tab1=J(`rn',5,.)
mat stars=J(`rn',5,0)
local r=1
local c=1
foreach i in all none a b c {
	foreach round in 1 2 {
		foreach x of local cvars`round' {
			/* qui */ sum `x' if incident_`i'==1 
			mat tab1[`r',`c']=r(mean)
			if inlist("`i'","a","b","c") {
				/* qui */ ttest `x' if incident_`i'==1 | incident_none==1, by(cgroup`i')
				mat stars[`r',`c']=(r(p)<.01) + (r(p)<.05)
}
			local r=`r'+1
}
		foreach x of local ivars`round' {
			/* qui */ sum `x' if incident_`i'==1
			mat tab1[`r',`c']=r(mean)*100
			if inlist("`i'","a","b","c") {
			/* qui */	tab `x' cgroup`i' if incident_`i'==1 | incident_none==1, chi2
				mat stars[`r',`c']=(r(p)<.01) + (r(p)<.05)
}
			local r=`r'+1
}
}
	local r=`r'+1

	
	foreach x of local coutcomes {
		/* qui */ sum `x' if incident_`i'==1,d
		mat tab1[`r',`c']=r(mean)
		if inlist("`i'","a","b","c") {
		/* qui */	ttest `x' if incident_`i'==1 | incident_none==1, by(cgroup`i')
			mat stars[`r',`c']=(r(p)<.01) + (r(p)<.05)
}
		local r=`r'+1
*		if "`x'"=="tot_paid_by_mc_12m_wi_n0" {
			/* qui */ sum `x' if incident_`i'==1,d
			mat tab1[`r',`c']=r(p50)
			local r=`r'+1
*}
}
	foreach x of local ioutcomes {
		/* qui */ sum `x' if incident_`i'==1
		mat tab1[`r',`c']=r(mean)*100
			if inlist("`i'","a","b","c") {
				/* qui */ tab `x' cgroup`i' if incident_`i'==1 | incident_none==1, chi2
				mat stars[`r',`c']=(r(p)<.01) + (r(p)<.05)
}
			local r=`r'+1
}
	/* qui */ sum ind if incident_`i'==1
	mat tab1[`r',`c']=r(N)
	local r=1
	local c=`c'+1
}

foreach x in `coutcomes' {
local rnames `rnames' "`x'" "Median"
}

mat rownames tab1=`cvars1' `ivars1' `cvars2' `ivars2' "Outcome Measures Over 1 Year" ///
`rnames' `ioutcomes' N

frmttable using `logpath'\sample_characteristics_xwavee.doc, replace statmat(tab1) ///
 title("NHATS Waves 1- 3 Serious Illness Criteria") ///
 ctitles("" "Full Sample" "None" "ADL Impairment" "Ser Med Ill" "ADL + Ser Med Ill" ) ///
 sdec(1) annotate(stars) asymbol(*,*) ///
 varlabels note("*p<.05 difference between x and no criteria met groups, t-test or chi2" ///
 "Sample was derived from the incident wave when a person 1st met a criteria. For those who met no criteria their most recent wave was used.")

capture log close

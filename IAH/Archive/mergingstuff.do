*use "E:\nhats\data\Projects\IAH\final_data\IAH_sample_ebl.dta" , clear

*use "E:\nhats\data\Projects\IAH\final_data\iah_wave1-3.dta", clear

cap drop _m
merge 1:1 bene_id index_date using "E:\nhats\data\Projects\IAH\int_data\iah_rehab_flag.dta", keepus(snf hh ip_rehab)

rename snf snf_rehab
rename hh hh_rehab

foreach x of varlist snf_rehab hh_rehab ip_rehab {

replace `x' = 0 if `x'==.
}

gen iah_all = 0
replace iah_all = 1 if iah_chronic==1 & iah_adl==1 & iah_nonelect==1 & iah_pacute==1

/*
cap drop _m
merge 1:1 bene_id index_year using "E:\nhats\data\Projects\IAH\int_data\hospice_pre.dta" 
drop if _m==2
cap drop _m

foreach x of varlist n_hs_days_12m ind_hs_use_12m n_hs_days_6m ind_hs_use_6m {

replace `x'=0 if `x'==.
}

merge 1:1 bene_id index_year using "E:\nhats\data\Projects\IAH\int_data\hospice_post.dta" 
drop if _m==2
cap drop _m

foreach x of varlist n_hs_days_p12m ind_hs_use_p12m n_hs_days_p6m ind_hs_use_p6m {
replace `x'=0 if `x'==.
}
*/
save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta" , replace


use "E:\nhats\data\Projects\IAH\int_data\life_proc_12.dta", clear
collapse (max) pre_intubation pre_trach pre_gastro_tude pre_enteral_nut pre_cpr proc_12m proc_6m, by(bene_id index_year)
label var pre_intubation "intubation/mechanic ventilation pre ivw"
label var pre_trach "trachostomy pre ivw"
label var pre_gastro_tude "gastrostomy tube pre ivw"
label var pre_enteral_nut "enteral/parenteral nutrition pre ivw"
label var pre_cpr "CPR pre ivw"
label var proc_12m "Had 1 or more life saving procedure 12m pre ivw"
label var proc_6m "Had 1 or more life saving procedure 6m pre ivw"

save "E:\nhats\data\Projects\IAH\int_data\life_proc_12.dta", replace


use "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", clear

cap drop _m
merge 1:1 bene_id index_year using "E:\nhats\data\Projects\IAH\int_data\life_proc_12.dta" 
drop if _m==2

foreach x of varlist pre_intubation pre_trach pre_gastro_tude pre_enteral_nut pre_cpr proc_12m proc_6m {
replace `x' = 0 if `x'==.
}

cap drop _m

save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace
use "E:\nhats\data\Projects\IAH\int_data\life_proc_p12.dta", clear
 
collapse (max) post_intubation post_trach post_gastro_tude post_enteral_nut post_cpr proc_p12m proc_p6m, by(bene_id index_year)
label var post_intubation "intubation/mechanic ventilation post ivw"
label var post_trach "trachostomy post ivw"
label var post_gastro_tude "gastrostomy tube post ivw"
label var post_enteral_nut "enteral/parenteral nutrition post ivw"
label var post_cpr "CPR post ivw"
label var proc_p12m "Had 1 or more life saving procedure 12m post ivw"
label var proc_p6m "Had 1 or more life saving procedure 6m post ivw"
save "E:\nhats\data\Projects\IAH\int_data\life_proc_p12.dta", replace
use "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", clear
merge 1:1 bene_id index_year using "E:\nhats\data\Projects\IAH\int_data\life_proc_p12.dta" 
drop if _m==2

foreach x of varlist post_intubation post_trach post_gastro_tude post_enteral_nut post_cpr proc_p12m proc_p6m {
replace `x' = 0 if `x'==.
}

save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace

gen iah_pacute = 0
replace iah_pacute = 1 if snf_rehab | hh_rehab | ip_rehab

label var iah_pacute "Post Acute Care 12m prior"

cap drop _m

merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\homecallsb4.dta", keepus(cnt)

gen homecallsb4 = 0
replace homecallsb4 = 1 if _m==3

cap drop _m

merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\homecallsafter.dta", keepus(cnt)

gen homecallsafter = 0
replace homecallsafter = 1 if _m==3

save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace

cap drop _m
merge m:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\hospice_death.dta", keepus(n_hs_days)

save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace

use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", replace

keep if nhres 
keep spid wave nhres

rename nhres nhres_nw
label var nhres_nw "Nursing Home Resident Next Wave"

replace wave = wave - 1

save "E:\nhats\data\Projects\IAH\int_data\nhres_nw.dta", replace

use "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", clear

cap drop _m

merge 1:1 spid wave using "E:\nhats\data\Projects\IAH\int_data\nhres_nw.dta", keepus(nhres_nw)
drop if _m==2

cap drop _m
merge 1:1 bene_id wave using "E:\nhats\data\Projects\IAH\int_data\hcc_scores.dta"
keep if _m==3

replace n_hs_days = 1 if n_hs_days==0


save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace

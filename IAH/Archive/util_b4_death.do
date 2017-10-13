 use "E:\nhats\data\Projects\IAH\int_data\utilization_1yrb4_death.dta", clear
 
 local ivars icu_days_1yr n_ip_admit_1yr n_hospd_1yr n_em_urgent_admit_1yr n_em_admit_1yr n_urgent_admit_1yr n_elect_admit_1yr n_ed_ip_1yr ind_hosp_adm_1yr ind_em_ur_adm_1yr ind_em_adm_1yr ind_ur_adm_1yr ind_elect_adm_1yr ind_nonelect_adm_1yr n_nonelect_adm_1yr ind_ed_adm_1yr n_snf_days_1yr ind_snf_use_1yr n_ed_op_visits_1yr ind_ed_op_1yr ed_op_wout_adm_ind ind_snf_1yr ind_hh_1yr
 
 foreach x of local ivars {
 rename `x' `x'_death
 
 }
 
 save "E:\nhats\data\Projects\IAH\int_data\utilization_1yrb4_death.dta", replace

 
 use "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", clear
 cap drop _m
 
merge m:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\utilization_1yrb4_death.dta"
  
cap drop _m
 
save "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", replace

 use "E:\nhats\data\Projects\IAH\int_data\utilization_6mb4_death.dta", clear
 
 local ivars2 icu_days_6m n_ip_admit_6m n_hospd_6m n_em_urgent_admit_6m n_em_admit_6m n_urgent_admit_6m n_elect_admit_6m n_ed_ip_6m ind_hosp_adm_6m ind_em_ur_adm_6m ind_em_adm_6m ind_ur_adm_6m ind_elect_adm_6m ind_nonelect_adm_6m n_nonelect_adm_6m ind_ed_adm_6m n_snf_days_6m ind_snf_use_6m n_ed_op_visits_6m n_ed_op_no_adm ind_ed_op_6m ed_op_wout_adm_ind ind_snf_6m ind_hh_6m
 
 foreach x of local ivars2 {
 rename `x' `x'_death
 
 }
 
save "E:\nhats\data\Projects\IAH\int_data\utilization_6mb4_death.dta", replace

use "E:\nhats\data\Projects\IAH\final_data\IAH_final_sample.dta", clear
cap drop _m

merge m:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\utilization_6mb4_death.dta"



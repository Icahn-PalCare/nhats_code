local intpath "E:\nhats\data\Projects\serious_ill\int_data"
local datapath "E:\nhats\data\Projects\serious_ill\final_data"
local logpath "E:\nhats\data\Projects\serious_ill\logs"

cd `datapath'
*log using `logpath'\table1_xwave.txt, text replace

use serious_ill_nhats_sample, clear
 
keep if wave==1
keep if ffs_12m==1

local cvars  sr_ami_raw sr_stroke_raw sr_cancer_raw sr_hip_raw sr_heart_dis_raw sr_htn_raw sr_ra_raw sr_osteoprs_raw sr_diabetes_raw sr_lung_dis_raw sr_dementia_raw
 
egen c_con = anycount(`cvars'), values(1)
gen cc_flag = 0
replace cc_flag = 1 if c_con>=2
label var cc_flag "2+ Chronic Conditions"
 
local avars adl_eat_help adl_bath_help adl_toil_help adl_dres_help adl_bed_help adl_ins_help
egen adl_con = anycount(`avars'), values(1)
gen adl_flag = 0
replace adl_flag = 1 if adl_con=>2 
label var adl_flag "2+ ADL Impairment"


keep if 



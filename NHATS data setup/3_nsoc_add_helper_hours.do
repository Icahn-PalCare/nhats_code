//adds in imputed caregiver hours from the SP / OP data processing
//these are hours self reported by SP, not the hours reported in the NSOC dataset

capture log close
clear all
set more off

local logs E:\nhats\nhats_code\NHATS data setup\logs
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/
log using `logs'3_nsoc_nhats_add_imp_help_hrs.txt, text replace

local r1raw E:\nhats\data\NHATS Public\round_1\
local r2raw E:\nhats\data\NHATS Public\round_2\
local r3raw E:\nhats\data\NHATS Public\round_3\
local work E:\nhats\data\NHATS working data\
local r1s E:\nhats\data\NHATS Sensitive\r1_sensitive\
local r2s E:\nhats\data\NHATS Sensitive\r2_sensitive\
/*local r1raw /Users/rebeccagorges/Documents/data/nhats/round_1/
local r2raw /Users/rebeccagorges/Documents/data/nhats/round_2/
local r3raw /Users/rebeccagorges/Documents/data/nhats/round_3/
local work /Users/rebeccagorges/Documents/data/nhats/working
local r1s /Users/rebeccagorges/Documents/data/nhats/r1_sensitive/
local r2s /Users/rebeccagorges/Documents/data/nhats/r2_sensitive/ 
*/
cd `work'

************************************************************************
//this includes helper information aggregated to the sp-wave level
use caregiver_ds_nsoc_clean_v2.dta, replace 

sum tot_hrsmonth_help_i, detail

gen prim_cg_ind=0
replace prim_cg_ind=1 if prim_helper_opid==opid

la var prim_cg_ind "Caregiver is Primary helper"
tab prim_cg_ind, missing

//merge in individual helper OP level data from imputed helper dataset
merge 1:1 spid opid wave using R1_hrs_imputed_added.dta, ///
 keepusing(impute_cat op_hrsmth_i op_numdays_i ln_opdhrsmth_i ///
 op_ind_hrsmth spouse otherrel nonrel)

drop if _merge==2 //drop obs where OP is not in the NSOC dataset

tab cg_relationship_cat spouse, missing

************************************************************************
log close

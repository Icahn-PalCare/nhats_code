/*Collapse helper information to the SP - wave level
and merge into SP dataset

variables created are:
Total # helpers for the SP
Total hours/month help provided for SP
Indicators for relationship of primary helper (identified as helper 
with the most hours)

Uses imputed hours per code 1a_help_hours_imputation.do
(see NHATS Technical Paper #7 for imputation methodology)
*/

capture log close
clear all
set more off
local logs E:\nhats\nhats_code\NHATS data setup\logs\
log using "`logs'5-add_helper_to_SP_ds-LOG.txt", text replace

local r1raw E:\nhats\data\NHATS Public\round_1\
local r2raw E:\nhats\data\NHATS Public\round_2\
local r3raw E:\nhats\data\NHATS Public\round_3\
local r4raw E:\nhats\data\NHATS Public\round_4\
local work E:\nhats\data\NHATS working data
local r1s E:\nhats\data\NHATS Sensitive\r1_sensitive\
local r2s E:\nhats\data\NHATS Sensitive\r2_sensitive\
local r3s E:\nhats\data\NHATS Sensitive\r3_sensitive\
local r4s E:\nhats\data\NHATS Sensitive\r4_sensitive\
local logs E:\nhats\nhats_code\NHATS data setup\logs\

cd "`work'"
***************************************************************
//get all 3 waves helper imputed hours into a single dataset
use R1_hrs_imputed_added.dta

local keepvars spid wave opid op_hrsmth_i numact yearnotmonth disab ///
 justone spouse otherrel nonrel regular oneact impute_cat opishelper_allw

keep `keepvars'

qui append using R2_hrs_imputed_added.dta, keep(`keepvars')
 
qui append using R3_hrs_imputed_added.dta, keep(`keepvars')

qui append using R4_hrs_imputed_added.dta, keep(`keepvars')
 
tab wave opishelper_allw, missing

//just keep OP's that are helpers
keep if opishelper_allw==1
***************************************************************
//identify primary helper, person with the most hours / month using imputed hours
sort spid wave opid spouse

gen primary_cg=0
egen max_hrs_helped=max(op_hrsmth_i), by(spid wave)
replace primary_cg=1 if op_hrsmth_i==max_hrs_helped
tab primary_cg wave, missing

//check that each sp has 1 primary cg identified, doesn't matter!
egen num_primary_cg=sum(primary_cg), by(spid wave)
tab num_primary_cg wave, missing

//assign relationship to primary helper
//if same number of hours for two different helpers, then assign to spouse first
gen prim_helper_cat=1 if primary_cg==1 & spouse==1
replace prim_helper_cat=2 if primary_cg==1 & otherrel==1 & prim_helper_cat==.
replace prim_helper_cat=3 if prim_helper_cat==.
la def helpcat 1"Spouse" 2"Other relative" 3"Other, not relative"
la val prim_helper_cat helpcat
tab prim_helper_cat wave, missing

//get total number hours/month help received and number of helpers per spid/wave
egen tot_hrsmonth_help_i=total(op_hrsmth_i), by(spid wave)
egen n_helpers=count(op_hrsmth_i), by(spid wave)

//keep the entry for the primary caregiver only, this will then be the 
//information merged into the SP dataset
keep if primary_cg==1

//sort and keep only first primary cg, again preference given if spouse
sort spid wave opid spouse otherrel
quietly by spid wave: gen dup = cond(_N==1,0,_n)
tab dup
keep if dup==0
//now one obs per sp - wave

sum tot_hrsmonth_help_i, detail
tab n_helpers wave, missing
tab prim_helper_cat wave, missing
***************************************************************
//merge this helper data with the main SP dataset
save helper_by_sp.dta, replace

use round_1_4_cleanv3, clear

merge 1:1 spid wave using helper_by_sp.dta, keepusing(opid n_helpers ///
 tot_hrsmonth_help_i prim_helper_cat)

drop _merge 

replace n_helpers=0 if n_helpers==.

gen ind_no_helpers=.
replace ind_no_helpers=1 if n_helpers==0
replace ind_no_helpers=0 if n_helpers>0
la var ind_no_helpers "Indicator no Helpers reported"
tab ind_no_helpers wave, missing

la var tot_hrsmonth_help_i "Hours / month help received, all helpers, imputed"
sum tot_hrsmonth_help_i, detail
la var n_helpers "Number helpers reported by SP"
tab n_helpers wave, missing
la var prim_helper_cat "Primary helper relationship, missing if no helper"
tab prim_helper_cat wave, missing

rename opid prim_helper_opid
la var prim_helper_opid "Primary helper OPID"

***************************************************************
//save the dataset with helper information added

save round_1_4_clean_helper_added.dta, replace

saveold round_1_4_clean_helper_added_old.dta, replace

***************************************************************
log close

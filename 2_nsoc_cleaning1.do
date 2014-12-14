//cleaning, variable setup of caregiver dataset from nsoc

capture log close
clear all
set more off

//local logs C:\data\nhats\logs\
local logs /Users/rebeccagorges/Documents/data/nhats/logs/
log using `logs'1_nsoc_nhats_setup1.txt, text replace

/*local r1raw C:\data\nhats\round_1\
local r2raw C:\data\nhats\round_2\
local r3raw C:\data\nhats\round_3\
local work C:\data\nhats\working
local r1s C:\data\nhats\r1_sensitive\
local r2s C:\data\nhats\r2_sensitive\ 
*/
local r1raw /Users/rebeccagorges/Documents/data/nhats/round_1/
local r2raw /Users/rebeccagorges/Documents/data/nhats/round_2/
local r3raw /Users/rebeccagorges/Documents/data/nhats/round_3/
local work /Users/rebeccagorges/Documents/data/nhats/working
local r1s /Users/rebeccagorges/Documents/data/nhats/r1_sensitive/
local r2s /Users/rebeccagorges/Documents/data/nhats/r2_sensitive/ 

cd `work'

use caregiver_ds_nsoc_v1.dta, replace
******************************************************************
tab c1dgender, missing //caregiver gender
gen cg_female=1 if c1dgender==2
replace cg_female=0 if c1dgender==1
label var cg_female "Caregiver = female"
tab cg_female, missing

tab c1relatnshp, missing //caregiver relationship to SP
gen cg_relationship_cat=3
replace cg_relationship_cat=1 if c1relatnshp==2
replace cg_relationship_cat =2 if inlist(c1relatnshp,3,4,5,6,7,8)
la def rel 1 "Spouse" 2 "Adult child" 3 "Other"
la val cg_relationship_cat rel
la var cg_relationship_cat "Caregiver relationship"
tab cg_relationship_cat, missing

//ask about this, if want age categories, then fill in from categorical
//variable directly from nhats, don't use actual age
gen cg_age=op1age
replace cg_age=. if inlist(op1age,-8,-7,-1)
sum cg_age, detail

tab op1catgryage if cg_age==., missing

//caregiver resides in same household
tab op1prsninhh, missing //caregiver in household
gen cg_lives_with_sp=1 if op1prsninhh==1
replace cg_lives_with_sp=0 if op1prsninhh==2
tab cg_lives_with_sp, missing
tab cg_lives_with_sp cg_relationship_cat, missing

tab op1proxy if cg_lives_with_sp==.
tab livearrang if cg_lives_with_sp==. & cg_relationship_cat==1, missing

//check hh1livwthspo (SP lives with spouse), needs to come from sp interview though
tab hh1livwthspo cg_lives_with_sp  if cg_relationship_cat==1


//caregiver level of education
tab op1leveledu, missing
tab hh1spouseduc if op1leveledu==. & cg_relationship_cat==1, missing
******************************************************************
//caregiver health
tab che1health, missing //caregiver self reported health
gen cg_srh=che1health
replace cg_srh=. if che1health==-8 | che1health==-7
la def srh 1"Excellent" 2"Very good" 3"Good" 4"Fair" 5"Poor"
la val cg_srh srh
gen cg_srh_fp=1 if inlist(cg_srh,4,5)
replace cg_srh_fp=0 if inlist(cg_srh,1,2,3)
la var cg_srh "Caregiver self reported health 1-5"
la var cg_srh_fp "Caregiver SHR fair/poor"
tab cg_srh cg_srh_fp, missing


******************************************************************
log close

//get caregivers dataset from nsoc 

capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/
log using `logs'1_nsoc_nhats_setup1.txt, text replace

local r1raw C:\data\nhats\round_1\
local r2raw C:\data\nhats\round_2\
local r3raw C:\data\nhats\round_3\
local work C:\data\nhats\working\
local r1s C:\data\nhats\r1_sensitive\
local r2s C:\data\nhats\r2_sensitive\ 
/*
local r1raw /Users/rebeccagorges/Documents/data/nhats/round_1/
local r2raw /Users/rebeccagorges/Documents/data/nhats/round_2/
local r3raw /Users/rebeccagorges/Documents/data/nhats/round_3/
local work /Users/rebeccagorges/Documents/data/nhats/working/
local r1s /Users/rebeccagorges/Documents/data/nhats/r1_sensitive/
local r2s /Users/rebeccagorges/Documents/data/nhats/r2_sensitive/ 
*/
cd `work'

//get just round 1 sp cleaned interviews, save ds for merging in later
//note need to update this with final clean dataset name
use `work'round_1_3_cleanv1.dta if wave==1
save `work'round1_only_clean.dta, replace

//spid is the nhats spid, so if more than one caregiver, more than one row
use `r1s'NSOC_Round_1_File_v2.dta

//merge in round 3 tracker file to get indicator of death
merge m:1 spid  using `r3raw'NHATS_Round_3B_Tracker_File.dta
drop if _merge==2
drop _merge
//merge in tracker file details
//NSOC_Round_1_SP_Tracker_File.dta

//other person sensitive data to get caregiver age
merge 1:1 spid opid using `r1s'NHATS_Round_1_OP_Sen_Dem_File.dta
drop if _merge==2
drop _merge

//other person main nhats file for other caregiver information
merge 1:1 spid opid using `r1raw'NHATS_Round_1_OP_File_v2.dta
drop if _merge==2
drop _merge

//merge in round 1 sp interviews, probably want to change this when have final
//sp dataset saved
merge m:1 spid using `work'round1_only_clean.dta
drop if _merge==2
drop _merge
******************************************************

//create indicator of those SPIDs that died
gen sp_died=0
replace sp_died=1 if inlist(r2status,62,86) | inlist(r3status,62,86)
la var sp_died "Sample person died r2 or r3"
tab sp_died, missing

save caregiver_ds_nsoc_v1.dta, replace

//how many unique SP's is this?
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
replace dup=dup+1
tab dup

drop if dup>1
tab sp_died,missing

*******************************************************
log close

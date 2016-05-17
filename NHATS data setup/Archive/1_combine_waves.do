/*Combines rounds 1 and 2 sample person SP interview files,
sensitive demo files and the round 2 cumulative tracker file case 
status variables into a single file

Data format is multiple observations per subject, one for each round
*/

capture log close
clear all
set more off

local logs E:\nhats\nhats_code\NHATS data setup\logs\
log using "`logs'1_nhats_setup1.txt", text replace
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
*********************************************

//round 1
use "`r1raw'NHATS_Round_1_SP_File.dta"
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=1
la var wave "Survey wave"
save round_1_1.dta, replace
clear

//round 2
use "`r2raw'NHATS_Round_2_SP_File_v2.dta"
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=2
la var wave "Survey wave"
save round_2_1.dta, replace
clear 

//round 3
use "`r3raw'NHATS_Round_3_SP_File.dta"
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=3
la var wave "Survey wave"
save round_3_1.dta, replace
clear 

//round 4
use "`r4raw'NHATS_Round_4_SP_File.dta"
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=4
la var wave "Survey wave"
save round_4_1.dta, replace
clear 

//round 1
foreach w in 1 2 3 4{
use round_`w'_1.dta

//keep selected variables only
local keepallwaves spid wave r`w'dresid w`w'varunit w`w'anfinwgt0 w`w'varstrat  ///
	mo* r`w'd2intvrage hh`w'martlstat ///
	ip`w'cmedicaid ip`w'mgapmedsp ip`w'nginsnurs ip`w'covmedcad ip`w'covtricar ///
	hh* hc* ss* pc* cp* cg* ha* sc* mc* sd* wb* fl* ///
	is`w'resptype ht`w'placedesc

if `w'==1 {	
keep `keepallwaves' r`w'dgender rl`w'dracehisp rl`w'spkothlan rl`w'condspanh el`w'higstschl ///
ia`w'toincim1-ia`w'toincim5 ia1totinc re`w'resistrct
}

if `w'==2 {	
keep `keepallwaves' re2intplace re2newstrct re2spadrsnew re2dresistrct ///
	re2dadrscorr re2dcensdiv ip2nginslast
}

if `w'==3 {	
keep `keepallwaves' re3intplace re3newstrct re3spadrsnew re3dresistrct ///
	re3dcensdiv ip3nginslast
}
if `w'==4 {	
keep `keepallwaves' re4intplace re4newstrct re4spadrsnew re4dresistrct ///
	re4dcensdiv ip4nginslast
}

save round_`w'_ltd.dta, replace
}

//check sensitive data files, keep only some variables, merge with ltd datasets
foreach w in 1 2 3 4{
	use "`r`w's'NHATS_Round_`w'_SP_Sen_Dem_File.dta"
	sort spid 
	quietly by spid: gen dup = cond(_N==1,0,_n)
	tab dup	
	clear
}

//combine 3 waves into single dataset
use round_1_ltd.dta
append using round_2_ltd.dta
append using round_3_ltd.dta
append using round_4_ltd.dta

//merge in sensitive data, use r1 as basis
merge m:1 spid using "`r1s'NHATS_Round_1_SP_Sen_Dem_File.dta", ///
	keepusing(r1dbirthmth r1dbirthyr r1dintvwrage hh1modob hh1yrdob hh1dspousage ///
	rl1primarace rl1hisplatno)	
drop _merge

//merge in additional r2 sensitive data
merge m:1 spid using "`r2s'NHATS_Round_2_SP_Sen_Dem_File.dta", ///
	keepusing(r2dintvwrage hh2dspousage r2ddeathage pd2mthdied pd2yrdied)
drop _merge

//merge in additional r3 sensitive data
merge m:1 spid using "`r3s'NHATS_Round_3_SP_Sen_Dem_File.dta", ///
	keepusing(r3dintvwrage hh3dspousage r3ddeathage pd3mthdied pd3yrdied)
drop _merge

//merge in additional r4 sensitive data
merge m:1 spid using "`r4s'NHATS_Round_4_SP_Sen_Dem_File.dta", ///
	keepusing(r4dintvwrage hh4dspousage r4ddeathage pd4mthdied pd4yrdied)
drop _merge

//3B?
//merge in tracker status information
merge m:1 spid using "`r4raw'NHATS_Round_4_Tracker_File", ///
	keepusing(yearsample r4status r4spstat r4spstatdtyr r3status r3spstat r3spstatdtyr ///
		r2status r2spstat r2spstatdtyr r1status r1spstat r1spstatdtyr)
	
//drop obs that are in tracker file but not sp file
drop if _merge==2
drop _merge	
save round_1_to_4.dta, replace

*********************************************
log close

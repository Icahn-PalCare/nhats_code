/*Combines rounds 1 and 2 sample person SP interview files,
sensitive demo files and the round 2 cumulative tracker file case 
status variables into a single file

Data format is multiple observations per subject, one for each round
*/

capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/
log using `logs'1_nhats_setup1.txt, text replace

local r1raw C:\data\nhats\round_1\
local r2raw C:\data\nhats\round_2\
local work C:\data\nhats\working
local r1s C:\data\nhats\r1_sensitive\
local r2s C:\data\nhats\r2_sensitive\

//local r1raw /Users/rebeccagorges/Documents/data/nhats/round_1/
//local r2raw /Users/rebeccagorges/Documents/data/nhats/round_2/
//local work /Users/rebeccagorges/Documents/data/nhats/working

cd `work'
*********************************************

//round 1
use `r1raw'NHATS_Round_1_SP_File.dta
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=1
la var wave "Survey wave"
save round_1_1.dta, replace
clear

//round 2
use `r2raw'NHATS_Round_2_SP_File_v2.dta
//check to make sure sample ids are unique
sort spid 
quietly by spid: gen dup = cond(_N==1,0,_n)
tab dup
gen wave=2
la var wave "Survey wave"
save round_2_1.dta, replace
clear 

//drop variables not needed
local keepallwaves spid wave r`w'dresid w`w'varunit w`w'anfinwgt0 w`w'varstrat  ///
	mo`w'out* r`w'd2intvrage hh`w'martlstat ///
	ia`w'toincim1-ia`w'toincim5 ip`w'cmedicaid rl`w'spkothlan re`w'resistrct ///
	hh`w'dlvngarrg hh`w'dhshldnum hc`w'health hc`w'disescn1-hc`w'disescn10 ///
	hc`w'depresan* is`w'resptype cp`w'chgthink* cg`w'speaktosp cg`w'todaydat* ///
	cg`w'presidna* cg`w'vpname* cg`w'dclkdraw cg`w'dwrdimmrc cg`w'dwrddlyrc ///
	hc`w'brokebon1 hc`w'fllsinmth sc`w'deathelp sc`w'dbathhelp sc`w'dtoilhelp ///
	sc`w'ddreshelp mc`w'havregdoc mc`w'regdoclyr mc`w'hwgtregd8 hc`w'hosptstay ///
	hc`w'hosovrnht
	
//round 1
foreach w in 1 2{
use round_`w'_1.dta

local keepallwaves spid wave r`w'dresid w`w'varunit w`w'anfinwgt0 w`w'varstrat  ///
	mo`w'out* r`w'd2intvrage hh`w'martlstat ///
	ip`w'cmedicaid  ///
	hh`w'dlvngarrg hh`w'dhshldnum hc`w'health hc`w'disescn1-hc`w'disescn10 ///
	hc`w'depresan* is`w'resptype cp`w'chgthink* cg`w'speaktosp cg`w'todaydat* ///
	cg`w'presidna* cg`w'vpname* cg`w'dclkdraw cg`w'dwrdimmrc cg`w'dwrddlyrc ///
	hc`w'brokebon1 hc`w'fllsinmth sc`w'deathelp sc`w'dbathhelp sc`w'dtoilhelp ///
	sc`w'ddreshelp mc`w'havregdoc mc`w'regdoclyr mc`w'hwgtregd8 hc`w'hosptstay ///
	hc`w'hosovrnht

if `w'==1 {	
keep `keepallwaves' r`w'dgender rl`w'dracehisp rl`w'spkothlan el`w'higstschl ///
ia`w'toincim1-ia`w'toincim5 re`w'resistrct
}

if `w'==2 {	
keep `keepallwaves' re2intplace re2newstrct
}

save round_`w'_ltd.dta, replace
}

//check sensitive data files, keep only some variables, merge with ltd datasets
foreach w in 1 2{
	use `r`w's'NHATS_Round_`w'_SP_Sen_Dem_File.dta
	sort spid 
	quietly by spid: gen dup = cond(_N==1,0,_n)
	tab dup	
	clear
}
/*variables I'll need to pull once I get the sensitive dataset
r`w'dintvwrage
*/

//combine 2 waves into single dataset
use round_1_ltd.dta
append using round_2_ltd.dta

//merge in sensitive data, use r1 as basis
merge m:1 spid using `r1s'NHATS_Round_1_SP_Sen_Dem_File.dta, ///
	keepusing(r1dbirthmth r1dbirthyr r1dintvwrage hh1modob hh1yrdob hh1dspousage ///
	rl1primarace rl1hisplatno)	
drop _merge

//merge in additional r2 sensitive data
merge m:1 spid using `r2s'NHATS_Round_2_SP_Sen_Dem_File.dta, ///
	keepusing(r2dintvwrage hh2dspousage r2ddeathage pd2mthdied pd2yrdied)
drop _merge

//merge in tracker status information
merge m:1 spid using `r2raw'NHATS_Round_2_Tracker_File_v2, ///
	keepusing(yearsample r2status r2spstat r2spstatdtyr r1status r1spstat r1spstatdtyr)
	
//drop obs that are in tracker file but not sp file
drop if _merge==2
drop _merge	
save round_1_2.dta, replace

*********************************************
log close

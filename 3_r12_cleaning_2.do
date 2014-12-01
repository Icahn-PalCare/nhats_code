capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'3_nhats_cleaning.txt, text replace

local work C:\data\nhats\working
//local work /Users/rebeccagorges/Documents/data/nhats/working

cd `work'
use round_1_3_cleanv1.dta
*********************************************
tab wave, missing

*********************************************
*********************************************
//self reported health status/conditions
*********************************************
*********************************************
gen srh=.
foreach w in 1 2 3{
tab hc`w'health if wave==`w', missing
replace srh=hc`w'health if wave==`w'
}
replace srh=. if inlist(srh,-9,-8,-1)

la var srh "Self reported health, categorical"
la def srh 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor"
la val srh srh
tab srh if ivw_type==1, missing

gen srh_fp=1 if srh==4 | srh==5
replace srh_fp=0 if inlist(srh,1,2,3)
la var srh_fp "Self reported health=fair/poor"
tab srh_fp srh, missing

//Self-Report Disease
//Round 1 - ever told you had xx
//Round 2 - since the last interview, new condition? 
/*
1 heart attack
2 heart disease
3 high blood pressure
4 arthritis
5 osteoporosis
6 diabetes
7 lung disease
8 stroke
9 dementia
10 cancer
create two sets of indicator variables for waves 2 and later
sr_disease_ever = 1 if ever report having the disease (only this variable in wave 1)
sr_disease_new = 1 if newly reported the disease this wave
*/

//heart attack / ami, asked both waves, for Wave 1 ask ever had, wave 2 ask in last year
gen sr_ami_raw=.
foreach w in 1 2 3{
replace sr_ami_raw=1 if hc`w'disescn1==1 & wave==`w'
replace sr_ami_raw=0 if hc`w'disescn1==2 & wave==`w'
}

la var sr_ami_raw "Self report Heart Attack, Raw"
tab sr_ami_raw wave, missing
tab sr_ami_raw wave if ivw_type==1, missing
tab sr_ami_raw ivw_type if wave==2, missing
//create two new variables from this...
gen sr_ami_ever=sr_ami_raw
replace sr_ami_ever=. if (wave==2 | wave==3) & sr_ami_raw==0 //set to missing if report no new wave

sort spid wave
by spid (wave): carryforward sr_ami_ever if ivw_type==1 , replace
la var sr_ami_ever "Ever Self report Heart Attack"
tab sr_ami_ever wave if ivw_type==1, missing

gen sr_ami_new=sr_ami_raw if wave==2 | wave==3
la var sr_ami_new "Self report Heart Attack since prev year"
tab sr_ami_new if (wave==2 | wave==3) & ivw_type==1, missing

**************************************************************************
//Many diseases asked 1st wave, then if report no, asked again 2nd wave
//wave 2,3=7 if report yes in wave 1

//use a program over several diseases since pattern is the same
// heart disease, hypertension, arthritis, osteoporosis

la def sr_prev_rept 0 "No" 1 "Yes" 7 "Previously reported"

capture program drop prev_report
program define prev_report
	args dis num
 
	gen sr_`dis'_raw=.
		foreach w in 1 2 3{
			replace sr_`dis'_raw=1 if hc`w'disescn`num'==1 & wave==`w'
			replace sr_`dis'_raw=0 if hc`w'disescn`num'==2 & wave==`w'
			replace sr_`dis'_raw=7 if hc`w'disescn`num'==7 & wave==`w'
		}

	la val sr_`dis'_raw sr_prev_rept
	tab sr_`dis'_raw wave, missing
	tab sr_`dis'_raw wave if ivw_type==1, missing

	gen sr_`dis'_ever = 1 if inlist(sr_`dis'_raw,1,7) //if prev or curr report yes
	replace sr_`dis'_ever = 0 if sr_`dis'_raw==0
	tab sr_`dis'_ever sr_`dis'_raw, missing
	tab sr_`dis'_ever wave, missing

	gen sr_`dis'_new=sr_`dis'_raw if wave==2 | wave==3
	replace sr_`dis'_new=0 if sr_`dis'_raw==7
	tab sr_`dis'_new if (wave==2 | wave==3) & ivw_type==1, missing

	end
	
prev_report heart_dis 2
prev_report htn 3
prev_report ra 4
prev_report osteoprs 5

la var sr_heart_dis_ever "Self report Heart Disease"
la var sr_heart_dis_new "Self report Heart Disease since prev year"
la var sr_htn_ever "Self report high blood pressure"
la var sr_htn_new "Self report high blood pressure since prev year"
la var sr_ra_ever "Self report arthritis"
la var sr_ra_new "Self report arthritis"
la var sr_osteoprs_ever "Self report osteoporosis"
la var sr_osteoprs_new "Self report osteoporosis"


**************************************************************************
//arthritis, asked 1st wave, then if report no, asked again 2nd wave
//wave 2=7 if report yes in wave 1
foreach w in 1 2 3{
tab hc`w'disescn5 if wave==`w', missing
}



/*
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound): tab `var', percent col count format(%10.0g)
}
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound if levelzero==1): tab `var', percent col count format(%10.0g)
}
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound if levelone==1): tab `var', percent col count format(%10.0g)
}
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound if leveltwo==1): tab `var', percent col count format(%10.0g)
}
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound if levelthree==1): tab `var', percent col count format(%10.0g)
}
foreach var of varlist hc1disescn1-hc1disescn10 {
svy, subpop(homebound if levelfour==1): tab `var', percent col count format(%10.0g)
}*/

*************************************************
log close

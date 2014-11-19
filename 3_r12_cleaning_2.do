capture log close
clear all
set more off

//local logs C:\data\nhats\logs\
local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'3_nhats_cleaning.txt, text replace

//local work C:\data\nhats\working
local work /Users/rebeccagorges/Documents/data/nhats/working

cd `work'
use round_1_2_cleanv1.dta
*********************************************
tab wave, missing

*********************************************
*********************************************
//self reported health status/conditions
*********************************************
*********************************************
gen srh=.
foreach w in 1 2{
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
*/

//heart attack / ami, asked both waves, for Wave 1 ask ever had, wave 2 ask in last year
gen sr_ami=.
foreach w in 1 2{
replace sr_ami=1 if hc`w'disescn1==1 & wave==`w'
replace sr_ami=0 if hc`w'disescn1==2 & wave==`w'
}

la var sr_ami "Self report Heart Attack"
tab sr_ami wave, missing

//heart disease, asked 1st wave, then if report no, asked again 2nd wave
//wave 2=7 if report yes in wave 1
gen sr_heart_dis=.
foreach w in 1 2{
replace sr_heart_dis=1 if hc`w'disescn2==1 & wave==`w'
replace sr_heart_dis=0 if hc`w'disescn2==2 & wave==`w'
replace sr_heart_dis=7 if hc`w'disescn2==7 & wave==`w'

}
la def sr_prev_rept 0 "No" 1 "Yes" 7 "Previously reported"
la val sr_heart_dis sr_prev_rept
tab sr_heart_dis wave, missing


tab hc1disescn1 hc2disescn1, missing
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

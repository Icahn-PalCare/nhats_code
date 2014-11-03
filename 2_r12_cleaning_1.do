capture log close
clear all
set more off

//local logs C:\data\nhats\logs
local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'2_nhats_cleaning.txt, text replace

//local work C:\data\nhats\working
local work /Users/rebeccagorges/Documents/data/nhats/working

cd `work'
use round_1_2.dta
*********************************************
tab wave, missing

*********************************************
//interview type, varies by wave, use tracker status variables

gen ivw_type=3
replace ivw_type=1 if r1spstat==20 & wave==1 | (r2spstat==20 & r2status!=62) & wave==2
replace ivw_type=2 if (r2spstat==20 & r2status==62) & wave==2
la def ivw_type 1 "Alive, SP interview completed" 2"Died, proxy SP LML interview completed" ///
	3"SP interview not completed"
la val ivw_type ivw_type
tab ivw_type wave, missing

tab r1status if wave==1, missing
tab r1spstat if wave==1, missing
gen sp_ivw_yes=1 if r1spstat==20 & wave==1
replace sp_ivw_yes=0 if inlist(r1spstat,11,24) & wave==1

tab r2status r2spstat if wave==2, missing
replace sp_ivw_yes=1 if r2spstat==20 & wave==2
replace sp_ivw_yes=0 if inlist(r2spstat,11,12,24) & wave==2

la var sp_ivw_yes "SP interview conducted? yes=1"
tab sp_ivw_yes wave, missing

gen lml_ivw_yes = 0
replace lml_ivw_yes=1 if r2spstat==20 & r2status==62 & wave==2
la var lml_ivw_yes "LWL interview? yes=1"

tab sp_ivw_yes lml_ivw_yes, missing
tab lml_ivw_yes wave, missing

tab mo2outoft r2status if wave==2, missing

/*missing data convention per user guide
For our purposes, code all as missing
The following codes were used at the item level for missing data of different types:
-7 = Refusal
-8 = Don’t Know
-1 = Inapplicable
-9 = Not Ascertained*/
local miss -9,-8,-7,-1

//definitions of homebound
gen freq_go_out=.
foreach w in 1 2{
	tab mo`w'outoft, missing
	replace freq_go_out=mo`w'outoft if wave==`w'
}
replace freq_go_out=. if inlist(freq_go_out,`miss')
la def freq_go_out 1 "Every day" 2 "Most days (5-6/week)" ///
	3 "Some days (2-4/week)" 4 "Rarely" 5 "Never"
la val 	freq_go_out freq_go_out
la var freq_go_out "How often go outside"
tab freq_go_out sp_ivw_yes if wave==1, missing
tab freq_go_out sp_ivw_yes if wave==2 & lml_ivw_yes==0, missing
tab freq_go_out sp_ivw_yes if wave==2 & lml_ivw_yes==1, missing

tab freq_go_out r2status if wave==2 & lml_ivw_yes==1, missing


*********************************************
log close

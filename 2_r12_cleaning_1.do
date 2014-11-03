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
//residential status - determines if SP interview questions are inapplicable
//sp questions not asked if resid status = 3 or 4


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
tab freq_go_out, missing

*********************************************
log close

capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'4_nhats_cleaning.txt, text replace

local work C:\data\nhats\working
//local work /Users/rebeccagorges/Documents/data/nhats/working

cd `work'
use round_1_3_cleanv2.dta
*********************************************
//fall in the last month
gen fall_last_month=.
foreach w in 1 2 3{
	replace fall_last_month=1 if hc`w'fllsinmth==1 & wave==`w'
	replace fall_last_month=0 if hc`w'fllsinmth==2 & wave==`w'
}
la var fall_last_month "Fall down in last month"
tab fall_last_month wave, missing

*********************************************
//self care help, using the derived variables in the SC section
//uses the "has help" variables (has difficulty, uses devices other options)
//if don't know, refused, or not done, set to missing
tab sc1deathelp, missing

capture program drop selfcare
program define selfcare
	args act
	
	gen adl_`act'_help=.
	foreach w in 1 2 3{
		replace adl_`act'_help=1 if sc`w'd`act'help==2 & wave==`w' //yes
		replace adl_`act'_help=0 if sc`w'd`act'help==1 & wave==`w' //no
	}
	tab adl_`act'_help wave, missing
	tab adl_`act'_help wave if ivw_type==1, missing
	
end	
	
selfcare eat
selfcare bath
selfcare toil
selfcare dres

la var adl_eat_help "Has help while eating"
la var adl_bath_help "Has help while bathing"
la var adl_toil_help "Has help while toileting"
la var adl_dres_help "Has help while dressing"

*********************************************
//has , sees regular doctor
gen reg_doc_have = .
foreach w in 1 2 3{
	replace reg_doc_have=1 if mc`w'havregdoc==1
	replace reg_doc_have=0 if mc`w'havregdoc==2
}
la var reg_doc_have "Have regular doctor"
tab reg_doc_have wave, missing
tab reg_doc_have wave if ivw_type==1, missing

gen reg_doc_seen = .
foreach w in 1 2 3{
	replace reg_doc_seen=1 if mc`w'regdoclyr==1 & wave==`w'
	replace reg_doc_seen=0 if mc`w'regdoclyr==2 & wave==`w'
}
la var reg_doc_seen "Seen regular doctor within last year"
tab reg_doc_seen wave, missing
tab reg_doc_seen wave if ivw_type==1, missing

//home visit, missing if did not see regular doctor within the last year
tab mc1regdoclyr mc1hwgtregd8 if wave==1, missing

gen reg_doc_homevisit = .
foreach w in 1 2 3{
	replace reg_doc_homevisit=1 if mc`w'hwgtregd8==1
	replace reg_doc_homevisit=0 if mc`w'hwgtregd8==2
}
la var reg_doc_homevisit "Was regular doctor visit a home visit?"
tab reg_doc_homevisit wave, missing
tab reg_doc_homevisit wave if ivw_type==1, missing

//hospital stay last 12 months?
tab hc1hosptstay, missing

gen sr_hosp_ind=.
foreach w in 1 2 3{
	replace sr_hosp_ind=1 if hc`w'hosptstay==1
	replace sr_hosp_ind=0 if hc`w'hosptstay==2
}
la var sr_hosp_ind "Hospital stay in the last year 1=yes"
tab sr_hosp_ind wave, missing
tab sr_hosp_ind wave if ivw_type==1, missing

//number of separate hospital stays?
tab hc1hosovrnht hc1hosptstay, missing //if ind=no above, raw variable is n/a
gen sr_hosp_stays=.
foreach w in 1 2 3{
	replace sr_hosp_stays=hc`w'hosovrnht if hc`w'hosovrnht>0 & wave==`w'
}
replace sr_hosp_stays=0 if sr_hosp_ind==0 //set to 0 if none reported in y/n ? above
la var sr_hosp_stays "Number unique hospital stays last year"
tab sr_hosp_stays wave, missing
tab sr_hosp_stays wave if ivw_type==1, missing

save round_1_3_cleanv3.dta, replace

*********************************************
log close

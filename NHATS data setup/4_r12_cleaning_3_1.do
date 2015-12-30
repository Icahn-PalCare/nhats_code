capture log close
clear all
set more off

local logs "E:\nhats\nhats_code\NHATS data setup\logs"
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using "`logs'4_nhats_cleaning.txt", text replace

local work "E:\nhats\data\NHATS working data\"
//local work /Users/rebeccagorges/Documents/data/nhats/working

cd "`work'"
use round_1_4_cleanv2.dta

*********************************************
//fall in the last month
gen fall_last_month=.
foreach w in 1 2 3 4{
	replace fall_last_month=1 if hc`w'fllsinmth==1 & wave==`w'
	replace fall_last_month=0 if hc`w'fllsinmth==2 & wave==`w'
	replace fall_last_month = -7 if hc`w'fllsinmth==-7 & wave==`w'
	replace fall_last_month = -8 if hc`w'fllsinmth==-8 & wave==`w'
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
	foreach w in 1 2 3 4{
		replace adl_`act'_help=1 if sc`w'`act'hlp==1 & wave==`w' //yes
		replace adl_`act'_help=0 if sc`w'`act'hlp==2 & wave==`w' //no
		replace adl_`act'_help=-7 if sc`w'`act'hlp==-7 & wave==`w' //refused
		replace adl_`act'_help=-8 if sc`w'`act'hlp==-8 & wave==`w' //DK

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
//household activity help, using derived variables in the HA section
//if did not do by self b/c of health
//reason only or health and other reason, then new help var ==1
tab ha1dlaunsfdf ha1dlaunreas if wave==1, missing
tab ha2dlaunsfdf ha2dlaunreas if wave==2, missing

capture program drop hhact
program define hhact
	args act
	
	gen iadl_`act'_help=.
	foreach w in 1 2 3 4 {
		replace iadl_`act'_help=1 if inlist(ha`w'd`act'sfdf,1,8) & ///
			inlist(ha`w'd`act'reas,1,3) & wave==`w'
		replace iadl_`act'_help=0 if inlist(ha`w'd`act'sfdf,2,3,6) & wave==`w' //did by self
		replace iadl_`act'_help=0 if inlist(ha`w'd`act'sfdf,1,8) & ///
			inlist(ha`w'd`act'reas,2,4) & wave==`w'		
		replace iadl_`act'_help=-8 if inlist(ha`w'd`act'sfdf,4,5,7) & wave==`w' //dkrf
		replace iadl_`act'_help=-8 if inlist(ha`w'd`act'sfdf,1,8) & ///
			inlist(ha`w'd`act'reas,-7,-8) & wave==`w'
		
	}	
	tab iadl_`act'_help wave, missing
	tab iadl_`act'_help wave if ivw_type==1, missing
	end
	
hhact laun
hhact shop
hhact meal
hhact bank

la var iadl_laun_help "Rec'd help doing laundry last month"
la var iadl_shop_help "Rec'd help shopping last month"
la var iadl_meal_help "Rec'd help preparing meals last month"
la var iadl_bank_help "Rec'd help with banking last month"
 
//taking medications, questions slightly different and in mc section
//set to =0 if do not take medications
tab mc1dmedssfdf mc1dmedsreas if wave==1, missing
tab mc2dmedssfdf mc2dmedsreas if wave==2, missing

gen iadl_meds_help=.
foreach w in 1 2 3 4{
	replace iadl_meds_help=1 if inlist(mc`w'dmedssfdf,1,8) & ///
		inlist(mc`w'dmedsreas,1,3) & wave==`w'
	//did by self or don't take medications
	replace iadl_meds_help=0 if inlist(mc`w'dmedssfdf,2,3,6,9) & wave==`w' 
	replace iadl_meds_help=0 if inlist(mc`w'dmedssfdf,1,8) & ///
		inlist(mc`w'dmedsreas,2,4) & wave==`w'		
	replace iadl_meds_help=-8 if mc`w'dmedssfdf == 7 & wave==`w' 
	replace iadl_meds_help=-8 if inlist(mc`w'dmedssfdf,1,8) & ///
		inlist(mc`w'dmedsreas,-7,-8) & wave==`w'
	}	

la var iadl_meds_help "Rec'd help taking medications last month"
tab iadl_meds_help wave, missing
tab iadl_meds_help wave if ivw_type==1, missing


*********************************************
//has , sees regular doctor
gen reg_doc_have = .
foreach w in 1 2 3 4{
	replace reg_doc_have=1 if mc`w'havregdoc==1
	replace reg_doc_have=0 if mc`w'havregdoc==2
	replace reg_doc_have=-7 if mc`w'havregdoc==-7
	replace reg_doc_have=-8 if mc`w'havregdoc==-8
}
la var reg_doc_have "Have regular doctor"
tab reg_doc_have wave, missing
tab reg_doc_have wave if ivw_type==1, missing

gen reg_doc_seen = .
foreach w in 1 2 3 4{
	replace reg_doc_seen=1 if mc`w'regdoclyr==1 & wave==`w'
	replace reg_doc_seen=0 if mc`w'regdoclyr==2 & wave==`w'
	replace reg_doc_seen=-7 if mc`w'regdoclyr==-7 & wave==`w'
	replace reg_doc_seen=-8 if mc`w'regdoclyr==-8 & wave==`w'
}
la var reg_doc_seen "Seen regular doctor within last year"
tab reg_doc_seen wave, missing
tab reg_doc_seen wave if ivw_type==1, missing

//home visit, missing if did not see regular doctor within the last year
tab mc1regdoclyr mc1hwgtregd8 if wave==1, missing

gen reg_doc_homevisit = .
foreach w in 1 2 3 4{
	replace reg_doc_homevisit=1 if mc`w'hwgtregd8==1
	replace reg_doc_homevisit=0 if mc`w'hwgtregd8==2
	replace reg_doc_homevisit=-7 if mc`w'hwgtregd8==-7
	replace reg_doc_homevisit=-8 if mc`w'hwgtregd8==-8
	//replace reg_doc_homevisit=0 if mc`w'regdoclyr==2
}
la var reg_doc_homevisit "Was regular doctor visit a home visit?"
tab reg_doc_homevisit wave, missing
tab reg_doc_homevisit wave if ivw_type==1, missing

//hospital stay last 12 months?
tab hc1hosptstay, missing

gen sr_hosp_ind=.
foreach w in 1 2 3 4{
	replace sr_hosp_ind=1 if hc`w'hosptstay==1
	replace sr_hosp_ind=0 if hc`w'hosptstay==2
	replace sr_hosp_ind=-7 if hc`w'hosptstay==-7
	replace sr_hosp_ind=-8 if hc`w'hosptstay==-8
}
la var sr_hosp_ind "Hospital stay in the last year 1=yes"
tab sr_hosp_ind wave, missing
tab sr_hosp_ind wave if ivw_type==1, missing

//number of separate hospital stays?
tab hc1hosovrnht hc1hosptstay, missing //if ind=no above, raw variable is n/a
gen sr_hosp_stays=.
foreach w in 1 2 3 4{
	replace sr_hosp_stays=hc`w'hosovrnht if hc`w'hosovrnht>0 & wave==`w'
}
replace sr_hosp_stays=0 if sr_hosp_ind==0 //set to 0 if none reported in y/n ? above
la var sr_hosp_stays "Number unique hospital stays last year"
tab sr_hosp_stays wave, missing
tab sr_hosp_stays wave if ivw_type==1, missing

save round_1_4_cleanv3.dta, replace

local ivars fall_last_month adl_eat_help adl_bath_help adl_toil_help adl_dres_help iadl_laun_help iadl_shop_help ///
iadl_meal_help iadl_bank_help iadl_meds_help reg_doc_have reg_doc_seen reg_doc_homevisit sr_hosp_ind sr_hosp_stays
foreach w in `ivars'{
tab `w' wave,missing
}

*********************************************
log close

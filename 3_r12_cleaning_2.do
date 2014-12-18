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

*********************************************
//Self-Report Disease
*********************************************
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
//same questions for stroke, cancer

capture program drop disease
program define disease 
	args dis num
	
	gen sr_`dis'_raw=.
	foreach w in 1 2 3{
		replace sr_`dis'_raw=1 if hc`w'disescn`num'==1 & wave==`w'
		replace sr_`dis'_raw=0 if hc`w'disescn`num'==2 & wave==`w'
	}
	//create two new variables from this...
	gen sr_`dis'_ever=sr_`dis'_raw
	replace sr_`dis'_ever=. if (wave==2 | wave==3) & sr_`dis'_raw==0 //set to missing if report no new wave

	sort spid wave
	by spid (wave): carryforward sr_`dis'_ever if ivw_type==1 , replace

	gen sr_`dis'_new=sr_`dis'_raw if wave==2 | wave==3

	end

//now run programs for specific disease variables
disease ami 1
disease stroke 8
disease cancer 10

la var sr_ami_raw "Self report Heart Attack, Raw"
la var sr_ami_ever "Ever Self report Heart Attack"
la var sr_ami_new "Self report Heart Attack since prev year"
la var sr_stroke_raw "Self report Stroke, Raw"
la var sr_stroke_ever "Ever Self report Stroke"
la var sr_stroke_new "Self report Stroke since prev year"
la var sr_cancer_raw "Self report Cancer, Raw"
la var sr_cancer_ever "Ever Self report Cancer"
la var sr_cancer_new "Self report Cancer since prev year"

foreach dis in ami stroke cancer{
tab sr_`dis'_raw wave if ivw_type==1, missing
tab sr_`dis'_ever wave if ivw_type==1, missing
tab sr_`dis'_new wave if ivw_type==1, missing
}

**************************************************************************
//Many diseases asked 1st wave, then only if report no, asked again 2nd wave
//wave 2,3=7 if report yes in wave 1
//use a program over several diseases since pattern is the same

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
	tab sr_`dis'_raw wave if ivw_type==1, missing

	gen sr_`dis'_ever = 1 if inlist(sr_`dis'_raw,1,7) //if prev or curr report yes
	replace sr_`dis'_ever = 0 if sr_`dis'_raw==0
	tab sr_`dis'_ever sr_`dis'_raw, missing
	tab sr_`dis'_ever wave if ivw_type==1, missing

	gen sr_`dis'_new=sr_`dis'_raw if wave==2 | wave==3
	replace sr_`dis'_new=0 if sr_`dis'_raw==7
	tab sr_`dis'_new if (wave==2 | wave==3) & ivw_type==1, missing

	end

//now run programs for specific disease variables
prev_report heart_dis 2
prev_report htn 3
prev_report ra 4
prev_report osteoprs 5
prev_report diabetes 6
prev_report lung_dis 7
prev_report dementia 9

la var sr_heart_dis_ever "Self report Heart Disease"
la var sr_heart_dis_new "Self report Heart Disease since prev year"
la var sr_htn_ever "Self report high blood pressure"
la var sr_htn_new "Self report high blood pressure since prev year"
la var sr_ra_ever "Self report arthritis"
la var sr_ra_new "Self report arthritis since prev year"
la var sr_osteoprs_ever "Self report osteoporosis"
la var sr_osteoprs_new "Self report osteoporosis since prev year"
la var sr_diabetes_ever "Self report osteoporosis"
la var sr_diabetes_new "Self report osteoporosis since prev year"
la var sr_lung_dis_ever "Self report Lung Disease"
la var sr_lung_dis_new "Self report Lung Disease since prev year"
la var sr_dementia_ever "Self report Dementia"
la var sr_dementia_new "Self report Dementia since prev year"

*************************************************
//Depression & Anxiety
//Over the last month how often have you:
//responses are 1=not at all, 2=several days, 3=more than half days, 4=nearly every day
*************************************************
gen sr_depr_pqq1=.
gen sr_depr_pqq2=.
gen sr_anx_gad1=.
gen sr_anx_gad2=.

foreach w in 1 2 3{
	//set up new variables for individual wave variables
	foreach q in 1 2 3 4{
	gen temp_hc`w'deprsan`q'=. if inlist(hc`w'depresan`q',-9,-8,-7,-1)
	replace temp_hc`w'deprsan`q'=hc`w'depresan`q'-1 if inlist(hc`w'depresan`q',1,2,3,4)
	}
	//now create clean depression, anxiety variables
	replace sr_depr_pqq1=temp_hc`w'deprsan1 if wave==`w' //little interest or pleasure in doing things
	replace sr_depr_pqq2=temp_hc`w'deprsan2 if wave==`w' //felt down/depressed/hopeless
	replace sr_anx_gad1=temp_hc`w'deprsan3 if wave==`w' //felt nervous or anxious
	replace sr_anx_gad2=temp_hc`w'deprsan4 if wave==`w' //unable to stop worrying

	foreach q in 1 2 3 4{
	drop temp_hc`w'deprsan`q'
	}
	
}

la def depr_anx 0"Not at all" 1"Several days" 2"More than half the days" ///
3"Nearly every day"
la val sr_depr_pqq1 sr_depr_pqq2 sr_anx_gad1 sr_anx_gad2 depr_anx
la var sr_depr_pqq1 "How often little interest in doing things?"
la var sr_depr_pqq2 "How often felt down, depressed, hopeless?"
la var sr_anx_gad1 "How often felt nervous or anxious?"
la var sr_anx_gad2 "How often unable to stop worrying?"

foreach v in sr_depr_pqq1 sr_depr_pqq2 sr_anx_gad1 sr_anx_gad2{
	tab `v' wave if ivw_type==1,missing
}

//combined phq-2 score for depression, cutoff 3+=depressed
gen sr_phq2_score=sr_depr_pqq1+sr_depr_pqq2
gen sr_phq2_depressed=1 if sr_phq2_score>=3 & sr_phq2_score~=.
replace sr_phq2_depressed=0 if sr_phq2_score<3 & sr_phq2_score~=.
la var sr_phq2_score "PHQ-2 combined score 0-6 scale"
la var sr_phq2_depressed "Depressed per PHQ-2, score=3+"
tab sr_phq2_score sr_phq2_depressed if ivw_type==1, missing

//combined gad-2 score for anxiety, cutoff 3+=anxiety
gen sr_gad2_score=sr_anx_gad1+sr_anx_gad2
gen sr_gad2_anxiety=1 if sr_gad2_score>=3 & sr_gad2_score~=.
replace sr_gad2_anxiety=0 if sr_gad2_score<3 & sr_gad2_score~=.
la var sr_gad2_score "GAD-2 combined score 0-6 scale"
la var sr_gad2_anxiety "Anxiety per GAD-2, score=3+"
tab sr_gad2_score sr_gad2_anxiety if ivw_type==1, missing

*************************************************
//Dementia
//separate variables for proxy vs self interviews
*************************************************
tab proxy_ivw ivw_type, missing

//for proxy interviews, get ad8 score
forvalues i = 1/8{
gen pr_ad8_`i'=-1 if proxy_ivw==0 | proxy_ivw==. //set to n/a if not proxy ivw
foreach w in 1 2 3{
	replace pr_ad8_`i'=1 if inlist(cp`w'chgthink`i',1,3) & wave==`w' //yes or dementia reported
	replace pr_ad8_`i'=0 if cp`w'chgthink`i'==2 & wave==`w' //no
	}
tab pr_ad8_`i' wave, missing
tab pr_ad8_`i' wave if proxy_ivw==1, missing
}

tab pr_ad8_1 cp2dad8dem if wave==2 & proxy_ivw==1, missing //previous proxy ivw ad8 items indicated dementia
tab pr_ad8_1 sr_dementia_ever if wave==2 & proxy_ivw==1, missing // reported dementia directly

*************************************************
log close

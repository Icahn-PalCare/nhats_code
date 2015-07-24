capture log close
clear all
set more off

local logs E:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'3_nhats_cleaning.txt, text replace

local work E:\data\nhats\working
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

//same question pattern, different variable name though, for hip fracture
gen sr_hip_raw=.
foreach w in 1 2 3{
	replace sr_hip_raw=1 if hc`w'brokebon1==1 & wave==`w'
	replace sr_hip_raw=0 if hc`w'brokebon1==2 & wave==`w'
}
//create two new variables from this...
gen sr_hip_ever=sr_hip_raw
replace sr_hip_ever=. if (wave==2 | wave==3) & sr_hip_raw==0 //set to missing if report no new wave

sort spid wave
by spid (wave): carryforward sr_hip_ever if ivw_type==1 , replace

gen sr_hip_new=sr_hip_raw if wave==2 | wave==3
la var sr_hip_raw "Self report Hip Fracture, Raw"
la var sr_hip_ever "Ever Self report Hip Fracture (since age 50)"
la var sr_hip_new "Self report Hip Fracture since prev year"

foreach dis in ami stroke cancer hip{
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
tab sr_gad2_anxiety wave, missing

*************************************************
//Dementia, based on NHATS technical paper no. 5, expanded for 3 waves
//separate variables for proxy vs self interviews
*************************************************
tab proxy_ivw ivw_type, missing

//Initialize 3 category dementia variable
//probable dementia, possible dementia, no dementia
//probable = diagnosis reported or 2+ ad8 questions (proxy) or <1.5 SD below mean
gen dem_3_cat=-1 if ivw_type!=1 //set to na if not SP interview
replace dem_3_cat=1 if sr_dementia_ever==1 //if reported directly

//for proxy interviews, use ad8 score
forvalues i = 1/8{
gen pr_ad8_`i'=-1 //initialize to n/a
replace pr_ad8_`i'=. if proxy_ivw==1 & dem_3_cat==. //set missing if proxy ivw w/o direct report dementia
foreach w in 1 2 3{
	replace pr_ad8_`i'=1 if inlist(cp`w'chgthink`i',1,3) & wave==`w' & dem_3_cat==. & proxy_ivw==1 //yes or dementia reported
	replace pr_ad8_`i'=0 if inlist(cp`w'chgthink`i',2,-8) & wave==`w' & dem_3_cat==. &  proxy_ivw==1 //no or don't know
	}	
tab pr_ad8_`i' wave, missing
tab pr_ad8_`i' wave if proxy_ivw==1, missing
}

tab pr_ad8_3 cp1chgthink3 if wave==1, missing
tab cp2chgthink1 cp2dad8dem if wave==2 & proxy_ivw==1, missing //previous proxy ivw ad8 items indicated dementia

tab pr_ad8_1 wave, missing
tab pr_ad8_1 cp2dad8dem if wave==2 & proxy_ivw==1, missing //previous proxy ivw ad8 items indicated dementia
tab pr_ad8_1 sr_dementia_ever if wave==2 & proxy_ivw==1, missing // reported dementia directly

gen pr_ad8_score=(pr_ad8_1+pr_ad8_2+pr_ad8_3+pr_ad8_4+pr_ad8_5+pr_ad8_6+pr_ad8_7+pr_ad8_8) if proxy_ivw==1 & dem_3_cat==.
tab pr_ad8_score proxy_ivw, missing
tab pr_ad8_score wave, missing

gen dem_via_proxy=1 if pr_ad8_score>=2 & pr_ad8_score~=. //from ad8 score directly
replace dem_via_proxy=0 if inlist(pr_ad8_score,0,1)
replace dem_via_proxy=1 if (cp2dad8dem==1 | cp3dad8dem==1) & proxy_ivw==1 //if previous interview ad8 indicated dementia
replace dem_via_proxy=-1 if sr_dementia_ever==1
tab dem_via_proxy wave if proxy_ivw==1 & ivw_type==1, missing

//set 3 category dementia state variable
//first xwave variable for proxy allowed sp to answer cg section
gen speaktosp=.
foreach w in 1 2 3{
	replace speaktosp=cg`w'speaktosp if wave==`w'
}

replace dem_3_cat=1 if dem_3_cat==. & dem_via_proxy==1 //if proxy ivw indicates dem
replace dem_3_cat=3 if dem_3_cat==. & dem_via_proxy==0 & speaktosp==2  //proxy ind no dem
tab dem_3_cat wave, missing
*************************************************
//for self interviews
*************************************************
//current date questions
tab cg1todaydat1 cg1speaktosp if wave==1 & ivw_type==1, missing

forvalues i = 1/4{
	gen date_item`i'=.
	foreach w in 1 2 3{
		replace date_item`i'=1 if cg`w'todaydat`i'==1 & wave==`w' //yes
		replace date_item`i'=0 if inlist(cg`w'todaydat`i',2,-7) & wave==`w' //no, dont know, refused
	}
}
//count date questions correct
gen date_sum=date_item1+date_item2+date_item3+date_item4
tab date_sum wave, missing

//add categories for proxy says can't speak to sp or proxy says can speak but sp unble to answer
foreach w in 1 2 3{
	replace date_sum=-2 if date_sum==. & cg`w'speaktosp==2 & wave==`w'
	replace date_sum=-3 if (date_item1==. | date_item2==. | date_item3==. | ///
		date_item4==. ) & cg`w'speaktosp==1 & wave==`w'
}
tab date_sum wave, missing

//new version date sum measure, without the extra categories
gen date_sumr=date_sum
replace date_sumr=. if date_sum==-2
replace date_sumr=0 if date_sum==-3

//president/vp items and count
capture program drop president 
program define president
	args newv oldv
	gen `newv'=.	
	foreach w in 1 2 3{
		replace `newv'=1 if cg`w'`oldv'==1  & wave==`w' //yes
		replace `newv'=0 if inlist(cg`w'`oldv',2,-7) & wave==`w' //no, refused
	}
	tab `newv' wave, missing
end

president preslast presidna1	
president presfirst presidna3
president vplast vpname1
president vpfirst vpname3

//count president questions correct
gen presvp=preslast+presfirst+vplast+vpfirst
tab presvp wave, missing

//add categories for proxy says can't speak to sp or proxy says can speak but sp unble to answer
foreach w in 1 2 3{
	replace presvp=-2 if presvp==. & cg`w'speaktosp==2 & wave==`w'
	replace presvp=-3 if presvp==. & (preslast==. | presfirst==. | vplast==. | ///
		vpfirst==. ) & cg`w'speaktosp==1 & wave==`w'
}
tab presvp wave, missing

//new version president sum measure, without the extra categories
gen presvpr=presvp
replace presvpr=. if presvp==-2
replace presvpr=0 if presvp==-3

//total orientation domain, date and president questions
gen date_prvp=date_sumr+presvpr
tab date_prvp, missing

//executive function domain, clock drawing score
gen clock_scorer=.
foreach w in 1 2 3{
	replace clock_scorer=cg`w'dclkdraw if wave==`w'
	replace clock_scorer=. if inlist(cg`w'dclkdraw,-2,-9) & wave==`w' //missing
	replace clock_scorer=0 if inlist(cg`w'dclkdraw,-3,-4,-7) & wave==`w' //refused,unable
//assign mean values where missing response
	replace clock_scorer=2 if cg`w'dclkdraw==-9 & cg`w'speaktosp==1 & wave==`w' //proxy
	replace clock_scorer=3 if cg`w'dclkdraw==-9 & cg`w'speaktosp==-1 & wave==`w' //self
	}
tab clock_scorer wave, missing //left as -1 if inapplicable

//memory domain, word recall, uses derived scores, not raw responses
capture program drop recall
program define recall
	args newv oldv
	gen `newv'=.
	foreach w in 1 2 3{
		replace `newv'=cg`w'`oldv' if wave==`w'
		replace `newv'=. if inlist(cg`w'`oldv',-2,-1) & wave==`w' //n/a or not asked
		replace `newv'=0 if inlist(cg`w'`oldv',-7,-3) & wave==`w' //refused or unable
	}
	tab `newv' wave, missing
end

recall irecall dwrdimmrc
recall drecall dwrddlyrc

gen wordrecall0_20=irecall+drecall

//overall cognitive domain score, assigns cutoffs for each of the domain variables
gen clock65=0 if clock_scorer>1 & clock_scorer<=5
replace clock65=1 if inlist(clock_scorer,0,1)

gen word65=0 if wordrecall0_20>3 & wordrecall0_20<=20
replace word65=1 if inlist(wordrecall0_20,0,1,2,3)

gen datena65=0 if date_prvp>3 & date_prvp<=8
replace datena65=1 if inlist(date_prvp,0,1,2,3)

gen domain65=clock65+word65+datena65
tab domain65 wave, missing

//now apply to dementia 3 category variable
replace dem_3_cat=1 if dem_3_cat==. & inlist(speaktosp,1,-1) & inlist(domain65,2,3)
replace dem_3_cat=2 if dem_3_cat==. & inlist(speaktosp,1,-1) & domain65==1
replace dem_3_cat=3 if dem_3_cat==. & inlist(speaktosp,1,-1) & domain65==0

la def dem3 1"Probable dementia" 2"Possible dementia" 3"No dementia"
la val dem_3_cat dem3
la var dem_3_cat "Dementia likelihood, 3 categories"

tab dem_3_cat wave, missing

gen dem_2_cat=1 if inlist(dem_3_cat,1,2)
replace dem_2_cat=0 if dem_3_cat==3
la var dem_2_cat "Ind prob/possible dementia"
tab dem_2_cat wave, missing
*************************************************
//rate memory
gen memory=.
foreach w in 1 2 3{
replace memory=cg`w'ratememry if wave==`w'&proxy_ivw==0 //self interview
replace memory=cp`w'memrygood if wave==`w'&proxy_ivw==1 //proxy interview
}
replace memory=. if inlist(memory,-8,-7,-1)
la var memory "Rate memory 1=Excell, 5=Poor"
la def mem 1"Excellent" 2"Very good" 3"Good" 4"Fair" 5"Poor"
la val memory mem
tab memory wave, missing

*************************************************
//total number self reported medical conditions, ever
//note that depression and anxeity are from the specific interview questions
//the others are all if the person has reported the condition in any interview wave
egen sr_numconditions1=anycount(sr_ami_ever sr_stroke_ever sr_cancer_ever ///
	sr_hip_ever sr_heart_dis_ever sr_htn_ever sr_ra_ever sr_osteoprs_ever ///
	sr_diabetes_ever sr_lung_dis_ever sr_dementia_ever sr_phq2_depressed ///
	sr_gad2_anxiety), values(1)
replace sr_numconditions1=. if ivw_type!=1
la var 	sr_numconditions1 "Count medical conditions"
tab sr_numconditions1 wave, missing

*************************************************
save round_1_3_cleanv2.dta, replace

*************************************************
log close

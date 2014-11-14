capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/

log using `logs'2_nhats_cleaning.txt, text replace

local work C:\data\nhats\working
//local work /Users/rebeccagorges/Documents/data/nhats/working

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

tab r1status r1spstat if wave==1, missing
tab r1dresid r1spstat if wave==1, missing
//compare to old code, if r1dresid=1 or 2, then include in homebound paper
//so use ivw type=1 is the same thing for r1

gen sp_ivw_yes=1 if r1spstat==20 & wave==1
replace sp_ivw_yes=0 if inlist(r1spstat,11,24) & wave==1

tab r2status r2spstat if wave==2, missing
replace sp_ivw_yes=1 if r2spstat==20 & wave==2
replace sp_ivw_yes=0 if inlist(r2spstat,11,12,24) & wave==2

la var sp_ivw_yes "SP interview conducted? yes=1" //note this includes lml interviews
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

*********************************************
//definitions of homebound
//how often go out of the house?
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
tab freq_go_out sp_ivw_yes, missing
tab freq_go_out sp_ivw_yes if wave==1, missing
tab freq_go_out sp_ivw_yes if wave==2 & lml_ivw_yes==0, missing
tab freq_go_out sp_ivw_yes if wave==2 & lml_ivw_yes==1, missing

//MO questions not asked in lml interviews where persons were not alert(PD6)
//or not mobile(PD7) in last month so lml has more missingless
tab freq_go_out mo2outoft if wave==2 & lml_ivw_yes==1, missing

*********************************************
//Did anyone ever help you - asked if report going outside
//left missing if report never go outside
gen help_go_out=.
foreach w in 1 2{
	tab mo`w'outhlp, missing
	replace help_go_out=1 if mo`w'outhlp==1
	replace help_go_out=0 if mo`w'outhlp==2
}
la var help_go_out "Anyone ever help you leave home?"
tab help_go_out wave if sp_ivw_yes==1, missing

*********************************************
//go out of the house on own?
//only asked if report having help when go outside (help_go_out==1)
gen out_on_own=.
foreach w in 1 2{
	tab mo`w'outslf help_go_out if wave==`w', missing
	replace out_on_own=mo`w'outslf if wave==`w'
}
replace out_on_own=. if inlist(out_on_own,`miss')
replace out_on_own=5 if help_go_out==0
replace out_on_own=6 if freq_go_out==5
la def out_on_own 1"Most times" 2"Sometimes" 3"Rarely" 4"Never"5"NA, reported no help" ///
6"NA, never left home"
la val out_on_own out_on_own
la var out_on_own "When left house, left by yourself?"
tab out_on_own wave if sp_ivw_yes==1, missing
*********************************************
//needs help when go outside? gets help and also goes outside on own != never
gen needshelp=0
replace needshelp=1 if help_go_out==1& out_on_own~=4
la var needshelp "Leaves houme but with help"
tab needshelp wave, missing

*********************************************
//has difficulty? when you used your walker,cane,etc? how much difficulty
//did you have leaving the house by yourself? 1=none, 2=a little, 3=some, 4=a lot
//inapplicable if don't report using any device to help, so set to 0 here
gen hasdifficulty=0
foreach w in 1 2{
	tab mo`w'outdif if wave==`w', missing
	replace hasdifficulty=1 if inlist(mo`w'outdif,2,3,4,-8)
	replace hasdifficulty=0 if mo`w'outdif==1
}
la var hasdifficulty "Leaves home on own but has difficulty"
tab hasdifficulty wave if sp_ivw_yes==1, missing
*********************************************
//needs help or has difficulty going outside?
gen helpdiff=.
replace helpdiff=0 if needshelp==0 & hasdifficulty==0
replace helpdiff=1 if needshelp==1 | hasdifficulty==1
la var helpdiff "Either needs help or has difficulty going outside"
tab helpdiff wave if sp_ivw_yes==1, missing
*********************************************
//independent - go out some/most days but are independent
gen independent=0
replace independent=1 if help_go_out==0 & hasdifficulty==0
la var independent "Independently leaves home"
tab independent wave if sp_ivw_yes==1, missing

tab independent helpdiff, missing //no overlap
*********************************************
/*homebound categories
0 = never go out
1 = rarely go out
2 = go out but never by self
3 = go out but need help/have difficulty
4 = go out, independent - don't need help or have difficulty
*/
gen homebound_cat=.
replace homebound_cat=0 if freq_go_out==5
replace homebound_cat=1 if freq_go_out==4
replace homebound_cat=2 if inlist(freq_go_out,3,2,1) & out_on_own==4
replace homebound_cat=3 if inlist(freq_go_out,3,2,1) & helpdiff==1
replace homebound_cat=4 if inlist(freq_go_out,3,2,1) & independent==1

la var homebound_cat "Homebound status, categorical"
la def hb 0 "Never leave home" 1 "Rarely leaves home" 2 "Leaves home but never by self" ///
3 "Leaves home but needs help/has difficulty" 4 "Independent, not homebound"
la val homebound_cat hb
tab homebound_cat wave if sp_ivw_yes==1, missing
*********************************************
/*subcategories for level 4 homeboud category
independent but go out only rarely
independent and go out frequently*/
gen indeplow=0
replace indeplow=1 if freq_go_out==3 & independent==1
la var indeplow "Independent, go out rarely" 

gen indephigh=0
replace indephigh=1 if inlist(freq_go_out,2,1) & independent==1
la var indephigh "Independent, go out often"

tab indeplow wave if sp_ivw_yes==1, missing
tab indephigh wave if sp_ivw_yes==1, missing

*********************************************
*********************************************
//demographic information
*********************************************
*********************************************


*********************************************
log close

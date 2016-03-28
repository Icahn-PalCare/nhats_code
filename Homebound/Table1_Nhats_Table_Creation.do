use "E:\nhats\data\NHATS working data\NHATS_Table1_Caregiver_Project.dta", clear
set more off
gen n=1
gen n1 = 1

gen data_grp = 0
replace data_grp = 1 if community_dwelling == 1
replace data_grp = 2 if eligible == 1

drop if data_grp == 0

tab sum_adl_cat, gen(sum_adl_cat)

replace medicaid = . if medicaid < 0

local ivars female white gt_hs_edu married medicaid livealone srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever  sr_phq2_depressed dem_2_cat sum_adl_cat1 sum_adl_cat2 sum_adl_cat3 ///
fall_last_month reg_doc_seen reg_doc_homevisit sr_hosp_ind meals_wheels restrnt_takeout noone_talk
local cvars sr_numconditions1 age sr_hosp_stays

foreach x in `ivars'{
replace `x' = . if `x' < 0
}

label var female "Female"
label var white "White"
label var gt_hs_edu "> HS Education"
label var married "Married"
label var medicaid "Covered by Medicaid"
label var livealone "Lives Alone?"
label var srh_fp "Self-Rated Health (Fair/Poor)"
label var sr_ami_ever "Self-Reported Heart Attack"
label var sr_ra_ever "Self-Reported Arthritis"
label var sr_diabetes_ever "Self-Reported Diabetes"
label var sr_lung_dis_ever "Self-Reported Lung Disease"
label var sr_stroke_ever "Self-Reported Stroke"
label var sr_cancer_ever "Self-Reported Cancer"
label var sr_phq2_depressed "PHQ-2 Depression: Score > 3"
label var dem_2_cat "Dementia Classification: Possible/Probable Dementia"
label var fall_last_month "Fall Last Month"
label var sum_adl_cat1 "Disability: 0 ADLs"
label var sum_adl_cat2 "Disability: 1-2 ADLs"
label var sum_adl_cat3 "Disability: >= 3 ADLs"
label var reg_doc_seen "Regular Doctor Seen"
label var reg_doc_homevisit "Regular Doctor was Home Visit?"
label var sr_hosp_ind "Hospital Stay in the last 12 months"
label var sr_hosp_stays "Number of Hospital Stays"
label var age "Age"
label var n1 "Weighted N"
label var meals_wheels "Meals on Wheels"
label var restrnt_takeout "Restaurant Takeout"
label var noone_talk "SP No one to Talk To"


 svyset [pw=w1anfinwgt0]

local rn : word count `cvars' `ivars' n n1


local r=1
local c=1
tab died


foreach weight in  "[aw=w1anfinwgt0]" {
	mat test1=J(`rn',20,.)
	mat test2=J(`rn',20,.)
	foreach d in 1 2{
	preserve
	keep if data_grp >= `d'
	foreach x in `cvars' {
		foreach i in 1 2 3 4 {
			sum `x' `weight' if homebound_cat1==`i'
			mat test`d'[`r',`c']=r(mean)
			mat test`d'[`r',`c'+1]=r(sd)
			svy: regress `x' i.homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
		    mat test`d'[`r',`c'+2]=e(p) 
			local c=`c'+3

	}
	local r=`r'+1
	local c=1
	}
	foreach x in `ivars' {
		foreach i in 1 2 3 4 {
			sum `x'`weight' if homebound_cat1==`i'
			mat test`d'[`r',`c']=r(sum)
			mat test`d'[`r',`c'+1]=r(mean)*100
			svy: tab `x' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
			mat test`d'[`r',`c'+2]=e(p_Pear)
			local c=`c'+3
	}
	local r=`r'+1
	local c=1
	}


	foreach i in 1 2 3 4 {
		sum n`weight' if homebound_cat1==`i'
			mat test`d'[`r',`c']=r(N)
			mat test`d'[`r'+1,`c'] = r(sum_w)
			local c=`c'+3
	}
restore
local r = 1
local c = 1
}

mat rownames test1=`cvars' `ivars' "Sample N" "Sample N (Weighted)"
mat rownames test2=`cvars' `ivars' "Sample N" "Sample N (Weighted)"
frmttable using "E:\nhats\data\Projects\Homebound\logs\Table1_Homebound_1", statmat(test1) ctitles("" "Mean/N Homebound" "SD/%" "" "Mean/N Semi-HB: Never by Self" "SD/%" "P-value" "Semi-HB: Needs Help/Has Diff" "SD/%" "P-value" "Not Homebound" "SD/%" "P-value") ///
store(test1) sdec(2)  varlabels replace title("Community Dwelling Homebound Sample")
frmttable using "E:\nhats\data\Projects\Homebound\logs\Table1_Homebound_2", statmat(test2) ctitles("" "Mean/N Homebound" "SD/%" "" "Mean/N Semi-HB: Never by Self" "SD/%" "P-value" "Semi-HB: Needs Help/Has Diff" "SD/%" "P-value" "Not Homebound" "SD/%" "P-value") ///
store(test2) sdec(2)  varlabels replace title("NSOC Eligible Homebound Sample")
}

// if you do weights. Change the test type in the loop, change "replace" to "addtable", change the title from Unweighted to Weighted, change the loop to put in [aw=w1cgfinwgt0] in the quotes.

use "E:\nhats\data\Projects\Caregivers\NHATS_Table1_Caregiver_Project.dta", clear
set more off
gen n=1
gen n1 = 1

gen data_grp = 0
replace data_grp = 1 if community_dwelling == 1
replace data_grp = 2 if eligible == 1

drop if died == .

drop if data_grp == 0

tab sum_adl_cat, gen(sum_adl_cat)

replace medicaid = . if medicaid < 0

local ivars female white gt_hs_edu married medicaid lives_alone srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever  sr_phq2_depressed dem_2_cat sum_adl_cat1 sum_adl_cat2 sum_adl_cat3 ///
fall_last_month reg_doc_seen reg_doc_homevisit sr_hosp_ind 
local cvars sr_numconditions1 age sr_hosp_stays

label var female "Female"
label var white "White"
label var gt_hs_edu "> HS Education"
label var married "Married"
label var medicaid "Covered by Medicaid"
label var lives_alone "Lives Alone?"
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

 svyset [pw=w1anfinwgt0]

local rn : word count `cvars' `ivars' n n1


local r=1
local c=1
tab died


foreach weight in  "[aw=w1anfinwgt0]" {
	mat test1=J(`rn',7,.)
	mat test2=J(`rn',7,.)
	foreach d in 1 2{
	preserve
	keep if data_grp >= `d'
	foreach x in `cvars' {
		foreach i in 0 1 {
			sum `x'`weight' if died==`i'
			mat test`d'[`r',`c']=r(mean)
			mat test`d'[`r',`c'+1]=r(sd)
			local c=`c'+2

	}
	sum `x' `weight'
	mat test`d'[`r',`c'+1]=`=_N'-r(N)
	//ttest `x', by(died)
	//mat test`d'[`r',`c']=r(p)
	svy: regress `x' died
	mat test`d'[`r',`c']=e(p) 
	local r=`r'+1
	local c=1
	}
	foreach x in `ivars' {
		foreach i in 0 1 {
			sum `x'`weight' if died==`i'
			mat test`d'[`r',`c']=r(sum)
			mat test`d'[`r',`c'+1]=r(mean)*100
			local c=`c'+2
	}
	sum `x' `weight'
	mat test`d'[`r',`c'+1]=`=_N'-r(N)
	//tab `x' died, chi2
	//mat test`d'[`r',`c']=r(p)
	svy: tab `x' died
	mat test`d'[`r',`c']=e(p_Pear)
	local r=`r'+1
	local c=1
	}


	foreach i in 0 1 {
		sum n`weight' if died==`i'
			mat test`d'[`r',`c']=r(N)
			mat test`d'[`r'+1,`c'] = r(sum_w)
			local c=`c'+2
	}
restore
local r = 1
local c = 1
}

mat rownames test1=`cvars' `ivars' "Sample N" "Sample N (Weighted)"
mat rownames test2=`cvars' `ivars' "Sample N" "Sample N (Weighted)"
frmttable , statmat(test1) ctitles("" "Mean/N Survived" "SD/%" "Mean/N Died" "SD/%" "P-value" "Missing") ///
store(test1) sdec(2,2,2,2,2,2,2,3)  varlabels replace title("SP with Eligible NSOC Helplers by 1 year Death, Weighted")
frmttable using "E:\nhats\data\Projects\Caregivers\logs\Table1", statmat(test2) ctitles("" "Mean/N Survived" "SD/%" "Mean/N Died" "SD/%" "P-value" "Missing") ///
merge(test1) sdec(2,2,2,2,2,2,2,3)  varlabels replace title("Community Dwelling older adults by one year survival")
}

// if you do weights. Change the test type in the loop, change "replace" to "addtable", change the title from Unweighted to Weighted, change the loop to put in [aw=w1cgfinwgt0] in the quotes.

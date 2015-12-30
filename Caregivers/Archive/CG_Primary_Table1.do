use "E:\nhats\data\Projects\Caregivers\Caregiver_3.dta", clear

label var female "Female"
label var white "White"
label var gt_hs_edu "> High School"
label var married "Married"
label var spouse "Spouse + Other"
label var medicaid "Medicaid"
label var srh_fp "Self-Reported Health (Fair/Poor)"
label var sr_ami_ever "Ever Heart Attack"
label var sr_heart_dis_ever "Ever Heart Disease" 
label var sr_ra_ever "Ever Arthritis"
label var sr_diabetes_ever "Ever Diabetes"
label var sr_lung_dis_ever "Ever Lung Disease"
label var sr_stroke_ever "Ever Stroke"
label var sr_cancer_ever "Ever Cancer"
label var sr_phq2_depressed "Ever Depressed"
label var dem_2_cat "Dementia (Possible/Probable)"
label var fall_last_month "Fall Past Month"
label var sum_adl_cat "ADL Disability"
label var reg_doc_seen "Seen Regular Doctor"
label var reg_doc_homevisit "Regular Doctor Home visit"
label var sr_hosp_ind "Hospital Stay last 12 months"
label var age "Age, Mean"
label var sr_numconditions1 "Number of conditions"
label var sr_hosp_stays "Number of Hospital Stays"

local ivars female white gt_hs_edu married spouse medicaid srh_fp sr_ami_ever sr_heart_dis_ever sr_ra_ever ///
sr_diabetes_ever sr_lung_dis_ever sr_stroke_ever sr_cancer_ever sr_phq2_depressed dem_2_cat fall_last_month  ///
reg_doc_seen reg_doc_homevisit sr_hosp_ind
local catvars sum_adl_cat
local cvars age sr_numconditions1 sr_hosp_stays


mat test1=J(23,5,.)
local r=1
svyset [pw=w1anfinwgt0]
foreach v in `cvars'{

sum `v' if died == 0 [aw=w1anfinwgt0]
mat test1[`r',1]=r(mean)
mat test1[`r',2]=r(sd)
sum `v' if died == 1 [aw=w1anfinwgt0]
mat test1[`r',3]=r(mean)
mat test1[`r',4]=r(sd)
svy: mean `v', over(died)
test [`v']0 = [`v']1
mat test1[`r',5]=r(p)
local r=`r'+1

}
local r = 4
foreach w in `ivars'{

sum `w' if died == 0 [aw=w1anfinwgt0]
mat test1[`r',1]= round(r(sum),0)
tab `w' if died == 0 [aw=w1anfinwgt0], matcell(row1)
mat test1[`r',2]=row1[2,1]/r(N)*100
sum `w' if died == 1 [aw=w1anfinwgt0]
mat test1[`r',3]=round(r(sum),0)
tab `w' if died == 1 [aw=w1anfinwgt0], matcell(row1)
mat test1[`r',4]=row1[2,1]/r(N)*100
logit died `w' [pw=w1anfinwgt0] //p-values
test `w'
mat test1[`r',5]=r(p)
local r = `r'+1
}
mat rownames test1= `cvars' `ivars'


frmttable using "E:\nhats\projects\Caregivers_KO\10012015\Caregiver_Table3.rtf", statmat(test1) varlabels title("Demo") ///
 ctitles ("" "N/MEAN (Died = 0)" "%/SD (Died = 0)" "N/MEAN (Died = 1)" "%/SD (Died = 1)" "P-Value") ///
 store(test1)
 matlist test1

outreg using "E:\nhats\projects\Caregivers_KO\10012015\Caregiver_Table3.rtf", replay(test1) replace

	sum tot_paid_`i'_wi_n0
	mat money[1,`c']=r(mean)
	mat money[1,`c'+1]=r(sd)
	local r=2
	
	ctitles("" "Mean 12m" "SD" "Mean 2nd Yr" "SD" "Mean 24m" "SD")

	

tab female if died == 1 [aweight=w1anfinwgt0], count matcell(row1)
sum female if died == 1 [aweight=w1anfinwgt0]
svy: tab female if died == 1, cell count 
svy: tab female died
gen test = row1[2,1]/r(N)*100
tab `v' if group_ind==1, matcell(row1)
logit died female [pw=w1anfinwgt0] //p-values
	test female
	mat t2[1,5]=r(p)


svy: mean age if died == 1
display e(varlist)
sum age if died == 1 [aw=w1anfinwgt0]
mean age, over(died)
ttest age, by(died)
svy: mean age, over(died) 
test [age]0 = [age]1

use "E:\nhats\data\Projects\Caregivers\Helpers1.dta", clear
// hours_helped count_helpers log_hours_helped num_helper_cat

gen data_grp0 = 1
gen data_grp1 = 0
replace  data_grp1 = 1 if died == 0
gen data_grp2 = 0
replace data_grp2 = 1 if died == 1
tab num_helper_cat, gen(num_helper_cat)

local vars n1 n2 n3
 
mat test1=J(53,9,.)
local r=1


local r=1
local c=1

 svyset [pw=w1anfinwgt0]

foreach w in 0 1 2 {
preserve 
keep if data_grp`w' == 1
sum count_helpers [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum_w)
mat test1[`r'+1,`c']=r(mean)
mat test1[`r'+1,`c'+1]=r(sd)
mat test1[`r'+2,`c']=r(p50)
sum num_helper_cat1 [aw=w1anfinwgt0], detail
mat test1[`r'+3,`c']=r(sum)
mat test1[`r'+3,`c'+1]=r(mean)*100
sum num_helper_cat2 [aw=w1anfinwgt0], detail
mat test1[`r'+4,`c']=r(sum)
mat test1[`r'+4,`c'+1]=r(mean)*100
sum num_helper_cat3 [aw=w1anfinwgt0], detail
mat test1[`r'+5,`c']=r(sum)
mat test1[`r'+5,`c'+1]=r(mean)*100
sum hours_helped [aw=w1anfinwgt0], detail
mat test1[`r'+6,`c']=r(mean)
mat test1[`r'+6,`c'+1]=r(sd)
mat test1[`r'+7,`c']=r(p50)
local c = `c' + 2
restore
}
svy: regress count_helpers died
mat test1[`r'+1,`c'+1]=e(p)
svy: tab num_helper_cat1 died
mat test1[`r'+3,`c'+1]=e(p_Pear)
svy: tab num_helper_cat2 died
mat test1[`r'+4,`c'+1]=e(p_Pear)
svy: tab num_helper_cat3 died
mat test1[`r'+5,`c'+1]=e(p_Pear)
svy: regress hours_helped died
mat test1[`r'+6,`c'+1]=e(p)

local r = 11
local c = 1

foreach w in spouse_i daug_i son_i oth_fam_i paid_cg_i oth_nofam_i{

sum `w' [aw=w1anfinwgt0], detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab `w' died 
mat test1[`r',`c'+7] = e(p_Pear)


foreach i in 0 1{
local c = `c' + 2
sum `w' [aw=w1anfinwgt0] if died == `i', detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
}

local r = `r' + 1
local c = 1

}

use "E:\nhats\data\Projects\Caregivers\Helpers.dta", clear
 svyset [pw=w1anfinwgt0]

local r = 19
local c = 1
foreach  w in 1 2 3 4 5 6 {

sum op_relationship_cat`w' [aw=w1anfinwgt0], detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_relationship_cat`w' died
mat test1[`r',`c'+7] = e(p_Pear)

sum total_hours if op_relationship_cat`w' == 1 [aw=w1anfinwgt0], detail
mat test1[`r'+8,`c'] = r(mean)
mat test1[`r'+8,`c'+1] = r(sd)
svy: regress total_hours died if op_relationship_cat`w' == 1 
mat test1[`r'+8,`c'+7] = e(p)

foreach i in 0 1{
local c = `c' + 2
sum op_relationship_cat`w' if died == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
sum total_hours if op_relationship_cat`w' == 1 & died == `i' [aw=w1anfinwgt0], detail
mat test1[`r'+8,`c'] = r(mean)
mat test1[`r'+8,`c'+1] = r(sd)
}

local r = `r' + 1
local c = 1
}

local r = 35
local c = 1
foreach w in eat bath toil dres insd bed  {

sum op_adl_`w' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_adl_`w' died 
mat test1[`r',`c'+7] = e(p_Pear)

foreach i in 0 1{
local c = `c' + 2
sum op_adl_`w' if died == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100

}

local r = `r' + 1
local c = 1

}

local r = 43
local c = 1

foreach w in laun shop meal bank  meds {

sum op_iadl_`w' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_iadl_`w' died
mat test1[`r',`c'+7] = e(p_Pear)

foreach i in 0 1{
local c = `c' + 2
sum op_iadl_`w' if died == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100

}

local r = `r' + 1
local c = 1

}
local r = 50
local c = 1

foreach w in adl iadl{

sum any_`w' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab any_`w' died
mat test1[`r',`c'+7] = e(p_Pear)

foreach i in 0 1{
local c = `c' + 2
sum any_`w' if died == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
}
local r = `r' + 1
local c = 1
}
matlist test1

frmttable using "E:\nhats\data\Projects\Caregivers\logs\Helper_Table(Table2)_12_15", statmat(test1) rtitles ("Total Number of Helpers"\"Mean Number of Helpers mean(sd)"\"Median number of helpers per older adult"\ ///
"Category: Number of Helpers (1-3) n(%)"\"Category: Number of Helpers (4-6) n(%)"\"Category: Number of Helpers (7+) n(%)"\"Total Mean hours of help per older adult"\"Total Median hours of help per older adult"\""\ ///
"Helper Prevalence per SP:"\"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\""\ ///
"Helper Prevalence :"\"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\""\"Mean Number of Hours of care per type of Helper:"\ ///
"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\""\"Type of Help received by Older Adults (ADL):"\"Eating"\"Bathing"\"Toileting"\"Dressing"\"Walking Inside"\ ///
"Getting out of Bed"\""\"Type of Help Received by Older Adults (IADL):"\"Laundry"\"Shopping"\"Meals"\"Banking"\"Medicine"\""\"Any ADL"\"Any IADL") ///
ctitles("" "Mean/N Total" "SD/%" "Mean/N Survivors" "SD/%" "Mean/N Decedents" "SD/%" ) ///
store(test1) sdec(2,2,2,2,2,2,2,4) replace title("Helpers of the NSOC SP Sample by survivial status") 

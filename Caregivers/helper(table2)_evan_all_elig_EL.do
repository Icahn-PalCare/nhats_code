use "E:\nhats\data\Projects\Caregivers\Helpers.dta", clear

gen tot=1 
gen lived=died==0

tab num_helper_cat, gen(num_helper_cat)
by spid, sort: gen unique=_n==1

svyset [pw=w1anfinwgt0]

mat test1=J(36,9,.)
local r=2
local c=1

preserve
keep if unique==1
duplicates drop spid, force

foreach g in tot lived died {
sum count_helpers if `g'==1 [aw=w1anfinwgt0], detail
mat test1[1,`c']=r(sum_w)
mat test1[`r',`c']=r(sum)
mat test1[`r'+1,`c']=r(mean)
mat test1[`r'+1,`c'+1]=r(sd)
mat test1[`r'+2,`c']=r(p50)
sum num_helper_cat1 if `g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+3,`c']=r(sum)
mat test1[`r'+3,`c'+1]=r(mean)*100
sum num_helper_cat2 if `g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+4,`c']=r(sum)
mat test1[`r'+4,`c'+1]=r(mean)*100
sum num_helper_cat3 if `g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+5,`c']=r(sum)
mat test1[`r'+5,`c'+1]=r(mean)*100
sum hours_helped if `g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+6,`c']=r(mean)
mat test1[`r'+6,`c'+1]=r(sd)
mat test1[`r'+7,`c']=r(p50)
local c = `c' + 2

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

local r = 12
local c = 1

foreach w in  spouse_i daug_i son_i oth_fam_i paid_cg_i oth_nofam_i {

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
local r = 20
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

local r = 28
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
local r = 34
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

restore

frmttable using "E:\nhats\data\Projects\Caregivers\logs\Helper_Table_all_elig_12_29_15", ///
statmat(test1) rtitles ("Total Number of SPs"\"Total Number of Helpers"\ ///
"Mean Number of Helpers mean(sd)"\"Median number of helpers per SP"\ ///
"Category: Number of Helpers (1-3) n(%)"\"Category: Number of Helpers (4-6) n(%)"\ ///
"Category: Number of Helpers (7+) n(%)"\"Mean total hours of help per SP"\ ///
"Median total hours of help per SP"\""\"Helper Prevalence per SP:"\ ///
"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\""\ ///
"Type of Help received by Older Adults (ADL):"\"Eating"\"Bathing"\"Toileting"\ ///
"Dressing"\"Walking Inside"\"Getting out of Bed"\""\"Type of Help Received by Older Adults (IADL):" ///
\"Laundry"\"Shopping"\"Meals"\"Banking"\"Medicine"\""\"Any ADL"\"Any IADL") ///
ctitles("" "Total" "" "Survivors" "" "Decedents" "" \ "" "Mean/N Total" "SD/%" "Mean/N Survivors" "SD/%" "Mean/N Decedents" "SD/%" ) ///
store(test1) sdec(2,2,2,2,2,2,2,4) replace ///
title("SPs and their Help, all NSOC-eligible SPs, by SP survivial status") ///
note("2,423 NSOC-eligible SPs have 5,702 helpers listed in the OP file."\ ///
 "41 SPs and 92 Helpers dropped for unknown SP survival status within 12 months")

 
mat test1=J(36,9,.)
local r = 3
local c = 1

sum op1ishelp [aw=w1anfinwgt0]
mat test1[1,`c']=r(sum)
sum op1ishelp if died==0 [aw=w1anfinwgt0]
mat test1[1,`c'+2]=r(sum)
sum op1ishelp if died==1 [aw=w1anfinwgt0]
mat test1[1,`c'+4]=r(sum)
sum op1ishelp 
mat test1[2,`c']=r(sum)
sum op1ishelp if died==0 
mat test1[2,`c'+2]=r(sum)
sum op1ishelp if died==1 
mat test1[2,`c'+4]=r(sum)

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

local r = 19
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

local r = 27
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
local r = 33
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

frmttable using "E:\nhats\data\Projects\Caregivers\logs\Helper_Table_all_elig_12_29_15", ///
statmat(test1) rtitles ("Total Number of Helpers"\ ///
"Helper Prevalence :"\"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\ ///
"Other non-relatives"\""\"Mean Number of Hours of care per type of Helper:"\ ///
"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\ ///
""\"Type of Help provided (ADL):"\"Eating"\"Bathing"\"Toileting"\ ///
"Dressing"\"Walking Inside"\"Getting out of Bed"\""\"Type of Help provided(IADL):" ///
\"Laundry"\"Shopping"\"Meals"\"Banking"\"Medicine"\""\"Any ADL"\"Any IADL") ///
ctitles("" "Total" "" "Survivors" "" "Decedents" "" \ "" "Mean/N Total" "SD/%" "Mean/N Survivors" "SD/%" "Mean/N Decedents" "SD/%" ) ///
store(test1) sdec(2,2,2,2,2,2,2,4) addtable ///
title("Helpers, all NSOC-eligible SPs, by SP survivial status") ///
note("2,423 NSOC-eligible SPs have 5,702 helpers listed in the OP file."\ ///
 "41 SPs and 92 Helpers dropped for unknown SP survival status within 12 months")

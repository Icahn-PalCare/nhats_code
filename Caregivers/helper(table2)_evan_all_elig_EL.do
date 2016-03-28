use "E:\nhats\data\Projects\Homebound\Helpers.dta", clear
set more off

replace homebound_cat1= 3 if  spid == 10009011

gen tot=1 
gen homebound_cat_1=homebound_cat1==1
gen homebound_cat_2=homebound_cat1==2
gen homebound_cat_3=homebound_cat1==3
gen homebound_cat_4=homebound_cat1==4

tab num_helper_cat, gen(num_helper_cat)
by spid, sort: gen unique=_n==1

svyset [pw=w1anfinwgt0]

mat test1=J(48,18,.)
local r=2
local c=1

preserve
keep if unique==1
duplicates drop spid, force

foreach g in 1 2 3 4 {
sum count_helpers if homebound_cat_`g'==1 [aw=w1anfinwgt0], detail
mat test1[1,`c']=r(sum_w)
mat test1[`r',`c']=r(sum)
mat test1[`r'+1,`c']=r(mean)
mat test1[`r'+1,`c'+1]=r(sd)
mat test1[`r'+2,`c']=r(p50)
svy: regress count_helpers homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `g'
mat test1[`r'+1,`c'+2]=e(p)
sum num_helper_cat1 if homebound_cat_`g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+3,`c']=r(sum)
mat test1[`r'+3,`c'+1]=r(mean)*100
svy: tab num_helper_cat1 homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `g'
mat test1[`r'+3,`c'+2]=e(p_Pear)
sum num_helper_cat2 if homebound_cat_`g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+4,`c']=r(sum)
mat test1[`r'+4,`c'+1]=r(mean)*100
svy: tab num_helper_cat2 homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `g'
mat test1[`r'+4,`c'+2]=e(p_Pear)
sum num_helper_cat3 if homebound_cat_`g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+5,`c']=r(sum)
mat test1[`r'+5,`c'+1]=r(mean)*100
svy: tab num_helper_cat3 homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `g'
mat test1[`r'+5,`c'+2]=e(p_Pear)
sum hours_helped_wk_i if homebound_cat_`g'==1 [aw=w1anfinwgt0], detail
mat test1[`r'+6,`c']=r(mean)
mat test1[`r'+6,`c'+1]=r(sd)
mat test1[`r'+7,`c']=r(p50)
svy: regress hours_helped_wk_i i.homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `g'
mat test1[`r'+6,`c'+2]=e(p)
local c = `c' + 3

}



local r = 12
local c = 1

foreach w in spouse_i daug_i son_i oth_fam_i paid_cg_i oth_nofam_i {

svy: tab `w' homebound_cat1 
mat test1[`r',`c'+9] = e(p_Pear)


foreach i in 1 2 3 4{

sum `w' [aw=w1anfinwgt0] if homebound_cat1 == `i', detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab `w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}

local r = `r' + 1
local c = 1


}
local r = 20
local c = 1
foreach w in eat bath toil dres insd bed  {

foreach i in 1 2 3 4{

sum op_adl_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_adl_`w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}

local r = `r' + 1
local c = 1

}

local r = 28
local c = 1

foreach w in laun shop meal bank  meds {

foreach i in 1 2 3 4{

sum op_iadl_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_iadl_`w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3

}

local r = `r' + 1
local c = 1

}
local r = 35
local c = 1

foreach w in out money tkpl1 doc insur {

foreach i in 1 2 3 4{

sum op_help_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_help_`w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3

}

local r = `r' + 1
local c = 1

}

local r = 41
local c = 1

foreach w in adl iadl{
foreach i in 1 2 3 4{

sum any_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab any_`w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}
local r = `r' + 1
local c = 1
}

local r = 44
local c = 1

foreach w in meals_wheels restrnt_takeout{
foreach i in 1 2 3 4{

sum `w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab `w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}
local r = `r' + 1
local c = 1
}

restore

frmttable using "E:\nhats\data\Projects\Homebound\logs\Helper_Table_2_2_16", ///
statmat(test1) rtitles ("Total Number of SPs"\"Total Number of Helpers"\ ///
"Mean Number of Helpers mean(sd)"\"Median number of helpers per SP"\ ///
"Category: Number of Helpers (1-3) n(%)"\"Category: Number of Helpers (4-6) n(%)"\ ///
"Category: Number of Helpers (7+) n(%)"\"Mean total hours of help per SP"\ ///
"Median total hours of help per SP"\""\"Helper Prevalence per SP:"\ ///
"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\""\ ///
"Type of Help received by Older Adults (ADL):"\"Eating"\"Bathing"\"Toileting"\ ///
"Dressing"\"Walking Inside"\"Getting out of Bed"\""\"Type of Help Received by Older Adults (IADL):" ///
\"Laundry"\"Shopping"\"Meals"\"Banking"\"Medicine"\""\"Other Type of Help Received:"\ ///
"Go Outside"\"Money Matters"\"Mostly Takes SP Places"\"Sits with SP at DR"\"Help with Insurance"\""\"Any ADL"\"Any IADL"\""\"Meals on Wheels"\"Restaurant Takeout") ///
ctitles("" "Homebound" "" "" "Semi-HB: Never by Self" "" "" "Semi-HB: Needs Help/Diffculty" "" "" "Not Homebound" ""  \ "" "Mean/N" "SD/%" "" "Mean/N" "SD/%" "P-Value" "Mean/N" "SD/%" "P-Value" "Mean/N" "SD/%" "P-value" ) ///
store(test1) sdec(2) replace ///
title("SPs and their Helpers, all NSOC-eligible SPs, by Homebound status") ///
note("2,423 NSOC-eligible SPs have 5,702 helpers listed in the OP file.") ///

 
mat test1=J(45,18,.)
local r = 3
local c = 1

sum op1ishelp if homebound_cat1 == 1 [aw=w1anfinwgt0]
mat test1[1,`c']=r(sum)
sum op1ishelp if homebound_cat1 == 2 [aw=w1anfinwgt0]
mat test1[1,`c'+3]=r(sum)
sum op1ishelp if homebound_cat1 == 3 [aw=w1anfinwgt0]
mat test1[1,`c'+6]=r(sum)
sum op1ishelp if homebound_cat1 == 4 [aw=w1anfinwgt0]
mat test1[1,`c'+9]=r(sum)
sum op1ishelp if homebound_cat1 == 1
mat test1[2,`c']=r(sum)
sum op1ishelp if homebound_cat1 == 2
mat test1[2,`c'+3]=r(sum)
sum op1ishelp if homebound_cat1 == 3 
mat test1[2,`c'+6]=r(sum)
sum op1ishelp if homebound_cat1 == 4 
mat test1[2,`c'+9]=r(sum)

foreach  w in 1 2 3 4 5 6 {
foreach i in 1 2 3 4{

sum op_relationship_cat`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c'] = r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_relationship_cat`w' homebound_cat1 if homebound_cat1 == `i' | homebound_cat1 == 1
mat test1[`r',`c'+2] = e(p_Pear)

sum total_hours_wk_i if op_relationship_cat`w' == 1 & homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r'+8,`c'] = r(mean)
mat test1[`r'+8,`c'+1] = r(sd)
svy: regress total_hours_wk_i i.homebound_cat1 if op_relationship_cat`w' == 1 & (homebound_cat1 == 1 | homebound_cat1 == `i')
mat test1[`r'+8,`c'+2] = e(p)

local c = `c' + 3
}

local r = `r' + 1
local c = 1
}

local r = 19
local c = 1
foreach w in eat bath toil dres insd bed  {
foreach i in 1 2 3 4{

sum op_adl_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_adl_`w' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}

local r = `r' + 1
local c = 1

}

local r = 27
local c = 1

foreach w in laun shop meal bank  meds {
foreach i in 1 2 3 4{

sum op_iadl_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_iadl_`w' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}

local r = `r' + 1
local c = 1

}
local r = 34
local c = 1

foreach w in out money tkpl1 doc insur {
foreach i in 1 2 3 4{

sum op_help_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab op_help_`w' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}

local r = `r' + 1
local c = 1

}

local r = 40
local c = 1

foreach w in adl iadl{
foreach i in 1 2 3 4{

sum any_`w' if homebound_cat1 == `i' [aw=w1anfinwgt0], detail
mat test1[`r',`c']=r(sum)
mat test1[`r',`c'+1] = r(mean)*100
svy: tab any_`w' homebound_cat1 if homebound_cat1 == 1 | homebound_cat1 == `i'
mat test1[`r',`c'+2] = e(p_Pear)
local c = `c' + 3
}
local r = `r' + 1
local c = 1
}


matlist test1

frmttable using "E:\nhats\data\Projects\Homebound\logs\Helper_Table_2_2_16", ///
statmat(test1) rtitles ("Total Number of Helpers"\ ///
"Helper Prevalence :"\"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\ ///
"Other non-relatives"\""\"Mean Number of Hours of care per type of Helper:"\ ///
"Spouse/Partner"\"Daughter"\"Son"\"Other Relatives"\"Paid Caregiver"\"Other non-relatives"\ ///
""\"Type of Help provided (ADL):"\"Eating"\"Bathing"\"Toileting"\ ///
"Dressing"\"Walking Inside"\"Getting out of Bed"\""\"Type of Help provided(IADL):" ///
\"Laundry"\"Shopping"\"Meals"\"Banking"\"Medicine"\""\"Other Type of Help Received:"\ ///
"Go Outside"\"Money Matters"\"Mostly Takes SP Places"\"Sits with SP at DR"\"Help with Insurance"\""\"Any ADL"\"Any IADL"\""\"Meals on Wheels"\"Restaurant Takeout") ///
ctitles("" "Homebound" "" "" "Semi-HB: Never by Self" "" "" "Semi-HB: Needs Help/Diffculty" "" "" "Not Homebound" ""  \ "" "Mean/N" "SD/%" "" "Mean/N" "SD/%" "P-Value" "Mean/N" "SD/%" "P-Value" "Mean/N" "SD/%" "P-value" ) ///
store(test1) sdec(2) addtable ///
title("Helpers, all NSOC-eligible SPs, by Homebound status") ///
note("2,423 NSOC-eligible SPs have 5,702 helpers listed in the OP file."\ ///
 "41 SPs and 92 Helpers dropped for unknown SP survival status within 12 months")

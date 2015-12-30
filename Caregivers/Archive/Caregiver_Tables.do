use "E:\nhats\data\Projects\Caregivers\nsoc.dta", clear

tab died che1hrtattck

local nsoc c1dgender c1relatnshp c1intmonth c1dintdays cca1hwoftchs cca1hwoftshp cca1hlpordmd cca1hlpbnkng cca1cmpgrcry cca1cmpordrx cca1cmpbnkng cca1hwoftpc cca1hwofthom ///
cca1hwoftdrv cca1hlpmed cca1hlpshot cca1hlpmdtk cca1hlpexrcs cca1hlpdiet cca1hlpteeth cca1hlpfeet cca1hlpskin cca1hlpmdapt cca1hlpspkdr cca1hlpinsrn cca1hlpothin ///
cdc1hlpdyswk cdc1hlphrmvf cdc1hlphrlmt cdc1hlpyrpls cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst cac1joylevel cac1joylevel cac1arguelv cac1spapprlv cac1nerveslv ///
cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1diffinc cac1diffemo cac1diffphy cac1diffinlv cac1diffemlv cac1diffphlv cac1fmlydisa cac1exhaustd cac1toomuch cac1notime cac1uroutchg ///
cse1frfamact cpp1wrk4pay cpp1hlpkptwk cpp1careothr che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing ///
che1hearing che1fltdown che1fltnervs che1fltworry chd1martstat chd1chldlvng chd1numchild chd1numchu18 chd1educ chd1cgbrthmt chd1cgbrthyr cec1wrk4pay cec1hlpafwk1 cec1occuptn cec1worktype ///
chi1medicare chi1medigap chi1medicaid chi1privinsr chi1tricare chi1uninsurd chi1insrtype

gen cg_educ = 0
replace cg_educ = 1 if chd1educ >= 4
replace cg_educ = . if chd1educ < 0
gen cg_mar_part = 0
replace cg_mar_part = 1 if chd1martstat == 1 | chd1martstat == 2
replace cg_mar_part = . if chd1martstat < 0

tab cg_relationship_cat

log using "E:\nhats\projects\Caregivers_KO\10022015\Tables.txt", text replace
foreach v in `nsoc' {

replace `v' = . if `v' < 0
tab `v' died, chi2

}
log close
 

local other cca1hlpbnkng cca1hlpmed cca1hlpmdapt cca1hlpspkdr cca1hlpordmd cca1hlpinsrn cca1hlpothin cca1hlpdiet cca1hlpfeet cca1hlpskin cca1hlpexrcs cca1hlpteeth cca1hlpmdtk cca1hlpshot cac1diffinc cac1diffemo cac1diffphy ///
 che1health che1hrtattck che1othheart che1highbld che1arthrits che1osteoprs che1diabetes che1lungdis che1cancer che1seeing che1hearing che1fltdown ///
 che1fltnervs che1fltworry chd1martstat  chi1medicare chd1chldlvng 

foreach v in `other' {

gen cg_`v' = .
replace cg_`v' = 1 if `v' == 1
replace cg_`v' = 0 if `v' == 2
tab cg_`v'
lab var `v'
}
local other1 cca1hwoftpc cca1hwofthom cca1hwoftchs cca1hwoftshp
foreach v in `other1' {

gen cg_`v' = .
replace cg_`v' = 1 if `v' == 1|`v' == 2|`v' == 3
replace cg_`v' = 0 if `v' == 4|`v' == 5
tab cg_`v'
lab var `v'
}
local other2 cac1moreconf cac1dealbetr cac1closr2sp cac1moresat cac1exhaustd cac1toomuch cac1notime cac1uroutchg
foreach v in `other2' {

gen cg_`v' = .
replace cg_`v' = 1 if `v' == 1|`v' == 2
replace cg_`v' = 0 if `v' == 3
tab cg_`v'
lab var `v'
}



sum cg_age
gen cg_age1 = 2011 - chd1cgbrthyr
replace cg_age1 = . if cg_age1 > 150
sum cg_age1
replace cg_age = cg_age1 if cg_age == . & cg_age1 != .
sum cg_age
gen cg_spouse_adult = 0
replace cg_spouse_adult = 1 if cg_relationship_cat== 1 | cg_relationship_cat == 2
tab cg_spouse_adult
replace cg_age = 65 if spid == 10012285

mat test1=J(44,9,.)
local r=1
svyset [pw=w1cgfinwgt0]



label var cg_female "Female Yes/No"
label var cg_spouse_adult "Caregiver is Spouse/Adult"
label var cg_lives_with_sp "Caregiver Lives with SP"
label var cg_age "Caregiver Age"
label var cg_educ "Caregiver Education"
label var cg_mar_part "Caregiver Marital Status"
label var cg_chd1chldlvng "Any Children Missing Yes/No"
label var cg_chi1medicare "Medicare Yes/No"
label var cg_che1hrtattck "Ever Heart Attack"
label var cg_che1othheart "Ever Heart Disease"
label var cg_che1arthrits "Ever Arthritis"
label var cg_che1diabetes "Ever Diabetes"
label var cg_che1lungdis "Ever Lung Disease"
label var cg_che1cancer "Ever Cancer"
label var cg_cac1diffinc "Financially Difficult (Yes/No)"
label var cg_cac1diffemo "Emotionally Difficult (Yes/No)"
label var cg_cac1diffphy "Physically Difficult (Yes/No)"
label var cg_cca1hlpmdapt "Help Make Appointments (Yes/No)"
label var cg_cca1hlpspkdr "Help Speak to Doctors (Yes/No)"
label var cg_cca1hlpordmd "Help Order Medicine (Yes/No)"
label var cg_cca1hlpinsrn "Help Add/Change Insurance (Yes/No)"
label var cg_cca1hlpothin "Help Other Insurance Issues (Yes/No)"
label var cg_cca1hlpdiet "Help Diet"
label var cg_cca1hlpfeet "Help Foot Care"
label var cg_cca1hlpskin "Help Skin Care"
label var cg_cca1hlpexrcs "Help Exercises"
label var cg_cca1hlpteeth "Help Dental Care"
label var cg_cca1hlpmdtk "Help Manage Medical Tasks"
label var cg_cca1hlpshot "Help with Shots/Injections"
label var cg_cca1hlpbnkng "Help with Bills/Manage $"
label var cg_cca1hlpmed "Help Keep Track of Meds"
label var cg_cca1hwoftpc "Help with Personal Care (Every/Most/Some)"
label var cg_cca1hwofthom "Help Getting Around (Every/Most/Some)"
label var cg_cca1hwoftchs "Help with Housework Chores (Every/Most/Some)"
label var cg_cca1hwoftshp "Help with Shopping (Every/Most/Some)"
label var cg_cac1moreconf "More Confident in Abilities (Very/Somewhat)"
label var cg_cac1dealbetr "Deal with Diff Situations (Very/Somewhat)"
label var cg_cac1closr2sp "Closer to SP (Very/Somewhat)"
label var cg_cac1moresat "Satisfaction Recipient is Cared for (Very/Somewhat)"
label var cg_cac1exhaustd "Exhausted when you go to bed (Very/Somewhat)"
label var cg_cac1toomuch "More than you can handle (Very/Somewhat)"
label var cg_cac1notime "No Time for yourself (Very/Somewhat)"
label var cg_cac1uroutchg "No Routine (Very/Somewhat)"


local ivars cg_female cg_spouse_adult cg_lives_with_sp cg_educ cg_mar_part cg_chd1chldlvng cg_chi1medicare cg_che1hrtattck cg_che1othheart cg_che1arthrits cg_che1diabetes cg_che1lungdis cg_che1cancer ///
cg_cac1diffinc cg_cac1diffemo cg_cac1diffphy cg_cca1hlpmdapt cg_cca1hlpspkdr cg_cca1hlpordmd cg_cca1hlpinsrn cg_cca1hlpothin cg_cca1hlpdiet cg_cca1hlpfeet cg_cca1hlpskin cg_cca1hlpexrcs ///
cg_cca1hlpteeth cg_cca1hlpmdtk cg_cca1hlpshot cg_cca1hlpbnkng cg_cca1hlpmed cg_cca1hwoftpc cg_cca1hwofthom cg_cca1hwoftchs cg_cca1hwoftshp cg_cac1moreconf cg_cac1dealbetr cg_cac1closr2sp ///
cg_cac1moresat cg_cac1exhaustd cg_cac1toomuch cg_cac1notime cg_cac1uroutchg

local cvars cg_age

foreach w in `ivars'{
sum `w'
mat test1[`r',1]= round(r(sum),0)
sum `w' [aw=w1cgfinwgt0]
mat test1[`r',2]= round(r(sum),0)
tab `w' [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',3]=row1[2,1]/r(N)*100
sum `w' if died == 0
mat test1[`r',4]= round(r(sum),0)
sum `w' if died == 0 [aw=w1cgfinwgt0]
mat test1[`r',5]= round(r(sum),0)
tab `w' if died == 0 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',6]=row1[2,1]/r(N)*100
sum `w' if died == 1
mat test1[`r',7]= round(r(sum),0)
sum `w' if died == 1 [aw=w1cgfinwgt0]
mat test1[`r',8]=round(r(sum),0)
tab `w' if died == 1 [aw=w1cgfinwgt0], matcell(row1)
mat test1[`r',9]=row1[2,1]/r(N)*100
local r = `r'+1
}

local r = 41
foreach v in `cvars'{
sum `v' [aw=w1cgfinwgt0]
mat test1[`r',1] = r(N)
mat test1[`r',2] = r(mean)
mat test1[`r',3] = r(sd)
sum `v' if died == 0 [aw=w1cgfinwgt0]
mat test1[`r',4] = r(N)
mat test1[`r',5]=r(mean)
mat test1[`r',6]=r(sd)
sum `v' if died == 1 [aw=w1cgfinwgt0]
mat test1[`r',7] = r(N)
mat test1[`r',8]=r(mean)
mat test1[`r',9]=r(sd)

local r=`r'+1

}
mat rownames test1= `ivars' `cvars' 
 matlist test1
frmttable using "E:\nhats\projects\Caregivers_KO\10012015\Cargiver_Surveys3_1.rtf", statmat(test1) varlabels title("Demo") ///
ctitles ("" "ALL Sample N" "ALL Weighted N/MEAN(age)" "ALL %/SD" "Survivor Sample N" "Survivor Weighted N/MEAN(age)" "Survivor %/SD" "EOL Sample N" "EOL Weighted N/MEAN(age)" "EOL %/SD" ) ///
 store(test1)
 matlist test1
 
 
 tab cac1moreconf
 tab cac1dealbetr 
 tab cac1closr2sp 
 tab cac1moresat 
 tab cac1diffinc 
 tab cac1diffemo 
 tab cac1diffphy 
 tab cac1exhaustd 
 tab cac1toomuch 
 tab cac1notime 
 tab cac1uroutchg
 
 
 
 saveold  "E:\nhats\data\Projects\Caregivers\nsoc_10072015.dta", replace
 
 use "E:\nhats\data\Projects\Caregivers\nsoc_10072015.dta",clear
 
log using "E:\nhats\projects\Caregivers_KO\10022015\Tables.txt", text replace
 
drop if died == 1 | died == .
 
 local ivars cg_female cg_spouse_adult cg_lives_with_sp cg_educ cg_mar_part cg_chd1chldlvng cg_chi1medicare cg_che1hrtattck cg_che1othheart cg_che1arthrits cg_che1diabetes cg_che1lungdis cg_che1cancer ///
cg_cca1hwoftpc cg_cca1hwofthom cg_cca1hwoftshp cg_cca1hwoftchs cg_cca1hlpbnkng cg_cca1hlpmed  cg_cca1hwoftchs cg_cca1hlpmdapt cg_cca1hlpspkdr cg_cca1hlpordmd cg_cca1hlpinsrn cg_cca1hlpothin cg_cca1hlpdiet cg_cca1hlpfeet cg_cca1hlpskin cg_cca1hlpexrcs ///
cg_cca1hlpteeth cg_cca1hlpmdtk cg_cca1hlpshot  cg_cac1moreconf cg_cac1dealbetr cg_cac1closr2sp ///
cg_cac1moresat cg_cac1exhaustd cg_cac1toomuch cg_cac1notime cg_cac1uroutchg  cg_cac1diffinc cg_cac1diffemo cg_cac1diffphy 


local cvars cg_age

foreach x in `ivars' {
qui sum `x'
di "`x'"
qui sum cg_relationship_cat if `x'==.
di r(N)

}
log close
 
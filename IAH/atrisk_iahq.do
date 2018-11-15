
/***** IAH ****/


use "E:\nhats\data\Projects\IAH\int_data\iah_mostrecent.dta", clear
cap drop _m

merge 1:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\iah_snf_3m.dta", keepus(admit_date)

*merge 1:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\iah_snf.dta", keepus(admit_date)
cap drop _m

merge 1:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\iah_died.dta"
drop if _m==3

gen nh_b4death = 0
replace nh_b4death = 1 if admit_date<death_date

drop if death_date - admit_date<=91 

*keep if death_date - admit_date<=91 

gen exit_date = .

/*
replace exit_date = admit_date if nh_b4death==1
replace exit_date = death_date if nh_b4death==0
*/

replace exit_date = admit_date // nurshing home admission only


cap drop exit_days
gen exit_days = .
replace exit_days = exit_date - index_date 

gen exit_months = exit_days/30.4
replace exit_months = ceil(exit_months) 


gen fail = 0
replace fail = 1 if exit_months!=.
replace exit_months = 37 if exit_months>=37
replace exit_months = 1 if exit_months==0

gen adl_cat = .
replace adl_cat = 1 if adl_con<=2
replace adl_cat = 2 if adl_con>2 & adl_con<=4
replace adl_cat = 3 if adl_con>=5 & adl_con<=6
label define adl_lbl 1"2 ADLs"2"3-4 ADLs"3"5-6 ADLs"
la values adl_cat adl_lbl

stset exit_months, f(fail==1) exit(exit_months==36)


sts list, by(adl_cat)  at(1 2 3 to 36)
sts list,  at(1 2 3 to 36)

sts graph, by(adl_cat) xtitle(Months From Index) xlabel(3(3)36) title("Index Date to Long-Term NH, Survived >3m after NH") ci

/**** Housecalls *****/

use "E:\nhats\data\Projects\IAH\int_data\housecalls.dta" , clear
cap drop _m

merge 1:1 bene_id using "E:\nhats\data\Projects\IAH\int_data\hc_snf_3m.dta", keepus(admit_date)

drop if _m==2

gen nh_b4death = 0
replace nh_b4death = 1 if admit_date<death_date

drop if death_date - admit_date<=91 

gen exit_date = .
/*
replace exit_date = admit_date if nh_b4death==1
replace exit_date = death_date if nh_b4death==0
*/

replace exit_date = admit_date // nurshing home admission only

cap drop exit_days
gen exit_days = .
replace exit_days = exit_date - index_date 

gen exit_months = exit_days/30.4
replace exit_months = ceil(exit_months) 


gen fail = 0
replace fail = 1 if exit_months!=.
replace exit_months = 38 if exit_months>=37
replace exit_months = 1 if exit_months==0

gen adl_cat = .
replace adl_cat = 1 if adl_con<=2
replace adl_cat = 2 if adl_con>2 & adl_con<=4
replace adl_cat = 3 if adl_con>=5 & adl_con<=6
label define adl_lbl 1"0-2 ADLs"2"3-4 ADLs"3"5-6 ADLs"
la values adl_cat adl_lbl

stset exit_months, f(fail==1) exit(exit_months==36)


sts list, by(adl_cat)  at(1 2 3 to 36)
sts list,  at(1 2 3 to 36)

sts graph, by(adl_cat) xtitle(Months From Index) xlabel(3(3)36) title("Index Date to Long-Term NH, Survived >3m post NH") ci

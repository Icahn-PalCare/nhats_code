 use "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added_old_trunc1.dta", clear

 
 tab dem_3_cat, missing
 replace dem_3_cat = . if dem_3_cat == -1
 tab dem_3_cat, gen(dem_cat)
 label var dem_cat1 "Dementia: Probable"
 label var dem_cat2 "Dementia: Possible"
 label var dem_cat3 "Dementia: No Dementia"

 tab maritalstat

 replace maritalstat = . if maritalstat == -9
  tab maritalstat, gen(marital)
 label var marital1 "Marital Stat: Married"
 label var marital2 "Marital Stat: Live w/Partner"
 label var marital3 "Marital Stat: Separated"
 label var marital4 "Marital Stat: Divorced"
 label var marital5 "Marital Stat: Widowed"
 label var marital6 "Marital Stat: Never Married"
 gen spouse = 1 if maritalstat == 1 | maritalstat == 2
 replace spouse = 0 if maritalstat == 3 | maritalstat == 4 | maritalstat==5 | maritalstat == 6
 replace spouse = -7 if maritalstat == -7
 replace spouse = -8 if maritalstat == -8
 tab spouse
 label var spouse "Marital Stat: Married or Live w/Partner"
   
 tab income_cat, gen(income_cat)
 label var income_cat1 "Income: <15,000"
 label var income_cat2 "Income: 15-29,999"
 label var income_cat3 "Income: 30-59,999"
 label var income_cat4 "Income: >60,000"
 
 gen race_cat_1 = race_cat
 replace race_cat_1 = . if race_cat < 0
 tab race_cat_1, gen(race_cat)
 label var race_cat1 "Race: White (Non-His)"
 replace race_cat1 = -7 if race_cat == -7
 replace race_cat1 = -8 if race_cat == -8
 label var race_cat2 "Race: Black (Non-His)"
 replace race_cat2 = -7 if race_cat == -7
 replace race_cat2 = -8 if race_cat == -8
 label var race_cat3 "Race: Other"
 replace race_cat3 = -7 if race_cat == -7
 replace race_cat3 = -8 if race_cat == -8
 label var race_cat4 "Race: Hispanic"
 replace race_cat4 = -7 if race_cat == -7
 replace race_cat4 = -8 if race_cat == -8
 
 tab education
 gen education_1 = education
 replace education_1 = . if education < 0
 tab education_1, gen(education_cat)
  foreach vars in education_cat{ 
	 foreach w in 1 2 3 4{
	 replace `vars'`w' = -7 if education == -7
	 replace `vars'`w' = -8 if education == -8
	 }
 }
 label var education_cat1 "Education: < HS"
 label var education_cat2 "Education: High School"
 label var education_cat3 "Education: Some College"
 label var education_cat4 "Education: >= Bachelors"
 
 gen srh_1 = srh
 replace srh_1 = . if srh < 0
 tab srh_1, gen(srh_cat)
 foreach vars in srh_cat{ 
	 foreach w in 1 2 3 4 5{
	 replace `vars'`w' = -7 if srh == -7
	 replace `vars'`w' = -8 if srh == -8
	 }
}
 label var srh_cat1 "SRH: Excellent"
 label var srh_cat2 "SRH: Very Good"
 label var srh_cat3 "SRH: Good"
 label var srh_cat4 "SRH: Fair"
 label var srh_cat5 "SRH: Poor"
 
 gen memory_1 = memory
 replace memory_1 = . if memory <0
 tab memory_1, gen(memory_cat)
 foreach vars in memory_cat{ 
	 foreach w in 1 2 3 4 5{
	 replace `vars'`w' = -7 if memory == -7
	 replace `vars'`w' = -8 if memory == -8
	 }
}
 label var memory_cat1 "Memory: Excellent"
 label var memory_cat2 "Memory: Very Good"
 label var memory_cat3 "Memory: Good"
 label var memory_cat4 "Memory: Fair"
 label var memory_cat5 "Memory: Poor"
 
 

 saveold "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added_old_trunc_lab1.dta", replace

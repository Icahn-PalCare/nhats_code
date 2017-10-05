use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta", clear


gen ffs_month_5 = 0
gen ffs_month_6 = 0
gen ffs_month_7 = 0
gen ffs_month_8 = 0
gen ffs_month_9 = 0
gen ffs_month_10 = 0
gen ffs_month_11 = 0

gen ffs_12m_hcc = 0

forvalues i=5/11 {

replace ffs_12m_hcc = 1 if ivw_month_`i'==ivw_month
}





keep if ffs_12==1
keep spid bene_id index_date ivw_month index_year wave
tab index_date
gen leap = 0
replace leap = 1 if year(index_date)==2012
replace index_date = index_date-365 if leap==0
replace index_date = index_date-365.25 if leap==1
tab index_date
replace index_year = index_year-1
keep if wave<=3

duplicates drop spid bene_id index_year, force

saveold "E:\nhats\data\Projects\IAH\int_data\ffs_list.dta", version(12) replace


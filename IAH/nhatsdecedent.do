/* Creating decedent dataset using cleaned serious illness + lml from raw data */

use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta" , clear
keep if wave<4
keep if died_12
keep spid
duplicates drop 


save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\spid_died.dta", replace

use "E:\nhats\data\Projects\serious_ill\final_data\serious_ill_nhats_sample.dta" , clear
merge m:1 spid using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\spid_died.dta"
keep if _m==3
keep if wave<=4
drop _m

save "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", replace


 
use "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_SP_File_old.dta", clear
keep spid lm2* pd2*
gen wave = 2


local lmlvars pd2placedied pd2homedied pd2hospdied pd2hospice1 pd2hospice2 pd2stayunit pd2staydays ///
pd2staywks pd2staymths pd2stayyrs pd2staymthpl pd2placepre pd2alert pd2outbed lm2pain lm2painhlp ///
lm2painhlpam lm2bre lm2brehlp lm2brehlpam lm2sad lm2sadhlp lm2sadhlpam lm2caredecis lm2carenowan ///
lm2perscare lm2respect lm2informed lm2doctor lm2docclear lm2relg lm2relgamt lm2ratecare

foreach x of local lmlvars {
recode `x' (-1=.) (-8/-7=0) // recode N/A (still alive at time of ivw) to missing and DK to 0

local new = substr("`x'",4,.)
rename `x' `new'

}

save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w2.dta", replace




use "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_SP_File_old.dta", clear
keep spid lm3* pd3*
gen wave = 3


local lmlvars lm3pain lm3painhlp lm3painhlpam lm3bre lm3brehlp lm3brehlpam lm3sad ///
lm3sadhlp lm3sadhlpam lm3caredecis lm3carenowan lm3perscare lm3respect lm3informed ///
lm3doctor lm3docclear lm3relg lm3relgamt lm3ratecare pd3placedied pd3homedied ///
pd3hospdied pd3hospice1 pd3hospice2 pd3stayunit pd3staydays pd3staywks pd3staymths ///
pd3stayyrs pd3staymthpl pd3placepre pd3hospcelml pd3alert pd3outbed

foreach x of local lmlvars {
recode `x' (-1=.) (-8/-7=0)  // recode N/A (still alive at time of ivw) to missing and DK to 0

local new = substr("`x'",4,.)
rename `x' `new'

}

save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w3.dta", replace

use "E:\nhats\data\NHATS Public\round_4\NHATS_Round_4_SP_File.dta", clear
keep spid lm4* pd4* 
gen wave = 4

local lmlvars pd4placedied pd4homedied pd4hospdied pd4hospice1 pd4hospice2 pd4stayunit pd4staydays ///
pd4staywks pd4staymths pd4stayyrs pd4staymthpl pd4placepre pd4hospcelml pd4alert pd4outbed ///
lm4pain lm4painhlp lm4painhlpam lm4bre lm4brehlp lm4brehlpam lm4sad lm4sadhlpam lm4caredecis ///
lm4carenowan lm4perscare lm4respect lm4informed lm4doctor lm4docclear lm4relg lm4relgamt lm4ratecare lm4sadhlp

foreach x of local lmlvars {
recode `x' (-1=.) (-8/-7=0)  // recode N/A (still alive at time of ivw) to missing and DK to 0

local new = substr("`x'",4,.)
rename `x' `new'

}

save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w4.dta", replace


use "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", clear
merge 1:1 spid wave using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w2.dta"
drop if _m==2
drop _m
keep if wave==2
save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w2.dta", replace



use "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", clear
merge 1:1 spid wave using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w3.dta"
drop if _m==2
drop _m
keep if wave==3
save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w3.dta", replace

use "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", clear
merge 1:1 spid wave using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w4.dta"
drop if _m==2
drop _m
keep if wave==4
save "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w4.dta", replace


use "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", clear
keep if wave==1
append using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w2.dta"
append using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w3.dta"
append using "E:\nhats\data\Projects\NHATS Decedent Dataset\int_data\lml_w4.dta"

save "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", replace

use "E:\nhats\data\NHATS cleaned\nsoc_round_1.dta", clear 

keep if cg_srh_pf==1
keep spid cg_srh_pf
duplicates drop

merge 1:m spid using "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta"

replace cg_srh_pf = 0 if cg_srh_pf==.

drop if _m==1
drop _m

save "E:\nhats\data\Projects\NHATS Decedent Dataset\final data\nhats_died.dta", replace





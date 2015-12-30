use "E:\nhats\data\Projects\Caregivers\raw_op_sens2.dta" ,clear

//age table

gen n = 1
gen cat_total = .

mat test1=J(5,6,.)
local r=1
local c=1

sum op1catgryage, detail
mat test1[1,3]=r(N)
sum op1catgryage if op1catgryage >= 1, detail
mat test1[1,1]=r(N)
mat test1[1,2]=r(N)
mat test1[1,4]=(test1[1,2]/test1[1,3])*100
sum op1dage if op1catgryage <= 0 & op1dage >=1, detail
mat test1[2,1]=r(N)
mat test1[2,2]=r(N)+ test1[1,2]
mat test1[2,3]=test1[1,3]
mat test1[2,4]=(test1[2,2]/test1[2,3])*100
sum chd1cgbrthyr if op1catgryage <= 0 & op1dage <=0 & chd1cgbrthyr > 0, detail
mat test1[3,1]=r(N)
mat test1[3,2]=r(N)+ test1[2,2]
mat test1[3,3]=test1[1,3]
mat test1[3,4]=(test1[3,2]/test1[3,3])*100

use "E:\nhats\data\Projects\Caregivers\nsoc_age.dta", clear

sum cg_age_cat, detail
mat test1[5,1]=r(N)
mat test1[5,2]=r(N)
sum spid, detail
mat test1[5,3]=r(N)
mat test1[5,4]=(test1[5,2]/test1[5,3])*100

frmttable using "E:\nhats\data\Projects\Caregivers\logs\Age_Setup.rtf", statmat(test1) rtitles ("Age Category (op1catgryage)"\"Adding in Age Category for those Missing (op1dage)"\"Adding in Age Category for those Missing (chd1cgbrthyr)"\ ///
"Merge with the Original NSOC sample (N=2007)"\"Total number of available Age Categories") ///
ctitles("" "N From Var." "Cumulative N." "Total Number of Obs in Database" "Percentage of Values Avail.") ///
store(test1) sdec(0,0,0,2) replace title("Age Category Breakdown") 

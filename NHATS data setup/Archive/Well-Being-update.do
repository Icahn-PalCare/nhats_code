use "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added.dta", clear

gen community_dwelling = 0
replace community_dwelling = 1 if r1dresid == 1 | r1dresid == 2 | r2dresid == 1 | r2dresid == 2 | r3dresid == 1 | r3dresid == 2 | r4dresid == 1 | r4dresid == 2 
gen SP_completed = 0
replace SP_completed = 1 if r1dresid == 1 | r1dresid == 2 | r2dresid == 1 | r2dresid == 2 | r2dresid == 4 | r3dresid == 1 | r3dresid == 2 | r3dresid == 4 | r4dresid == 1 | r4dresid == 2 | r4dresid == 4


foreach i in 1 2 3 4 {

replace wb1offelche`i' = 6 if wb1offelche`i' == -7 | wb1offelche`i' == -8
replace wb1offelche`i' = 7 if wb1offelche`i' == -1 | wb1offelche`i' == -9
replace wb1offelche`i' = 8 if wb1offelche`i' == 7 & proxy_ivw == 1
replace wb1offelche`i' = 9 if wb1offelche`i' == 7 & SP_completed == 0
tab wb1offelche`i', gen(wb1offelche`i'_)

}


local rn : word count wb1offelche1 wb1offelche2 wb1offelche3 wb1offelche4 n n n
local r=2
local c=1
mat test=J(`rn',12,.)	
foreach x in 1 2 3 4 {

	foreach y in 1 2 3 4 5 6 7 8 {
		sum wb1offelche`x'_`y'
		mat test[`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r'+1
local c = 1
}

frmttable using "E:\nhats\data\Logs - NHATS setup\Well-Being_How_Often_Feel.rtf", statmat(test) ctitles("" "Every Day (7 Days Week)" "Most Days (5-6 Days Week)" "Some Days (2-4 Days Week)" "Rarely (1 Day or Less)" "Never" "Missing due to DK/RF" "Missing due to Proxy" "Missing due to Community-dwelling") ///
rtitles("During the last Month, how often did you feel" \ "Cheerful" \ "Bored" \ "Full of Life" \ "Upset") store(test) sdec(0) replace varlabels  title("How often do you feel in the Past Month Questions Round 1")

foreach x in 2 3 4{
	foreach i in 1 2 3 4 {

	replace wb`x'offelche`i' = 6 if wb`x'offelche`i' == -7 | wb`x'offelche`i' == -8
	replace wb`x'offelche`i' = 7 if wb`x'offelche`i' == -1 | wb`x'offelche`i' == -9
	replace wb`x'offelche`i' = 8 if wb`x'offelche`i' == 7 & proxy_ivw == 1
	replace wb`x'offelche`i' = 9 if wb`x'offelche`i' == 7 & SP_completed == 0
	tab wb`x'offelche`i', gen(wb`x'offelche`i'_)

	}
}

foreach z in 2 3 4{
local rn : word count wb1offelche1 wb1offelche2 wb1offelche3 wb1offelche4 n n n
local r=2
local c=1
mat test=J(`rn',12,.)	
foreach x in 1 2 3 4 {

	foreach y in 1 2 3 4 5 6 7 8 {
		sum wb`z'offelche`x'_`y'
		mat test[`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r'+1
local c = 1
}
frmttable using "E:\nhats\data\Logs - NHATS setup\Well-Being_How_Often_Feel.rtf", statmat(test) ctitles("" "Every Day (7 Days Week)" "Most Days (5-6 Days Week)" "Some Days (2-4 Days Week)" "Rarely (1 Day or Less)" "Never" "Missing due to DK/RF" "Missing due to Proxy" "Missing due to Community-dwelling") ///
rtitles("During the last Month, how often did you feel" \ "Cheerful" \ "Bored" \ "Full of Life" \ "Upset") store(test) sdec(0) addtable varlabels  title("How often do you feel in the Past Month Questions Round `z'")
}



//Next Step is in another set of questions


foreach i in 1 2 3 4 {

replace wb1truestme`i' = 6 if wb1truestme`i' == -7 | wb1truestme`i' == -8
replace wb1truestme`i' = 7 if wb1truestme`i' == -1 | wb1truestme`i' == -9
replace wb1truestme`i' = 8 if wb1truestme`i' == 7 & proxy_ivw == 1
replace wb1truestme`i' = 9 if wb1truestme`i' == 7 & SP_completed == 0
tab wb1truestme`i', gen(wb1truestme`i'_)

}

foreach i in 1 2 3 {

replace wb1agrwstmt`i' = 6 if wb1agrwstmt`i' == -7 | wb1agrwstmt`i' == -8
replace wb1agrwstmt`i' = 7 if wb1agrwstmt`i' == -1 | wb1agrwstmt`i' == -9
replace wb1agrwstmt`i' = 8 if wb1agrwstmt`i' == 7 & proxy_ivw == 1
replace wb1agrwstmt`i' = 9 if wb1agrwstmt`i' == 7 & SP_completed == 0
tab wb1agrwstmt`i', gen(wb1agrwstmt`i'_)

}


local rn : word count wb1truestme1 wb1truestme2 wb1truestme3 wb1truestme4 wb1agrwstmt1 wb1agrwstmt2 wb1agrwstmt3 n n n
local r=2
local c=1
mat test=J(`rn',12,.)	
foreach x in 1 2 3 4 {

	foreach y in 1 2 3 4 5 6  {
		sum wb1truestme`x'_`y'
		mat test[`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r'+1
local c = 1
}
local r = `r'+1
foreach x in 1 2 3 {
	foreach y in 1 2 3 4 5 6 {
		sum wb1agrwstmt`x'_`y'
		mat test [`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r' + 1
local c = 1


}

frmttable using "E:\nhats\data\Logs - NHATS setup\Well-Being_About_Life.rtf", statmat(test) ctitles("" "Agree A Lot" "Agree a Little" "Agree Not at all" "Missing due to DK/RF" "Missing due to Proxy" "Missing due to Community-dwelling") ///
rtitles("Agree with Following Statements" \ "	My life has meaning and Purpose" \ "	I feel confident and Good about myself" \ "		I gave up trying to improve my life" \ "	I like my living situation" \ "" \ "	Other people determine most of what I can do" \ "	When I want something, I find a way to do it" \ "	Easy time adjusting to change") store(test) sdec(0) replace varlabels  title("Agree A lot/Little/Not at all with the Following Statements (Round 1)")

foreach x in 2 3 4{
	foreach i in 1 2 3 4 {

	replace wb`x'truestme`i' = 6 if wb`x'truestme`i' == -7 | wb`x'truestme`i' == -8
	replace wb`x'truestme`i' = 7 if wb`x'truestme`i' == -1 | wb`x'truestme`i' == -9
	replace wb`x'truestme`i' = 8 if wb`x'truestme`i' == 7 & proxy_ivw == 1
	replace wb`x'truestme`i' = 9 if wb`x'truestme`i' == 7 & SP_completed == 0
	tab wb`x'truestme`i', gen(wb`x'truestme`i'_)

	}
	foreach i in 1 2 3 {

	replace wb`x'agrwstmt`i' = 6 if wb`x'agrwstmt`i' == -7 | wb`x'agrwstmt`i' == -8
	replace wb`x'agrwstmt`i' = 7 if wb`x'agrwstmt`i' == -1 | wb`x'agrwstmt`i' == -9
	replace wb`x'agrwstmt`i' = 8 if wb`x'agrwstmt`i' == 7 & proxy_ivw == 1
	replace wb`x'agrwstmt`i' = 9 if wb`x'agrwstmt`i' == 7 & SP_completed == 0
	tab wb`x'agrwstmt`i', gen(wb`x'agrwstmt`i'_)

	}
}

foreach z in 2 3 4{
local rn : word count wb1truestme1 wb1truestme2 wb1truestme3 wb1truestme4 wb1truestme1 wb1truestme2 wb1truestme3 wb1truestme4 wb1agrwstmt1 wb1agrwstmt2 wb1agrwstmt3 n n n
local r=2
local c=1
mat test=J(`rn',12,.)	
foreach x in 1 2 3 4 {

	foreach y in 1 2 3 4 5 6 {
		sum wb`z'truestme`x'_`y'
		mat test[`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r'+1
local c = 1
}
local r = `r'+1
foreach x in 1 2 3 {
	foreach y in 1 2 3 4 5 6 {
		sum wb`z'agrwstmt`x'_`y'
		mat test [`r',`c']=r(sum)
		local c = `c' + 1
	}
local r = `r' + 1
local c = 1
}
frmttable using "E:\nhats\data\Logs - NHATS setup\Well-Being_About_Life.rtf", statmat(test) ctitles("" "Agree A Lot" "Agree a Little" "Agree Not at all" "Missing due to DK/RF" "Missing due to Proxy" "Missing due to Community-dwelling") ///
rtitles("Agree with Following Statements" \ "	My life has meaning and Purpose" \ "	I feel confident and Good about myself" \ "		I gave up trying to improve my life" \ "	I like my living situation" \ "" \ "	Other people determine most of what I can do" \ "	When I want something, I find a way to do it" \ "	Easy time adjusting to change") store(test) sdec(0) addtable varlabels  title("Agree A lot/Little/Not at all with the Following Statements (Round `z')")

}

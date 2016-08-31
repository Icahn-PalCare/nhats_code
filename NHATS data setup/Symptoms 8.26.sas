



/*******SP FILES******/

Data nhats1;
set nhats.r1sp;
drop r1dresidr--r1breakoffqt
is1reasnprx1--is1reasnprx9 
is1prxyrelat--fl1bldgfl
ht1longlived--se1payservi9
cs1dreconcil--te1intrntmd3
dm1helpmobil--dt1otfrfamtk
ds1gethlpeat--ds1dhlpyrs
pa1vistfrfam--el1lvwmofaor
el1mothalive--rl1spkengwel
va1serarmfor--ip1mgapmedsp
ip1covtricar--ia1toincimf
ia1toincim2--fq1dlocsp
w1anfinwgt1--w1anfinwgt56;
run;


Data nhats2;
set nhats.r2sp;
drop r2dresidlml--cg2dwrd10dly 
fl2didntleav--fl2drvlstyr
ds2gethlpeat--w2varunit;
run;

Data nhats3;
set nhats.r3sp;
drop r3dresidlml--cg3dwrd10dly 
fl3didntleav--fl3drvlstyr
ds3gethlpeat--w3varunit;
run;

/*******SENSITIVE FILES******/

Data r1sensitive;
set nhats.r1sensitive;
keep spid r1dintvwrage;
run;


Data r2sensitive;
set nhats.r2sensitive;
keep spid pd2mthdied pd2yrdied;
run;

Data r3sensitive;
set nhats.r3sensitive;
keep spid pd3mthdied pd3yrdied;
run;


/****** TRACKER FILES*******/

Data r1tracker;
set nhats.r1tracker;
keep spid r1status r1status r1casestdtmt r1casestdtyr r1spstatdtmt r1spstatdtyr;
run;


Data r2tracker;
set nhats.r2tracker;
keep spid r2status r2casestdtmt r2casestdtyr ;
run;


Data r3tracker;
set nhats.r3tracker;
keep spid r3status r3casestdtmt r3casestdtyr;
run;




/*************Merge round 1-3 sp, sensitive, tracker*************/
proc sort data = nhats1;
by spid;
run;
proc sort data = nhats2;
by spid;
run;

proc sort data = nhats3;
by spid;
run;

proc sort data = r1sensitive;
by spid;
run;

proc sort data = r2sensitive;
by spid;
run;

proc sort data = r3sensitive;
by spid;
run;

proc sort data = r1tracker;
by spid;
run;

proc sort data = r2tracker;
by spid;
run;

proc sort data = r3tracker;
by spid;
run;

data all;
merge nhats1 nhats2 nhats3 r1sensitive r2sensitive r3sensitive r1tracker r2tracker r3tracker;
by spid;
run;

data junk;
set all (where = (r2status =86));
run;

/*Remove residents of nursing homes and FQ only observations
Round 1 Residential Status
The variable r1dresid has the following values:
1 = SP resides in community and an SP interview was completed
2 = SP resides in residential care (not nursing home) and an SP interview was completed
3 = SP resides in residential care (not nursing home) but only an FQ was completed (SP interview was missing)
4 = SP resides in a nursing home and by design has only an FQ interview*/
/*EXCLUDED: n= 468 nursing home residents at baseline*/
data work1;
set all (where = (r1dresid = 1 or r1dresid = 2));
run;

proc freq data = work1;
tables r1dintvwrage*r1dresid;
run;




/*Create derived variables*/
/*Create homebound round 1*/
/*Create homebound variable with 6 groups
0.	Completely 	Never went out in the last month
1.	Mostly 	Rarely (once a week or less) went out in the last month
2.	Never by self	Go out at least sometimes (twice per week), but never by themselves
3.	Needs help and/or has difficulty	Go out at least sometimes (twice per week), but needs help and/ or has difficulty
4.	Low frequency	Go  out 2-4 times per week without help and/or difficulty
5.	High frequency	Go out most days (at least 5 days per week) without help and/or difficulty*/

/*0.completely*/
data work2;
set work1;
levelzero = 0;
if mo1outoft = 5 then levelzero = 1;

/*1.mostly*/
levelone = 0;
if mo1outoft = 4 then levelone = 1;

/*2.neverbyself*/
leveltwo = 0;
if (mo1outoft = 1 and mo1outslf = 4) or (mo1outoft = 2 and mo1outslf = 4) or (mo1outoft = 3 and mo1outslf = 4) then leveltwo = 1;

/*3.needs help and/or has difficulty
generate needs help*/
needshelp = 0;
if mo1outhlp = 1 and mo1outslf ~= 4 then needshelp = 1;

/*generate has difficulty*/
difficult = 0;
if mo1outdif = 2 or mo1outdif = 3 or mo1outdif = 4 or mo1outdif = -8 then difficult = 1;

/*generate needs help and/or has difficulty*/
helpdiff = 0;
if needshelp = 1 or difficult = 1 then helpdiff = 1;

/*generate level 3*/
levelthree = 0;
if (mo1outoft =1 and helpdiff = 1) or (mo1outoft =2 and helpdiff = 1) or (mo1outoft = 3 and helpdiff = 1) then levelthree = 1;

/*4.low freq, no help or difficulty*/
independent = 0;
if mo1outhlp = 2 and mo1outdif = 1 then independent = 1;

/*5.high frequency*/ 
levelfour = 0;
if mo1outoft = 3 and independent = 1 then levelfour = 1;

levelfive = 0;
if (mo1outoft = 1 and independent = 1) or (mo1outoft = 2 and independent = 1) then levelfive= 1; 
run;

data work3;
set work2;
homebound = .;
if levelzero  = 1 then homebound = 0;
if levelone = 1 then homebound = 1;
if leveltwo = 1 then homebound = 2;
if levelthree = 1 then homebound = 3;
if levelfour = 1 then homebound = 4;
if levelfive = 1 then homebound = 5;
run;

proc surveyfreq data = work3;
tables homebound;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;


/*Create homebound round 2*/
/*0.completely*/
data work4;
set work3;
level2zero = 0;
if mo2outoft = 5 then level2zero = 1;

/*1.mostly*/
level2one = 0;
if mo2outoft = 4 then level2one = 1;

/*2.neverbyself*/
level2two = 0;
if (mo2outoft = 1 and mo2outslf = 4) or (mo2outoft = 2 and mo2outslf = 4) or (mo2outoft = 3 and mo2outslf = 4) then level2two = 1;

/*3.needs help and/or has difficulty
generate needs help*/
needs2help = 0;
if mo2outhlp = 1 and mo2outslf ~= 4 then needs2help = 1;

/*generate has difficulty*/
diff2icult = 0;
if mo2outdif = 2 or mo2outdif = 3 or mo2outdif = 4 or mo2outdif = -8 then diff2icult = 1;

/*generate needs help and/or has difficulty*/
helpdiff2 = 0;
if needs2help = 1 or diff2icult = 1 then help2diff = 1;

/*generate level 3*/
level2three = 0;
if (mo2outoft =1 and help2diff = 1) or (mo2outoft =2 and help2diff = 1) or (mo2outoft = 3 and help2diff = 1) then level2three = 1;

/*4.low freq, no help or difficulty*/
inde2pendent = 0;
if mo2outhlp = 2 and mo2outdif = 1 then inde2pendent = 1;

/*5.high frequency*/ 
level2four = 0;
if mo2outoft = 3 and inde2pendent = 1 then level2four = 1;

level2five = 0;
if (mo2outoft = 1 and inde2pendent = 1) or (mo2outoft = 2 and inde2pendent = 1) then level2five = 1; 
run;

data work5;
set work4;
home2bound = .;
if level2zero  = 1 then home2bound = 0;
if level2one = 1 then home2bound = 1;
if level2two = 1 then home2bound = 2;
if level2three = 1 then home2bound = 3;
if level2four = 1 then home2bound = 4;
if level2five = 1 then home2bound = 5;
run;


/*Create homebound round 3*/
/*0.completely*/
data work6;
set work5;
level3zero = 0;
if mo3outoft = 5 then level3zero = 1;

/*1.mostly*/
level3one = 0;
if mo3outoft = 4 then level3one = 1;

/*2.neverbyself*/
level3two = 0;
if (mo3outoft = 1 and mo3outslf = 4) or (mo3outoft = 2 and mo3outslf = 4) or (mo3outoft = 3 and mo3outslf = 4) then level3two = 1;

/*3.needs help and/or has difficulty
generate needs help*/
needs3help = 0;
if mo3outhlp = 1 and mo3outslf ~= 4 then needs3help = 1;

/*generate has difficulty*/
diff3icult = 0;
if mo3outdif = 2 or mo3outdif = 3 or mo3outdif = 4 or mo3outdif = -8 then diff3icult = 1;

/*generate needs help and/or has difficulty*/
helpdiff3 = 0;
if needs3help = 1 or diff3icult = 1 then help3diff = 1;

/*generate level 3*/
level3three = 0;
if (mo3outoft =1 and help3diff = 1) or (mo3outoft =2 and help3diff = 1) or (mo3outoft = 3 and help3diff = 1) then level3three = 1;

/*4.low freq, no help or difficulty*/
inde3pendent = 0;
if mo3outhlp = 2 and mo3outdif = 1 then inde3pendent = 1;

/*5.high frequency*/ 
level3four = 0;
if mo3outoft = 3 and inde3pendent = 1 then level3four = 1;

level3five = 0;
if (mo3outoft = 1 and inde3pendent = 1) or (mo3outoft = 2 and inde3pendent = 1) then level3five = 1; 
run;

data work7;
set work6;
home3bound = .;
if level3zero  = 1 then home3bound = 0;
if level3one = 1 then home3bound = 1;
if level3two = 1 then home3bound = 2;
if level3three = 1 then home3bound = 3;
if level3four = 1 then home3bound = 4;
if level3five = 1 then home3bound = 5;
run;

/* deleting non-deceased "missing"*/

data work8;
set work7;
if homebound = . then delete;
run;
/*6 already deleted*/


/*CREATE TERCILES OF HOMEBOUND STATUS*/
/*turn homebound status into terciles*/
data work12;
set work8;
hometer = .;
if homebound = 0 then hometer = 0;
if homebound = 1 then hometer = 0;
if homebound = 2 then hometer = 1;
if homebound = 3 then hometer = 1;
if homebound = 4 then hometer = 2;
if homebound = 5 then hometer = 2;

home2ter = .;
if home2bound = 0 then home2ter = 0;
if home2bound = 1 then home2ter = 0;
if home2bound = 2 then home2ter = 1;
if home2bound = 3 then home2ter = 1;
if home2bound = 4 then home2ter = 2;
if home2bound = 5 then home2ter = 2;

home3ter = .;
if home3bound = 0 then home3ter = 0;
if home3bound = 1 then home3ter = 0;
if home3bound = 2 then home3ter = 1;
if home3bound = 3 then home3ter = 1;
if home3bound = 4 then home3ter = 2;
if home3bound = 5 then home3ter = 2;
run;


/*VARIABLES FOR ROUND 2 AND 3 STATUS*/
data work13;
set work12;
r2place = .;
if (r2dresid = 1 or r2dresid = 2) and home2ter = 0 then r2place = 0;
if (r2dresid = 1 or r2dresid = 2) and home2ter = 1 then r2place = 1;
if (r2dresid = 1 or r2dresid = 2) and home2ter = 2 then r2place = 2;
if (r2dresid = 6 or r2status = 86) then r2place = -1;
if (r2dresid = 4 or r2dresid = 5 or r2dresid = 8) then r2place = -6;

/*Variable for round 3 status*/
r3place = .;
if (r3dresid = 1 or r3dresid = 2) and home3ter = 0 then r3place = 0;
if (r3dresid = 1 or r3dresid = 2) and home3ter = 1 then r3place = 1;
if (r3dresid = 1 or r3dresid = 2) and home3ter = 2 then r3place = 2;
if (r3dresid = 6 or r3status = 86 or r2dresid = 6 or r3status = 86) then r3place = -1;
if (r3dresid = 4 or r3dresid = 5 or r3dresid = 8) then r3place = -6;
if r2dresid = -1 then r3place = -1;
run;

/*key for r_place
0 - homebound
1 - semihomebound
2 - not homebound
-1 - deceased
-6 - nursing home */




/*delete lost to follow-up round 2*/
data sig;
set work13;
if r2place = . then delete;
run;

/*delete HB and SHB at baseline */
data sig1;
set sig;
if (hometer = 0 or hometer = 1) then delete;
run;





/*****************Variables for cox  *************/

/*newly homebound; new = 1 yes, new = 0, no*/
data sig2;
set sig1;
new = 0;
if r2place = 0 then new = 1;
if r3place = 0 then new = 1;
run;

/*homebound date*/
data sig3;
set sig2;
newdate = .;
if r2place = 0 then newdate =  INT(MDY(r2casestdtmt, 1, r2casestdtyr));
if (r3place = 0 and r2place ~= 0) then newdate = INT(MDY(r3casestdtmt, 1, r2casestdtyr));
run;

/*nursing home admission*/
data sig4;
set sig3;
nh = 0;
if r2place = -6 or r2place = -6 then nh = 1;
run;

/*nursing home admission date */
data sig5;
set sig4;
nhdate = .;
if r2place = -6 then nhdate = INT(MDY(r2casestdtmt, 1, r2casestdtyr));
if (r3place = -6 and r3place ~=-6) then nhdate = INT(MDY(r3casestdtmt, 1, r3casestdtyr));
run;

/*death*/
data sig6;
set sig5;
death = 0;
if r2place = -1 then death = 1;
if r3place = -1 then death = 1;
run;

/*death date*/
data sig7;
set sig6;
month = .;
if r2place = -1 and pd2mthdied >= 1 then month = pd2mthdied;
if r2place = -1 and pd2mthdied < 1 then month = 1;
if r3place = -1 and pd3mthdied >= 1 then month = pd3mthdied;
if r3place = -1 and pd3mthdied < 1 then month = 1;

/*create end year*/
year = .;
if (r3place = -1 and r2place ~=-1) and pd2yrdied = 1 then year = 2011;
if (r3place = -1 and r2place ~=-1) and pd2yrdied = 2 then year = 2012;
if (r3place = -1 and r2place ~=-1) and pd2yrdied < 1 then year = 2012;
if (r3place = -1 and r2place ~=-1) and pd3yrdied < 1 then year = 2013;
if (r3place = -1 and r2place ~=-1) and pd3yrdied >= 1 then year = pd3yrdied;

deathdate = INT (MDY(month,1,year));
run;

/*end of study*/
data sig8;
set sig7;
endofstudy = INT(MDY(r3casestdtmt, 1, r3casestdtyr));
run;


/*censor variable*/
data final;
set sig8;
startdate = INT(MDY(r1spstatdtmt, 1, r1spstatdtyr));
censor = .;
censdate = .;
if new = 1 then do;
	censor = 0;
	censdate = newdate;
	end;
else if nh = 1 then do;
	censor = 1;
	censdate = nhdate;
	end;
else if death = 1 then do;
	censor = 2;
	censdate = deathdate;
	end;
else if death ~=1 then do;
	censor = 3;
	censdate = endofstudy;
	end;
lenfol = censdate - startdate;
run;



/*******Table 1********/

/*age*/
proc sort data = final;
by new;
run;

proc surveyreg data=final;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
class new;
MODEL r1dintvwrage=new; 
lsmeans new/diff cl;
run;

proc surveyfreq data = final;
tables new * r1d2intvrage /chisq row;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;


/*gender*/
proc surveyfreq data = final;
tables new * r1dgender /chisq row;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

/*race*/
data tru1;
set final;
raceethnicity = .;
if rl1dracehisp = 5 then raceethnicity = 3;
else if rl1dracehisp = 6 then raceethnicity = 3;
else raceethnicity = rl1dracehisp;
run;

proc surveyfreq data = tru1;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * raceethnicity /chisq row;
run;


/*education*/
data tru2;
set tru1;
education = .;
if (el1higstschl = 1 or el1higstschl = 2 or el1higstschl = 3) then education = 1;
if (el1higstschl = 4) then education = 2;
if (el1higstschl = 5 or el1higstschl = 6 or el1higstschl = 7 or el1higstschl = 8 or el1higstschl = 9) then education = 3;
run;

proc surveyfreq data = tru2;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * education /chisq row;
run;

/*marital status*/
data tru3;
set tru2;
married = .;
if (hh1martlstat = 1 or hh1martlstat = 2) then married = 1;
if (hh1martlstat = 3 or hh1martlstat = 4 or hh1martlstat = 5 or hh1martlstat = 6) then married = 2;
run;

proc surveyfreq data = tru3;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * married /chisq row;
run;

/*Living arrangement*/
/*1 = lives alone, 2 = lives with others */ 
data tru4;
set tru3;
livingarrange = .; 
if (hh1dlvngarrg = 1 or hh1dhshldnum = 1) then livingarrange = 1; 
if hh1dlvngarrg = 2 or hh1dlvngarrg = 3 or hh1dlvngarrg = 4 then livingarrange = 2;
run;

proc surveyfreq data = tru4;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * livingarrange/chisq row;
run;


/*income*/
data tru5;
set tru4;
income = .;
if ia1toincim1 <15000 then income = 1;
if (ia1toincim1 >=15000 and ia1toincim1 <30000) then income = 2;
if (ia1toincim1 >=30000 and ia1toincim1 <60000) then income = 3;
if (ia1toincim1 >=60000) then income = 4;
run;

proc surveyfreq data = tru5;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * income/chisq row;
run;


/*medicaid*/
data medicaid;
set tru5;
medicaid = .;
if ip1cmedicaid = 1 then medicaid = 1;
if ip1cmedicaid = 2 then medicaid = 2;
run;

proc surveyfreq data=medicaid;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * medicaid /chisq row;
run;

/*chronic diseases, which 1=yes, 2= no*/
/*heart attack*/
data tru6;
set medicaid;
heart = .;
if hc1disescn1 = 1 then heart = 1;
if hc1disescn1 = 2 then heart = 2;
run;

proc surveyfreq data = tru6;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * heart/chisq row;
run;

/*heart disease*/
data tru55;
set tru6;
heartdisease = .;
if hc1disescn2 = 1 then heartdisease = 1;
if hc1disescn2 = 2 then heartdisease = 2;
run;

proc surveyfreq data = tru55;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * heartdisease/chisq row;
run;

/*hypertension*/
data tru7;
set tru6;
htn = .;
if hc1disescn3 = 1 then htn = 1;
if hc1disescn3 = 2 then htn = 2;
run;

proc surveyfreq data = tru7;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * htn/chisq row;
run;

/*arthritis*/

data tru8;
set tru7;
arthritis = .;
if hc1disescn4 = 1 then arthritis = 1;
if hc1disescn4 = 2 then arthritis = 2;
run;

proc surveyfreq data = tru8;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * arthritis/chisq row;
run;


/*osteoporosis*/
data trul8;
set tru7;
porosis = .;
if hc1disescn5 = 1 then porosis = 1;
if hc1disescn5 = 2 then porosis = 2;
run;

proc surveyfreq data = trul8;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * porosis/chisq row;
run;

/*diabetes*/
data tru9;
set tru8;
if hc1disescn6 = 1 then diabetes = 1;
if hc1disescn6 = 2 then diabetes = 2;
run;

proc surveyfreq data = tru9;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * diabetes/chisq row;
run;

/*lung disease*/
data tru10;
set tru9;
if hc1disescn7 = 1 then lung = 1;
if hc1disescn7 = 2 then lung = 2;
run;
proc surveyfreq data = tru10;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * lung/chisq row;
run;

/*stroke*/
data trul10;
set tru9;
if hc1disescn8 = 1 then stroke = 1;
if hc1disescn8 = 2 then stroke = 2;
run;

proc surveyfreq data = trul10;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * stroke/chisq row;
run;


/*dementia*/
data tru11;
set trul10;
demen = .;
if hc1disescn9 = 1then demen = 1;
if hc1disescn9 = 2 then demen = 2;
run;

proc surveyfreq data = tru11;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * demen/chisq row;
run;

/*cancer*/
data tru12;
set tru11;
demcanceren = .;
if hc1disescn10 = 1then cancer = 1;
if hc1disescn10 = 2 then cancer = 2;
run;
proc surveyfreq data = tru12;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * cancer/chisq row;
run;


/*chronic disease, number*/
data tru13;
set tru12;
hattack = 0;
if hc1disescn1 = 1 then hattack = 1;
hdisease = 0;
if hc1disescn2 = 1 then hdisease = 1;
htn = 0;
if hc1disescn3 = 1 then htn = 1;
arthritis = 0;
if hc1disescn4 = 1 then arthritis = 1;
osteo = 0;
if hc1disescn5 = 1 then osteo = 1;
diabetes = 0;
if hc1disescn6 = 1 then diabetes = 1;
lung = 0;
if hc1disescn7 = 1 then lung = 1;
stroke = 0;
if hc1disescn8 = 1 then stroke = 1;
dementia = 0;
if hc1disescn9 = 1 then dementia = 1;
cancer = 0;
if hc1disescn10 = 1 then cancer = 1;
run;

data tru14;
set tru13;
chronicdisease = (hattack + hdisease + htn + arthritis + osteo + diabetes + lung + stroke + dementia + cancer);
run;


data mean9;
set tru14;
if chronicdisease = 0 then delete;
run;

proc sort data = mean9;
by new;
run;

proc surveymeans data=mean9 t mean clm;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
var chronicdisease;
domain new;
run;

data tru16;
set tru14;
chronicqtr = .;
if (chronicdisease = 0 or chronicdisease = 1) then chronicqtr = 1;
if (chronicdisease = 2) then chronicqtr = 2;
if (chronicdisease = 3) then chronicqtr = 3;
if (chronicdisease =4) then chronicqtr = 4;
if (chronicdisease >=5) then chronicqtr = 5;
run;

data mm;
set tru16;
mm = .;
if (chronicdisease <=2) then mm = 0;
if chronicdisease >3 then mm = 1;
run;

proc surveyfreq data = mm;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * mm/chisq row;
run;

/*Create + screen for depression*/
data test41;
set mm;
phq91 = .;
if hc1depresan1 = 1 then phq91= 0;
if hc1depresan1 = 2 then phq91= 1;
if hc1depresan1 = 3 then phq91= 2;
if hc1depresan1 = 4 then phq91= 3;

phq92 = .;
if hc1depresan2 = 1 then phq92= 0;
if hc1depresan2 = 2 then phq92= 1;
if hc1depresan2 = 3 then phq92= 2;
if hc1depresan2 = 4 then phq92= 3;
run;

data test42;
set test41;
score = phq91 + phq92;
run;

/* depression, not depressed = 0, depressed = 1*/
data test43;
set test42;
depression = .;
if (score = 0!1!2) then depression = 0;
if score >=3 then depression = 1;
run;

proc surveyfreq data = test43;
tables new*depression /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

/*Create + screen for anxiety*/
data sx;
set test43;
gad91 = .;
if hc1depresan3 = 1 then gad91= 0;
if hc1depresan3 = 2 then gad91= 1;
if hc1depresan3 = 3 then gad91= 2;
if hc1depresan3 = 4 then gad91= 3;

gad92 = .;
if hc1depresan4 = 1 then gad92= 0;
if hc1depresan4 = 2 then gad92= 1;
if hc1depresan4 = 3 then gad92= 2;
if hc1depresan4 = 4 then gad92= 3;
run;

data sx2;
set sx;
ascore = gad91 + gad92;
run;

/* anxious, not anxious = 0, anxious = 1*/
data sx3;
set sx2;
anxiety = .;
if (ascore = 0 or ascore = 1 or ascore = 2) then anxiety = 0;
if ascore >=3 then anxiety = 1;
run;


proc surveyfreq data = sx3;
tables new*anxiety /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;


/*Create Unintentional weight loss */

data sx4;
set sx3;
weightloss = 0;
if hw1lst10pnds = 1 and hw1trytolose = 2 then weightloss = 1;
run;

proc surveyfreq data = sx4;
tables weightloss*new /cl or;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

/*Create difficulty sleeping (only most or every)*/
data sx5;
set sx4;
insomnia = 0;
if hc1sleepmed = 1 or hc1sleepmed = 2 or 
hc1aslep30mn = 1 or hc1aslep30mn = 2 or 
hc1trbfalbck = 1 or hc1trbfalbck = 2 then insomnia = 1;
run;


proc surveyfreq data = sx5;
tables new*insomnia /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

/*Counting number of symptoms */

data sx6;
set sx5;
pain = 0;
if ss1painbothr = 1 then pain = 1;
sob = 0;
if ss1probbreat = 1 then sob = 1;
upper = 0;
if ss1strnglmup = 1 then upper = 1;
lower = 0;
if ss1lwrbodstr = 1 then lower = 1;
energy = 0;
if ss1lowenergy = 1 then energy = 1;
balance = 0;
if ss1prbbalcrd = 1 then balance = 1;
run;

proc surveyfreq data = sx6;
tables new*pain /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyfreq data = sx6;
tables new*sob /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyfreq data = sx6;
tables new*upper /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyfreq data = sx6;
tables new*lower /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyfreq data = sx6;
tables new*energy /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyfreq data = sx6;
tables new*balance /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

data sx7;
set sx6;
totalsx = (pain + sob+ upper +lower + energy+ balance + depression + anxiety + insomnia + weightloss);
run;

data sx8;
set sx7;
sxq = .;
if (totalsx <= 2) then sxq = 1;
if (totalsx = 3 or totalsx = 4 or totalsx = 5) then sxq = 2;
if (totalsx >= 6 or totalsx = 5 or totalsx = 6) then sxq = 3;
run;


proc surveyfreq data = sx8;
tables new*sxq /chisq row;
weight w1anfinwgt0;
strata w1varstrat;
cluster w1varunit;
run;

proc surveyreg data=sx8;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
class new;
MODEL totalsx=new; 
lsmeans new/diff cl;
run;


/*avg # limiting sx*/
data sx9;
set sx8;
plim = 0;
if ss1painlimts = 1 then plim = 1;
slim = 0;
if ss1prbbrlimt = 1 then slim = 1;
ulim = 0;
if ss1uplimtact = 1 then ulim = 1;
llim = 0;
if ss1lwrbodimp = 1 then llim = 1;
elim = 0;
if ss1loenlmtat = 1 then elim = 1;
blim = 0;
if ss1prbbalcnt = 1 then blim = 1;
run;

data sx10;
set sx9;
limsx = plim + slim + ulim +llim +elim + blim;
run;

/* age as terciles */
data sx11;
set sx10;
age = .;
if (r1d2intvrage = 1 or r1d2intvrage = 2) then age = 1;
if (r1d2intvrage = 3 or r1d2intvrage = 4) then age = 2; 
if (r1d2intvrage = 5 or r1d2intvrage = 6) then age = 3;
run;

proc freq data = sx11;
tables age;
run;

proc surveyreg data=sx11;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
class new;
MODEL limsx=new; 
lsmeans new/diff cl;
run;






/*    Cox       */
 
proc surveyphreg data = sx11;
class age (ref = "1")/param=ref; 
model lenfol*censor(1,2,3) = age /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class r1dgender (ref = "1 MALE")/param=ref; 
model lenfol*censor(1,2,3) = r1dgender /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class raceethnicity (ref = "1")/param=ref; 
model lenfol*censor(1,2,3) = raceethnicity /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class livingarrange (ref = "1")/param=ref; 
model lenfol*censor(1,2,3) = livingarrange /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class mm (ref = "0")/param=ref; 
model lenfol*censor(1,2,3) = mm /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class medicaid (ref = "2")/param=ref; 
model lenfol*censor(1,2,3) = medicaid /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class sxq (ref = "1")/param=ref; 
model lenfol*censor(1,2,3) = sxq /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc surveyphreg data = sx11;
class sxq (ref = "1") age (ref = "1") r1dgender (ref = "1 MALE") raceethnicity (ref = "1") medicaid (ref = "2") /param=ref;
model lenfol*censor(1,2,3) =  age r1dgender raceethnicity medicaid livingarrange mm sxq/risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;

proc freq data = sx11;
tables new;
run;

/*Functional dependence*/
/*do it by yourself most times...
are you independent? yes = 0, no = 1*/

data tru17;
set sx9;
eating = .;
if sc1deathelp = 1 then eating = 0;
if (sc1deathelp = 2) then eating = 1;
bathing = .;
if sc1dbathhelp = 1 then bathing = 0;
if sc1dbathhelp = 2 then bathing = 1;
toileting = .;
if sc1dtoilhelp = 1 then toileting = 0;
if sc1dtoilhelp = 2 then toileting = 1;
dressing = .;
if sc1ddreshelp = 1 then dressing = 0;
if sc1ddreshelp = 2 then dressing = 1;
continence = .;
if (sc1toilwout = 1 or sc1usvartoi2 = 1) then continence = 1;
else if (sc1toilwout = 2 or sc1usvartoi2 = 2) then continence = 0;
transferring = .;
if mo1dbedhelp = 1 then transferring = 0;
if mo1dbedhelp = 2 then transferring = 1;
run;

data tru18;
set tru17;
adls = eating + bathing + toileting + dressing + continence + transferring;
run;

proc sort data = tru18;
by new;
run;

proc surveymeans data = tru18;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
var adls;
domain new;
run;

data tru19;
set tru18;
adlsqtr = .;
if adls = 0 then adlsqtr = 1;
if (adls = 1 or adls = 2 or adls = 3) then adlsqtr = 2;
if (adls = 4 or adls = 5 or adls = 6) then adlsqtr = 3;
run;

proc surveyfreq data=tru19;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables hometer02 * adlsqtr / chisq row;
tables hometer12 * adlsqtr / chisq row;
/*tables lthomebound02 * adlsqtr / chisq row;
tables lthomebound12 * adlsqtr / chisq row;*/
run;


/*Household activities*/
/*are you independent? yes = 0, no = 1*/

/*laundry*/
data tru20;
set tru19;
laundry = 0;
if ha1dlaunsfdf = 1 and ha1dlaunreas = 1 then laundry = 1; 

/*shopping*/
shopping = 0;
if ha1dshopsfdf = 1 and ha1dshopreas  = 1 then shopping = 1; 

/*cooking*/
cooking = 0;
if ha1dmealsfdf = 1 and ha1dmealreas = 1 then cooking = 1; 

/*finances*/
banking = 0;
if ha1dbanksfdf = 1 and ha1dbankreas = 1 then banking = 1; 

/*meds*/
meds = 0;
if mc1dmedssfdf = 1 and mc1dmedsreas = 1 then meds = 1;
run;

/*number household activities*/
data tru21;
set tru20;
hactivities = .;
hactivities = laundry + shopping + cooking + banking + meds;
run;

proc surveymeans data = tru21;
var hactivities;
domain new;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;


/* Walk at least 6 blocks */
data tru22;
set tru21;
walks = .;
if pc1walk6blks = 1 then walks = 0;
if pc1walk6blks = 2 then walks = 1;
run;

proc surveyfreq data=tru22;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
tables new * walks /or;
run;

proc surveyphreg data = test43;
class depression (ref = "0") /param=ref;
model lenfol*censor(1,2,3) = depression /risklimits;
weight w1anfinwgt0;
cluster w1varunit;
strata w1varstrat;
run;




















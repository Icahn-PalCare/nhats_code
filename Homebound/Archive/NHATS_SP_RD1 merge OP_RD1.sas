*Merging SP Round 1 homebound status to OP Round 1;
*Note: OP is not always helper;

libname NHATSRD1 '\\home\users$\lawk02\Documents\NHATS\Zipped\R1';
libname derived "\\home\users$\lawk02\Documents\NHATS\Derived dataset";

data round1_sp;
set NHATSRD1.Nhats_round_1_sp_file;
run;

proc format;
value homeboundf
	1 = "Homebound"
	2 = "Semi-homebound"
	3 = "Not homebound";
run;

data round1_sp;
set round1_sp;
/*0.completely*/
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

if levelzero  = 1 then homebound = 1;
if levelone = 1 then homebound = 1;
if leveltwo = 1 then homebound = 2;
if levelthree = 1 then homebound = 2;
if levelfour = 1 then homebound = 3;
if levelfive = 1 then homebound = 3;

if levelzero  = 1 then homebound2 = 1;
if levelone = 1 then homebound2 = 2;
if leveltwo = 1 then homebound2 = 3;
if levelthree = 1 then homebound2 = 4;
if levelfour = 1 then homebound2 = 5;
if levelfive = 1 then homebound2 = 6;

format homebound homeboundf.;
run;

proc freq data=round1_sp;
tables homebound;
run;

data round1_OP;
set NHATSRD1.NHATS_Round_1_OP_File_v2;
run;

proc sort data=round1_sp;
by SPID;
run;

proc sort data=round1_OP;
by SPID;
run;

data SP_OP_RD1;
merge round1_sp(in=a) round1_OP(in=b);
by SPID;
if b;
run;

data derived.SP_OP;
set SP_OP_RD1;
run;

proc freq data=derived.SP_OP;
tables homebound;
run;




libname claims "E:\nhats\data\CMS_DUA_28016\Merged";
libname line "E:\nhats\data\CMS_DUA_28016\Cumulative Years";
libname cyears "E:\nhats\data\CMS_DUA_28016\Cumulative Years";

proc import datafile="E:\nhats\data\Projects\IAH\final_data\IAH_final_sample_old.dta" out=nhats replace; run; 

data nhats (keep = spid bene_id wave ffs_6m index_date);
set nhats;
run;

/*
data carrier_pflag;
set claims.pb_09_14;
pos1flag = 0;
array dx pos1--pos13;
do over dx;
if dx in:(12,13,14) then pos1flag = 1;
output;
end;
run;

*/

data carrier;
set claims.pb_09_14;
array dx hcpcscd1--hcpcscd13;
do over dx;
cptcodes=dx;
output;
end;
/*
pos1flag = 0;
if pos1 in:(12,13,14) then pos1flag = 1;
if pos2 in:(12,13,14) then pos1flag = 1;
if pos3 in:(12,13,14) then pos1flag = 1;
if pos4 in:(12,13,14) then pos1flag = 1;
if pos5 in:(12,13,14) then pos1flag = 1;
if pos6 in:(12,13,14) then pos1flag = 1;
if pos7 in:(12,13,14) then pos1flag = 1;
if pos8 in:(12,13,14) then pos1flag = 1;
if pos9 in:(12,13,14) then pos1flag = 1;
if pos10 in:(12,13,14) then pos1flag = 1;
if pos11 in:(12,13,14) then pos1flag = 1;
if pos12 in:(12,13,14) then pos1flag = 1;
if pos13 in:(12,13,14) then pos1flag = 1;
*/
run;


data carrierline (keep = bene_id clm_id LINE_PLACE_OF_SRVC_CD cptcodes hcpcs_cd);
set line.bcarrier_line_j_09_14;
cptcodes = input(compress(hcpcs_cd,'ABCDEFGHIJKLMNOPQRSTUVWXYZ/',),8.);
run;

data carrierline;
set carrierline;
cptflag = 0;
posflag = 0;
if 99341<=cptcodes<=99350 or 99324<=cptcodes<=99328 or 99334<=cptcodes<=99337 then cptflag=1;
if LINE_PLACE_OF_SRVC_CD in:(12,13,14) then posflag=1;
run;

data carrierline;
set carrierline;
both = 0;
if cptflag = 1 and posflag = 1 then both = 1;
run;


proc sql;
create table carrier2 as select a.*, b.admit_date, b.disch_date
from carrierline a
inner join carrier b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;

proc sql;
create table carrier3 as select a.*, b.*
from carrier2 a
inner join nhats b
on a.bene_id=b.bene_id and -90<=b.index_date-a.admit_date<=90;
quit;


data carrier3;
set carrier3;
where ffs_6m = 1;
run;

proc freq data=carrierline; tables cptflag posflag both; run;

/* both */

data bothclaims;
set carrier3;
where both = 1;
same = 0;
if hcpcs_cd = cptcodes then same = 1; /*checking if the cptcodes from from carrier claims is the same as the hcpcs_cd code in carrier line */
run;

proc sort data=bothclaims nodupkey; by bene_id clm_id hcpcs_cd; run;

/* gen single line per claim for annual count */

proc sort data=bothclaims out=annual nodupkey; by bene_id clm_id; run;

data annual;
set annual;
year = year(admit_date);
run;

proc sql;
create table annual_1 as select distinct bene_id, year,
sum(both) as housecalls_count
from annual
group by bene_id, year;
quit;

data annual_1;
set annual_1;
if year = 2011 then wave = 1;
if year = 2012 then wave = 2;
if year = 2013 then wave = 3;
run;

proc export data=annual_1 outfile="E:\nhats\data\Projects\IAH\int_data\annualcpt_count.dta" dbms=stata replace; run;

proc freq data=bothclaims order=freq; tables hcpcs_cd; run;

proc sort data=bothclaims nodupkey; by bene_id wave; run;


data both_beneid (keep= bene_id wave bflag);
set bothclaims;
bflag = 1;
run;

proc freq data=both_beneid; tables wave; run;

proc export data=both_beneid outfile="E:\nhats\data\Projects\IAH\int_data\cpt+pos.dta" replace; run;

proc sort data=both_beneid out=test nodupkey; by bene_id; run;


/*cptcodes only */

data cptclaims;
set carrier3;
where cptflag= 1 and both=0;
run;

proc sql;
create table cptclaims1 as select a.*, b.bflag
from cptclaims a
left join both_beneid b
on a.bene_id=b.bene_id and a.wave=b.wave;
quit;

data cptclaims;
set cptclaims1;
if bflag = 1 then delete;
cflag = 1;
run;

proc sort data=cptclaims nodupkey; by bene_id clm_id hcpcs_cd; run;


proc freq data=cptclaims order=freq; tables hcpcs_cd; run;
proc freq data=cptclaims order=freq; tables LINE_PLACE_OF_SRVC_CD; run;

proc sort data=cptclaims nodupkey; by bene_id wave; run;
proc freq data=cptclaims ; tables wave; run;
proc sort data=cptclaims out=test nodupkey; by bene_id; run;

proc export data=cptclaims outfile="E:\nhats\data\Projects\IAH\int_data\cpt+only.dta" replace; run;


/*pos only */

data posclaims;
set carrier3;
where posflag = 1 and both=0;
run;

proc sql;
create table posclaims1 as select a.*, b.cflag
from posclaims a
left join cptclaims b
on a.bene_id=b.bene_id and a.wave=b.wave;
quit;

proc sql;
create table posclaims2 as select a.*, b.bflag
from posclaims1 a
left join both_beneid b
on a.bene_id=b.bene_id and a.wave=b.wave;
quit;

data posclaims;
set posclaims2;
if cflag = 1 or bflag = 1 then delete;
run;



proc sort data=posclaims nodupkey; by bene_id clm_id hcpcs_cd; run;
proc freq data=posclaims order=freq; tables hcpcs_cd; run;

 
proc sort data=posclaims nodupkey; by bene_id wave; run;

proc freq data=posclaims; tables wave; run;


proc sort data=posclaims nodupkey; by bene_id; run;


proc export data=posclaims outfile="E:\nhats\data\Projects\IAH\int_data\pos+only.dta" replace; run;





















/*cptcodes only */

data cptclaims;
set carrier3;
where cptflag= 1 and both=0;
run;

proc sql;
create table cptclaims1 as select a.*, b.pflag
from cptclaims a
left join posclaims b
on a.bene_id=b.bene_id and a.wave=b.wave;
quit;

data cptclaims;
set cptclaims1;
if pflag = 1 then delete;
run;

proc sort data=cptclaims nodupkey; by bene_id clm_id hcpcs_cd; run;


proc freq data=cptclaims order=freq; tables hcpcs_cd; run;
proc freq data=cptclaims order=freq; tables LINE_PLACE_OF_SRVC_CD; run;

proc sort data=cptclaims nodupkey; by bene_id wave; run;
proc freq data=cptclaims ; tables wave; run;

/* none */

data noclaims;
set carrier3;
where cpt


data carrier2 (keep = cptcodes hcpcs_cd) ;
set carrier2;
where posflag = 1 or pos1flag = 1;
run;

data carrier2 (keep = hcpcs_cd);
set carrier2;
run;
*/

proc sort data=carrier2 nodup; by hcpcs_cd; run;


proc export data=carrier2 outfile="E:\nhats\projects\IAH\20171115\cptcodes.xlsx" dbms=xlsx replace; run;

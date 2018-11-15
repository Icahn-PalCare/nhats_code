libname claims "E:\nhats\data\20180625 NHATS CMS Data\merged";
libname cyears "E:\nhats\data\20180625 NHATS CMS Data\Cumulative";

proc import datafile="E:\nhats\data\Projects\IAH\final_data\iah_wave1-5.dta" out=iv_mb2 dbms=stata replace; run; 


/* Identifying Inpatient Rehab */

data ip_check (keep = bene_id index_date index_month year wave ffs_6m);
set iv_mb2;
run;


data inpatient;
set claims.ip_06_16;
run;

data ip_rev;
set cyears.inpatient_revenue_center_j_06_16;
run;

proc sql;
create table ip_clm_rev as select a.*, b.*
from inpatient a
inner join ip_rev b
on a.bene_id = b.bene_id and a.clm_id = b.clm_id;
quit;

proc freq data=inpatient; tables PTNT_DSCHRG_STUS_CD; run;
proc freq data=ip_rev; tables REV_CNTR_UNIT_CNT; run;
 

data ip_clm_rev;
set ip_clm_rev;
disch_rehab = 0;
ip_rehab = 0;
if PTNT_DSCHRG_STUS_CD='62' or PTNT_DSCHRG_STUS_CD='90' then disch_rehab = 1;
if REV_CNTR_UNIT_CNT = 24 then ip_rehab = 1;
run;


proc freq data=ip_clm_rev; tables disch_rehab; run;
proc freq data=ip_clm_rev; tables ip_rehab; run;


data disch_2_iprehab;
set ip_clm_rev;
where disch_rehab = 1;
run;

data ip_rehab;
set ip_clm_rev;
where ip_rehab = 1;
run;


data test;
set disch_2_iprehab ip_rehab;
run;


proc sort data=test nodupkey; by bene_id admit_date; run;


proc sql;
create table ip_restays as select a.*, b.admit_date, b.disch_date
from ip_check a
inner join test b
on a.bene_id = b.bene_id and 0 < a.index_date-b.admit_date <365;
quit;

proc sort data=ip_restays out=ip_rehabstays nodupkey; by bene_id index_date; run;

data ip_rehabstays; /*inpatient hospital rehab stays */
set ip_rehabstays;
ip_rehab = 1;
run;

/* Checking for HH/SNF within 7 days of disch_date */

data homehealth;
set claims.hh_09_16;
run;

data snf;
set claims.snf_09_16;
run;

proc sql;
create table hh_nhats as select a.*, b.*
from ip_check a
inner join homehealth b
on a.bene_id = b.bene_id
where 0 < a.index_date - b.disch_date < 365;
quit;

data hh_nhats_short (keep = bene_id index_date admit_date disch_date hh);
set hh_nhats;
hh = 1;
run;

proc sql;
create table snf_nhats as select a.*, b.*
from ip_check a
inner join snf b
on a.bene_id = b.bene_id
where 0 <a.index_date - b.disch_date < 365;
quit;

data snf_nhats_short (keep = bene_id index_date admit_date disch_date snf);
set snf_nhats;
snf = 1;
run;

data rehab (rename=(admit_date = rehab_admit disch_date = rehab_disch));
set snf_nhats_short hh_nhats_short;
*format rehab_admit rehab_disch date10.;
run;

proc sql;
create table ip1 as select a.admit_date, a.disch_date, b.*
from inpatient a
inner join rehab b
on a.bene_id = b.bene_id
where 0 <= b.rehab_admit-a.disch_date < 8;
quit;

data ip1;
set ip1 ip_rehabstays;
run;

proc sort data=ip1; by bene_id index_date; run;
proc sort data=ip1 nodupkey; by bene_id index_date; run;

proc freq data=ip1; tables ip_rehab; run;

proc export data=ip1 outfile="E:\nhats\data\Projects\IAH\final_data\iah_rehab_flag.dta" replace; run;


/* Checking Nursing home enrollment on a monthly basis */

data snf_sheet;
set snf;
month = month(admit_date);
year = year(admit_date);
snf_stay = 1;
run;

/*** Alternate version ***/

proc sql;
create table snf_test as select a.*, b.index_date
from snf_sheet a
inner join ip_check b
on a.bene_id=b.bene_id and a.year=b.year;
quit;

proc sort data=snf_test; by bene_id year admit_date; run;

data snf_sheet;
set snf_sheet;
m_1 = 0;
m_2 = 0;
m_3 = 0;
m_4 = 0;
m_5 = 0;
m_6 = 0;
m_7 = 0;
m_8 = 0;
m_9 = 0;
m_10 = 0;
m_11 = 0;
m_12 = 0;
if month = 1 then m_1 = 1;
if month = 2 then m_2 = 1;
if month = 3 then m_3 = 1;
if month = 4 then m_4 = 1;
if month = 5 then m_5 = 1;
if month = 6 then m_6 = 1;
if month = 7 then m_7 = 1;
if month = 8 then m_8 = 1;
if month = 9 then m_9 = 1;
if month = 10 then m_10 = 1;
if month = 11 then m_11 = 1;
if month = 12 then m_12 = 1;
run;

proc sql;
create table snf_st as
select distinct bene_id, year,
sum(m_1) as Jan,
sum(m_2) as Feb,
sum(m_3) as Mar,
sum(m_4) as Apr,
sum(m_5) as May,
sum(m_6) as Jun,
sum(m_7) as Jul,
sum(m_8) as Aug,
sum(m_9) as Sep,
sum(m_10) as Oct,
sum(m_11) as Nov,
sum(m_12) as Dec
from snf_sheet
group by bene_id, year;
quit;

data snf_st;
set snf_st;
array list Jan--Dec;
do over list;
if list > 0 then list = 1;
end;
run;

data snf_st;
set snf_st;
snf_months = trim(left(Jan))||trim(left(Feb))||trim(left(Mar))||trim(left(Apr))||trim(left(May))||trim(left(Jun))||trim(left(Jul))||trim(left(Aug))
||trim(left(Sep))||trim(left(Oct))||trim(left(Nov))||trim(left(Dec));
snf_months_p1 = snf_months;
run;


proc sql;
create table snf_ind as select a.*, b.index_month
from snf_st a
inner join ip_check b
on a.bene_id=b.bene_id and a.year=b.year;
quit;

data snf_ind (drop = snf_months_p1);
set snf_ind;
run;

proc sql;
create table snf_index as select a.*, b.snf_months_p1 
from snf_ind a
left join snf_st b
on a.bene_id=b.bene_id and a.year = b.year+1;
quit;

data snf_index;
set snf_index;
months_post = substr(snf_months,index_month,12);
snf_n1 = trim(left(reverse(snf_months_n1)));
run;

data snf_index;
set snf_index;
snf_1m = substr(snf_n1,1,1);
snf_s = trim(left(months_post))||trim(left(snf_n1));
run;

data snf_index;
set snf_index;
snf_m = substr(snf_s,1,3);
snf_3m = 0;
if indexc(snf_m,"0")=0 then snf_3m = 1;
run;


proc export data=snf_index (keep = bene_id year snf_3m) outfile="E:\nhats\data\Projects\IAH\final_data\snf_flag.dta" dbms=stata replace; run; 

proc contents data=claims.pb_09_16; run;


/* Identifying house calls */

data carrier;
set claims.pb_09_16;
array dx hcpcscd1--hcpcscd13;
do over dx;
hcpcs_cd=dx;
output;
end;
run;

data carrier1;
set carrier;
cptcodes1 = input(compress(hcpcs_cd,'ABCDEFGHIJKLMNOPQRSTUVWXYZ/',),8.);
run;

data carrier1;
set carrier1;
cpt1flag = 0;
if 99341<=cptcodes1<=99350 or 99324<=cptcodes1<=99328 or 99334<=cptcodes1<=99337 then cpt1flag = 1;
run;

proc sort data=carrier1 nodupkey; by bene_id clm_id; run;

data carrierline (keep = bene_id clm_id LINE_PLACE_OF_SRVC_CD cptcodes);
set cyears.bcarrier_line_j_09_16;
cptcodes = input(compress(hcpcs_cd,'ABCDEFGHIJKLMNOPQRSTUVWXYZ/',),8.);
run;

data carrierline;
set carrierline;
cptflag = 0;
posflag = 0;
if 99341<=cptcodes<=99350 or 99324<=cptcodes<=99328 or 99334<=cptcodes<=99337 then cptflag=1;
if LINE_PLACE_OF_SRVC_CD in:(12,13,14) then posflag=1;
run;

data linecalls;
set carrierline;
where cptflag = 1 or posflag = 1;
run;

proc sql;
create table carrier2 as select a.*, b.*
from carrier1 a
full outer join linecalls b
on a.bene_id=b.bene_id and a.clm_id = b.clm_id;
quit;

data carrier2;
set carrier2;
where cptflag = 1 and posflag = 1;
year = year(admit_date);
run;

proc sort data=carrier2 nodupkey; by bene_id clm_id; run;

proc sql;
create table annual as select distinct bene_id, year,
sum(posflag) as housecalls_count
from carrier2
group by bene_id, year;
quit;


proc export data=annual outfile="E:\nhats\data\Projects\IAH\int_data\annualcpt_count.dta" replace; run;

proc sql;
create table homecallsb4_90 as select a.*, b.cptcodes
from ip_check a
inner join carrier2 b
on a.bene_id=b.bene_id and -90<a.index_date-b.admit_date<=90;
quit;


proc sort data=homecallsb4_90 nodupkey; by descending wave bene_id; run;
proc sort data=homecallsb4_90 nodupkey; by bene_id; run;

proc freq data=homecallsb4_90; tables ffs_6m; run;

proc sql;
create table homecallsb4_180 as select a.*, b.cptcodes
from ip_check a
inner join carrier2 b
on a.bene_id=b.bene_id and -180<a.index_date-b.admit_date<=180;
quit;

/*
proc sql;
create table homecallsafter as select a.*, b.cptcodes
from ip_check a
inner join carrier2 b
on a.bene_id=b.bene_id and 0<b.admit_date-a.index_date<=365;
quit;
*/
proc sort data=homecallsb4_90 out=test; by descending wave bene_id; run;






proc sort data=homecallsb4_180; by bene_id wave; run;


/*
%macro homecallsb4(wave=,days=);

data homecallsb4_&days._&wave.;
set homecallsb4_&days.;
by bene_id;
where wave = &wave.;
*cnt + 1;
if first.bene_id then cnt = 1;
run;

data homecallsb4_&days._&wave.;
set homecallsb4_&wave.;
*where cnt = 1; 
run;

%mend;


%homecallsb4(wave=1, days=90);
%homecallsb4(wave=2, days=90);
%homecallsb4(wave=3, days=90);
%homecallsb4(wave=4, days=90);
%homecallsb4(wave=5, days=90);

%homecallsb4(wave=1, days=180);
%homecallsb4(wave=2, days=180);
%homecallsb4(wave=3, days=180);
%homecallsb4(wave=4, days=180);
%homecallsb4(wave=5, days=180);

*/

data homecalls_90;
set homecallsb4_90_1 homecallsb4_90_2 homecallsb4_90_3 homecallsb4_90_4 homecallsb4_90_5;
run;


data homecalls_180;
set homecallsb4_180_1 homecallsb4_180_2 homecallsb4_180_3 homecallsb4_180_4 homecallsb4_180_5;
run;

proc export data=homecallsb4_90 outfile="E:\nhats\data\Projects\IAH\int_data\homecalls_90.dta" replace; run;

proc export data=homecalls_180 outfile="E:\nhats\data\Projects\IAH\int_data\homecalls_180.dta" replace; run;



proc sort data=homecallsb4_90; by descending bene_id wave; run;


data homecalls_bs; 
set homecallsb4_90;
where ffs_6m = 1;
run;

data snf_sheet;
set snf;
month = month(admit_date);
year = year(admit_date);
snf_stay = 1;
run;

proc sql;
create table home_snf as select a.*, b.*
from homecalls_bs a
inner join snf_sheet b
on a.bene_id = b.bene_id and a.index_date<=b.admit_date;
run;

proc sort data=home_snf; by bene_id admit_date; run;

data home_snf;
set home_snf;
by bene_id;
if first.bene_id then first = 1;
run;

data home_snf;
set home_snf;
where first = 1;
run;

proc export data=home_snf outfile="E:\nhats\data\Projects\IAH\int_data\snf_incident.dta" dbms=stata replace; run;

proc import datafile="E:\nhats\data\Projects\IAH\int_data\iah_mostrecent.dta" out=iah_q dbms=stata replace; run;

proc sql; 
create table iah_snf as select a.*, b.admit_date
from iah_q a 
inner join snf_sheet b
on a.bene_id = b.bene_id and a.index_date<=b.admit_date;
quit;

proc sort data=iah_snf; by bene_id admit_date; run;



proc sql;
create table snf_ind as select a.*, b.index_month
from snf_st a
inner join ip_check b
on a.bene_id=b.bene_id and a.year=b.year;
quit;

data snf_ind (drop = snf_months_p1);
set snf_ind;
run;

proc sql;
create table snf_index as select a.*, b.snf_months_p1 
from snf_ind a
left join snf_st b
on a.bene_id=b.bene_id and a.year = b.year+1;
quit;

data snf_index;
set snf_index;
months_post = substr(snf_months,index_month,12);
snf_n1 = trim(left(reverse(snf_months_n1)));
run;

data snf_index;
set snf_index;
snf_1m = substr(snf_n1,1,1);
snf_s = trim(left(months_post))||trim(left(snf_n1));
run;

data snf_index;
set snf_index;
snf_m = substr(snf_s,1,3);
snf_3m = 0;
if indexc(snf_m,"0")=0 then snf_3m = 1;
run;


data iah_snf;
set iah_snf;
by bene_id;
if first.bene_id then first = 1;
run;

data iah_snf;
set iah_snf; 
where first = 1;
run;

proc export data = iah_snf outfile="E:\nhats\data\Projects\IAH\int_data\iah_snf" dbms=stata replace; run;


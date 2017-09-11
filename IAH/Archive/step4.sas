libname claims "E:\nhats\data\CMS_DUA_28016\Merged";
libname line "E:\nhats\data\CMS_DUA_28016\Cumulative Years";
libname cyears "E:\nhats\data\CMS_DUA_28016\Cumulative Years";

proc import datafile="E:\nhats\data\Projects\IAH\final_data\iah_wave1-3.dta" out=steps123 replace; run;

/* Identifying Inpatient Rehab */

data ip_check (keep = bene_id index_date wave);
set steps123;
where ffs_6m = 1 and community_dwelling=1;
*where community_dwelling=1;
run;

data inpatient;
set claims.ip_06_14;
run;

data ip_rev;
set cyears.inpatient_revenue_center_j_06_14;
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

data ip_rehabstays;
set ip_rehabstays;
ip_rehab = 1;
run;

/* Checking for HH/SNF within 7 days of disch_date */

data homehealth;
set claims.hh_09_14;
run;

data snf;
set claims.snf_09_14;
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
format rehab_admit rehab_disch date10.;
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


/* Identifying house calls */

data carrier;
set claims.pb_09_14;
array dx hcpcscd1--hcpcscd13;
do over dx;
hcpcs_cd=dx;
output;
end;
run;

data carrier1;
set carrier;
cptcodes1 = input(compress(hcpcs_cd,'ABCDEFGHIJKLMNOPQRSTUVWXYZ/',),8.);
*where 993341<=cptcodes<=99350 or 99324<=cptcodes<=99328 or 99334<=cptcodes<=99337;
run;

data carrier1;
set carrier1;
cpt1flag = 0;
if 99341<=cptcodes1<=99350 or 99324<=cptcodes1<=99328 or 99334<=cptcodes1<=99337 then cpt1flag = 1;
run;

proc sort data=carrier1 nodupkey; by bene_id clm_id; run;

data carrierline (keep = bene_id clm_id LINE_PLACE_OF_SRVC_CD cptcodes);
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

data linecalls;
set carrierline;
where cptflag = 1 or posflag = 1;
run;

proc sort data=linecalls nodupkey; by bene_id clm_id; run;

proc sql;
create table carrier2 as select a.*, b.*
from carrier1 a
full outer join linecalls b
on a.bene_id=b.bene_id and a.clm_id = b.clm_id;
quit;

data carrier2;
set carrier2;
where cpt1flag = 1 or cptflag = 1 or posflag = 1;
run;


proc sql;
create table homecallsb4 as select a.*, b.cptcodes
from ip_check a
inner join carrier2 b
on a.bene_id=b.bene_id and 0<a.index_date-b.admit_date<=365;
quit;

proc sql;
create table homecallsafter as select a.*, b.cptcodes
from ip_check a
inner join carrier2 b
on a.bene_id=b.bene_id and 0<b.admit_date-a.index_date<=365;
quit;

proc sort data=homecallsb4; by bene_id wave; run;

data homecallsb4_1;
set homecallsb4;
by bene_id;
where wave = 1;
cnt + 1;
if first.bene_id then cnt = 1;
run;

data homecallsb4_1;
set homecallsb4_1;
where cnt = 2; 
run;

data homecallsb4_2;
set homecallsb4;
by bene_id;
where wave = 2;
cnt + 1;
if first.bene_id then cnt = 1;
run;

data homecallsb4_2;
set homecallsb4_2;
where cnt = 2; 
run;


data homecallsb4_3;
set homecallsb4;
by bene_id;
where wave = 3;
cnt + 1;
if first.bene_id then cnt = 1;
run;

data homecallsb4_3;
set homecallsb4_3;
where cnt = 2; 
run;

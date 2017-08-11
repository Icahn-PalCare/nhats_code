libname claims "E:\nhats\data\CMS_DUA_28016\Merged";

proc import datafile="E:\nhats\data\Projects\IAH\int_data\steps123.dta" out=steps123 replace; run;



data ip_check (keep = bene_id index_date);
set steps123;
run;

data ip_check;
set ip_check;
*idate = index_date - 372;
format idate date10.;
run;


data inpatient;
set claims.ip_06_14;
run;

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
where a.index_date - b.disch_date < 365;
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
where a.index_date - b.disch_date < 365;
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


proc sort data=ip1 nodupkey; by bene_id rehab_admit; run;
proc sort data=ip1 nodupkey; by bene_id; run;

proc export data=ip1 outfile="E:\nhats\data\Projects\IAH\final_data\iah_wave1.dta" replace; run;

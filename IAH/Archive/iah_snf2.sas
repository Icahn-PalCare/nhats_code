/* proc import datafile="E:\nhats\data\Projects\IAH\int_data\iah_mostrecent.dta" out=iah_q dbms=stata replace; run; */

proc import datafile="E:\nhats\data\Projects\IAH\int_data\homecalls_90.dta" out=iah_q dbms=stata replace; run;

data iah_q;
set iah_q;
year = year(index_date);
run;

data snf_sheet;
set snf;
month = month(admit_date);
year = year(admit_date);
snf_stay = 1;
run;


proc sql; 
create table iah_snf as select a.*, b.admit_date, b.CLM_ID
from iah_q a 
inner join snf_sheet b
on a.bene_id = b.bene_id and a.index_date<=b.admit_date;
quit;

data iah_snf;
set iah_snf;
admit_year = year(admit_date);
run;

proc sort data=iah_snf; by bene_id admit_date; run; /* all nursing home claims for IAH-Q post index */ 

proc sql;
create table snf_test as select a.*, b.index_date, b.* /* all nursing home claims for NHATs post index */
from snf_sheet a
/* inner join ip_check b */
inner join iah_q b
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
snf_months_p2 = snf_months;
run;

data snf_stay (drop = snf_months_p1 snf_months_p2);
set snf_st;
run;

proc sql;
create table snf_index as select a.*, b.snf_months_p1  
from snf_stay a
left join snf_st b
on a.bene_id=b.bene_id and a.year = b.year+1;
quit;

proc sql; /*all snf stays for nhats post index, with 24 months of followup */
create table snf_index_2 as select a.*, b.snf_months_p2
from snf_index a
left join snf_st b
on a.bene_id=b.bene_id and a.year=b.year+2;
quit;

proc sql; 
create table iah_snf_index as select a.bene_id, a.index_date, a.wave, a.admit_date, a.admit_year, b.*
from iah_snf a
left join snf_index_2 b
on a.bene_id=b.bene_id and a.admit_year = b.year;
quit;

data iah_snf_index;
set iah_snf_index;
if snf_months_p1 = "" then snf_months_p1 = "000000000000";
if snf_months_p2 = "" then snf_months_p2 = "000000000000";
admit_month = month(admit_date);
run;

data iah_snf_index;
set iah_snf_index;
snf_s = trim(left(snf_months))||trim(left(snf_months_p1));
snf_m = substr(snf_s,admit_month,3);
snf_3m = 0;
if indexc(snf_m,"0")=0 then snf_3m = 1;
run;

data iah_died;
set iah_snf_index;
died = death_date - admit_date;
run;

data iah_died;
set iah_died;
where died <=91;
run;

proc sort data=iah_died nodupkey; by bene_id; run; 
proc export data=iah_died outfile="E:\nhats\data\Projects\IAH\int_data\iah_died.dta" dbms=stata replace; run;



data iah_snf_index;
set iah_snf_index; 
where snf_3m = 1;
run;

proc sort data=iah_snf_index; by bene_id admit_date; run;

data iah_snf_index;
set iah_snf_index;
by bene_id;
if first.bene_id then first = 1;
run;

data iah_snf_index;
set iah_snf_index;
where first = 1;
run;

proc export data=iah_snf_index outfile="E:\nhats\data\Projects\IAH\int_data\hc_snf_3m.dta" dbms=stata replace; run;

proc export data=iah_snf_index outfile="E:\nhats\data\Projects\IAH\int_data\iah_snf_3m.dta" dbms=stata replace; run; 

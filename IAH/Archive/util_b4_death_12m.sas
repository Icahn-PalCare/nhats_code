/*These additional variables are just added to the dataset with the
elixhauser and cc's 1 year preceeding the interview, can add them
later when required to get the 2 year look-back dataset*/

/****************************************************************************/
/*Get indicator of any hospital admission 6 and 12 months pre-core interview*/
/****************************************************************************/

%macro admissions(days=,suffix=);

/*pull list of ip claims from all medpar claims x days pre-interview*/
data ip_meet_&days.;
set proj_int.ip_meet_&days.;
run;
data ip_&days._2;
set ip_meet_&days.;
type_adm=clm_ip_admsn_type_cd;
if icarecnt=. then icarecnt=0; /*medpar intensive care day count*/
if CRNRYDAY=. then CRNRYDAY=0; /*medpar coronary day count*/
icu_days=icarecnt+CRNRYDAY;
em_urgent_admit=0; /*Urgent , emergent admissions from admission type*/
if type_adm in (1,2) then em_urgent_admit=1;
em_admit=0;
if type_adm=1 then em_admit=1;
urgent_admit=0;
if type_adm=2 then urgent_admit=1;
elect_admit=0;
if type_adm=3 then elect_admit=1;
ind_ed_charge=0; /*ED charges as another indicator of ED use*/
if erdaycnt>0 & erdaycnt~=. then ind_ed_charge=1;
if erdaycnt=0 | erdaycnt=. then ind_ed_charge=0;

/*truncate stays where the admit is more than x days before interview
or discharge is after the interview date so can get accurate LOS*/
if index_date-admit_date>&days. then do;
	admit_date=index_date-&days.;
	admit_trunc=1;
	end;
if index_date<disch_date then do;
	disch_date=index_date;
	disch_trunc=1;	
	end;
adj_los=disch_date-admit_date;
if disch_date-admit_date=0 then adj_los=1;
run;

proc sort data=ip_&days._2;
by bene_id index_year;
run;

proc sql;
create table ip_&days._3 as select distinct bene_id,index_year,
/*total ICU days*/
sum(icu_days) as icu_days_&suffix. label="total icu days &suffix. pre death",
/*count of IP admissions, all types*/
count(*) as n_ip_admit_&suffix. label="total n of hospital admit &suffix. pre death",
/*total Hospital LOS*/
sum(adj_los) as n_hospd_&suffix. label="total hospital days &suffix. pre death",
/*count urgent or emergency admissions*/
count(case when em_urgent_admit=1 then em_urgent_admit else . end) as n_em_urgent_admit_&suffix. 
	label="total n of urgent/emergent hospital admit &suffix. pre death",
/*count of emergency admissions, from admission type code*/
count(case when em_admit=1 then em_admit else . end) as n_em_admit_&suffix. 
	label="total n of emergent hospital admit &suffix. pre death",
/*count of urgent admissions, from admission type code*/
count(case when urgent_admit=1 then urgent_admit else . end) as n_urgent_admit_&suffix. 
	label="total n of urgent hospital admit &suffix. pre death",
/*count of elective admissions, from admission type code*/
count(case when elect_admit=1 then elect_admit else . end) as n_elect_admit_&suffix. 
	label="total n of elective hospital admit &suffix. pre death",
/*count of admissions with any ED charges*/
count(case when ind_ed_charge=1 then ind_ed_charge else . end) as n_ED_ip_&suffix. 
	label="total n of ED visits with subsequent admit &suffix. pre death"

 from ip_&days._2 group by bene_id,index_year;
quit;

data ip_&days._4;
set ip_&days._3;
if icu_days_&suffix.>n_hospd_&suffix. then icu_days_&suffix.=n_hospd_&suffix.;
run;

%mend;

%admissions(days=183,suffix=6m);
%admissions(days=365,suffix=1yr);

proc sort data=ip_183_3 nodupkey;
by bene_id index_year;
run;

proc sort data=ip_365_3 nodupkey;
by bene_id index_year;
run;

proc sql;
create table ip_1yr as select a.*,b.icu_days_1yr,
b.n_ip_admit_1yr,b.n_hospd_1yr,b.n_em_urgent_admit_1yr,b.n_em_admit_1yr,
b.n_urgent_admit_1yr,b.n_elect_admit_1yr,b.n_ED_ip_1yr
from index a
left join
ip_365_3 b 
on trim(left(a.bene_id))=trim(left(b.bene_id)) and a.index_year=b.index_year;
quit;

/*
proc sql;
create table ip1 as select a.*,b.icu_days_6m,
b.n_ip_admit_6m,b.n_hospd_6m,b.n_em_urgent_admit_6m,b.n_em_admit_6m,
b.n_urgent_admit_6m,b.n_elect_admit_6m,b.n_ED_ip_6m
from ip_6m a
left join
ip_365_3 b 
on trim(left(a.bene_id))=trim(left(b.bene_id)) and a.index_year=b.index_year;
quit;
*/
/*Dataset just contains obs with ffs mc 6m and age 65+
So if missing, set var to 0*/
 data ip ;
 set ip_1yr ;
 array list icu_days_1yr n_ip_admit_1yr n_hospd_1yr n_em_urgent_admit_1yr 
	n_em_admit_1yr n_urgent_admit_1yr n_elect_admit_1yr n_ED_ip_1yr
	icu_days_1yr n_ip_admit_1yr n_hospd_1yr n_em_urgent_admit_1yr
	n_em_admit_1yr n_urgent_admit_1yr n_elect_admit_1yr n_ED_ip_1yr;
 do over list;
 if list=. then list=0;
 end;

 if n_ip_admit_1yr=0 then ind_hosp_adm_1yr=0;
 if n_ip_admit_1yr>0 & n_ip_admit_1yr~=. then ind_hosp_adm_1yr=1;
 label ind_hosp_adm_1yr="Indicator for any hospital admission 1yr pre death";

 if n_em_urgent_admit_1yr=0 then ind_em_ur_adm_1yr=0;
 if n_em_urgent_admit_1yr>0 & n_em_urgent_admit_1yr~=. then ind_em_ur_adm_1yr=1;
 label ind_em_ur_adm_1yr="Ind any urgent or emergent hospital admission 1yr pre death";

 if n_em_admit_1yr=0 then ind_em_adm_1yr=0;
 if n_em_admit_1yr>0 & n_em_admit_1yr~=. then ind_em_adm_1yr=1;
 label ind_em_adm_1yr="Ind any emergency hospital admission 1yr pre death";

 if n_urgent_admit_1yr=0 then ind_ur_adm_1yr=0;
 if n_urgent_admit_1yr>0 & n_urgent_admit_1yr~=. then ind_ur_adm_1yr=1;
 label ind_ur_adm_1yr="Ind any urgent hospital admission 1yr pre death";

 if n_elect_admit_1yr =0 then ind_elect_adm_1yr=0;
 if n_elect_admit_1yr >0 & n_elect_admit_1yr ~=. then ind_elect_adm_1yr=1;
 label ind_elect_adm_1yr="Ind any elective hospital admission 1yr pre death";

 if (n_ip_admit_1yr - n_elect_admit_1yr)=0 then ind_nonelect_adm_1yr=0;
 if (n_ip_admit_1yr - n_elect_admit_1yr)>0 & n_elect_admit_1yr~=. then ind_nonelect_adm_1yr=1;
 label ind_nonelect_adm_1yr="Ind any non-elective hospital admission 1yr pre death";

 n_nonelect_adm_1yr=(n_ip_admit_1yr - n_elect_admit_1yr);
 label n_nonelect_adm_1yr="total n non-elective ip admit 1yr pre death";

 if n_ED_ip_1yr=0 then ind_ED_adm_1yr=0;
 if n_ED_ip_1yr>0 & n_ED_ip_1yr~=. then ind_ED_adm_1yr=1;
 label ind_ED_adm_1yr="Ind ED use with hospital admission 1yr pre death, from charges";

 if n_ip_admit_1yr=0 then ind_hosp_adm_1yr=0;
 if n_ip_admit_1yr>0 & n_ip_admit_1yr~=. then ind_hosp_adm_1yr=1;
 label ind_hosp_adm_1yr="Indicator for any hospital admission 1yr pre death";

 if n_em_urgent_admit_1yr=0 then ind_em_ur_adm_1yr=0;
 if n_em_urgent_admit_1yr>0 & n_em_urgent_admit_1yr~=. then ind_em_ur_adm_1yr=1;
 label ind_em_ur_adm_1yr="Ind any urgent or emergent hospital admission 1yr pre death";

 if n_em_admit_1yr=0 then ind_em_adm_1yr=0;
 if n_em_admit_1yr>0 & n_em_admit_1yr~=. then ind_em_adm_1yr=1;
 label ind_em_adm_1yr="Ind any emergency hospital admission 1yr pre death";

 if n_urgent_admit_1yr=0 then ind_ur_adm_1yr=0;
 if n_urgent_admit_1yr>0 & n_urgent_admit_1yr~=. then ind_ur_adm_1yr=1;
 label ind_ur_adm_1yr="Ind any urgent hospital admission 1yr pre death";

 if n_elect_admit_1yr =0 then ind_elect_adm_1yr=0;
 if n_elect_admit_1yr >0 & n_elect_admit_1yr ~=. then ind_elect_adm_1yr=1;
 label ind_elect_adm_1yr="Ind any elective hospital admission 1yr pre death";

 if (n_ip_admit_1yr - n_elect_admit_1yr)=0 then ind_nonelect_adm_1yr=0;
 if (n_ip_admit_1yr - n_elect_admit_1yr)>0 & n_elect_admit_1yr~=. then ind_nonelect_adm_1yr=1;
 label ind_nonelect_adm_1yr="Ind any non-elective hospital admission 1yr pre death";

 n_nonelect_adm_1yr=(n_ip_admit_1yr - n_elect_admit_1yr);
 label n_nonelect_adm_1yr="total n non-elective ip admit 1yr pre death";

 if n_ED_ip_1yr=0 then ind_ED_adm_1yr=0;
 if n_ED_ip_1yr>0 & n_ED_ip_1yr~=. then ind_ED_adm_1yr=1;
 label ind_ED_adm_1yr="Ind ED use with hospital admission 1yr pre death, from charges";

run;

 proc freq;
 table icu_days_1yr n_ip_admit_1yr n_hospd_1yr ind_hosp_adm_1yr n_em_urgent_admit_1yr ind_em_ur_adm_1yr 
	ind_em_adm_1yr ind_ur_adm_1yr ind_nonelect_adm_1yr n_nonelect_adm_1yr n_ED_ip_1yr ind_ED_adm_1yr 
	ind_em_adm_1yr*ind_ED_adm_1yr /missprint;
 run;

proc freq;
table icu_days_1yr n_ip_admit_1yr n_hospd_1yr ind_hosp_adm_1yr n_em_urgent_admit_1yr ind_em_ur_adm_1yr
	ind_em_adm_1yr ind_ur_adm_1yr ind_nonelect_adm_1yr n_nonelect_adm_1yr n_ED_ip_1yr ind_ED_adm_1yr 
	ind_em_adm_1yr*ind_ED_adm_1yr /missprint;
run;

/****************************************************************************/
/****************************************************************************/
/*Get SNF days, indicator for 12 months preceding the interview*/
/****************************************************************************/
/****************************************************************************/

/*pull list of snf claims from all medpar claims 12 months pre-interview*/
data snf_meet_365;
set proj_int.snf_meet_365;
run;

proc sort data=snf_meet_365;
by bene_id admit_date;
run;

data snf_meet_365_1a;
set snf_meet_365;
format admit_date date9. disch_date date9.;
run;

/*3 claim windows are present:
1. SNF stays fully within the 1 year before interview
2. Stays that begin before 1 year pre-core but end within 1 year pre-core
3. Stays that begin within 1 year of core but end after core death
4. Stays that begin before 1 year and end after interview, LOS=365!
Get claims that meet 1 *1797*/
proc sql;
create table snf_meet1_pre_365 as select *
from snf_meet_365_1a
where (index_date - admit_date)<365 & (index_date - disch_date)>=0; 
quit;


/*meet time window 2 *152*/
proc sql;
create table snf_meet2_pre_365 as select *
from snf_meet_365_1a
where (index_date - admit_date)>=365 & (index_date - disch_date)>=0; 
quit;

/*For these claims that start > 1 year before core, truncate start date so 
only count LOS days w/i 1 year
create indicator variable that claim start date is truncated*/
data snf_meet2_pre_365_1;
set snf_meet2_pre_365;
admit_date = index_date-365;
snf_admit_date_mod = 1;
label snf_admit_date_mod = "Admit date mod; at 12 mo from death date";
run;

proc freq;
table snf_admit_date_mod ;
run;

/*meet time window 3 *135 */
proc sql;
create table snf_meet3_pre_365 as select *
from snf_meet_365_1a
where (index_date - admit_date)<365 & (index_date-disch_date)<0; 
quit;

/*For these claims that end after core, truncate end date so 
only count LOS days 1 year before the core
create indicator variable that claim end date is truncated*/
data snf_meet3_pre_365_1;
set snf_meet3_pre_365;
disch_date = index_date;
snf_disch_date_mod = 1;
label snf_disch_date_mod = "Disch date mod; at death date";
run;

proc freq;
table snf_disch_date_mod ;
run;

/*meet 4 , overlap both start and end dates n=7*/
proc sql;
create table snf_meet4_pre_365 as select *
from snf_meet_365_1a
where (index_date - admit_date)>=365 & (index_date - disch_date)<0; 
quit;

/*truncate both start and end dates so just count 1 year pre interview*/
data snf_meet4_pre_365_1;
set snf_meet4_pre_365;
disch_date = index_date;
snf_disch_date_mod = 1;
label snf_disch_date_mod = "Disch date mod; at death date";
admit_date = index_date-365;
snf_admit_date_mod = 1;
label snf_admit_date_mod = "Admit date mod; at 12 mo from death date";
run;

proc freq;
table snf_disch_date_mod snf_admit_date_mod;
run;


data snf_meet_pre_365;
set snf_meet1_pre_365 snf_meet2_pre_365_1 snf_meet3_pre_365_1 snf_meet4_pre_365_1;
run;

proc freq;
table snf_admit_date_mod snf_disch_date_mod ;
run;

/*save final files to project int_data directory*/
data proj_int.snf_meet_pre_365 ;
set  snf_meet_pre_365;
run;

/*************************************************************/
/*calculate total number of days spent in SNF by BID*/
/*************************************************************/

data pre_snf_days_1;
set proj_int.snf_meet_pre_365;
calc_snf_LOS=disch_date-admit_date;
if calc_snf_LOS=0 then calc_snf_LOS=1;
run;

proc sort data=pre_snf_days_1;
by bene_id index_date admit_date;
run;

proc sql;
create table snf_days_pre as select distinct bene_id,index_year,
sum(calc_snf_LOS)
	as n_snf_days_1yr
	from pre_snf_days_1 group by bene_id,index_year;
quit;


/*merge into full ffs 6m, age 65+ dataset*/
proc sort data=snf_days_pre nodupkey;
by bene_id index_year;
run;



 data snf ;
 set snf_days_pre ;
 array list n_snf_days_1yr;
 do over list;
 if list=. then list=0;
 end; 

if n_snf_days_1yr=0 then ind_snf_use_1yr=0;
 if n_snf_days_1yr>0 & n_snf_days_1yr~=. then ind_snf_use_1yr=1;
 label ind_snf_use_1yr="Indicator for any SNF stay 1yr pre death";
 label n_snf_days_1yr="SNF Days 1yr pre death";

run;

/****************************************************************************/
/****************************************************************************/
/*Get indicator of ESRD codes from the denominator file the year of the interview*/
/****************************************************************************/
/****************************************************************************/
proc sort data=medi.mbsf_06_14 out=dn_2000_20122  nodupkey;
by bene_id year;
run;

/*pull ESRD status variable from dn file
for the core interview years*/
proc sql;
create table esrd1 as select
a.*,b.Bene_ESRD_IND from 
index a left join
dn_2000_20122 b
on trim(left(a.bene_id))=trim(left(b.bene_id))
and a.index_year=b.year;
quit;

proc freq;
table bene_esrd_ind /missprint;
run;

data esrd;
set esrd1 ;
if bene_esrd_ind='Y' then esrd_ind_n=1;
if bene_esrd_ind='0' then esrd_ind_n=0;
label esrd_ind_n="ESRD indicator from claims denominator file";
drop bene_esrd_ind;
run;

proc freq;
table esrd_ind_n /missprint;
run;

/****************************************************************************/
/*Get indicator of Home 02 use 12 months pre interview from DME claims*/
/****************************************************************************/
data oxygen1(keep=bene_id index_year oxygen);
set proj_int.dm_meet_365;
oxygen=0;
if h_o2>0 then oxygen=1;
run;

proc sort data=oxygen1 out=oxygen nodupkey;
by bene_id index_year;
run;
proc contents data=medi.op_09_14; run;

proc contents data=proj_int.op_meet_365; run;
/*added 7/27/17--Observation stays from OP file*/
data ed_op_1;
set proj_int.op_meet_365(keep=bene_id admit_date disch_date index_date index_year erdaycnt obs_stay);
if erdaycnt>0 then ed_op=1;
if erdaycnt=0 then ed_op=0;
if obs_stay=. then obs_stay=0;
if obs_stay>1 then obs_stay=1;
label obs_stay="Observation stay, 1yr pre death";
run;

/*added 7/7/17; pull indicator for ER OP visit that doesn't lead to admission*/
/*
data ed_op_1a;
set ed_op_1;
where ed_op=1;
run;*/

data ip_for_op (keep=bene_id index_date admit_date match);
set proj_int.ip_meet_365;
match=1;
run;

proc sql;
create table ed_op_1b as select * from
ed_op_1 a
left join 
ip_for_op b
on a.bene_id=b.bene_id and a.disch_date=b.admit_date;
quit;
data ed_op_1b2;
set ed_op_1b;
if match~=1;
run;

proc sql;
create table ed_op_1d as select distinct bene_id,index_year,
count(case when ed_op=1 then ed_op else . end)
	as n_ed_op_no_adm
	from ed_op_1b2 group by bene_id,index_year;
quit;

proc sort data=ed_op_1d nodupkey;
by bene_id index_year;
run;
/*
data ed_op_1c(keep=bene_id ed_op_wout_adm_ind);
set ed_op_1b;
ed_op_wout_adm_ind=1;
where match~=1;
run;
proc freq;
tables ind_ed_op_6m*ed_op_wout_adm_ind;
run;
proc sort nodupkey data=ed_op_1c out=ed_op_1d;
by bene_id;
run;
*/

proc sql;
create table ed_op_2 as select distinct bene_id,index_year,
count(case when ed_op=1 then ed_op else . end)
	as n_ed_op_visits_1yr,
max(obs_stay) as obs_stay
	from ed_op_1 group by bene_id,index_year;
quit;

proc freq;
table n_ed_op_visits_1yr obs_stay;
run;


proc sort data=ed_op_2 nodupkey;
by bene_id index_year;
run;

proc sql;
create table ed_op_3 as select * from
ed_op_2 a
left join ed_op_1d b
on a.bene_id=b.bene_id;
quit;

data ed ;
set ed_op_3;
if n_ed_op_visits_1yr=. and comorb_1_0_1yr~=. then n_ed_op_visits_1yr=0;
label n_ed_op_visits_1yr="Count ED OP visits, 1yr pre death";

if n_ed_op_visits_1yr=0 then ind_ed_op_1yr=0;
if n_ed_op_visits_1yr>0 & n_ed_op_visits_1yr~=. then ind_ed_op_1yr=1;
label ind_ed_op_1yr="Indicator any ED OP visits, 1yr pre death";

if n_ed_op_no_adm=0 then ed_op_wout_adm_ind=0;
if n_ed_op_no_adm>0 & n_ed_op_no_adm~=. then ed_op_wout_adm_ind=1;
if ed_op_wout_adm_ind=. then ed_op_wout_adm_ind=0;
label ed_op_wout_adm_ind="Indicator ED visit not leading to admission, 1yr pre death";
run;

proc freq;
table n_ed_op_visits_1yr*ind_ed_op_1yr;
run;

/*pull indicator for snf and hh use 6m prior*/

proc sql;
create table snf_1yr as select * from
index a
left join
proj_int.snf_meet_365 b
on a.bene_id=b.bene_id and a.index_year=b.index_year;
quit;

data snf_6ma(keep=bene_id index_year ind_snf_1yr);
set snf_1yr;
if admit_date~=. then ind_snf_1yr=1;
if admit_date=. then ind_snf_1yr=0;
run;

proc sort data=snf_6ma out=snf_6mb nodupkey;
by bene_id index_year; 
run;

proc sql;
create table hh_1yr as select * from
index a
left join
proj_int.hh_meet_365 b
on a.bene_id=b.bene_id and a.index_year=b.index_year;
quit;

data hh_6ma(keep=bene_id index_year ind_hh_1yr);
set hh_1yr;
if admit_date~=. then ind_hh_1yr=1;
if admit_date=. then ind_hh_1yr=0;
run;

proc sort data=hh_6ma out=hh nodupkey;
by bene_id index_year; 
run;

proc sort data=ip out=ip nodupkey; by bene_id index_year; run;
proc sort data=snf out=snf nodupkey; by bene_id index_year; run;
proc sort data=esrd out=esrd nodupkey; by bene_id index_year; run;
proc sort data=oxygen out=oxygen nodupkey; by bene_id index_year; run;
proc sort data=ed out=ed nodupkey; by bene_id index_year; run;

proc sql;
create table proj_int.utilization_pre as select * 
from index a 
left join
ip b
on trim(left(a.bene_id))=trim(left(b.bene_id)) and a.index_year=b.index_year
left join 
snf c
on trim(left(a.bene_id))=trim(left(c.bene_id)) and a.index_year=c.index_year
left join 
esrd d
on trim(left(a.bene_id))=trim(left(d.bene_id)) and a.index_year=d.index_year
left join
oxygen e
on trim(left(a.bene_id))=trim(left(e.bene_id)) and a.index_year=e.index_year
left join 
ed f
on trim(left(a.bene_id))=trim(left(f.bene_id)) and a.index_year=f.index_year
left join
snf_6mb g
on trim(left(a.bene_id))=trim(left(g.bene_id)) and a.index_year=g.index_year
left join
hh h
on trim(left(a.bene_id))=trim(left(h.bene_id)) and a.index_year=h.index_year;
quit;

proc contents data=proj_int.utilization_pre; 
run;

proc export data=proj_int.utilization_pre outfile="E:\nhats\data\Projects\IAH\int_data\utilization_1yrb4_death.dta" replace; run;

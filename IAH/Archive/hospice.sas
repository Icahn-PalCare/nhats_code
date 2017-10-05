/****************************************************************************/
/****************************************************************************/
/*Get Hospice days, indicator for 12 months preceding the interview*/
/****************************************************************************/
/****************************************************************************/



libname proj_int 'E:\nhats\data\projects\pal_perf_scale\int_data';
/*pull list of hs claims from all medpar claims 6 months pre-interview*/
data hs_meet_365;
set proj_int.hs_meet_365;
run;

proc sort data=hs_meet_365;
by bene_id admit_date;
run;

data hs_meet_365_1a;
set hs_meet_365;
format admit_date date9. disch_date date9. index_date date9.;
run;

/* hospice claims where admit date & disch date <1yr prior */

proc sql;
create table hs_meet1_pre_365 as select *
from hs_meet_365_1a
where (index_date - admit_date)<=366 & (index_date - disch_date)>=0; 
quit;


/* hospice claims where admit date>1yr & disch date <1yr prior */
proc sql;
create table hs_meet2_pre_365 as select *
from hs_meet_365_1a
where (index_date - admit_date)>366 & (index_date - disch_date)>=0; 
quit;

/*For these claims that start > 1 year before core, truncate start date so 
only count LOS days w/i 1 year
create indicator variable that claim start date is truncated*/
data hs_meet2_pre_365_1;
set hs_meet2_pre_365;
admit_date = index_date-365;
hs_admit_date_mod = 1;
label hs_admit_date_mod = "Admit date mod; at 6 mo from ivw date";
run;


data hs_meet_pre_365;
set hs_meet1_pre_365 hs_meet2_pre_365_1;
run;

proc freq;
table hs_admit_date_mod hs_disch_date_mod ;
run;

/*save final files to project int_data directory*/
data proj_int.hs_meet_pre_365 ;
set  hs_meet_pre_365;
run;


/*************************************************************/
/*calculate total number of days spent in SNF by BID*/
/*************************************************************/

data pre_hs_days_1;
set proj_int.hs_meet_pre_365;
calc_hs_LOS=disch_date-admit_date;
if calc_hs_LOS=0 then calc_hs_LOS=1;
run;

proc sort data=pre_hs_days_1;
by bene_id index_date admit_date;
run;

proc sql;
create table hs_days_pre as select distinct bene_id,index_year,
sum(calc_hs_LOS)
	as n_hs_days_12m
	from pre_hs_days_1 group by bene_id,index_year;
quit;


/*merge into full ffs 6m, age 65+ dataset*/
proc sort data=hs_days_pre nodupkey;
by bene_id index_year;
run;



 data hs ;
 set hs_days_pre ;
 array list n_hs_days_12m;
 do over list;
 if list=. then list=0;
 end; 

if n_hs_days_12m=0 then ind_hs_use_12m=0;
 if n_hs_days_12m>0 & n_hs_days_12m~=. then ind_hs_use_12m=1;
 label ind_hs_use_12m="Indicator for any hospice stay 12m pre ivw";
 label n_hs_days_12m="Hospice Days 12m pre ivw";

run;


/* 6 months */

/*pull list of hs claims from all medpar claims 6 months pre-interview*/
data hs_meet_183;
set proj_int.hs_meet_183;
run;

proc sort data=hs_meet_183;
by bene_id admit_date;
run;

data hs_meet_183_1a;
set hs_meet_183;
format admit_date date9. disch_date date9. index_date date9.;
run;

/* admit & disch < 1yr */

proc sql;
create table hs_meet1_pre_183 as select *
from hs_meet_183_1a
where (index_date - admit_date)<=183 & (index_date - disch_date)>=0; 
quit;


/* admit >1yr disch <1yr */
proc sql;
create table hs_meet2_pre_183 as select *
from hs_meet_183_1a
where (index_date - admit_date)>183 & (index_date - disch_date)>=0; 
quit;

/*For these claims that start > 1 year before core, truncate start date so 
only count LOS days w/i 1 year
create indicator variable that claim start date is truncated*/
data hs_meet2_pre_183_1;
set hs_meet2_pre_183;
admit_date = index_date-183;
hs_admit_date_mod = 1;
label hs_admit_date_mod = "Admit date mod; at 6 mo from ivw date";
run;

proc freq;
table hs_admit_date_mod ;
run;



data hs_meet_pre_183;
set hs_meet1_pre_183 hs_meet2_pre_183_1;
run;

proc freq;
table hs_admit_date_mod hs_disch_date_mod ;
run;

/*save final files to project int_data directory*/
data proj_int.hs_meet_pre_183 ;
set  hs_meet_pre_183;
run;

/*************************************************************/
/*calculate total number of days spent in SNF by BID*/
/*************************************************************/

data pre_hs_days_1;
set proj_int.hs_meet_pre_183;
calc_hs_LOS=disch_date-admit_date;
if calc_hs_LOS=0 then calc_hs_LOS=1;
run;

proc sort data=pre_hs_days_1;
by bene_id index_date admit_date;
run;

proc sql;
create table hs_days_pre as select distinct bene_id,index_year,
sum(calc_hs_LOS)
	as n_hs_days_6m
	from pre_hs_days_1 group by bene_id,index_year;
quit;


/*merge into full ffs 6m, age 65+ dataset*/
proc sort data=hs_days_pre nodupkey;
by bene_id index_year;
run;



 data hs_6m ;
 set hs_days_pre ;
 array list n_hs_days_6m;
 do over list;
 if list=. then list=0;
 end; 

if n_hs_days_6m=0 then ind_hs_use_6m=0;
 if n_hs_days_6m>0 & n_hs_days_6m~=. then ind_hs_use_6m=1;
 label ind_hs_use_6m="Indicator for any hospice stay 6m pre ivw";
 label n_hs_days_6m="Hospice Days 6m pre ivw";

run;

proc sql;
create table hospice as select a.*, b.*
from hs a
full outer join
hs_6m b
on a.bene_id = b.bene_id and a.index_year=b.index_year;
quit;


proc freq data=hospice; tables 


proc export data=hospice outfile='E:\nhats\data\Projects\IAH\int_data\hospice_pre.dta' replace; run;



/* 12m post */

data hs_meet_365;
set proj_int.hs_meet_365p;
run;

proc sort data=hs_meet_365;
by bene_id admit_date;
run;

data hs_meet_365_1a;
set hs_meet_365;
format admit_date date9. disch_date date9. index_date date9.;
run;

/* people who have an admit and disch_date entirely within a year of index */

proc sql;
create table hs_meet1_post_365 as select *
from hs_meet_365_1a
where (admit_date - index_date )<=365 & (disch_date - index_date)<=365; 
quit;


/* admit date within year of index, discharge date > 1yr */
proc sql;
create table hs_meet2_post_365 as select *
from hs_meet_365_1a
where (admit_date - index_date)<=365 & (disch_date - index_date)>365; 
quit;

/*For these claims that start > 1 year before core, truncate start date so 
only count LOS days w/i 1 year
create indicator variable that claim start date is truncated */
data hs_meet2_post_365_1;
set hs_meet2_post_365;
disch_date = index_date+365;
hs_admit_date_mod = 1;
label hs_admit_date_mod = "Admit date mod; at 6 mo from ivw date";
run;

proc freq;
table hs_admit_date_mod ;
run;


data hs_meet_post_365;
set hs_meet1_post_365 hs_meet2_post_365_1;
run;

/*save final files to project int_data directory*/
data proj_int.hs_meet_post_365 ;
set  hs_meet_post_365;
run;

/*************************************************************/
/*calculate total number of days spent in hospice by BID*/
/*************************************************************/

data post_hs_days_1;
set proj_int.hs_meet_post_365;
calc_hs_LOS=disch_date-admit_date;
if calc_hs_LOS=0 then calc_hs_LOS=1;
run;

proc sort data=post_hs_days_1;
by bene_id index_date admit_date;
run;

proc sql;
create table hs_days_post as select distinct bene_id,index_year,
sum(calc_hs_LOS)
	as n_hs_days_p12m
	from post_hs_days_1 group by bene_id,index_year;
quit;


/*merge into full ffs 6m, age 65+ dataset*/
proc sort data=hs_days_post nodupkey;
by bene_id index_year;
run;

proc freq data=hs_days_post; tables n_hs_days_p12m; run;

/* testing

data test1 (keep = bene_id index_year n_hs_days_p12m);
set hs_days_post;
where n_hs_days_p12m > 360;
run;


proc sql;
create table testing as select a.*, b.index_date,b.admit_date,b.disch_date
from test1 a
inner join hs_meet_365_1a b
on a.bene_id = b.bene_id and a.index_year=b.index_year;
quit;

data testing;
set testing;
diff = disch_date - admit_date;
run;
*/

 data hs ;
 set hs_days_post ;
 array list n_hs_days_p12m;
 do over list;
 if list=. then list=0;
 end; 

if n_hs_days_p12m=0 then ind_hs_use_p12m=0;
 if n_hs_days_p12m>0 & n_hs_days_p12m~=. then ind_hs_use_p12m=1;
 label ind_hs_use_p12m="Indicator for any hospice stay 12m post ivw";
 label n_hs_days_p12m="Hospice Days 12m post ivw";

run;


/* 6 months */

/*pull list of hs claims from all medpar claims 6 months pre-interview*/
data hs_meet_183;
set proj_int.hs_meet_183p;
run;

proc sort data=hs_meet_183;
by bene_id admit_date;
run;

data hs_meet_183_1a;
set hs_meet_183;
format admit_date date9. disch_date date9.;
run;

/*3 claim windows are present:
1. SNF stays fully within the 1 year before interview
2. Stays that begin before 1 year pre-core but end within 1 year pre-core
3. Stays that begin within 1 year of core but end after core ivw
4. Stays that begin before 1 year and end after interview, LOS=183!
Get claims that meet 1 *1797*/
proc sql;
create table hs_meet1_post_183 as select *
from hs_meet_183_1a
where (admit_date - index_date )<=183 & (disch_date - index_date)<=183; 
quit;


/*meet time window 2 *152*/
proc sql;
create table hs_meet2_post_183 as select *
from hs_meet_183_1a
where (admit_date - index_date)<=183 & (disch_date - index_date)>183; 
quit;

/*For these claims that start > 1 year before core, truncate start date so 
only count LOS days w/i 1 year
create indicator variable that claim start date is truncated */

data hs_meet2_post_183_1;
set hs_meet2_post_183;
disch_date = index_date+183;
hs_admit_date_mod = 1;
label hs_admit_date_mod = "Admit date mod; at 6 mo from ivw date";
run;

proc freq;
table hs_admit_date_mod ;
run;



data hs_meet_post_183;
set hs_meet1_post_183 hs_meet2_post_183_1;
run;

/*save final files to project int_data directory*/
data proj_int.hs_meet_post_183 ;
set  hs_meet_post_183;
run;

/*************************************************************/
/*calculate total number of days spent in SNF by BID*/
/*************************************************************/

data post_hs_days_1;
set proj_int.hs_meet_post_183;
calc_hs_LOS=disch_date-admit_date;
if calc_hs_LOS=0 then calc_hs_LOS=1;
run;

proc sort data=post_hs_days_1;
by bene_id index_date admit_date;
run;

proc sql;
create table hs_days_post as select distinct bene_id,index_year,
sum(calc_hs_LOS)
	as n_hs_days_p6m
	from post_hs_days_1 group by bene_id,index_year;
quit;


/*merge into full ffs 6m, age 65+ dataset*/
proc sort data=hs_days_post nodupkey;
by bene_id index_year;
run;



 data hs_p6m ;
 set hs_days_post ;
 array list n_hs_days_p6m;
 do over list;
 if list=. then list=0;
 end; 

if n_hs_days_p6m=0 then ind_hs_use_p6m=0;
 if n_hs_days_p6m>0 & n_hs_days_p6m~=. then ind_hs_use_p6m=1;
 label ind_hs_use_p6m="Indicator for any hospice stay p6m pre ivw";
 label n_hs_days_p6m="Hospice Days p6m pre ivw";

run;

proc sql;
create table hospice_6 as select a.*, b.*
from hs a
full outer join
hs_p6m b
on a.bene_id = b.bene_id and a.index_year=b.index_year;
quit;

proc freq data=hospice_6; tables n_hs_days_p6m n_hs_days_p12m; run;

proc export data=hospice_6 outfile='E:\nhats\data\Projects\IAH\int_data\hospice_post.dta' replace; run;


proc export data=tmp6.personout outfile="E:\nhats\data\Projects\IAH\int_data\hcc_scores.dta" dbms=stata replace; run;

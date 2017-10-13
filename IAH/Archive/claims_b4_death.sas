libname medi 'E:\nhats\data\cms_DUA_28016\merged';
libname proj_int 'E:\nhats\data\Projects\IAH\int_data';

proc import datafile="E:\nhats\data\Projects\IAH\int_data\death_datesw1_3.dta" out=index replace; run;

data index;
set index;
index_year = year(index_date);
run;

proc sort data=index nodupkey; by bene_id; run;

/****************************************************************************/
/* Macro to pull claims lists, saves lists to int_data folder               */
/****************************************************************************/
%macro claims_pre(days_start=,days_bef_index=,yrs=,source=);

proc sql;
create table &source._meet_&days_bef_index. as select a.index_date, a.index_year,b.*
from index a inner join
medi.&source._&yrs. b 
on trim(left(a.bene_id))=trim(left(b.bene_id))
and &days_start<=a.index_date-b.admit_date<=&days_bef_index;
quit;

%mend;

/*run to get claims list 6 mo pre-ivw for ip*/
%claims_pre(days_start=0,days_bef_index=183,yrs=06_14,source=ip);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=snf);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=op);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=pb);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=hh);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=hs);
%claims_pre(days_start=0,days_bef_index=183,yrs=09_14,source=dm);
/*1yr*/
%claims_pre(days_start=0,days_bef_index=365,yrs=06_14,source=ip);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=snf);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=op);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=pb);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=hh);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=hs);
%claims_pre(days_start=0,days_bef_index=365,yrs=09_14,source=dm);

/*2yrs*/
%claims_pre(days_start=0,days_bef_index=730,yrs=06_14,source=ip);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=snf);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=op);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=pb);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=hh);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=hs);
%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=dm);

%macro ip_drop(days_bef_index=);
data proj_int.ip_meet_&days_bef_index.;
set ip_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date disch_date 
  ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ICD_PRCDR_CD1-ICD_PRCDR_CD25 icarecnt crnrydaycnt erdaycnt clm_ip_admsn_type_cd
  PRCDR_DT1-PRCDR_DT25 hcpcscd1-hcpcscd49);
run;
%mend ip_drop;

%macro snf_drop(days_bef_index=);
data proj_int.snf_meet_&days_bef_index.;
set snf_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date disch_date 
  ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ICD_PRCDR_CD1-ICD_PRCDR_CD25 
 PRCDR_DT1-PRCDR_DT25 );
run;
%mend snf_drop;


/*hh*/
%macro hh_drop(days_bef_index=);
data proj_int.hh_meet_&days_bef_index.;
set hh_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 );
run;
%mend hh_drop;

/*hs*/
%macro hs_drop(days_bef_index=);
data proj_int.hs_meet_&days_bef_index.;
set hs_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date disch_date PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25);
run;
%mend hs_drop;

/*dme*/
%macro dm_drop(days_bef_index=);
data proj_int.dm_meet_&days_bef_index.;
set dm_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date 
PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12 h_o2);
run;
%mend dm_drop;

/*op*/
%macro op_drop(days_bef_index=);
data proj_int.op_meet_&days_bef_index.;
set op_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date disch_date
PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 erdaycnt obs_stay);
run;
%mend op_drop;

/*carrier*/
%macro pb_drop(days_bef_index=);
data proj_int.pb_meet_&days_bef_index.;
set pb_meet_&days_bef_index.(keep=bene_id index_year index_date admit_date disch_date
PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12 hcpcscd1-hcpcscd13);
run;
%mend pb_drop;

%ip_drop(days_bef_index=183);
%op_drop(days_bef_index=183);
%pb_drop(days_bef_index=183);
%snf_drop(days_bef_index=183);
%hh_drop(days_bef_index=183);
%dm_drop(days_bef_index=183);
%hs_drop(days_bef_index=183);
%ip_drop(days_bef_index=365);
%ip_drop(days_bef_index=730);
%snf_drop(days_bef_index=365);
%snf_drop(days_bef_index=730);
%hh_drop(days_bef_index=365);
%hh_drop(days_bef_index=730);
%hs_drop(days_bef_index=365);
%hs_drop(days_bef_index=730);
%dm_drop(days_bef_index=365);
%dm_drop(days_bef_index=730);
%op_drop(days_bef_index=365);
%op_drop(days_bef_index=730);
%pb_drop(days_bef_index=365);
%pb_drop(days_bef_index=730);



/****************************************************************************/
/****************************************************************************/
/* Macro to pull dx from claims lists, saves dx lists to int_data folder    */
/****************************************************************************/

%macro dx_time_range(range1=, range2=, days_bef_core=);

/*Process carrier medicare claims to pull out dx codes
Multiple lines per each BID*/
data pb_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.pb_meet_&days_bef_core.(keep=bene_id index_year PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12 hcpcscd1-hcpcscd13);
array dx PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12;
do over dx;
diag=dx ;
output;
end;
run;
/*check for and remove duplicates, note this doesn't remove blanks*/
proc sort data=pb_last_&range2._dx out=pb_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;


/*Process outpatient medicare claims to pull out dx codes
Dataset being created: op_last_&range2._dx2*/
data op_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.op_meet_&days_bef_core.(keep=bene_id index_year PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25  );
array dx PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=op_last_&range2._dx out=op_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;

proc contents data=proj_int.ip_meet_365; run;


/*Dataset being created: ip_last_&range2._dx2*/
data ip_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.ip_meet_&days_bef_core.(keep=bene_id index_year ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 hcpcscd1-hcpcscd49);
array dx ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=ip_last_&range2._dx out=ip_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;

/*Dataset being created: snf_last_&range2._dx2*/
data snf_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.snf_meet_&days_bef_core.(keep=bene_id index_year ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 );
array dx ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=snf_last_&range2._dx out=snf_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;

/*Process dme medicare claims to pull out dx codes
Dataset being created: dm_last_&range2._dx2*/
data dm_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.dm_meet_&days_bef_core.(keep=bene_id index_year PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12 );
array dx PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=dm_last_&range2._dx out=dm_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;

/*Process hh medicare claims to pull out dx codes
Dataset being created: dm_last_&range2._dx2*/
data hh_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.hh_meet_&days_bef_core.(keep=bene_id index_year PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 );
array dx PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=hh_last_&range2._dx out=hh_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;

/*Process hs medicare claims to pull out dx codes
Dataset being created: dm_last_&range2._dx2*/
data hs_last_&range2._dx(keep=bene_id index_year diag);
set proj_int.hs_meet_&days_bef_core.(keep=bene_id index_year PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 );
array dx PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ;
do over dx;
diag=dx ;
output;
end;
run;
proc sort data=hs_last_&range2._dx out=hs_last_&range2._dx2 nodupkey;
by bene_id index_year diag;
run;


/*set diag variable length = 7 chars since that's the max length from the mc claims
Need to do this because length varies across the different mc claim types*/
data hs_last_&range2._dx3;
length diag $7;
set hs_last_&range2._dx2;
run;
data hh_last_&range2._dx3;
length diag $7;
set hh_last_&range2._dx2;
run;
data ip_last_&range2._dx3;
length diag $7;
set ip_last_&range2._dx2;
run;
data snf_last_&range2._dx3;
length diag $7;
set snf_last_&range2._dx2;
run;
data dm_last_&range2._dx3;
length diag $7;
set dm_last_&range2._dx2;
run;
data op_last_&range2._dx3;
length diag $7;
set op_last_&range2._dx2;
run;
data pb_last_&range2._dx3;
length diag $7;
set pb_last_&range2._dx2;
run;


/*merge diagnoses from each claim type into single dataset*/
data dx_all_last_1&range2.;
set hs_last_&range2._dx3
hh_last_&range2._dx3
ip_last_&range2._dx3
snf_last_&range2._dx3
dm_last_&range2._dx3
op_last_&range2._dx3
pb_last_&range2._dx3;
run;

proc sql;
create table dx_all_last_&range2. as select * from
index a 
left join 
dx_all_last_1&range2. b
on a.bene_id=b.bene_id and a.index_year=b.index_year;
quit; 

proc sort data=dx_all_last_&range2.(where=(diag~="")) out=proj_int.dx_&range1._&range2 nodupkey;
by bene_id index_year diag;
run;


%mend;

/*1 and 2 years pre-interview: proj_int.dx_0_1yr, proj_int.dx_0_2yr */
%dx_time_range(range1=0, range2=6m, days_bef_core=183);
%dx_time_range(range1=0, range2=1yr, days_bef_core=365);
%dx_time_range(range1=0, range2=2yr, days_bef_core=730);



data dx_all_last_6m_w_dups;
set hs_last_6m_dx
hh_last_6m_dx
ip_last_6m_dx
snf_last_6m_dx
dm_last_6m_dx
op_last_6m_dx
pb_last_6m_dx;
if diag~='.';
run;



/*****************************************/
/*check dementia diagnosis frequencies, need to pull this into main dataset
dx list is from Elixhauser code*/
data proj_int.dem_dx_freq;
set dx_all_last_6m_w_dups;
	dementia=0;
	if (substr(diag,1,4) in ('3310','3311','3312','2900','2901',
             '2902','2903','2912','2948','2949') or
		substr(diag,1,5) in ('29410','29411','29040','29041','29042','29043')) 
		and dementia=0 
          then dementia=1;
run;


/************************************************************************
*************************************************************************
Medpar 2000-2012 files
Starts with individual year files mp_2000, etc. saved in 
E:\data\cms_DUA_25000_2012\received_20150327

*************************************************************************
************************************************************************/

/************************************************************************
*************************************************************************
Medpar 2000-2012 - processing steps
*************************************************************************
************************************************************************/
%let source=mp;
*/prints first 10 rows of mp_2000 file, just select variables listed below;
proc sql outobs=10;
select BID_HRS_21, ADMSNDT,DSCHRGDT,loscnt from medi_raw.&source._2000;
quit;

*creates merged medpar file 2000-2012 years;
data medi_wk.&source._2000_2012;
set medi_raw.&source._2000 medi_raw.&source._2001 medi_raw.&source._2002 medi_raw.&source._2003 medi_raw.&source._2004 medi_raw.&source._2005 medi_raw.&source._2006 medi_raw.&source._2007 medi_raw.&source._2008
medi_raw.&source._2009 medi_raw.&source._2010 medi_raw.&source._2011
medi_raw.&source._2012;
*formats dates for admission and discharge;
admit_date=datejul(ADMSNDT);
if substr(trim(left(DSCHRGDT)),1,1) in ("1","2") then do;
disch_date=datejul(DSCHRGDT);
end;

admit_year=year(admit_date);

*calculate discharge date if null from admit date and los;
if disch_date=. then disch_date=admit_date+loscnt;
*format ID in this medpar file to match xwalk file;
bid_n=substr(trim(left(BID_HRS_21)),2,9)+0;
disch_year=year(disch_date);

format admit_date date9.;
format disch_date date9.;
run;

*Check for and remove dupicates;
proc sort data=medi_wk.&source._2000_2012 out=temp2  nodupkey;
by BID_n admit_date disch_date pmt_amt;
run;

/*create table bid of just observations that had multiple observations
that match on id, admit date and discharge date
They have different payment amounts though b/c of previous step*/
proc sql;
create table bid as
select BID_n,admit_date, disch_date,count(*)
from medi_wk.&source._2000_2012 group by
BID_n,admit_date, disch_date having count(*)>1;

*prints list of observations where match on id, admit date and disch date;
select BID_n,admit_date, disch_date from medi_wk.&source._2000_2012
where bid_n in (select bid_n from bid)
;
quit;

* Variable list:
MSNDT ADMSNDT CHAR Documentation 
MEDPAR_ADMSN_DT: MEDPAR Admission Date 
DSCHRGDT DSCHRGDT CHAR Documentation 
MEDPAR_DSCHRG_DT: MEDPAR Discharge Date 
loscnt;

*identify observatons where discharge year is null - no observations identified;
proc sql outobs=10;
select BID_HRS_21, ADMSNDT,DSCHRGDT,loscnt from medi_wk.&source._2000_2012 where 
disch_year=.;
quit;
*frequency table of admit and disch year vars;
proc freq data=medi_wk.&source._2000_2012;
table admit_year disch_year;
run;

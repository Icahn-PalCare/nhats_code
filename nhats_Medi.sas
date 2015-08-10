/*Processes Medicare claims received in July 2015

Creates combined year files for 2000-2012 claims for use in other projects

Combined 2006-2012 files are saved here:
E:\data\NHATS_CMS_DUA_28016\All

Note that there was an error in the original 2009 and 2010 medpar files
received from MedRIC. New files were received in Feb 2014 and these
are replaced in the combined 2000-2010 files created here*/

libname hrs_med "E:\data\cms_DUA_24548_2012";


libname medi_raw 'E:\data\NHATS_CMS_DUA_28016\All';

/* KMCK libnames below were not updated - awaiting new data */
libname xw2008 'E:\data\hrs_restricted_2010\20131104_received\Medicare\Xref2008\distro';


/*process individual year denominator files into single file with
2000-2010 data*/

data medi_raw.Mbsf_ab_summary_06_12;
set  medi_raw.Mbsf_ab_summary_06 medi_raw.Mbsf_ab_summary_07  medi_raw.Mbsf_ab_summary_08
 medi_raw.Mbsf_ab_summary_09 medi_raw.Mbsf_ab_summary_10 medi_raw.Mbsf_ab_summary_11
 medi_raw.Mbsf_ab_summary_12;
year=BENE_ENROLLMT_REF_YR + 0;
bid_n=substr(trim(left(BID_HRS_19)),2,9)+0;
BID=bid_n;

/************************************************************************
*************************************************************************
Clean birth_date, death_date in date format from denominator file
*************************************************************************
************************************************************************/

/*note we can't use dob dod from CMS denominator file since a lot of them are missing,they should come from restricted file*/
if substr(trim(left(BENE_DEATH_DT)),1,1)~="0"  then do;
death_year=substr(trim(left(BENE_DEATH_DT)),1,4)+0;
death_month=substr(trim(left(BENE_DEATH_DT)),5,2)+0;
death_day=substr(trim(left(BENE_DEATH_DT)),7,2)+0;
death_date=mdy(death_month,death_day,death_year);
end;
if substr(trim(left(BENE_BIRTH_DT)),1,1)~="0"  then do;
birth_year=substr(trim(left(BENE_BIRTH_DT)),1,4)+0;
birth_month=substr(trim(left(BENE_BIRTH_DT)),5,2)+0;
birth_day=substr(trim(left(BENE_BIRTH_DT)),7,2)+0;
birth_date=mdy(birth_month,birth_day,birth_year);
end;
run;


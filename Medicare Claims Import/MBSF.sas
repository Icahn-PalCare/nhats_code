/*Processes Medicare claims received in July 2015

Creates combined year files for 2000-2012 claims for use in other projects

Combined 2006-2012 files are saved here:
E:\data\NHATS_CMS_DUA_28016\All

Note that there was an error in the original 2009 and 2010 medpar files
received from MedRIC. New files were received in Feb 2014 and these
are replaced in the combined 2000-2010 files created here*/

libname medi_raw 'E:\data\NHATS_CMS_DUA_28016\All';

/*process individual year denominator files into single file with
2000-2010 data*/

data medi_raw.Mbsf_ab_summary_06_12;
set  medi_raw.Mbsf_ab_summary_06 medi_raw.Mbsf_ab_summary_07  medi_raw.Mbsf_ab_summary_08
 medi_raw.Mbsf_ab_summary_09 medi_raw.Mbsf_ab_summary_10 medi_raw.Mbsf_ab_summary_11
 medi_raw.Mbsf_ab_summary_12;
year=BENE_ENROLLMT_REF_YR + 0;
format BENE_DEATH_DT mmddyy10. bene_birth_dt mmddyy10. COVSTART mmddyy10.; 
run;
data medi_raw.Mbsf_ab_summary_06_12;
set  medi_raw.Mbsf_ab_summary_06 medi_raw.Mbsf_ab_summary_07  medi_raw.Mbsf_ab_summary_08
 medi_raw.Mbsf_ab_summary_09 medi_raw.Mbsf_ab_summary_10 medi_raw.Mbsf_ab_summary_11
 medi_raw.Mbsf_ab_summary_12;
year=BENE_ENROLLMT_REF_YR + 0;
format BENE_DEATH_DT mmddyy10. bene_birth_dt mmddyy10. COVSTART mmddyy10.; 
run;

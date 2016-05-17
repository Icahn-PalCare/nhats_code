libname cms_2011 "E:\data\NHATS_CMS_DUA_28016\2011";
libname nhats "E:\data\nhats\working";

proc import out=nhats
			datafile = "E:\data\nhats\working\round_1_3_clean_helper_added_old.dta"
			replace;
run;
proc import out= HRR_merge datafile = "C:\data\nhats\HRR Codes\NHATS_HRR_xref_R1_R2_STATA\NHATS_Round_1_HRR_xref.dta";
run;
data cms_xwalk_nhats;
set cms_2011.Nhats2bene_xwalk;
spid = NHATS_CMS_NUM + 0;
run;

proc sql;
create table nhats_cms_hrr
as select a.*, b.hrrnum_2011, c.bene_id
from nhats a
left join hrr_merge b
on a.spid = b.spid
left join cms_xwalk_nhats c
on a.spid = c.spid;
quit;
proc freq data=nhats_cms_hrr;
table hrrnum_2011 bene_id;
run;

data nhats.nhats_crosswalk;
set nhats_cms_hrr;
run;

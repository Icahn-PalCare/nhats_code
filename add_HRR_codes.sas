proc import out= roundall datafile = "C:\data\nhats\working\round_1_3_clean_helper_added_old.dta";
run;
proc import out= HRR_merge datafile = "C:\data\nhats\HRR Codes\NHATS_HRR_xref_R1_R2_STATA\NHATS_Round_1_HRR_xref.dta";
run;

proc sql;
create table roundall_hrr
as select a.*, b.hrrnum_2011
from roundall a
left join hrr_merge b
on a.spid = b.spid;
quit;

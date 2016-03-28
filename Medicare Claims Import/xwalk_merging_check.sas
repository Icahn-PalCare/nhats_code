libname medi 'E:\nhats\data\cms_dua_28016\cumulative years';
libname m2 'E:\nhats\data\cms_dua_28016\extracted';

data mbsf11;
set m2.mbsf_ab_summary_11;
run;

proc export data=mbsf11 outfile="E:\nhats\data\cms_dua_28016\mbsf11.dta" replace; run;

data xwalk;
set m2.nhats2bene_xwalk_11;
run;

proc export data=xwalk outfile="E:\nhats\data\cms_dua_28016\xwalk.dta" replace; run;

proc sql;
create table xwalk_mbsf
as select a.*, b.BENE_SEX_IDENT_CD as bene_sex
from xwalk a
left join mbsf11 b
on a.bene_id = b.bene_id;
quit;

data xwalk_mbsf1;
set xwalk_mbsf;
if bene_sex = "" then delete;
spid = NHATS_CMS_NUM + 0;
run;

proc sql;
create table xwalk_mbsf2
as select a.*, b.r1dgender as sex
from xwalk_mbsf1 a
left join raw_nhats_r1 b
on a.spid = b.spid;
quit;

data xwalk_mbsf3;
set xwalk_mbsf2;
if sex = . then delete;
run;

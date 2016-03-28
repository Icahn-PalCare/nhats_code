libname medi 'E:\nhats\data\cms_DUA_28016\merged';
libname cumu 'E:\nhats\data\CMS_DUA_28016\Cumulative Years';

%macro day_cnt (sortfile = ,datafile = , rev_num1 = , rev_num2 = , rev_num3 = , cnt_var =, final_data = );
data medi.&final_data.;
set medi.&final_data.;
drop &cnt_var.;
run;
proc sort data=cumu.&sortfile. out=&datafile.;
by bene_id clm_id clm_thru_dt;
run;
data &datafile.;
set &datafile.;
rev_center = REV_CNTR + 0;
if (rev_center >= &rev_num1. and rev_center <= &rev_num2.)|rev_center = &rev_num3.;

run;
data &datafile.1 (keep = bene_id clm_id CLM_THRU_DT &cnt_var.);
set &datafile.;
by bene_id CLM_ID CLM_THRU_DT;
retain &cnt_var.;
&cnt_var. = &cnt_var. + REV_CNTR_UNIT_CNT;
if first.clm_id then do;
&cnt_var. = REV_CNTR_UNIT_CNT;
end;
if last.clm_id;
run;
proc sql;
create table &final_data._&cnt_var.
as select a.*, b.&cnt_var.
from medi.&final_data. a
left join &datafile.1 b
on a.bene_id = b.bene_id and
a.clm_id = b.clm_id;
quit;
proc freq data=&final_data._&cnt_var.;
table &cnt_var.;
run;
data medi.&final_data.;
set &final_data._&cnt_var.;
run;
%mend;
/*put 0000 if extra rev center not needed? need to fix at some point*/
%day_cnt(sortfile = Inpatient_revenue_center_j_06_12, datafile = inpat_rev_file, rev_num1 = 200, rev_num2 = 209, rev_num3=0000, cnt_var = icarecnt, final_data = ip_06_12);
%day_cnt(sortfile = Inpatient_revenue_center_j_06_12, datafile = inpat_rev_file, rev_num1 = 210, rev_num2 = 219, rev_num3=0000, cnt_var = crnrydaycnt, final_data = ip_06_12);
%day_cnt(sortfile = Inpatient_revenue_center_j_06_12, datafile = inpat_rev_file, rev_num1 = 450, rev_num2 = 459, rev_num3=981, cnt_var = ERdaycnt, final_data = ip_06_12);
%day_cnt(sortfile = Outpatient_rev_center_j_09_12, datafile = outpat_rev_file, rev_num1 = 450, rev_num2 = 459, rev_num3 = 981, cnt_var = ERdaycnt, final_data = op_06_12);

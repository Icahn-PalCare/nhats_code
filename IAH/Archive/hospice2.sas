/*Get claims 1 year and 2 year before each interview*/
/*Step 2: pull claims lists using xwalk and ivw date*/

proc sort data=proj_int.index out=index1 nodupkey;
by bene_id index_year;
run;


libname medi 'E:\nhats\data\cms_DUA_28016\merged';

proc import datafile="E:\nhats\data\Projects\IAH\int_data\death_datesw1_3.dta" out=index replace; run;

/****************************************************************************/
/* Macro to pull claims lists, saves lists to int_data folder               */
/****************************************************************************/
%macro claims_pre(days_start=,days_bef_index=,yrs=,source=);

proc sql;
create table &source._meet_&days_bef_index. as select a.index_date,b.*
from index a inner join
medi.&source._&yrs. b 
on trim(left(a.bene_id))=trim(left(b.bene_id))
and &days_start<=a.index_date-b.admit_date<=&days_bef_index;
quit;

%mend;


%claims_pre(days_start=0,days_bef_index=730,yrs=09_14,source=hs);




/*hs*/
%macro hs_drop(days_bef_index=);
data hs_meet_&days_bef_index.;
set hs_meet_&days_bef_index.(keep=bene_id index_date admit_date disch_date);
run;
%mend hs_drop;


%hs_drop(days_bef_index=730);





*Table 1;
*Total number of older adults;
proc surveyfreq data=round1_sp;
table homebound3/cl;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

*Total number of helpers;
proc sort data=Sp_op1;
by homebound3;
run;

proc freq data=Sp_op1;
tables homebound3;
run;

*Mean number of helpers per older adult;
proc means data=helper mean median std stderr min max maxdec=1;
var count;
class homebound3;
run;

proc means data=helper mean median std min max maxdec=1;
var count;
where homebound3>=1;
run;

proc freq data=total_helpers;
tables count*homebound3/ norow nocum;
tables helpers_cat*homebound3/ norow nocum;
run;

*Mean hours of help per older adult, n (std);
proc means data=hours mean median std min max maxdec=1;
var sumhour;
where sumhour>0 and homebound3>0;
run;

proc means data=hours mean median std min max maxdec=1;
var sumhour;
where sumhour>0;
class homebound3;
run;

*Helper prevalence per older adult, n (%);
proc freq data=sp_op1;
table relationship*homebound3;
run;

*Mean hours of help per older adult, n (std);
*no zeros;
proc means data=Sp_op1 maxdec=1;
var op1numhrsday;
class homebound3 relationship;
where (op1numhrsday>0) and (op1numhrsday^=.);
run;
proc means data=Sp_op1 maxdec=1;
var op1numhrsday;
class relationship;
where (op1numhrsday>0) and (op1numhrsday^=.) and homebound>=0;
run;

*Type of help received by older adults;
proc freq data=SP_help2;
tables mo sc ha mc allhelp/list;
by homebound3;
run;

proc freq data=SP_help2;
tables mo sc ha mc allhelp/list;
run;

*Table 2;

proc surveyfreq data=round1_sp;
tables homebound3/cl;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;


proc sort data=round1_sp;
by homebound3;
run;

*Assistance with activities;
proc surveyfreq data=round1_sp;
tables selfcare/cl;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc surveyfreq data=round1_sp;
tables hh_act/cl;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc surveyfreq data=round1_sp;
tables ha1dmealwhl/cl;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc surveyfreq data=round1_sp;
tables mo1douthelp mo1dinsdhelp mo1dbedhelp;
tables mobility/cl;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc surveyfreq data=round1_sp;
tables med_care/cl;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc surveyfreq data=round1_sp;
tables any_assist;
by homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
run;

proc print data=round1_sp;
var SPID homebound3 selfcare hh_act ha1dmealwhl mobility med_care any_assist;
where homebound3=1;
run;




*Table 3;
proc sort data=total_helpers;
by homebound3;
run;

proc freq data=total_helpers;
tables helper;
run;

proc surveyfreq data=total_helpers;
tables homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
where helper^=.;
run;

proc print data=total_helpers;
var spid homebound3 helper;
where helper=.;
run;

proc surveymeans data=total_helpers;
var r1dintvwrage ;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
where helper^=.;
run;


proc surveyfreq data=total_helpers;
tables r1dgender ;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
where helper^=.;
run;

proc surveyfreq data=total_helpers;
tables marital ;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
where helper^=.;
run;

proc surveyfreq data=total_helpers;
tables hh1dlvngarrg;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
where helper^=.;
run;

*Place of residence;
proc surveyfreq data=total_helpers;
tables r1dresid;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
where helper^=.;
run;

*Table 4;

proc sort data=total_helpers;
by homebound3;
run;

proc surveyfreq data=total_helpers;
tables homebound3;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
*where helper^=.;
run;

proc surveyfreq data=total_helpers;
tables unpaid_cg_cat;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
run;

proc surveyfreq data=total_helpers;
tables paid_cg_cat;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
run;

proc surveymeans data=total_helpers mean sum STD;
var helper;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
*where helper^=0;
run;

proc surveyfreq data=total_helpers;
tables helpers_cat;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
run;

*Mean number of helpers per activity, n (std) ;
proc sort data=sp_help;
by homebound3;
run;

proc surveymeans data=SP_help;
var sum_mo sum_SC sum_ha sum_mc;
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3;
run;

*mean hours of care per type of helper;
proc sort data=Sp_op1;
by homebound3 relationship;
run;
proc surveymeans data=Sp_op1 ;
var op1numhrsday;
where (op1numhrsday>0) and (op1numhrsday^=.);
weight w1anfinwgt0;
stratum w1varstrat ;
cluster w1varunit;
by homebound3 relationship;
run;


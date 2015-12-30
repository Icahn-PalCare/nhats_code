ods html close;
ods html;
proc freq data=nsoc1;
table cdc1hlpsched;
run;
proc means data=nsoc1;
where cdc1hlpdyswk > 0;
var cdc1hlpdyswk;
run;
proc freq data=nsoc1;
table cdc1hlpdyswk ;
run;
proc means data=nsoc1;
where cdc1hlphrsdy > 0;
var cdc1hlphrsdy;
run;
proc freq data=nsoc1;
table cdc1hlphrsdy;
run;

proc means data=nsoc1;
where cdc1hlpdysmt > 0;
var cdc1hlpdysmt;
run;
proc freq data=nsoc1;
table cdc1hlpdysmt;
run;
proc means data=nsoc1;
where cdc1hlphrlmt > 0;
var cdc1hlphrlmt;
run;
proc freq data=nsoc1;
table cdc1hlphrlmt;
run;

proc means data=nsoc1;
var total_hours;
run;

DATA test (keep = spid total_hours total_hours_day total_hours_month total_hours_week total_hours_other cdc1hlpsched cdc1hlpdyswk cdc1hlphrsdy cdc1hlpdysmt cdc1hlphrlmt);
set nsoc1;
if total_hours = .;
if cdc1hlpsched = 1 then total_hours = total_hours_day * total_hours_week * 4;
run;

proc freq data=nsoc1;
table cdc1hlpmthst cdc1hlpunit cdc1hlpyrs cdc1hlpyrst;
run;

proc freq data=nsoc1;
table cdc1hlpyrpls cca1hlplstyr;
run;

DATA test (keep = spid c1intmonth cdc1hlpyrpls cdc1hlpyrs cdc1hlpmthst cdc1hlpunit cdc1hlpyrst);
set nsoc1;

run;
proc freq data=test;
table cdc1hlpyrst;
run;

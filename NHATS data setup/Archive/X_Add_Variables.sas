proc import out=raw_nhats_r1
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File_old.dta";
run;
proc import out=raw_nhats_r2
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_SP_File_old.dta";
run;
proc import out=raw_nhats_r3
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_SP_File_old.dta";
run;
proc import out=nhats_rg
			datafile = "E:\nhats\data\NHATS working data\round_1_3_clean_helper_added_old_backup1.dta"
			replace;
run;
proc freq data=nhats_rg;
table wave mo1insdhlp mo2insdhlp mo3insdhlp;
run;

data nhats_add;
set nhats_rg;
drop adl_ins_help adl_bed_help;
run;
ods html close;
ods html;
option spool;
%let p_var = mo mo;
%let s_var = insdhlp bedhlp;
%let f_var = adl_ins_help adl_bed_help;
%macro help2;
%let i = 1;
%let pvar = %scan(&p_var, &i);
%let svar = %scan(&s_var, &i);
%let fvar = %scan(&f_var, &i);
%do %while(&pvar ne );
	%do j = 1 %to 3;
		proc freq data=nhats_add;
		table &pvar.&j.&svar.;
		run;
		data nhats_add;
		set nhats_add;
		if wave = &j then &fvar. = &pvar.&j.&svar.;
		run;
		proc freq data=nhats_add;
		table &fvar.;
		run;
	%end;
	data nhats_add;
	set nhats_add;
	if &fvar. = 1 then &fvar. = 1;
	if &fvar. = 2 then &fvar. = 0; 
	if &fvar. < 0 then &fvar. = .;
	run;
	proc freq data=nhats_add;
	table &fvar.;
	run;
%let i = %eval(&i + 1);
%let pvar = %scan(&p_var,&i);
%let svar = %scan(&s_var, &i);
%let fvar = %scan(&f_var, &i);

%end;
%mend;
%help2;




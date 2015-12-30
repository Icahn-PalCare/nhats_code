proc import out=nhats_fin
			datafile = "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added_old.dta"
			replace;
run;
proc import out=raw_nhats_r1
			datafile = "E:\nhats\data\NHATS Public\round_1\NHATS_Round_1_SP_File_old.dta";
run;
proc import out=raw_nhats_r2
			datafile = "E:\nhats\data\NHATS Public\round_2\NHATS_Round_2_SP_File_old.dta";
run;
proc import out=raw_nhats_r3
			datafile = "E:\nhats\data\NHATS Public\round_3\NHATS_Round_3_SP_File_old.dta";
run;
proc import out=raw_nhats_r4
			datafile = "E:\nhats\data\NHATS Public\round_4\NHATS_Round_4_SP_File.dta";
run;
proc freq data=raw_nhats_r1;
table mo1dinsdhelp mo1dbedsfdf mo1dbeddevi mo1dbedhelp sc1eatdev sc1deathelp sc1dbathhelp;
run;
proc freq data=raw_nhats_r1;
table mo1insdcane mo1insdwalkr mo1insdwlchr mo1insdsctr mo1oftholdwl mo1insdhlp mo1insdslf mo1insddif mo1insdyrgo mo1insdwout;
run;
proc freq data=raw_nhats_r1;
table sc1dresoft sc1dresdev sc1dreshlp;
run;
proc freq data=raw_nhats_r1;
where ha1dshopsfdf = 1 or ha1dshopsfdf = 8;
table ha1dshopreas;
run;
/*
ods rtf body = "E:\nhats\iadl_missing.rtf";
proc freq data=raw_nhats_r1;
table ha1dlaunsfdf ha1dlaunreas ha1dshopsfdf ha1dshopreas ha1dmealsfdf ha1dmealreas ha1dbanksfdf ha1dbankreas;
run;
ods rtf close;
ods rtf body = "E:\nhats\adl_missing.rtf";
proc freq data=raw_nhats_r1;
table sc1dresoft sc1dreshlp sc1eatdev sc1eathlp;
run; 
ods rtf close;
*/

data raw_nhats_r1;
set raw_nhats_r1;
wave = 1;
run;
data raw_nhats_r2;
set raw_nhats_r2;
wave = 2;
run;
data raw_nhats_r3;
set raw_nhats_r3;
wave = 3;
run;
data raw_nhats_r4;
set raw_nhats_r4;
wave = 4;
run;

data nhats_fin1;
set nhats_fin;
run;
%macro new_vars();
%do i = 1 %to 4;
	proc freq data=raw_nhats_r&i.;
	table mo&i.insdhlp mo&i.bedhlp;
	run;
	proc sql;
	create table nhats_fin1
	as select a.*, b.mo&i.insdhlp, b.mo&i.bedhlp
	from nhats_fin1 a
	left join raw_nhats_r&i. b
	on a.spid = b.spid and
	a.wave = b.wave;
	quit;
	proc freq data=nhats_fin1;
	table  mo&i.insdhlp mo&i.bedhlp;
	run;
%end;
%mend;
%new_vars()

proc export data=nhats_fin1 outfile = "E:\nhats\data\NHATS working data\round_1_4_clean_helper_added_old.dta" replace;
run;

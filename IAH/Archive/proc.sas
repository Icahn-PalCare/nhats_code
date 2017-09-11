libname proj_int 'E:\nhats\data\projects\pal_perf_scale\int_data';

data ip_365 (drop=hcpcscd1--hcpcscd45);
set proj_int.ip_meet_365;
array list ICD_PRCDR_CD1-ICD_PRCDR_CD25;
array date PRCDR_DT1-PRCDR_DT25;
do over list;
if list ~="" then do;
pro=list+0;
procedure_date = date;
output;
end;
end;
format procedure_date date10.;
run;

data proc_long_ba;
set ip_365;
array list 
pre_intubation
pre_trach
pre_gastro_tude
pre_hemodia
pre_enteral_nut
pre_cpr;
do over list;
list=0;
end;

if length(trim(left(pro)))>=3 then do;

	if  substr(trim(left(pro)),1,3) in ("967")  then pre_intubation =1;
	if  substr(trim(left(pro)),1,3) in ("311") then  pre_trach=1;
	if  substr(trim(left(pro)),1,3) in ("432") then  pre_gastro_tude=1;

	if substr(trim(left(pro)),1,3) in ("966") then  pre_enteral_nut=1;

	if length(trim(left(pro)))>3 then do;
		if substr(trim(left(pro)),1,4) in ("9604","9605") or 
		  substr(trim(left(pro)),1,3) in ("967") then pre_intubation =1;
		if substr(trim(left(pro)),1,4) in ("3121","3129") or 
		  substr(trim(left(pro)),1,3) in ("311") then pre_trach=1;
		if substr(trim(left(pro)),1,4) in ("4311","4319","4432")  or 
		  substr(trim(left(pro)),1,3) in ("432") then pre_gastro_tude=1;
		if substr(trim(left(pro)),1,4) in ("3995") then pre_hemodia=1;
		if substr(trim(left(pro)),1,4) in ("9915") or 
		  substr(trim(left(pro)),1,3) in ("966") then pre_enteral_nut=1;
		if substr(trim(left(pro)),1,4) in ("9960","9963") then pre_cpr=1;
	end;

end;

if pre_intubation|
pre_trach|
pre_gastro_tude|
pre_hemodia|
pre_enteral_nut|
pre_cpr then date_proc=procedure_date;
run;

data proc_list;
set proc_long_ba;
where pre_intubation = 1 or pre_trach = 1 or pre_gastro_tude = 1 or pre_enteral_nut = 1 or pre_cpr = 1;
if procedure_date = . then procedure_date = admit_date;
run;

data proc_12 (keep = bene_id index_year pre_intubation pre_trach pre_gastro_tude pre_enteral_nut pre_cpr proc_12m proc_6m);
set proc_list;
proc_12m = 1;
proc_6m = 0;
if index_date - procedure_date<=183 then proc_6m = 1;
where index_date - procedure_date<=365;
run;

data proc_12;
set proc_12;
label pre_intubation = "intubation/mechanic ventilation pre ivw";
label pre_trach = "trachostomy pre ivw";
label pre_gastro_tude = "gastrostomy tube pre ivw";
label pre_enteral_nut = "enteral/parenteral nutrition pre ivw";
label pre_cpr = "CPR pre ivw";
label proc_12m = "Had 1 or more life saving procedure 12m pre ivw";
label proc_6m = "Had 1 or more life saving procedure 6m pre ivw";
run;

proc export data=proc_12 outfile="E:\nhats\data\Projects\IAH\int_data\life_proc_12.dta" replace; run;


data ip_365_post (drop=hcpcscd1--hcpcscd45);
set proj_int.ip_meet_365p;
array list ICD_PRCDR_CD1-ICD_PRCDR_CD25;
array date PRCDR_DT1-PRCDR_DT25;
do over list;
if list ~="" then do;
pro=list+0;
procedure_date = date;
output;
end;
end;
format procedure_date date10.;
run;

data proc_post;
set ip_365_post;
array list 
post_intubation
post_trach
post_gastro_tude
post_hemodia
post_enteral_nut
post_cpr;
do over list;
list=0;
end;

if length(trim(left(pro)))>=3 then do;

	if  substr(trim(left(pro)),1,3) in ("967")  then post_intubation =1;
	if  substr(trim(left(pro)),1,3) in ("311") then  post_trach=1;
	if  substr(trim(left(pro)),1,3) in ("432") then  post_gastro_tude=1;

	if substr(trim(left(pro)),1,3) in ("966") then  post_enteral_nut=1;

	if length(trim(left(pro)))>3 then do;
		if substr(trim(left(pro)),1,4) in ("9604","9605") or 
		  substr(trim(left(pro)),1,3) in ("967") then post_intubation =1;
		if substr(trim(left(pro)),1,4) in ("3121","3129") or 
		  substr(trim(left(pro)),1,3) in ("311") then post_trach=1;
		if substr(trim(left(pro)),1,4) in ("4311","4319","4432")  or 
		  substr(trim(left(pro)),1,3) in ("432") then post_gastro_tude=1;
		if substr(trim(left(pro)),1,4) in ("3995") then post_hemodia=1;
		if substr(trim(left(pro)),1,4) in ("9915") or 
		  substr(trim(left(pro)),1,3) in ("966") then post_enteral_nut=1;
		if substr(trim(left(pro)),1,4) in ("9960","9963") then post_cpr=1;
	end;

end;

if post_intubation|
post_trach|
post_gastro_tude|
post_hemodia|
post_enteral_nut|
post_cpr then date_proc=procedure_date;
run;

data proc_list_post;
set proc_post;
where post_intubation = 1 or post_trach = 1 or post_gastro_tude = 1 or post_enteral_nut = 1 or post_cpr = 1;
if procedure_date = . then procedure_date = admit_date;
run;

data proc_p12 (keep = bene_id index_year post_intubation post_trach post_gastro_tude post_enteral_nut post_cpr proc_p12m proc_p6m);
set proc_list_post;
proc_p12m = 1;
proc_p6m = 0;
if procedure_date - index_date<=183 then proc_p6m = 1;
run;

data proc_p12;
set proc_p12;
label post_intubation = "intubation/mechanic ventilation post ivw";
label post_trach = "trachostomy post ivw";
label post_gastro_tude = "gastrostomy tube post ivw";
label post_enteral_nut = "enteral/parenteral nutrition post ivw";
label post_cpr = "CPR post ivw";
label proc_p12m = "Had 1 or more life saving procedure 12m post ivw";
label proc_p6m = "Had 1 or more life saving procedure 6m post ivw";
run;


proc export data=proc_p12 outfile="E:\nhats\data\Projects\IAH\int_data\life_proc_p12.dta" replace; run;

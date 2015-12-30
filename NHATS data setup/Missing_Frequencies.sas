/*********** ADL Variables that are Missing *************/
ods rtf body = "E:\nhats\adl_missing.rtf";

/****** Eating ******/

/*Answering that they are being fed through IV or Tubes skips the rest of Eating questions*/
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1eatdev;
run;
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1eathlp;
run;

/****** Bathing ******/

/*Answering Refused/Don't know to these questions leads to a complete skip in the question altogether*/
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1showrbat1 sc1showrbat2 sc1showrbat3;
run;
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1bathhlp;
run;

/****** Dressing ******/

/*If they say that they never get dressed/DKRF, then they skip dressing questions*/
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1dresoft;
run;
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table sc1dreshlp;
run;

/***** Walking in House *****/

/*If answer they never leave the bedroom at all, then skip most of the walking questions*/
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mo1oftgoarea mo1oflvslepr;
run;
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mo1insdhlp;
run;

ods rtf close;



/*********** IADL Variables that are Missing *************/

ods rtf body = "E:\nhats\iadl_missing1.rtf";
proc freq data=raw_nhats_r1;
table  ha1dlaunsfdf;
run;
proc freq data=raw_nhats_r1;
where ha1dlaunsfdf = 1 | ha1dlaunsfdf = 8;
table  ha1dlaunreas;
run;
proc freq data=raw_nhats_r1;
table  ha1dshopsfdf;
run;
proc freq data=raw_nhats_r1;
where ha1dshopsfdf = 1 | ha1dshopsfdf = 8;
table  ha1dshopreas;
run;
proc freq data=raw_nhats_r1;
table  ha1dmealsfdf;
run;
proc freq data=raw_nhats_r1;
where ha1dmealsfdf = 1 | ha1dmealsfdf = 8;
table  ha1dmealreas;
run;
proc freq data=raw_nhats_r1;
table  ha1dbanksfdf;
run;
proc freq data=raw_nhats_r1;
where ha1dbanksfdf = 1 | ha1dbanksfdf = 8;
table  ha1dbankreas;
run;
proc freq data=raw_nhats_r1;
table mc1dmedssfdf;
run;
proc freq data=raw_nhats_r1;
where mc1dmedssfdf = 1 | mc1dmedssfdf = 8;
table mc1dmedsreas;
run;
ods rtf close;

/*********** Doctor question ***********/
ods rtf body = "E:\nhats\other_var_missing.rtf";
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mc1regdoclyr;
run;
proc freq data = raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mc1hwgtregd8;
run;
ods rtf close;


/********** PHQ/GAD Questions **********/

ods rtf body = "E:\nhats\data\Logs - NHATS setup\PHQ_GAD_Missing.rtf";
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table hc1depresan1 hc1depresan2 hc1depresan3 hc1depresan4;
run;
ods rtf close;

/******* Random Questions ********/

ods rtf body = "E:\nhats\data\Logs - NHATS setup\Random_Questions.rtf";
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mo1outhlp;
run;
proc freq data=raw_nhats_r1;
where r1dresid = 1 | r1dresid = 2;
table mo1insdhlp;
run;
proc freq data=raw_nhats_r1;
where mo1outhlp = 2 & (r1dresid = 1 | r1dresid = 2);
table mo1insdhlp;
run;
ods rtf close;

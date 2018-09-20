libname old 'E:\nhats\data\CMS_DUA_28016\Merged';
libname new 'E:\nhats\data\20180625 NHATS CMS Data\Cumulative';

data old_ip (keep = bene_id admit_date disch_date 
  ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ICD_PRCDR_CD1-ICD_PRCDR_CD25 icarecnt crnrydaycnt erdaycnt clm_ip_admsn_type_cd
  PRCDR_DT1-PRCDR_DT25 hcpcscd1-hcpcscd49) ;
set old.ip_06_14;
run;

data new_ip (keep = bene_id admit_date disch_date 
 ADMTG_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25 ICD_PRCDR_CD1-ICD_PRCDR_CD25 icarecnt crnrydaycnt erdaycnt clm_ip_admsn_type_cd
 PRCDR_DT1-PRCDR_DT25 hcpcscd1-hcpcscd49);
set new.ip_15_16;
run;

%macro crwlk (v, v1);
proc contents data=&v1 noprint out=&v
(keep = name type format label length);
run;

data &v;
set &v;
&v = "&v1";
label_&v1 = label;
drop label;
run;

%mend;

%crwlk(ip_1, old_ip);
%crwlk(ip_2, new_ip);





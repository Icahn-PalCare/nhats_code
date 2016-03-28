PROC FORMAT;

    VALUE dosfacd /* FOR FQ1dosfacd  */
       -8 = "-8 DK"
       -1 = "-1 INAPPLICABLE"
        1 = " 1 FREE STANDING NURSING HOME"
        2 = " 2 FREE STANDING ASSISTED LIVING FACILITY / RESIDENTIAL CARE FACILITY"
        3 = " 3 NURSING HOME AND ASSISTED LIVING FACILITY"
        4 = " 4 CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
        5 = " 5 ADULT FAMILY CARE HOME"
        6 = " 6 GROUP HOME"
        7 = " 7 BOARD AND CARE HOME / PERSONAL CARE HOME"
        8 = " 8 RETIREMENT COMMUNITY OR SENIOR HOUSING (NOT CCRC)"
        9 = " 9 INDEPENDENT LIVING"
       10 = " 10 ASSISTED AND INDEPENDENT/RETIREMENT (NO NURSING HOME)"
       11 = " 11 HOUSING (APT, CONDO, ETC.)";
        ;
    VALUE dosfaca /* FOR FQ1dosfaca */
       -8 = "-8 DK"
       -1 = "-1 INAPPLICABLE"
        1 = " 1 INDEPENDENT LIVING / HOUSING / RETIREMENT "
        2 = " 2 ASSISTED LIVING / PERSONAL CARE"
        3 = " 3 SPECIAL CARE, MEMORY CARE, OR ALZHEIMER'S UNIT"
        4 = " 4 NURSING HOME"   ;

     VALUE DLOCSP /* FOR FQ1DLOCSP2 */
       -1 = "-1 INAPPLICABLE"
        1 = " 1 INDEPENDENT LIVING "
        2 = " 2 ASSISTED LIVING "
        3 = " 3 SPECIAL CARE UNIT"
        8 = " 8 NOT REPORTED"   ;

      VALUE CODE60_64B /*FOR CODE60_64B*/
       -1 = "-1 INAPPLICABLE"
        1 = " 1 INDEPENDENT LIVING "
        2 = " 2 ASSISTED LIVING, SCU, NOT REPORTED";

     VALUE DLOCSP2F /* FOR FQ1DLOCSP */
       -1 = "-1 Inapplicable"
        1 = " 1 Independent living"
        2 = " 2 Assisted living"
        3 = " 3 Special care unit"
        4 = " 4 Nursing Home"
        8 = " 8 Not reported";
/* used in creation of op1dhrsmth   */
      value gt0f
       -7,-8 = "-7,-8:DK/RF"
       -1 = "-1:Inapp.  "
       -9 = "-9:Missing "
        1-high = ">0";
      VALUE schedf
        1    = "1:Regular"
        2    = "2:Varied"
       -7,-8 = "-7,-8:DK/RF"
       -1    = "-1:Inapp."
       -9    = "-9:Missing" ;
     VALUE ynf
        1    = "1:Yes"
        2    = "2:No"
       -7,-8 = "-7,-8:DK/RF"
       -1    = "-1:Inapp."
       -9    = "-9:Missing"   ;
     value gt0hours
       -12= "-12:valid skip/staff"
       -11= "-11:hours missing"
       -10= "-10:days missing"
       -9 = "-9:days+hrs missing"
       -1 = "-1:Inapp."
       0 = "0:<1 hour/day"
       1-744=">0"
       9999="Not codeable, <1 hour/day";
value hoursf /*with categories for distribution checking*/
       -12= "-12:valid skip/staff"
       -11= "-11:hours missing"
       -10= "-10:days missing"
       -9 = "-9:days+hrs missing"
       -1 = "-1:Inapp."
        0-<1  ="<1"
        1-<10 =" 1-<10"
       10-<20 ="10-<20"
       20-<30 ="20-<30"
       30-<40 ="30-40"
       40-<60 ="40-60"
       60-<120 ="60-120"
       120-<180="120-180"
       180-744="180-744(24/7)"
       9999="Not codeable, <1 hour/day";
*****;
     VALUE release
        1 = '1 - Main Sample'
        2 = '2 - Reserve Sample'
        9 = '9 - New Release Sample';
    VALUE dchntinhh
        1 = '1 - Child identified in interview but not enumerated to OP File'
       -1 = '-1 - inapplicable';

    VALUE dmissadd
        1 =  ' 1 no flags and added at CL section'
        2 =  ' 2 no flags and added at DT section'
        3 =  ' 3 no flags and added at EW section'
        4 =  ' 4 no flags and added at HA section'
        5 =  ' 5 no flags and added at HO section'
        6 =  ' 6 no flags and added at MC section'
        7 =  ' 7 no flags and added at MO section'
        8 =  ' 8 no flags and added at PA section'
        9 = '9 no flags and added at PE section'
        10 = '10 no flags and added at SC section'
        11 = '11 no flags and added at SN section'
        -1 = '-1 not applicable';


    VALUE dnsoc
        1 = '1 eligible and interviewed'
        2 = '2 eligible and not interviewed'
        -1 = '-1 inapplicable';

/* FORMATS FOR MDS */
    VALUE INDEP
        1 = '1 Independent'
        2 = '2 Supervision or help'
        3 = '3 Total dependence'
        4 = '4 Activity occurred 2 or fewer times'
        -1 = '-1 inapplicable (not nursing home resident)'
        -8 = '-8 DK';

    VALUE CANE
        1 = '1 normally uses cane'
        2 = '2 no indication normally uses cane'
        -8 = '-8 DK'
        -1 = '-1 inapplicable (not nursing home resident)';

    VALUE WALKER
        1 = '1 normally uses walker'
        2 = '2 no indication normally uses walker'
        -8 = '-8 DK'
        -1 = '-1 inapplicable (not nursing home resident)';

    VALUE WHEELCH
    1 = '1 normally uses wheelchair'
    2 = '2 no indication normally uses wheelchair'
    -8  ='-8 DK'
    -1 = '-1 inapplicable (not nursing home resident)';

	VALUE CS1D_F
		1= '1 Yes'
		2= '2 Yes corrected by NHATS'
		3= '3 No'
		4= '4 Yes but missing OP records for child outside household '
		-1= '-1 Inapplicable'
		-7= '-7 RF'
		-8= '-8 DK'
		-9= '-9 Missing';

    VALUE FQ_4F
          1='1 YES'
          2='2 NO';

    VALUE GENDER
        1 = '1 MALE'
        2 = '2 FEMALE';

    VALUE RFDK
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable (nursing home resident or residential care no FQ)'
    -9 = '-9 Missing';

    VALUE RFDK_F
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE RFDK_Y
     1 = ' 1 Yes'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE RFDK_YN
     1 = ' 1 Yes'
     2 = ' 2 No'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE DMGETHLP
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    997 = '997 Help Since Birth/Entire Life';

    VALUE CENDIV /* RE1DCENSDIV */
    1 =  '1 Northeast Region: New England Division'
    2 =  '2 Northeast Region: Middle Atlantic Division'
    3 =  '3 Midwest Region: East North Central Division'
    4 =  '4 Midwest Region: West North Central Division'
    5 =  '5 South Region: South Atlantic Division'
    6 =  '6 South Region: East South Central Division'
    7 =  '7 South Region: West South Central Division'
    8 =  '8 West Region: Mountain Division'
    9 =  '9 West Region: Pacific Division'
    -9 = '-9 Not Ascertained (error Missing)';

    VALUE INAPMISS
        -1 = '-1 Inapplicable'
        -7 = '-7 RF'
        -8 = '-8 DK'
        -9 = '-9 Missing'      ;

    VALUE INAPMI_S
        -1 = '-1 Inapplicable'
        -9 = '-9 Children outside SP Household and OP records missing'     ;

    VALUE HT1DRESC
      1 = ' 1 NURSING HOME'
      2 = ' 2 GROUP HOME/ASSTLVNG/CCRC'
      3 = ' 3 RESIDENTIAL CARE'
      4 = ' 4 NOT RESIDENTIAL CARE'
     -7 = '-7 RF'
     -8 = '-8 DK';

   VALUE R1DRESID
     1 = '1 Community '
     2 = '2 Residential Care Resident not nursing home (SP interview complete)'
     3 = '3 Residential Care Resident not nursing home (FQ only)'
     4 = '4 Nursing Home Resident';

   VALUE R1DRES_R
     1 = ' 1 Case recoded from nursing home resident to other residential care'
    -1 = '-1 Inapplicable';


   VALUE HT1DLVNG
    1 = '1 Alone'
    2 = '2 With spouse/partner only [spouse/partner in household]'
    3 = '3 With spouse/partner and with others'
    4 = '4 With others only'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'  ;

    VALUE DLVNGARR
1 ='1 Alone '
2 ='2 With spouse/partner only [spouse/partner in household]'
3= '3 With spouse/partner and with others'
4= '4 With others only '
-1 = '-1 Inapplicable '
 -9= '-9 Missing ';

    VALUE WORDLIST
     1 = ' 1 YES'
     2 = ' 2 NO'
     3 = ' 3 NO WORDS REMEMBERED'
     4 = ' 4 REFUSED'
    -1 = '-1 Inapplicable (nursing home resident or residential care FQ only)'
    -9 = '-9 Missing'      ;

    VALUE WORDREC
        1 = ' 1 LIST 1'
        2 = ' 2 LIST 2'
        3 = ' 3 LIST 3'
       -1 = '-1 Inapplicable '
       -9 = '-9 Missing';

    VALUE WORDRECO
         1 = ' 1 NO WORDS REMEMBERED'
         2 = ' 2 NO'
        -1 = '-1 Inapplicable '
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE WORDRECP
        1  = '1 REFUSED WORD RECALL TASK'
        2  = '2 NO'
        -1 = '-1 Inapplicable '
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE WORDRECN
         1 = ' 1 YES'
         2 = ' 2 NO'
        -1 = '-1 Inapplicable '
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE WORDRE_N
        -1 = '-1 Inapplicable'
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE WORDRE_P
         1 = ' 1 YES'
         2 = ' 2 NO'
        -1 = '-1 Inapplicable'
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE WORDRECC
        -1 = '-1 Inapplicable '
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

    VALUE CLOCKSC
        -1 = '-1 Inapplicable'
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -4 = '-4 SP did not attempt to draw clock'
        -7 = '-7 SP refused to draw clock'
        -9 = '-9 Missing';

    VALUE MDOUTSLF
     1 = " 1 Did not do by self in last month"
     2 = " 2 Did by self in last month/no difficulty"
     3 = " 3 Did by self in last month/difficulty"
     4 = " 4 DKRF did by self in last month/no difficulty"
     5 = " 5 DKRF did by self in  last month/difficulty"
     6 = " 6 Did by self in last month/DKRF difficulty"
     7 = " 7 DKRF did by self in last month/DKRF difficulty"
     8 = " 8 Not done in last month"
    -1 = "-1 Inapplicable "
    -9 = '-9 Missing';

    VALUE MDOUTDEV
     8 = " 8 Not done in last month"
     1 = " 1 No use of devices to go outside in last month"
     2 = " 2 Use of devices to go outside in last month"
     3 = " 3 DKRF if used devices to go outside in last month"
     4 = " 4 DKRF if used devices in last month"
    -1 = "-1 Inapplicable "
    -9 = '-9 Missing';

    VALUE MDOUTHLP
     8 = " 8 Not done in last month"
     1 = " 1 No help to go outside in last month"
     2 = " 2 Had help to go outside in last month"
     3 = " 3 DKRF if had help to go outside in last month"
    -1 = "-1 Inapplicable "
    -9 = '-9 Missing';

    VALUE MODINSLF
     8 = " 8 Not done in last month"
     1 = " 1 Did not do by self in last month"
     2 = " 2 Did by self in last month/no difficulty"
     3 = " 3 Did by self in last month/difficulty"
     4 = " 4 DKRF did by self in last month/no difficulty"
     5 = " 5 DKRF did by self in  last month/difficulty"
     6 = " 6 Did by self in last month/DKRF difficulty"
     7 = " 7 DKRF did by self in last month/DKRF difficulty"
    -1 = "-1 Inapplicable"
    -9 = '-9 Missing';

    VALUE MODINDEV
     8 = " 8 Not done in last month"
     1 = " 1 No use of devices inside in last month"
     2 = " 2 Use of devices inside in last month"
     3 = " 3 DKRF if used devices inside in last month"
     4 = " 4 DKRF on use of devices "
    -1 = "-1 Inapplicable ";

    VALUE MODINHLP
     8 = " 8 Not done in last month"
     1 = " 1 No help to go around inside in last month"
     2 = " 2 Had help to go around inside in last month"
     3 = " 3 DKRF if had help to go around inside in last month"
    -1 = "-1 Inapplicable";

     VALUE MDBEDSLF
     8 = " 8 Not done in last month"
     1 = " 1 Did not do by self in last month"
     2 = " 2 Did by self in last month/no difficulty"
     3 = " 3 Did by self in last month/difficulty"
     4 = " 4 DKRF did by self in last month/no difficulty"
     5 = " 5 DKRF did by self in  last month/difficulty"
     6 = " 6 Did by self in last month/DKRF difficulty"
     7 = " 7 DKRF did by self in last month/DKRF difficulty"
    -1 = "-1 Inapplicable"
    -9 = '-9 Missing';

    VALUE MDBEDDEV
     1 = " 1 No use of cane or walker to get out of bed in last month"
     2 = " 2 Use of cane or walker to get out of bed in last month"
     3 = " 3 DKRF if used cane or walker to get out of bed in last month "
     4 = " 4 DKRF if used cane or walker in last month"
    -1 = "-1 Inapplicable ";

     VALUE MDBEDHLP
     1 = " 1 No help to get out of bed in last month"
     2 = " 2 Had help to get out of bed in last month"
     3 = " 3 DKRF if had help to get out of bed in last month"
    -1 = "-1 Inapplicable" ;

     VALUE DMDHLPYR
     1 = " 1 No mobility help in last year"
     2 = " 2 Mobility help in last year"
    -7 = " -7 RF"
    -8 = " -8 DK"
    -1 = " -1 Inapplicable ";

     VALUE DMDHLPST
      0 = ' 0 less than 1 month of help'
      1 = ' 1 1 month of help'
      2 = ' 2 2 months of help'
      3 = ' 3 3 months of help'
      4 = ' 4 4 months of help'
      5 = ' 5 5 months of help'
      6 = ' 6 6 months of help'
      7 = ' 7 7 months of help'
      8 = ' 8 8 months of help'
      9 = ' 9 9 months of help'
     10 = '10 10 months of help'
     11 = '11 11 months of help'
     -7 = '-7 help last month but RF number of months of help in year'
     -8 = '-8 help last month but DK number of months of help in year'
    -1 = " -1 Inapplicable ";

     VALUE DMDHLPEN
      0 = ' 0 less than 1 month since help ended'
      1 = ' 1 1 month since help ended'
      2 = ' 2 2 months since help ended'
      3 = ' 3 3 months since help ended'
      4 = ' 4 4 months since help ended'
      5 = ' 5 5 months since help ended'
      6 = ' 6 6 months since help ended'
      7 = ' 7 7 months since help ended'
      8 = ' 8 8 months since help ended'
      9 = ' 9 9 months since help ended'
     10 = '10 10 months since help ended'
     11 = '11 11 months since help ended'
     -7 = '-7 no help last month and RF number of months since help ended'
     -8 = '-8 no help last month and DK number of months since help ended'
     -1 = '-1 Inapplicable ';

    VALUE DMHLPYRS
     0   = '0 none or less than 1 year'
     997 = '997 since birth'
     -7  = '-7 RF'
     -8  = '-8 DK'
     -1  = '-1 Inapplicable '
     -9  = '-9 Missing';

     VALUE DMDDEVYR
      1 = ' 1 No Mobility device use in last year'
      2 = ' 2 Mobility device use in last year'
     -1 = '-1 Inapplicable '
     -7  = '-7 RF'
     -8  = '-8 DK'
     -9 = '-9 Missing';

    VALUE DMDEVST
     0 = ' 0 less than 1 month of mobility device use'
     1 = ' 1 1 month of mobility device use'
     2 = ' 2 2 months of mobility device use'
     3 = ' 3 3 months of mobility device use'
     4 = ' 4 4 months of mobility device use'
     5 = ' 5 5 months of mobility device use'
     6 = ' 6 6 months of mobility device use'
     7 = ' 7 7 months of mobility device use'
     8 = ' 8 8 months of mobility device use'
     9 = ' 9 9 months of mobility device use'
    10 = '10 10 months of mobility device use'
    11 = '11 11 months of mobility device use'
    -7 = '-7 used last month but RF number of months of use in year'
    -8 = '-8 used last month but DK number of months of use in year'
    -1 = '-1 Inapplicable ';

     VALUE DMDEVEND
     1 = ' 1 1 month since mobility device use ended'
     2 = ' 2 2 months since mobility device use ended'
     3 = ' 3 3 months since mobility device use ended'
     4 = ' 4 4 months since mobility device use ended'
     5 = ' 5 5 months since mobility device use ended'
     6 = ' 6 6 months since mobility device use ended'
     7 = ' 7 7 months since mobility device use ended'
     8 = ' 8 8 months since mobility device use ended'
     9 = ' 9 9 months since mobility device use ended'
    10 = '10 10 months since mobility device use ended'
    11 = '11 11 months since mobility device use ended'
    -7 = '-7 no use last month and RF number of months since device use ended'
    -8 = '-8 no use last month and DK number of months since device use ended'
    -1 = '-1 Inapplicable '
  ;

    VALUE DMDEVYRS
     0   = '0  none or less than 1 year'
     997 = '997 since birth'
     -7  = '-7 DK'
     -8  = '-8 RF'
     -1  = '-1 Inapplicable '
     ;

    VALUE HADLSLF
    1 = ' 1  Did not do by self in last month'
    2 = ' 2  Did by self in last month/no difficulty'
    3 = ' 3  Did by self in last month/difficulty'
    4 = ' 4  DKRF did by self in last month/no difficulty'
    5 = ' 5  DKRF did by self in last month/difficulty'
    6 = ' 6  Did by self in last month/DKRF difficulty'
    7 = ' 7  DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable'    ;

       VALUE HADLOTH
    1 = ' 1 Health/functioning reason only'
    2 = ' 2 Other reason only'
    3 = ' 3 Both health/functioning and other reason'
    4 = ' 4 Service/someone from the place SP lives'
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'       ;

    VALUE HADSHSLF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 Did by self in last month/no difficulty'
    3 = ' 3 Did by self in last month/difficulty'
    4 = ' 4 DKRF did by self in last month/no difficulty'
    5 = ' 5 DKRF did by self in  last month/difficulty'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable'  ;

    VALUE HADSHOTH
     1 = ' 1 Health/functioning reason only'
     2 = ' 2 Other reason only'
     3 = ' 3 Both health/functioning and other reason'
     4 = ' 4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable ';

    VALUE HADMLSLF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 Did by self in last month/no difficulty'
    3 = ' 3 Did by self in last month/difficulty'
    4 = ' 4 DKRF did by self in last month/no difficulty'
    5 = ' 5 DKRF did by self in  last month/difficulty'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable' ;

    VALUE HADMLOTH
     1 = ' 1 Health/functioning reason only'
     2 = ' 2 Other reason only'
     3 = ' 3 Both health/functioning and other reason'
     4 = ' 4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'        ;

    VALUE HADBBSLF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 Did by self in last month/no difficulty'
    3 = ' 3 Did by self in last month/difficulty'
    4 = ' 4 DKRF did by self in last month/no difficulty'
    5 = ' 5 DKRF did by self in  last month/difficulty'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
    -1 = 'Inapplicable'     ;

    VALUE HADBBOTH
     1 = ' 1 Health/functioning reason only'
     2 = ' 2 Other reason only'
     3 = ' 3 Both health/functioning and other reason'
     4 = ' 4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'  ;

    VALUE SCEATDEV
    1 = ' 1 No use of adapted utensils in last month'
    2 = ' 2 Use of adapted utensils in last month'
    3 = ' 3 RFDK if used adapted utensils in last month'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCEATHLP
     1 = ' 1 No help eating in last month'
     2 = ' 2 Help eating in last month'
     3 = ' 3 DKRF help eating in last month'
     8 = ' 8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'    ;

    VALUE SCEATDIF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 No difficulty by self (and when using utensils)'
    3 = ' 3 Difficulty by self (and when using utensils)'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCDBADEV
    1 = ' 1 No use of grab bars or bath seats in last month'
    2 = ' 2 Use of grab bars or bath seats in last month'
    3 = ' 3 DKRF if use of grab bars or bath seats in last month'
    4 = ' 4 DKRF if had grab bars or bath seats in last month'
    9 = ' 9 No grab bars or bath seats or washes up (does not shower or bathe) or has no shower or bathtub'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCBTHHLP
    1 = ' 1 No help bathing in last month'
    2 = ' 2 Had help bathing in last month'
    3 = ' 3 DKRF if had help bathing in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCDBADIF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 No difficulty by self (and when using grab bars or tub seat)'
    3 = ' 3 Difficulty by self (and when using grab bars or tub seat)'
    6 = ' 6 Did by self in last month/DKRF difficulty '
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCTLTDEV
    1 = " 1 No use of toileting devices in last month"
    2 = " 2 Use of toileting devices in last month"
    3 = ' 3 DKRF of some and no use of other toileting devices in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE SCTLTHLP
    1 = ' 1 No help toileting in last month'
    2 = ' 2 Had help toileting in last month'
    3 = ' 3 DKRF if had help toileting in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

    VALUE SCDTODIF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 No difficulty by self (and when using toileting devices)'
    3 = ' 3 Difficulty by self (and when using toileting devices)'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

    VALUE DDRDEV
    1 = ' 1 No use of dressing devices in last month'
    2 = ' 2 Use of dressing devices in last month'
    3 = ' 3 DKRF if use of dressing devices in last month'
    8 = ' 8 Not done in last month '
    9 = ' 9 DKRF if dressed in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

    VALUE DDRHLP
    1 = ' 1 No help dressing in last month'
    2 = ' 2 Had help dressing in last month'
    3 = ' 3 DKRF if had help dressing in last month'
    8 = ' 8 Not done in last month '
    9 = ' 9 DKRF if dressed in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

    VALUE DDRDIF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 No difficulty by self (and when using dressing devices)'
    3 = ' 3 Difficulty by self (and when using dressing devices)'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 Not done in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

    VALUE DSDHLPYR
    1 = ' 1 No self care help in last year'
    2 = ' 2 Self care help in last year'
   -1 = '-1 Inapplicable'
   -7 = '-7 DK'
   -8 = '-8 RF'
   -9 = '-9 Missing';

    VALUE DHLPST
     0 = ' 0 - less than 1 month of self care help'
     1 = ' 1 - 1 month of self care help'
     2 = ' 2 - 2 months of self care help'
     3 = ' 3 - 3 months of self care help'
     4 = ' 4 - 4 months of self care help'
     5 = ' 5 - 5 months of self care help'
     6 = ' 6 - 6 months of self care help'
     7 = ' 7 - 7 months of self care help'
     8 = ' 8 - 8 months of self care help'
     9 = ' 9 - 9 months of self care help'
    10 = '10 - 10 months of self care help'
    11 = '11 - 11 months of self care help'
    -7 = '-7 - help in last month but RF number of months of help in last year'
    -8 = '-8 - help in last month but DK number of months of help in last year'
    -1 = '-1 - Inapplicable'
    -9 = '-9 - Missing';

    VALUE DHLPEND
     1 = ' 1 - 1 month since self care help ended'
     2 = ' 2 - 2 months since self care help ended'
     3 = ' 3 - 3 months since self care help ended'
     4 = ' 4 - 4 months since self care help ended'
     5 = ' 5 - 5 months since self care help ended'
     6 = ' 6 - 6 months since self care help ended'
     7 = ' 7 - 7 months since self care help ended'
     8 = ' 8 - 8 months since self care help ended'
     9 = ' 9 - 9 months since self care help ended'
    10 = '10 - 10 months since self care help ended'
    11 = '11 - 11 months since self care help ended'
    -7 = '-7 - no help last month and RF number of months since help ended'
    -8 = '-8 - no help last month and DK number of months since help ended'
    -1 = '-1 - Inapplicable'
    -9 = '-9 - Missing';

    VALUE DSHLPYRS
         0 = ' 0 None or less than 1 year of self care help'
        -7 = '-7 RF'
        -8 = '-8 DK'
        -1 = '-1 Inapplicable'
        -9 = '-9 Missing'      ;

    VALUE DPMSLF
    1 = ' 1 Did not do by self in last month'
    2 = ' 2 Did by self in last month/no difficulty'
    3 = ' 3 Did by self in last month/difficulty'
    4 = ' 4 DKRF did by self in last month/no difficulty'
    5 = ' 5 DKRF did by self in  last month/difficulty'
    6 = ' 6 Did by self in last month/DKRF difficulty'
    7 = ' 7 DKRF did by self in last month/DKRF difficulty'
    8 = ' 8 not done in last month'
    9 = ' 9 no or DKRF if medications taken in last month'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;

    VALUE DFQTYPE
    0 = ' 0 Missing'
    2 = ' 2 Assisted Living or Continuing Care Retirement Community'
    3 = ' 3 Special care, memory care, Alzheimers unit'
    4 = ' 4 Nursing home'
    8 = ' 8 DKRF'
    9 = ' 9 Independent living or other'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'    ;



    VALUE DPMOTH
        1 = ' 1 Health/functioning reason only'
        2 = ' 2 Other reason only'
        3 = ' 3 Both health/functioning and other'
        4 = ' 4 Service/someone from the place SP lives'
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'        ;

    /* PE BOOKLET */
    VALUE PE_STAT
        1 = '1 Booklet with recorded information on at least 1 test SP was eligible for
        (balance stands, walking course, chair stands, grip strength, peak air flow)'
        2 = ' 2 No recorded information'
       -1 = '-1 Inapplicable (nursing home or residential care FQ only)'
       -9 = '-9 Missing';

    VALUE BALSTAND
    0 = ' 0 Not eligible balance stands'
    1 = ' 1 Administer balance stands'
   -9 = '-9 Residential care with no SP interview'
   -1 = '-1 Inapplicable (nursing home resident)'    ;

    VALUE WALKADMN
    0 = ' 0 Not eligible walking'
    1 = ' 1 Administer walking'
   -1 = '-9 Inapplicable (nursing home resident)'
   -9 = '-1 Missing';

    VALUE CHSTAND
    0 = ' 0 Not eligible chair stands'
    1 = ' 1 Administer chair stands'
   -1 = '-9 Inapplicable (nursing home resident)'
   -9 = '-1 Missing';

    VALUE GRSTADMN
    0 = ' 0 Not eligible grip strength'
    1 = ' 1 Administer grip strength on right hand'
    2 = ' 2 Administer grip strength on left hand'
   -1 = '-1 Inapplicable (nursing home resident)'
   -9 = '-9 Missing';

    VALUE DWORK
    1 = ' 1 Works'
    2 = ' 2 Out of labor force including retired'
    3 = ' 3 Other'
   -7 = '-7 Missing';

    VALUE ELAGE2US
      0 = '  0 less than age 1'
    997 = '997 born in US'
     -7 = ' -7 DK'
     -8 = ' -8 RF'
     -1 = ' -1 Inapplicable'
     -9 = ' -9 Missing';

    VALUE DSAMERES
     1 = ' 1 Lives in same City and State as at age 15'
     2 = ' 2 Lives in same state but different City (or DKRF city) as age 15'
     3 = ' 3 Does not live in same State as age 15'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'    ;

    VALUE RACEHISP
        1 = ' 1 White, non-hispanic'
        2 = ' 2 Black, non-hispanic'
        3 = ' 3 Other (Am Indian/Asian/Native Hawaiian/Pacific Islander/other specify), non-Hispanic'
        4 = ' 4 Hispanic'
        5 = ' 5 more than one DKRF primary'
        6 = ' 6 DKRF'
       -9 = '-9 Missing';

    VALUE $DISP
          '10' = "10 Not Available "
          '11' = "11 Ready"
          '12' = "12 Started "
          '20' = "20 Final "
          '24' = "24 Not Required "
          '60' = "60 Complete "
          '61' = "61 Complete, NH facility"
          '63' = "63 Complete SP, FQ not complete"
          '64' = "64 Complete FQ, SP not complete"
          '75' = "75 Physically/mentally unable to participate, no proxy"
          '76' = "76 Too ill to participate, no proxy"
          '77' = "77 Refusal, SP"
          '78' = "78 Language barrier"
          '79' = "79 Unable to locate"
          '80' = "80 Unavailable during field period"
          '82' = "82 Outside of PSU"
          '83' = "83 Ineligible"
          '85' = "85 Refusal, facility"
          '86' = "86 Deceased"
          '87' = "87 Refusal, proxy"
          '88' = "88 Work stopped"    ;

VALUE DISP_a
          10 = "10 Not Available"
          11 = "11 Ready"
          12 = "12 Started"
          20 = "20 Final"
          24 = "24 Not Required"
          60 = "60 Complete"
          61 = "61 Complete, NH facility"
          63 = "63 Complete SP, FQ not complete"
          64 = "64 Complete FQ, SP not complete "
          75 = "75 Physically/mentally unable to participate, no proxy"
          76 = "76 Too ill to participate, no proxy"
          77 = "77 Refusal, SP"
          78 = "78 Language barrier"
          79 = "79 Unable to locate"
          80 = "80 Unavailable during field period"
          82 = "82 Outside of PSU"
          83 = "83 Ineligible"
          85 = "85 Refusal, facility"
          86 = "86 Deceased"
          87 = "87 Refusal, proxy"
          88 = "88 Work stopped"    ;

    VALUE DISP_
          10 = "10 Not Available"
          11 = "11 Ready"
          12 = "12 Started"
          20 = "20 Final"
          24 = "24 Not Required";

    VALUE $STAT_DT
         '4' = " 4 April"
         '5' = " 5 May"
         '6' = " 6 June"
         '7' = " 7 July"
         '8' = " 8 August"
         '9' = " 9 September"
         '10' = "10 October"
         '11' = "11 November"
         '99' = "99 Prior to start of field work"
         '-1' = '-1 - Inapplicable';

    VALUE STAT_DTa
          4 = " 4 April"
          5 = " 5 May"
          6 = " 6 June"
          7 = " 7 July"
          8 = " 8 August"
          9 = " 9 September"
         10 = "10 October"
         11 = "11 November"
         99 = "99 Prior to start of field work"
         -1 = '-1 - Inapplicable';

    VALUE DOPAGECT
     -7 = '-7 - DK'
     -8 = '-8 - RF'
     -1 = '-1 - Inapplicable'
     -9 = '-9 - Missing'
      1 = " 1 - UNDER 20"
      2 = " 2 - 20-24"
      3 = " 3 - 25-29"
      4 = " 4 - 30-34"
      5 = " 5 - 35-39"
      6 = " 6 - 40-44"
      7 = " 7 - 45-49"
      8 = " 8 - 50-54"
      9 = " 9 - 55-59"
     10 = "10 - 60-64"
     11 = "11 - 65-69"
     12 = "12 - 70-74"
     13 = "13 - 75-79"
     14 = "14 - 80-84"
     15 = "15 - 85-89"
     16 = "16 - 90 +";

    VALUE DOPAGE2C
      -7 = '-7 - DK'
      -8 = '-8 - RF'
      -1 = '-1 - Inapplicable'
      -9 = '-9 - Missing'
       1 = " 1 - UNDER 20"
       2 = " 2 - 20-24"
       3 = " 3 - 25-29"
       4 = " 4 - 30-34"
       5 = " 5 - 35-39"
       6 = " 6 - 40-44"
       7 = " 7 - 45-49"
       8 = " 8 - 50-54"
       9 = " 9 - 55-59"
      10 = "10 - 60-65"
      11 = "11 - 66-69"
      12 = "12 - 70-74"
      13 = "13 - 75-79"
      14 = "14 - 80-84"
      15 = "15 - 85-89"
      16 = "16 - 90 +"    ;

    VALUE DOPAGE3C
        1  = '1- UNDER 30'
        2  = '2- 30-39'
        3  = '3- 40-49'
        4  = '4- 50-59'
        5  = '5- 60-69'
        6  = '6- 70-79'
        7  = '7- 80-89'
        8  = '8- 90 +'
       -7 = '-7 - DK'
       -8 = '-8 - RF'
       -1 = '-1 - Inapplicable'
       -9 = '-9 - Missing';


    VALUE DSPSAGEC
     -7 = '-7 - RF'
     -8 = '-8 - DK'
     -1 = '-1 - Inapplicable'
     -9 = '-9 - Missing'
      1 = " 1 - UNDER 50"
      2 = " 2 - 50-54"
      3 = " 3 - 55-59"
      4 = " 4 - 60-64"
      5 = " 5 - 65-69"
      6 = " 6 - 70-74"
      7 = " 7 - 75-79"
      8 = " 8 - 80-84"
      9 = " 9 - 85-89"
     10 = "10 - 90 +"    ;

    VALUE DINTAGEC
      1 = "1 - 65-69"
      2 = "2 - 70-74"
      3 = "3 - 75-79"
      4 = "4 - 80-84"
      5 = "5 - 85-89"
      6 = "6 - 90 +"   ;

    VALUE DCLCKSC
      0 = '0 Not recognizable as a clock'
      1 = '1 Severely distorted depiction of a clock'
      2 = '2 Moderately distorted depection of a clock'
      3 = '3 Mildly distorted depiction of a clock'
      4 = '4 Reasonably accurate depiction of a clock'
      5 = '5 Accurate depiction of a clock (circular or square)'
    -7 = '-7 SP refused to draw clock'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -2 = '-2 Proxy says cannot ask SP'
    -3 = '-3 Proxy says can ask SP but SP unable to answer'
    -4 = '-4 SP did not attempt to draw clock'
    -9 = '-9 Missing';

    VALUE DCLCKCL
      1 = '1 Very clear'
      2 = '2 Somewhat clear'
      3 = '3 Somewhat unclear'
      4 = '4 Very unclear'
      5 = '5 Blank'
    -7 = '-7 SP refused to draw clock'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -2 = '-2 Proxy says cannot ask SP'
    -3 = '-3 Proxy says can ask SP but SP unable to answer'
    -4 = '-4 SP did not attempt to draw clock'
    -9 = '-9 Missing';

    VALUE W000001W
      12 = "12 STARTED"
      20 = "20 COMPLETE"
      21 = "21 INELIGIBLE - NOT 65+"    ;

    VALUE W000002W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
     1 = " 1 MALE"
     2 = " 2 FEMALE"    ;

    VALUE W000003W
      1 = "1 Black"
      2 = "2 Hispanic"
      3 = "3 White"    ;

    VALUE W000004W
      12 = "12 Started"
      20 = "20 Complete"    ;

    VALUE W000005W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
     1 = " 1 YES"
     2 = " 2 NO"    ;

    VALUE W000006W
      1 = "1 Person"
      2 = "2 Agency"    ;

    VALUE W000007W
      1 = "1 Yes"
      2 = "2 Do not change this person's details"
      3 = "3 Mark person for removal"    ;

    VALUE W000008W
       1 = " 1 - UNDER 20"
       2 = " 2 - 20-24"
       3 = " 3 - 25-29"
       4 = " 4 - 30-34"
       5 = " 5 - 35-39"
       6 = " 6 - 40-44"
       7 = " 7 - 45-49"
       8 = " 8 - 50-54"
       9 = " 9 - 55-59"
      10 = "10 - 60-65"
      11 = "11 - 66-69"
      12 = "12 - 70-74"
      13 = "13 - 75-79"
      14 = "14 - 80-85"
      15 = "15 - 86-89"
      16 = "16 - 90-94"
      17 = "17 - 95-99"
      18 = "18 - 100 +"    ;

    VALUE W000009W
       1 = " 1 SAMPLE PERSON"
       2 = " 2 SPOUSE/ PARTNER"
       3 = " 3 DAUGHTER"
       4 = " 4 SON"
       5 = " 5 DAUGHTER-IN-LAW"
       6 = " 6 SON-IN-LAW"
       7 = " 7 STEPDAUGHTER"
       8 = " 8 STEPSON"
       9 = " 9 SISTER"
      10 = "10 BROTHER"
      11 = "11 SISTER-IN-LAW"
      12 = "12 BROTHER-IN-LAW"
      13 = "13 MOTHER"
      14 = "14 STEPMOTHER"
      15 = "15 MOTHER-IN-LAW"
      16 = "16 FATHER"
      17 = "17 STEPFATHER"
      18 = "18 FATHER-IN-LAW"
      19 = "19 GRANDDAUGHTER"
      20 = "20 GRANDSON"
      21 = "21 NIECE"
      22 = "22 NEPHEW"
      23 = "23 AUNT"
      24 = "24 UNCLE"
      25 = "25 COUSIN"
      26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
      27 = "27 STEPSON'S SON/ DAUGHTER"
      28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
      29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
      30 = "30 BOARDER/RENTER"
      31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
      32 = "32 ROOMMATE"
      33 = "33 EX-WIFE/ EX-HUSBAND"
      34 = "34 BOYFRIEND/ GIRLFRIEND"
      35 = "35 NEIGHBOR"
      36 = "36 FRIEND"
      37 = "37 STAFF PERSON AT THE PLACE SP LIVES"
      38 = "38 CO-WORKER"
      39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
      40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
      91 = "91 OTHER RELATIVE"
      92 = "92 OTHER NONRELATIVE"    ;

    VALUE W000010W
      1 = " 1 MARRIED"
      2 = " 2 LIVING WITH A PARTNER"
      3 = " 3 SEPARATED"
      4 = " 4 DIVORCED"
      5 = " 5 WIDOWED"
      6 = " 6 NEVER MARRIED"
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 INAPPLICABLE'
     -9 = '-9 MISSING';

    VALUE W000011W
      1 = " 1 HOME"
      2 = " 2 CELL PHONE"
      3 = " 3 WORK/OFFICE"
      4 = " 4 NEIGHBOR'S"
      5 = " 5 FRIEND'S"
      6 = " 6 RELATIVE'S"
     91 = "91 OTHER (SPECIFY)"   ;

    VALUE W000012W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NO SCHOOLING COMPLETED"
      2 = " 2 1ST-8TH GRADE"
      3 = " 3 9TH-12TH GRADE (NO DIPLOMA)"
      4 = " 4 HIGH SCHOOL GRADUATE (HIGH SCHOOL DIPLOMA OR EQUIVALENT)"
      5 = " 5 VOCATIONAL, TECHNICAL, BUSINESS, OR TRADE SCHOOL CERTIFICATE OR DIPLOMA (BEYOND HIGH SCHOOL LEVEL)"
      6 = " 6 SOME COLLEGE BUT NO DEGREE"
      7 = " 7 ASSOCIATE'S DEGREE"
      8 = " 8 BACHELOR'S DEGREE"
      9 = " 9 MASTER'S, PROFESSIONAL, OR DOCTORAL DEGREE";

    VALUE W000013W
      1 = " 1 REGULAR"
      2 = " 2 VARIED"
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 INAPPLICABLE'
     -9 = '-9 MISSING'    ;

    VALUE W000014W
      1 = " 1 SP AND/OR FAMILY"
      2 = " 2 GOVERNMENT PROGRAM"
      3 = " 3 INSURANCE"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000015W
      1 = " 1 HOURLY"
      2 = " 2 WEEKLY"
      3 = " 3 MONTHLY"
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 INAPPLICABLE'
     -9 = '-9 MISSING'    ;

    VALUE W000016W
      1 = " 1 MEDICAID"
      2 = " 2 MEDICARE"
      3 = " 3 STATE PROGRAM"
     91 = "91 OTHER (SPECIFY)"
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 INAPPLICABLE'
     -9 = '-9 MISSING'    ;

    VALUE W000017W
      1 = "1 Yes"
      2 = "2 No"
      3 = "3 Refused"    ;

    VALUE W000018W
       5 = " 5 DAUGHTER-IN-LAW"
       6 = " 6 SON-IN-LAW"
       9 = " 9 SISTER"
      10 = "10 BROTHER"
      11 = "11 SISTER-IN-LAW"
      12 = "12 BROTHER-IN-LAW"
      13 = "13 MOTHER"
      14 = "14 STEPMOTHER"
      15 = "15 MOTHER-IN-LAW"
      16 = "16 FATHER"
      17 = "17 STEPFATHER"
      18 = "18 FATHER-IN-LAW"
      19 = "19 GRANDDAUGHTER"
      20 = "20 GRANDSON"
      21 = "21 NIECE"
      22 = "22 NEPHEW"
      23 = "23 AUNT"
      24 = "24 UNCLE"
      25 = "25 COUSIN"
      26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
      27 = "27 STEPSON'S SON/ DAUGHTER"
      28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
      29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
      30 = "30 BOARDER/ RENTER"
      31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
      32 = "32 ROOMMATE"
      33 = "33 EX-WIFE/ EX-HUSBAND"
      34 = "34 BOYFRIEND/ GIRLFRIEND"
      35 = "35 NEIGHBOR"
      36 = "36 FRIEND"
      91 = "91 OTHER RELATIVE"
      92 = "92 OTHER NONRELATIVE"    ;

    VALUE W000019W
       5 = " 5 DAUGHTER-IN-LAW"
       6 = " 6 SON-IN-LAW"
       9 = " 9 SISTER"
      10 = "10 BROTHER"
      11 = "11 SISTER-IN-LAW"
      12 = "12 BROTHER-IN-LAW"
      13 = "13 MOTHER"
      14 = "14 STEPMOTHER"
      15 = "15 MOTHER-IN-LAW"
      16 = "16 FATHER"
      17 = "17 STEPFATHER"
      18 = "18 FATHER-IN-LAW"
      19 = "19 GRANDDAUGHTER"
      20 = "20 GRANDSON"
      21 = "21 NIECE"
      22 = "22 NEPHEW"
      23 = "23 AUNT"
      24 = "24 UNCLE"
      25 = "25 COUSIN"
      26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
      27 = "27 STEPSON'S SON/ DAUGHTER"
      28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
      29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
      30 = "30 BOARDER/ RENTER"
      31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
      32 = "32 ROOMMATE"
      33 = "33 EX-WIFE/ EX-HUSBAND"
      34 = "34 BOYFRIEND/ GIRLFRIEND"
      35 = "35 NEIGHBOR"
      36 = "36 FRIEND"
      37 = "37 STAFF PERSON AT THE PLACE SP LIVES"
      38 = "38 CO-WORKER"
      39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
      40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
      91 = "91 OTHER RELATIVE"
      92 = "92 OTHER NONRELATIVE"    ;

    VALUE W000020W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
      1 = "1 HOME"
      2 = "2 MULTI-UNIT"
      3 = "3 OTHER"    ;

    VALUE W000021W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
     1 = " 1 BUILDING HAS ONE FLOOR"
     2 = " 2 BUILDING HAS MULTIPLE FLOORS"    ;

    VALUE W000022W
      1 = "1  REQUIRED"
     24 = "24 NOT REQUIRED"    ;

    VALUE W000023W
      1 = "1 NURSING HOME"
      2 = "2 OTHER FACILITY"    ;

    VALUE W000024W
      1 = " 1 HOME"
      2 = " 2 APARTMENT"
      3 = " 3 ROOM"
      4 = " 4 UNIT"
      5 = " 5 SUITE"
      6 = " 6 SOMETHING ELSE (SPECIFY)"    ;

    VALUE W000025W
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
      1 = "1 SAMPLE PERSON (SP)"
      2 = "2 PROXY"    ;

    VALUE W000026W
      1 = " 1 DEMENTIA OR COGNITIVE IMPAIRMENT REPORTED BY PROXY"
      2 = " 2 SP TOO ILL"
      3 = " 3 SP SPEECH IMPAIRED"
      4 = " 4 SP HEARING IMPAIRED"
      5 = " 5 LANGUAGE BARRIER"
      6 = " 6 TEMPORARILY UNAVAILABLE"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000027W
      1 = "1 CONSENT TO RECORDING"
      7 = "7 REFUSE CONSENT TO RECORD"    ;

    VALUE W000028W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
       1 = " 1 SELF"
       2 = " 2 SPOUSE/ PARTNER"
       3 = " 3 DAUGHTER"
       4 = " 4 SON"
       5 = " 5 DAUGHTER-IN-LAW"
       6 = " 6 SON-IN-LAW"
       7 = " 7 STEPDAUGHTER"
       8 = " 8 STEPSON"
       9 = " 9 SISTER"
      10 = "10 BROTHER"
      11 = "11 SISTER-IN-LAW"
      12 = "12 BROTHER-IN-LAW"
      13 = "13 MOTHER"
      14 = "14 STEPMOTHER"
      15 = "15 MOTHER-IN-LAW"
      16 = "16 FATHER"
      17 = "17 STEPFATHER"
      18 = "18 FATHER-IN-LAW"
      19 = "19 GRANDDAUGHTER"
      20 = "20 GRANDSON"
      21 = "21 NIECE"
      22 = "22 NEPHEW"
      23 = "23 AUNT"
      24 = "24 UNCLE"
      25 = "25 COUSIN"
      26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
      27 = "27 STEPSON'S SON/ DAUGHTER"
      28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
      29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
      30 = "30 BOARDER/RENTER"
      31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
      32 = "32 ROOMMATE"
      33 = "33 EX-WIFE/ EX-HUSBAND"
      34 = "34 BOYFRIEND/ GIRLFRIEND"
      35 = "35 NEIGHBOR"
      36 = "36 FRIEND"
      37 = "37 STAFF PERSON FROM THE PLACE SP LIVES"
      38 = "38 CO-WORKER"
      39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
      40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
      91 = "91 OTHER RELATIVE"
      92 = "92 OTHER NONRELATIVE"    ;

    VALUE W000029W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 VERY FAMILIAR"
      2 = " 2 SOMEWHAT FAMILIAR"
      3 = " 3 A LITTLE FAMILIAR"
      4 = " 4 NOT AT ALL FAMILIAR"    ;

    VALUE W000030W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 FREE-STANDING (DETACHED) SINGLE HOUSE"
      2 = " 2 SINGLE HOUSE BUT ATTACHED TO OTHERS (ROW HOUSE, TOWNHOUSE, DUPLEX, TRIPLEX, OR TRIPLE DECKER)"
      3 = " 3 MOBILE HOME OR TRAILER"
      4 = " 4 MULTI-UNIT (2+) BUILDING"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000031W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EXCELLENT"
      2 = " 2 VERY GOOD"
      3 = " 3 GOOD"
      4 = " 4 FAIR"
      5 = " 5 POOR"    ;

    VALUE W000032W
      1 = " 1 SKIN CANCER"
      2 = " 2 BREAST CANCER"
      3 = " 3 PROSTATE CANCER"
      4 = " 4 BLADDER CANCER"
      5 = " 5 CERVICAL/OVARIAN/UTERINE CANCER"
      6 = " 6 COLON CANCER"
      7 = " 7 KIDNEY CANCER"
     91 = "91 OTHER TYPE OF CANCER"    ;

    VALUE W000033W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NOT AT ALL"
      2 = " 2 SEVERAL DAYS"
      3 = " 3 MORE THAN HALF THE DAYS"
      4 = " 4 NEARLY EVERY DAY"    ;

    VALUE W000034W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY NIGHT"
      2 = " 2 MOST NIGHTS"
      3 = " 3 SOME NIGHTS"
      4 = " 4 RARELY"
      5 = " 5 NEVER"    ;

    VALUE W000035W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY NIGHT"
      2 = " 2 MOST NIGHTS "
      3 = " 3 SOME NIGHTS"
      4 = " 4 RARELY"
      5 = " 5 NEVER"
      7 = " 7 DON'T WAKE UP/NOT A PROBLEM"    ;

    VALUE W000036W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MONTHS"
      2 = " 2 YEARS"    ;

    VALUE W000037W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 PRIVATE RESIDENCE"
      2 = " 2 A GROUP HOME, BOARD AND CARE, OR SUPERVISED HOUSING"
      3 = " 3 ASSISTED LIVING FACILITY OR CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
      4 = " 4 RELIGIOUS GROUP QUARTERS"
     91 = "91 OTHER (SPECIFY)"
    ;

    VALUE W000038W

     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 PLACE DOES NOT HAVE A NAME"    ;

    VALUE W000039W

     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 APARTMENT"
      2 = " 2 ROOM"
      3 = " 3 UNIT"
      4 = " 4 SUITE"
     91 = "91 SOMETHING ELSE (SPECIFY)"    ;

    VALUE W000040W

     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 PRIVATE RESIDENCE"
      2 = " 2 A GROUP HOME, BOARD AND CARE, OR SUPERVISED HOUSING"
      3 = " 3 ASSISTED LIVING FACILITY OR CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
      5 = " 5 NURSING HOME"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000041W
       3 = " 3 DAUGHTER"
       4 = " 4 SON"
       5 = " 5 DAUGHTER-IN-LAW"
       6 = " 6 SON-IN-LAW"
       7 = " 7 STEPDAUGHTER"
       8 = " 8 STEPSON"
       9 = " 9 SISTER"
      10 = "10 BROTHER"
      11 = "11 SISTER-IN-LAW"
      12 = "12 BROTHER-IN-LAW"
      13 = "13 MOTHER"
      14 = "14 STEPMOTHER"
      15 = "15 MOTHER-IN-LAW"
      16 = "16 FATHER"
      17 = "17 STEPFATHER"
      18 = "18 FATHER-IN-LAW"
      19 = "19 GRANDDAUGHTER"
      20 = "20 GRANDSON"
      21 = "21 NIECE"
      22 = "22 NEPHEW"
      23 = "23 AUNT"
      24 = "24 UNCLE"
      25 = "25 COUSIN"
      26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
      27 = "27 STEPSON'S SON/ DAUGHTER"
      28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
      29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
      30 = "30 BOARDER/ RENTER"
      31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
      32 = "32 ROOMMATE"
      33 = "33 EX-WIFE/ EX-HUSBAND"
      34 = "34 BOYFRIEND/ GIRLFRIEND"
      36 = "36 FRIEND"
      91 = "91 OTHER RELATIVE"
      92 = "92 OTHER NONRELATIVE"    ;

    VALUE W000042W
      3 = "3 DAUGHTER"
      4 = "4 SON"
      7 = "7 STEPDAUGHTER"
      8 = "8 STEPSON"    ;

    VALUE W000043W
       1 = " 1 SocialNetwork: Person 1"
       2 = " 2 SocialNetwork: Person 2"
       3 = " 3 SocialNetwork: Person 3"
       4 = " 4 SocialNetwork: Person 4"
       5 = " 5 SocialNetwork: Person 5"
       6 = " 6 SocialNetwork: Person 6"
       7 = " 7 SocialNetwork: Person 7"
       8 = " 8 SocialNetwork: Person 8"
       9 = " 9 SocialNetwork: Person 9"
      10 = "10 SocialNetwork: Person 10"
      11 = "11 SocialNetwork: Person 11"
      12 = "12 SocialNetwork: Person 12"
      13 = "13 SocialNetwork: Person 13"
      14 = "14 SocialNetwork: Person 14"
      15 = "15 SocialNetwork: Person 15"
      16 = "16 SocialNetwork: Person 16"
      17 = "17 SocialNetwork: Person 17"
      18 = "18 SocialNetwork: Person 18"
      19 = "19 SocialNetwork: Person 19"
      20 = "20 SocialNetwork: Person 20"
      21 = "21 SocialNetwork: Person 21"
      22 = "22 SocialNetwork: Person 22"    ;

    VALUE W000044W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
     1 = " 1 COMMON OR SHARED ENTRANCE"
     2 = " 2 ENTRANCE DIRECTLY INTO HOME"    ;

    VALUE W000045W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 - 1"
      2 = " 2 - 2"
      3 = " 3 - 3"
      4 = " 4 - 4+"    ;

    VALUE W000046W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ALL ITEMS HERE"
      2 = " 2 ADDED ONE OR MORE ITEMS"    ;

    VALUE W000047W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MORE THAN $500"
      2 = " 2 LESS THAN $500"
      3 = " 3 JUST ABOUT $500"    ;

    VALUE W000048W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MORE THAN $1,000"
      2 = " 2 LESS THAN $1,000"
      3 = " 3 JUST ABOUT $1,000"    ;

    VALUE W000049W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MORE THAN $100"
      2 = " 2 LESS THAN $100"
      3 = " 3 JUST ABOUT $100"    ;

    VALUE W000050W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 YES, DOESNT KNOW HOW TO USE A COMPUTER"    ;

    VALUE W000051W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MOST DAYS"
      2 = " 2 SOME DAYS"
      3 = " 3 RARELY"    ;

    VALUE W000052W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EXCELLENT"
      2 = " 2 VERY GOOD"
      3 = " 3 GOOD"
      4 = " 4 FAIR"
      5 = " 5 POOR"    ;

    VALUE W000053W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 DEAF"    ;

    VALUE W000054W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 BLIND"    ;

    VALUE W000055W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY DAY (7 DAYS A WEEK)"
      2 = " 2 MOST DAYS (5-6 DAYS A WEEK)"
      3 = " 3 SOME DAYS (2-4 DAYS A WEEK)"
      4 = " 4 RARELY (ONCE A WEEK OR LESS)"
      5 = " 5 NEVER"    ;

    VALUE W000056W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 BACK"
      2 = " 2 HIPS"
      3 = " 3 KNEES"
      4 = " 4 FEET"
      5 = " 5 HANDS"
      6 = " 6 WRISTS"
      7 = " 7 SHOULDERS"
      8 = " 8 HEAD"
      9 = " 9 NECK"
     10 = "10 ARMS"
     11 = "11 LEGS"
     12 = "12 STOMACH"
     91 = "91 OTHER PLACES (SPECIFY)"    ;

    VALUE W000057W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, A CHANGE"
      2 = " 2 NO, NO CHANGE"
      3 = " 3 DEMENTIA/ALZHEIMER'S REPORTED BY PROXY"    ;

    VALUE W000058W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 SP HAS DEMENTIA/ALZHEIMER'S/ NOT ABLE"
      2 = " 2 SP IS UNABLE TO SPEAK"
      3 = " 3 SP IS UNABLE TO HEAR"
      4 = " 4 SP REFUSED"
      5 = " 5 PROXY REFUSED"
      6 = " 6 SP NOT PRESENT"
      7 = " 7 SP TOO ILL"
      8 = " 8 SP LANGUAGE BARRIER"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000059W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MUCH BETTER"
      2 = " 2 BETTER"
      3 = " 3 SAME"
      4 = " 4 WORSE"
      5 = " 5 MUCH WORSE"    ;

    VALUE W000060W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO/DON'T KNOW"    ;

    VALUE W000061W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 CONTINUE WITH ACTIVITY"
      2 = " 2 SP REFUSES ACTIVITY"    ;

    VALUE W000062W
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Word[1]"
      2 = " 2 Word[2]"
      3 = " 3 Word[3]"
      4 = " 4 Word[4]"
      5 = " 5 Word[5]"
      6 = " 6 Word[6]"
      7 = " 7 Word[7]"
      8 = " 8 Word[8]"
      9 = " 9 Word[9]"
     10 = "10 Word[10]"
     91 = "91 NO WORDS REMEMBERED"
     92 = "92 REFUSED"    ;

    VALUE W000063W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 DIFFICULTY HEARING ANY OF THE WORDS"
      2 = " 2 INTERRUPTION OCCURRED WHILE LIST WAS BEING READ"
     91 = "91 OTHER PROBLEM (SPECIFY)"
     92 = "92 NO PROBLEMS OCCURRED"    ;

    VALUE W000064W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 SP ATTEMPTED CLOCK DRAWING"
      2 = " 2 SP DID NOT ATTEMPT CLOCK DRAWING"
     97 = "97 SP REFUSED CLOCK DRAWING"    ;

    VALUE W000065W
      1 = "1 LAST NAME CORRECT"
      2 = "2 LAST NAME NOT CORRECT/DK LAST NAME"
      3 = "3 FIRST NAME CORRECT"
      4 = "4 FIRST NAME NOT CORRECT/DK FIRST NAME"    ;

    VALUE W000066W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY DAY (7 DAYS A WEEK)"
      2 = " 2 MOST DAYS (5-6 DAYS A WEEK)"
      3 = " 3 SOME DAYS (2-4 DAYS A WEEK)"
      4 = " 4 RARELY (ONCE A WEEK OR LESS)"
      5 = " 5 NEVER"    ;

    VALUE W000067W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY TIME"
      2 = " 2 MOST TIMES"
      3 = " 3 SOMETIMES"
      4 = " 4 RARELY"
      5 = " 5 NEVER"    ;

    VALUE W000068W
       1 = " 1 HelperMember: Person 1"
       2 = " 2 HelperMember: Person 2"
       3 = " 3 HelperMember: Person 3"
       4 = " 4 HelperMember: Person 4"
       5 = " 5 HelperMember: Person 5"
       6 = " 6 HelperMember: Person 6"
       7 = " 7 HelperMember: Person 7"
       8 = " 8 HelperMember: Person 8"
       9 = " 9 HelperMember: Person 9"
      10 = "10 HelperMember: Person 10"
      11 = "11 HelperMember: Person 11"
      12 = "12 HelperMember: Person 12"
      13 = "13 HelperMember: Person 13"
      14 = "14 HelperMember: Person 14"
      15 = "15 HelperMember: Person 15"
      16 = "16 HelperMember: Person 16"
      17 = "17 HelperMember: Person 17"
      18 = "18 HelperMember: Person 18"
      19 = "19 HelperMember: Person 19"
      20 = "20 HelperMember: Person 20"
      21 = "21 HelperMember: Person 21"
      22 = "22 HelperMember: Person 22"
      23 = "23 HelperMember: Person 23"
      24 = "24 HelperMember: Person 24"
      25 = "25 HelperMember: Person 25"    ;

    VALUE W000069W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MOST TIMES"
      2 = " 2 SOMETIMES"
      3 = " 3 RARELY"
      4 = " 4 NEVER"    ;

    VALUE W000070W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NONE"
      2 = " 2 A LITTLE"
      3 = " 3 SOME"
      4 = " 4 A LOT"    ;

    VALUE W000071W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MORE OFTEN"
      2 = " 2 LESS OFTEN"
      3 = " 3 ABOUT THE SAME"    ;

    VALUE W000072W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, A YEAR OR MORE"
      2 = " 2 NO, LESS THAN A YEAR"    ;

    VALUE W000073W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 JANUARY"
      2 = " 2 FEBRUARY"
      3 = " 3 MARCH"
      4 = " 4 APRIL"
      5 = " 5 MAY"
      6 = " 6 JUNE"
      7 = " 7 JULY"
      8 = " 8 AUGUST"
      9 = " 9 SEPTEMBER"
     10 = "10 OCTOBER"
     11 = "11 NOVEMBER"
     12 = "12 DECEMBER"    ;

    VALUE W000074W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MONTH AND YEAR"
      2 = " 2 NUMBER OF MONTHS AGO"
      3 = " 3 NUMBER OF YEARS AGO"
      4 = " 4 AGE WHEN LAST DROVE"
      7 = " 7 NEVER DROVE"    ;

    VALUE W000075W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 {NO, NO RAIN OR BAD WEATHER}"    ;

    VALUE W000076W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ALWAYS DID IT BY SELF"
      2 = " 2 ALWAYS DID IT TOGETHER WITH SOMEONE ELSE"
      3 = " 3 SOMEONE ELSE ALWAYS DID IT"
      4 = " 4 IT VARIED (MORE THAN ONE WAY)"
      5 = " 5 NOT DONE IN LAST MONTH"    ;

    VALUE W000077W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MACHINE IN HOME"
      2 = " 2 MACHINE ELSEWHERE IN BUILDING"
      3 = " 3 LAUNDROMAT"
      4 = " 4 SINK IN HOME"
      5 = " 5 SINK ELSEWHERE IN BUILDING"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000078W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 HEALTH OR FUNCTIONING (INCLUDES AGE, MEMORY, VISION, HEALTH CONDITION/DISEASE NAMES, SURGERY, UNABLE TO DRIVE)"
      2 = " 2 OTHER REASON (INCLUDES SHARED ACTIVITY, ALWAYS DONE THIS WAY, SOMEONE ELSE WANTED TO DO IT, PAY SOMEONE, DOESNT LIKE TO D"
    ;

    VALUE W000079W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MORE OFTEN"
      2 = " 2 LESS OFTEN"
      3 = " 3 SAME"    ;

    VALUE W000080W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 CASH"
      2 = " 2 CHECK"
      3 = " 3 DEBIT OR GIFT CARD"
      4 = " 4 CREDIT CARD"
      5 = " 5 FOOD STAMPS"
      6 = " 6 SOMEONE ELSE PAYS"
     91 = "91 OTHER"    ;

    VALUE W000081W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 {DROVE}"
      2 = " 2 GOT A RIDE FROM A FAMILY MEMBER OR FRIEND OR SOMEONE PAID TO HELP"
      3 = " 3 {USED A VAN OR SHUTTLE SERVICE PROVIDED BY THE PLACE SP LIVES}"
      4 = " 4 USED A VAN OR SHUTTLE SERVICE FOR PEOPLE WITH DISABILITIES OR SENIORS {NOT PROVIDED BY THE PLACE SP LIVES}"
      5 = " 5 TOOK PUBLIC TRANSPORTATION (THE BUS, SUBWAY, TRAIN, OR TRAM)"
      6 = " 6 TOOK A TAXI"
      7 = " 7 WALKED"
      8 = " 8 HOME VISIT"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000082W
       1 = " 1 HelperMeals: Person 1"
       2 = " 2 HelperMeals: Person 2"
       3 = " 3 HelperMeals: Person 3"
       4 = " 4 HelperMeals: Person 4"
       5 = " 5 HelperMeals: Person 5"
       6 = " 6 HelperMeals: Person 6"
       7 = " 7 HelperMeals: Person 7"
       8 = " 8 HelperMeals: Person 8"
       9 = " 9 HelperMeals: Person 9"
      10 = "10 HelperMeals: Person 10"
      11 = "11 HelperMeals: Person 11"
      12 = "12 HelperMeals: Person 12"
      13 = "13 HelperMeals: Person 13"
      14 = "14 HelperMeals: Person 14"
      15 = "15 HelperMeals: Person 15"
      16 = "16 HelperMeals: Person 16"
      17 = "17 HelperMeals: Person 17"
      18 = "18 HelperMeals: Person 18"
      19 = "19 HelperMeals: Person 19"
      20 = "20 HelperMeals: Person 20"
      21 = "21 HelperMeals: Person 21"
      22 = "22 HelperMeals: Person 22"
      23 = "23 HelperMeals: Person 23"
      24 = "24 HelperMeals: Person 24"
      25 = "25 HelperMeals: Person 25"    ;

    VALUE W000083W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 ALWAYS FED THROUGH IV OR TUBE"    ;

    VALUE W000084W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY TIME"
      2 = " 2 MOST TIMES"
      3 = " 3 SOMETIMES"
      4 = " 4 RARELY"    ;

    VALUE W000085W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 SHOWERED"
      2 = " 2 TOOK BATHS IN A TUB"
      3 = " 3 WASHED UP SOME OTHER WAY"    ;

    VALUE W000086W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 {SHOWERING}"
      2 = " 2 {TAKING BATHS}"
      3 = " 3 {WASHING UP SOME OTHER WAY}"    ;

    VALUE W000087W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 LOCAL STORE OR PHARMACY"
      2 = " 2 BY MAIL"
      3 = " 3 HEALTHCARE PROVIDER/HOSPITAL"
     91 = "91 SOMEWHERE ELSE (SPECIFY)"    ;

    VALUE W000088W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 PICKED THEM UP BY SELF"
      2 = " 2 HAD THEM DELIVERED"
      3 = " 3 HAD SOMEONE ELSE PICK THEM UP"    ;

    VALUE W000089W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ^fdrove"
      2 = " 2 GOT A RIDE FROM A FAMILY MEMBER OR FRIEND OR SOMEONE PAID TO HELP"
      3 = " 3 ^fservice"
      4 = " 4 ^fnotprov"
      5 = " 5 TOOK PUBLIC TRANSPORTATION (THE BUS, SUBWAY, TRAIN, OR TRAM)"
      6 = " 6 TOOK A TAXI"
     91 = "91 OTHER (SPECIFY)"    ;

    VALUE W000090W
       1 = " 1 HelperSatInwDoctor: Person 1"
       2 = " 2 HelperSatInwDoctor: Person 2"
       3 = " 3 HelperSatInwDoctor: Person 3"
       4 = " 4 HelperSatInwDoctor: Person 4"
       5 = " 5 HelperSatInwDoctor: Person 5"
       6 = " 6 HelperSatInwDoctor: Person 6"
       7 = " 7 HelperSatInwDoctor: Person 7"
       8 = " 8 HelperSatInwDoctor: Person 8"
       9 = " 9 HelperSatInwDoctor: Person 9"
      10 = "10 HelperSatInwDoctor: Person 10"
      11 = "11 HelperSatInwDoctor: Person 11"
      12 = "12 HelperSatInwDoctor: Person 12"
      13 = "13 HelperSatInwDoctor: Person 13"
      14 = "14 HelperSatInwDoctor: Person 14"
      15 = "15 HelperSatInwDoctor: Person 15"
      16 = "16 HelperSatInwDoctor: Person 16"
      17 = "17 HelperSatInwDoctor: Person 17"
      18 = "18 HelperSatInwDoctor: Person 18"
      19 = "19 HelperSatInwDoctor: Person 19"
      20 = "20 HelperSatInwDoctor: Person 20"
      21 = "21 HelperSatInwDoctor: Person 21"
      22 = "22 HelperSatInwDoctor: Person 22"
      23 = "23 HelperSatInwDoctor: Person 23"
      24 = "24 HelperSatInwDoctor: Person 24"
      25 = "25 HelperSatInwDoctor: Person 25"    ;

    VALUE W000091W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 VERY IMPORTANT"
      2 = " 2 SOMEWHAT IMPORTANT"
      3 = " 3 NOT SO IMPORTANT"    ;

    VALUE W000092W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      3 = " 3 CAN'T DO/DON'T DO"    ;

    VALUE W000093W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 LEFT"
      2 = " 2 RIGHT"
      3 = " 3 BOTH"    ;

    VALUE W000094W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 LEFT SIDE"
      2 = " 2 RIGHT SIDE"
      3 = " 3 BOTH SIDES"    ;

    VALUE W000095W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ONE SIDE"
      2 = " 2 BOTH SIDES"    ;

    VALUE W000096W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 WELL OFF"
      2 = " 2 ABOVE AVERAGE"
      3 = " 3 AVERAGE"
      4 = " 4 BELOW AVERAGE"
      5 = " 5 POOR"    ;

    VALUE W000097W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MOTHER ONLY"
      2 = " 2 FATHER ONLY"
      3 = " 3 ANOTHER RELATIVE"
      4 = " 4 NON-RELATIVES"
      5 = " 5 VARIED/MOVED AROUND"    ;

    VALUE W000098W
       1 = " 1 Contact: Person 1"
       2 = " 2 Contact: Person 2"
       3 = " 3 Contact: Person 3"
       4 = " 4 Contact: Person 4"
       5 = " 5 Contact: Person 5"
       6 = " 6 Contact: Person 6"
       7 = " 7 Contact: Person 7"
       8 = " 8 Contact: Person 8"
       9 = " 9 Contact: Person 9"
      10 = "10 Contact: Person 10"
      11 = "11 Contact: Person 11"
      12 = "12 Contact: Person 12"
      13 = "13 Contact: Person 13"
      14 = "14 Contact: Person 14"
      15 = "15 Contact: Person 15"
      16 = "16 Contact: Person 16"
      17 = "17 Contact: Person 17"
      18 = "18 Contact: Person 18"
      19 = "19 Contact: Person 19"
      20 = "20 Contact: Person 20"
      21 = "21 Contact: Person 21"
      22 = "22 Contact: Person 22"    ;

    VALUE W000099W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 AGREE A LOT"
      2 = " 2 AGREE A LITTLE"
      3 = " 3 DO NOT AGREE"    ;

    VALUE W000100W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 WHITE/CAUCASIAN"
      2 = " 2 BLACK/AFRICAN AMERICAN"
      3 = " 3 AMERICAN INDIAN"
      4 = " 4 ALASKA NATIVE"
      5 = " 5 ASIAN"
      6 = " 6 NATIVE HAWAIIAN"
      7 = " 7 PACIFIC ISLANDER"
      8 = " 8 OTHER (SPECIFY)"    ;

    VALUE W000101W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 {WHITE}"
      2 = " 2 {BLACK}"
      3 = " 3 {AMERICAN INDIAN}"
      4 = " 4 {ALASKAN NATIVE}"
      5 = " 5 {ASIAN}"
      6 = " 6 {NATIVE HAWAIIAN}"
      7 = " 7 {PACIFIC ISLANDER}"
      8 = " 8 {OTHER}"    ;

    VALUE W000102W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MEXICAN AMERICAN/CHICANO"
      2 = " 2 PUERTO RICAN"
      3 = " 3 CUBAN AMERICAN"
      4 = " 4 OTHER (SPECIFY)"    ;

    VALUE W000103W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 VERY WELL"
      2 = " 2 WELL"
      3 = " 3 NOT WELL"
      4 = " 4 NOT AT ALL"    ;

    VALUE W000104W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NOVEMBER 1941 OR EARLIER"
      2 = " 2 WORLD WAR II (DECEMBER 1941-DECEMBER 1946)"
      3 = " 3 JANUARY 1947 - JUNE 1950"
      4 = " 4 KOREAN WAR (JULY 1950 - JANUARY 1955)"
      5 = " 5 FEBRUARY 1955 - JULY 1964"
      6 = " 6 VIETNAM ERA (AUGUST 1964 - APRIL 1975)"
      7 = " 7 MAY 1975 - JULY 1990"
      8 = " 8 AUGUST 1990 - AUGUST 2001 (INCLUDING PERSIAN GULF WAR)"
      9 = " 9 SEPTEMBER 2001 OR LATER"    ;

    VALUE W000105W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 AGREE A LOT"
      2 = " 2 AGREE A LITTLE"
      3 = " 3 AGREE NOT AT ALL"    ;

    VALUE W000106W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NURSING HOME CARE"
      2 = " 2 ASSISTED LIVING"
      3 = " 3 CARE BY HOME HEALTH PROVIDERS IN HOME"    ;

    VALUE W000107W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,000,"
      2 = " 2 $1,000 to less than $2,000,"
      3 = " 3 $2,000 to less than $3,000,"
      4 = " 4 $3,000 to less than $5,000, or"
      5 = " 5 $5,000 or more?"    ;

    VALUE W000108W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NUMBER OF YEARS"
      2 = " 2 AGE"    ;

    VALUE W000109W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      3 = " 3 RETIRED/DON'T WORK ANYMORE"    ;

    VALUE W000110W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 EVERY WEEK"
      2 = " 2 EVERY TWO WEEKS"
      3 = " 3 TWO TIMES A MONTH"
      4 = " 4 OTHER SCHEDULE (SPECIFY)"    ;

    VALUE W000111W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ENTER PAYCHECK AMOUNT"
      2 = " 2 ENTER PAY PER HOUR"
      3 = " 3 ENTER PAY PER DAY"    ;

    VALUE W000112W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ENTER OCCUPATION"
      2 = " 2 NEVER WORKED ENTIRE LIFE"
      3 = " 3 HOMEMAKER/RAISED CHILDREN/WORKED IN THE HOME"    ;

    VALUE W000113W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 SAME KIND OF WORK"
      2 = " 2 SOMETHING DIFFERENT"    ;

    VALUE W000114W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 OWN"
      2 = " 2 RENT"
      3 = " 3 SOME OTHER ARRANGEMENT"    ;

    VALUE W000115W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 PAID OFF"
      2 = " 2 STILL MAKE PAYMENTS"
      3 = " 3 REVERSE MORTGAGE"    ;

    VALUE W000116W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $250,"
      2 = " 2 $250-$499,"
      3 = " 3 $500-$999, or"
      4 = " 4 $1,000 or more?"    ;

    VALUE W000117W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 5 YEARS"
      2 = " 2 10 YEARS"
      3 = " 3 LONGER THAN 10 YEARS"    ;

    VALUE W000118W

     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $50,000,"
      2 = " 2 between $50,000 and $100,000, or"
      3 = " 3 over $100,000?"    ;

    VALUE W000119W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $50,000,"
      2 = " 2 $50,000-$74,999,"
      3 = " 3 $75,000-$99,999,"
      4 = " 4 $100,000-$199,999,"
      5 = " 5 $200,000-$299,999,"
      6 = " 6 $300,000-$499,999,"
      7 = " 7 $500,000-$749,999, or"
      8 = " 8 $750,000 or more?"    ;

    VALUE W000120W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, SP RECEIVED PAYMENT FROM SOURCE"
      2 = " 2 ^HH.fOption2Response"
      3 = " 3 NO PAYMENT RECEIVED FROM THIS SOURCE"    ;

    VALUE W000121W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
     1 = " 1 MAIL"
     2 = " 2 DIRECT DEPOSIT"    ;

    VALUE W000122W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, SP HAS 401K, 403B, IRA, OR KEOGH"
      2 = " 2 ^HH.fOption2ResponseIA7"
      3 = " 3 NO ACCOUNTS OF THIS TYPE"   ;

    VALUE W000123W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, SP HAS ASSET"
      2 = " 2 ^HH.fOption2ResponseIA8"
      3 = " 3 ^HH.fOption3Response"
      4 = " 4 NO ASSET OF THIS TYPE"    ;

    VALUE W000124W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, SP HAS ASSET"
      2 = " 2 ^HH.fOption2ResponseIA8"
      3 = " 3 ^HH.fOption3Response"
      4 = " 4 NO ASSETS OF THIS TYPE"    ;

    VALUE W000125W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 ENTER COMBINED AMOUNT"
      2 = " 2 ENTER SP AND SPOUSE/PARTNER AMOUNTS SEPARATELY"    ;

    VALUE W000126W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,200,"
      2 = " 2 $1,200-$1,599,"
      3 = " 3 $1,600-$1,999,"
      4 = " 4 $2,000-$2,499, or"
      5 = " 5 $2,500 or more?"    ;

    VALUE W000127W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $600,"
      2 = " 2 $600-$899,"
      3 = " 3 $900-$1,099,"
      4 = " 4 $1,100-$1,499, or"
      5 = " 5 $1,500 or more?"    ;

    VALUE W000128W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $300,"
      2 = " 2 $300-$699,"
      3 = " 3 $700-$999, or"
      4 = " 4 $1000 or more?"    ;

    VALUE W000129W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $100,"
      2 = " 2 $100-$199,"
      3 = " 3 $200-$399,"
      4 = " 4 $400-$699, or"
      5 = " 5 $700 or more?"    ;

    VALUE W000130W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $600,"
      2 = " 2 $600-$799,"
      3 = " 3 $800-$999,"
      4 = " 4 $1000-$1199, or"
      5 = " 5 $1200 or more?"    ;

    VALUE W000131W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $500,"
      2 = " 2 $500-$699,"
      3 = " 3 $700-$899,"
      4 = " 4 $900-$1,099, or"
      5 = " 5 $1,100 or more?"    ;

    VALUE W000132W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $600,"
      2 = " 2 $600-$1,099,"
      3 = " 3 $1,100-$2,099,"
      4 = " 4 $2,100-$4,499, or"
      5 = " 5 $4,500 or more?"    ;

    VALUE W000133W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $400,"
      2 = " 2 $400-$799,"
      3 = " 3 $800-$1,499,"
      4 = " 4 $1,500-$3,399, or"
      5 = " 5 $3,400 or more?"    ;

    VALUE W000134W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $16,000,"
      2 = " 2 $16,000-$49,999,"
      3 = " 3 $50,000-$118,999,"
      4 = " 4 $119,000-$224,999, or"
      5 = " 5 $225,000 or more?"    ;

    VALUE W000135W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $10,000,"
      2 = " 2 $10,000-$27,999,"
      3 = " 3 $28,000-$54,999,"
      4 = " 4 $55,000-$143,999, or"
      5 = " 5 $144,000 or more?"    ;

    VALUE W000136W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $200,"
      2 = " 2 $200-$299,"
      3 = " 3 $300-$699,"
      4 = " 4 $700-$1,499, or"
      5 = " 5 $1,500 or more?"    ;

    VALUE W000137W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $100,"
      2 = " 2 $100-$199,"
      3 = " 3 $200-$399,"
      4 = " 4 $400-$1,099, or"
      5 = " 5 $1,100 or more?"    ;

    VALUE W000138W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $2,400,"
      2 = " 2 $2,400-$3,599,"
      3 = " 3 $3,600-$8,399,"
      4 = " 4 $8,400-$17,999, or"
      5 = " 5 $18,000 or more?"    ;

    VALUE W000139W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,200,"
      2 = " 2 $1,200-$2,399,"
      3 = " 3 $2,400-$4,799,"
      4 = " 4 $4,800-$13,199, or"
      5 = " 5 $13,200 or more?"    ;

    VALUE W000140W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $62,000,"
      2 = " 2 $62,000-$85,999,"
      3 = " 3 $86,000-$149,999,"
      4 = " 4 $150,000-$434,999, or"
      5 = " 5 $435,000 or more?"    ;

    VALUE W000141W

     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,000,"
      2 = " 2 $1,000-$1,999,"
      3 = " 3 $2,000-$19,999,"
      4 = " 4 $20,000-$49,999, or"
      5 = " 5 $50,000 or more?"    ;

    VALUE W000142W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $77,000,"
      2 = " 2 $77,000-$79,999,"
      3 = " 3 $80,000-$171,999,"
      4 = " 4 $172,000-$199,999, or"
      5 = " 5 $200,000 or more?"    ;

    VALUE W000143W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,000,"
      2 = " 2 $1,000-$15,999,"
      3 = " 3 $16,000-$33,999,"
      4 = " 4 $34,000-$55,999, or"
      5 = " 5 $56,000 or more?"    ;

    VALUE W000144W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $11,000,"
      2 = " 2 $11,000-$22,999,"
      3 = " 3 $23,000-$44,999,"
      4 = " 4 $45,000-$112,999, or"
      5 = " 5 $113,000 or more?"    ;

    VALUE W000145W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,000,"
      2 = " 2 $1,000-$5,999,"
      3 = " 3 $6,000-$13,999,"
      4 = " 4 $14,000-$35,999, or"
      5 = " 5 $36,000 or more?"    ;

    VALUE W000146W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $10,000,"
      2 = " 2 $10,000-$22,999,"
      3 = " 3 $23,000-$55,999,"
      4 = " 4 $56,000-$80,999, or"
      5 = " 5 $81,000 or more?"    ;

    VALUE W000147W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $600,"
      2 = " 2 $600-$999,"
      3 = " 3 $1,000-$2,999,"
      4 = " 4 $3,000-$10,999, or"
      5 = " 5 $11,000 or more?"    ;

    VALUE W000148W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $500,"
      2 = " 2 $500-$999,"
      3 = " 3 $1,000-$3,999,"
      4 = " 4 $4,000-$15,999, or"
      5 = " 5 $16,000 or more?"    ;

    VALUE W000149W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $200,"
      2 = " 2 $200-$999,"
      3 = " 3 $1,000-$3,999,"
      4 = " 4 $4,000-$6,999, or"
      5 = " 5 $7,000 or more?"    ;

    VALUE W000150W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $30,000,"
      2 = " 2 $30,000-$151,999,"
      3 = " 3 $152,000-$367,999,"
      4 = " 4 $368,000-$956,999, or"
      5 = " 5 $957,000 or more?"    ;

    VALUE W000151W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $30,000,"
      2 = " 2 $30,000-$88,999,"
      3 = " 3 $89,000-$295,999,"
      4 = " 4 $296,000-$360,999, or"
      5 = " 5 $361,000 or more?"    ;

    VALUE W000152W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $7,200,"
      2 = " 2 $7,200-$16,799,"
      3 = " 3 $16,800-$40,799,"
      4 = " 4 $40,800-$86,399, or"
      5 = " 5 $86,400 or more?"    ;

    VALUE W000153W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $6,000,"
      2 = " 2 $6,000-$11,999,"
      3 = " 3 $12,000-$23,999,"
      4 = " 4 $24,000-$47,999, or"
      5 = " 5 $48,000 or more?"    ;

    VALUE W000154W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $27,600,"
      2 = " 2 $27,600-$41,999,"
      3 = " 3 $42,000-$63,999,"
      4 = " 4 $64,000-$107,999, or"
      5 = " 5 $108,000 or more?"    ;

    VALUE W000155W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $14,000,"
      2 = " 2 $14,000-$21,999,"
      3 = " 3 $22,000-$35,999,"
      4 = " 4 $36,000-$48,999, or"
      5 = " 5 $49,000 or more?"    ;

    VALUE W000156W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $2,500,"
      2 = " 2 $2,500-$4,999,"
      3 = " 3 $5,000-$7,499,"
      4 = " 4 $7,500-$9,999,"
      5 = " 5 $10,000-$19,999, or"
      6 = " 6 $20,000 or more?"    ;

    VALUE W000157W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 PAY OFF BALANCE"
      2 = " 2 PAY MINIMUM"
      3 = " 3 PAY MORE THAN MINIMUM, BUT NOT ENTIRE BALANCE"
      4 = " 4 DON'T HAVE ANY CREDIT CARDS"    ;

    VALUE W000158W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $1,000,"
      2 = " 2 over $1,000 but less than $2,000,"
      3 = " 3 over $2,000 but less than $4,000,"
      4 = " 4 over $4,000 but less than $6,000,"
      5 = " 5 over $6,000 but less than $10,000,"
      6 = " 6 over $10,000 but less than $20,000, or"
      7 = " 7 $20,000 or more?"    ;

    VALUE W000159W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MOST"
      2 = " 2 SOME"
      3 = " 3 A LITTLE"    ;

    VALUE W000160W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 less than $500,"
      2 = " 2 over $500 but less than $1,000,"
      3 = " 3 over $1,000 but less than $2,000,"
      4 = " 4 over $2,000 but less than $4,000,"
      5 = " 5 over $4,000 but less than $6,000,"
      6 = " 6 over $6,000 but less than $10,000,"
      7 = " 7 over $10,000 but less than $20,000, or"
      8 = " 8 $20,000 or more?"    ;

    VALUE W000161W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 CHILD/CHILDREN"
      2 = " 2 SOMEONE ELSE"    ;

    VALUE W000162W
      -7 = '-7 RF'
      -8 = '-8 DK'
      -1 = '-1 Inapplicable'
      -9 = '-9 Missing'
       1 = " 1 HelperChildRel: Person 1"
       2 = " 2 HelperChildRel: Person 2"
       3 = " 3 HelperChildRel: Person 3"
       4 = " 4 HelperChildRel: Person 4"
       5 = " 5 HelperChildRel: Person 5"
       6 = " 6 HelperChildRel: Person 6"
       7 = " 7 HelperChildRel: Person 7"
       8 = " 8 HelperChildRel: Person 8"
       9 = " 9 HelperChildRel: Person 9"
      10 = "10 HelperChildRel: Person 10"
      11 = "11 HelperChildRel: Person 11"
      12 = "12 HelperChildRel: Person 12"
      13 = "13 HelperChildRel: Person 13"
      14 = "14 HelperChildRel: Person 14"
      15 = "15 HelperChildRel: Person 15"
      16 = "16 HelperChildRel: Person 16"
      17 = "17 HelperChildRel: Person 17"
      18 = "18 HelperChildRel: Person 18"
      19 = "19 HelperChildRel: Person 19"
      20 = "20 HelperChildRel: Person 20"
      21 = "21 HelperChildRel: Person 21"
      22 = "22 HelperChildRel: Person 22"
      23 = "23 HelperChildRel: Person 23"
      24 = "24 HelperChildRel: Person 24"    ;

    VALUE W000163W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 CHILD/CHILDREN"
      2 = " 2 GRANDCHILD/GRANDCHILDREN"
      3 = " 3 SOMEONE ELSE"    ;

    VALUE W000164W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NEARLY EVERY DAY"
      2 = " 2 MORE THAN HALF THE DAYS"
      3 = " 3 SEVERAL DAYS (LESS THAN HALF)"
      4 = " 4 A FEW DAYS"    ;

    VALUE W000165W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 INCLUDED"
      2 = " 2 EXTRA CHARGE"    ;

    VALUE W000166W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES, PHONE NUMBER PROVIDED"
      2 = " 2 NO PHONE NUMBER AVAILABLE"
      3 = " 3 REFUSED TO GIVE PHONE NUMBER"    ;

    VALUE W000167W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 HOME"
      2 = " 2 CELL PHONE"
      3 = " 3 WORK PHONE"
     91 = "91 SOMEWHERE ELSE (SPECIFY)"    ;

    VALUE W000168W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Yes"    ;

    VALUE I000001W
      12 = "12 STARTED"
      20 = "20 COMPLETE"
      21 = "21 INELIGIBLE - NOT 65+"    ;

    VALUE I000002W
      12 = "12 Started"
      20 = "20 Complete"    ;

    VALUE I000003W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
     24 = "24 Notrequired"    ;

    VALUE I000004W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"    ;

    VALUE I000005W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 IN PERSON"
      2 = " 2 TELEPHONE"    ;

    VALUE I000006W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Friendly and interested"
      2 = " 2 Cooperative but not particularly interested"
      3 = " 3 Impatient and restless"
      4 = " 4 Hostile"    ;

    VALUE I000007W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Good"
      2 = " 2 Fair"
      3 = " 3 Poor"    ;

    VALUE I000008W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 All of the time"
      2 = " 2 Most of the time"
      3 = " 3 Some of the time"
      4 = " 4 Only for the cognition and/or performance parts"
      5 = " 5 None of the time"    ;

    VALUE I000009W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      3 = " 3 Interview was conducted by telephone"    ;

    VALUE I000010W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Spouse/Partner"
      2 = " 2 Child of SP"
      3 = " 3 Other relative"
      4 = " 4 Friend/Neighbor"
      5 = " 5 Staff person from place SP lives"
      6 = " 6 Personal helper/aide"
     91 = "91 Other"    ;

    VALUE I000011W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Yes"
      2 = " 2 No"
      3 = " 3 Not Administered"    ;

    VALUE I000012W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 SP/Proxy too tired to complete in 1 session"
      2 = " 2 SP/Proxy felt poorly/ill / SP's health"
      3 = " 3 Schedule conflict for respondent"
      91 =  "91 Other(Specify)"    ;

    VALUE I000013W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Not at all cluttered"
      2 = " 2 Somewhat cluttered"
      3 = " 3 Very cluttered"
      4 = " 4 Could not see other rooms"    ;

    VALUE I000014W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 NONE"
      2 = " 2 A LITTLE"
      3 = " 3 SOME"
      4 = " 4 A LOT"    ;

    VALUE I000015W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 YES"
      2 = " 2 NO"
      7 = " 7 Could not observe"    ;

    VALUE I000016W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 IN PERSON"
      2 = " 2 BY PHONE"    ;

      VALUE F000001W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 MALE"
      2 = " 2 FEMALE"      ;

      VALUE F000002W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 Yes"      ;

      VALUE F000003W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 CONSENT TO RECORDING"
      7 = " 7 REFUSE CONSENT TO RECORD"      ;

      VALUE F000004W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 FREE STANDING NURSING HOME"
        2 = " 2 FREE STANDING ASSISTED LIVING FACILITY"
        3 = " 3 NURSING HOME AND ASSISTED LIVING FACILITY"
        4 = " 4 CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
        5 = " 5 ADULT FAMILY CARE HOME"
        6 = " 6 GROUP HOME"
        7 = " 7 BOARD AND CARE HOME"
        8 = " 8 RETIREMENT COMMUNITY OR SENIOR HOUSING (NOT CCRC)"
       91 = "91 OTHER (SPECIFY)"      ;

      VALUE F000005W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 YES"
        2 = " 2 NO"      ;

      VALUE F000006W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 INDEPENDENT LIVING"
        2 = " 2 ASSISTED LIVING"
        3 = " 3 SPECIAL CARE, MEMORY CARE, OR ALZHEIMER'S UNIT"
        4 = " 4 NURSING HOME"
       91 = "91 OTHER (SPECIFY)"      ;

      VALUE F000007W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 ASSISTED LIVING"
        2 = " 2 NURSING HOME"      ;

      VALUE F000008W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 ASSISTED LIVING"
        2 = " 2 NURSING HOME"
        3 = " 3 BOTH"      ;

      VALUE F000009W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 YES, SERVICE PROVIDED AS PART OF PACKAGE"
        2 = " 2 YES, SERVICE PROVIDED AT AN EXTRA CHARGE"
        3 = " 3 NO, SERVICE NOT PROVIDED"
      ;

      VALUE F000010W

       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 SP/FAMILY"
        2 = " 2 SOCIAL SECURITY/SSI"
        3 = " 3 MEDICAID"
        4 = " 4 MEDICARE"
        5 = " 5 OTHER SOURCE"
      ;

      VALUE F000011W
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = " 1 INDEPENDENT LIVING"
        2 = " 2 ASSISTED LIVING"
        3 = " 3 SPECIAL CARE UNIT ASSISTED LIVING"
        4 = " 4 NURSING HOME"
        5 = " 5 SPECIAL CARE UNIT NURSING HOME"
        6 = " 6 OTHER (SPECIFY)"      ;

      VALUE F000012W
        12 = "12 STARTED"
        20 = "20 COMPLETED"
        24 = "24 NOT REQUIRED"      ;

      VALUE F000013W
        61 = "61 COMPLETE, NH FACILITY"      ;

      VALUE F000014W
        1 = "1 NURSING HOME"
        2 = "2 OTHER FACILITY"      ;
********;
VALUE BA1SS
    1 = '1 Eligible and recorded result for SxS Balance'
    2 = '2 Eligible and no recorded result for SxS Balance'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1STAN
    1 = '1 Eligible and recorded result for Semi Tandem Balance'
    2 = '2 Eligible and no recorded result for Semi Tandem Balance'
    3 = '3 Not administered because did not complete prior balance test'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1TAN
    1 = '1 Eligible and recorded result for Full tandem Balance'
    2 = '2 Eligible and no recorded result for Full tandem Balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1OP
    1 = '1 Eligible and recorded result for One leg eyes open Balance'
    2 = '2 Eligible and no recorded result for One leg eyes open Balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1CL
    1 = '1 Eligible and recorded result for One leg eyes closed Balance'
    2 = '2 Eligible and no recorded result for One leg eyes closed Balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE WA1WLK
    1 = '1 Eligible and recorded result for walking course'
    2 = '2 Eligible and no recorded result for walking course'
    4 = '4 Not Eligible due to exclusion criteria'
    5 = '5 Not Eligible on exclusion criteria but recorded result (SP changed mind)'
    -1 = '-1 Inapplicable '
    -9 = '-9 Missing';

VALUE CH1SCH
    1 = '1 Eligible and recorded result for single chair stand'
    2 = '2 Eligible and no recorded result for single chair stand'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE CH1RSH
    1 = '1 Eligible and recorded result for repeated chair stand'
    2 = '2 Eligible and no recorded result for repeated chair stand'
    3 = '3 Not administered because did not complete single chair stand w/o arms'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE GR1GRIP
    1 = '1 Eligible and recorded result for grip strength'
    2 = '2 Eligible and no recorded result for grip strength'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE WC1WAIST
    1 = '1 Eligible and recorded result for waist circumference'
    2 = '2 Eligible and no recorded result for waist circumference'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE PK1PEAK
    1 = '1 Eligible and recorded result for peak air flow'
    2 = '2 Eligible and no recorded result for peak air flow'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';


VALUE PA25FMT
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    111= '111 Sleeping Napping'
    131= '131 Eating'
    132= '132 Going out to eat'
    199= '199 Other self care activities'
    211= '211 Work and work-related activities'
    221= '221 Other income generating activities'
    241= '241 Volunteering'
    299= '299 Other productive activities'
    321= '321 Shopping for non-durable goods'
    399= '399 Other shopping'
    411= '411 Food and drink preparation'
    434= '434 Outdoor Maintenance'
    439= '439 Household chores (can not tell if indoor/outdoor)'
    441= '441 Animal and pet care'
    442= '442 Walking and exercising pets'
    449= '449 Other animal and pet care'
    451= '451 Vehicle maintenance and repair'
    471= '471 Financial management'
    499= '499 Other household activities'
    511= '511 Physical care and assistance to others'
    599= '599 Other physical care'
    611= '611 Socializing with others in person'
    612= '612 Socializing with others on the phone'
    616= '616 Socializing and communicating on the computer'
    621= '621 Watching TV and movies'
    631= '631 Doing puzzles or games not on computer or online'
    632= '632 Gambling not online or at a casino'
    636= '636 Doing puzzles or games on a computer or online'
    641= '641 Arts and crafts or hobbies'
    642= '642 Reading'
    643= '643 Writing'
    644= '644 Listening to music'
    646= '646 Computer or online leisure activities'
    651= '651 Smoking or other tobacco use'
    652= '652 Drinking alcohol'
    661= '661 Doing nothing/relaxing'
    669= '669 No activity'
    699= '699 Other non active leisure'
    711= '711 Playing sports'
    712= '712 Walking or jogging'
    713= '713 Other outdoor recreating activities'
    714= '714 Attending sporting events'
    718= '718 Watching sporting events'
    721= '721 Attending arts  including plays and concerts'
    723= '723 Attending movies'
    724= '724 Attending casinos'
    737= '737 Travel for leisure'
    799= '799 Other active leisure'
    811= '811 Attending religious activities'
    812= '812 Other religious and spirtual activities'
    821= '821 Attending meetings or events'
    899= '899 Other organizational activity'
    991= '991 Other miscellaneous'
    992= '992 No favorite activity'
    997= '997 Refused'
    998= '998 Don''t Know'
    999= '999 Not Codeable';

VALUE $PA25FM
    '-1' = '-1 Inapplicable'
    '-9' = '-9 Missing'
    '111'= '111 Sleeping Napping'
    '131'= '131 Eating'
    '132'= '132 Going out to eat'
    '199'= '199 Other self care activities'
    '211'= '211 Work and work-related activities'
    '221'= '221 Other income generating activities'
    '241'= '241 Volunteering'
    '299'= '299 Other productive activities'
    '321'= '321 Shopping for non-durable goods'
    '399'= '399 Other shopping'
    '411'= '411 Food and drink preparation'
    '434'= '434 Outdoor Maintenance'
    '439'= '439 Household chores (can not tell if indoor/outdoor)'
    '441'= '441 Animal and pet care'
    '442'= '442 Walking and exercising pets'
    '449'= '449 Other animal and pet care'
    '451'= '451 Vehicle maintenance and repair'
    '471'= '471 Financial management'
    '499'= '499 Other household activities'
    '511'= '511 Physical care and assistance to others'
    '599'= '599 Other physical care'
    '611'= '611 Socializing with others in person'
    '612'= '612 Socializing with others on the phone'
    '616'= '616 Socializing and communicating on the computer'
    '621'= '621 Watching TV and movies'
    '631'= '631 Doing puzzles or games not on computer or online'
    '632'= '632 Gambling not online or at a casino'
    '636'= '636 Doing puzzles or games on a computer or online'
    '641'= '641 Arts and crafts or hobbies'
    '642'= '642 Reading'
    '643'= '643 Writing'
    '644'= '644 Listening to music'
    '646'= '646 Computer or online leisure activities'
    '651'= '651 Smoking or other tobacco use'
    '652'= '652 Drinking alcohol'
    '661'= '661 Doing nothing/relaxing'
    '669'= '669 No activity'
    '699'= '699 Other non active leisure'
    '711'= '711 Playing sports'
    '712'= '712 Walking or jogging'
    '713'= '713 Other outdoor recreating activities'
    '714'= '714 Attending sporting events'
    '718'= '718 Watching sporting events'
    '721'= '721 Attending arts  including plays and concerts'
    '723'= '723 Attending movies'
    '724'= '724 Attending casinos'
    '737'= '737 Travel for leisure'
    '799'= '799 Other active leisure'
    '811'= '811 Attending religious activities'
    '812'= '812 Other religious and spirtual activities'
    '821'= '821 Attending meetings or events'
    '899'= '899 Other organizational activity'
    '991'= '991 Other miscellaneous'
    '992'= '992 No favorite activity'
    '997'= '997 Refused'
    '998'= '998 Don''t Know'
    '999'= '999 Not Codeable';

/* ADD NEW FORMATS FOR THE PE DATA. */

VALUE PE_COMP
    1 = '1 Completed    '
    2 = '2 Attempted    '
    3 = '3 Not attempted'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';


VALUE PE_YES
  1-HIGH = '1 Yes'
 -1 = '-1 Inapplicable'
 -9 = '-9 Missing';

 VALUE WalkAid
  1 = '1 none'
  2 = '2 cane'
  3 = '3 walker or rollator'
  9 = '4 other'
 -1 = '-1 Inapplicable'
 -7 = '-7 RF'
 -8 = '-8 DK'
 -9 = '-9 Missing';

 VALUE CH_ARMS
  1 = '1 with arms'
  2 = '2 without arms'
 -1 = '-1 Inapplicable'
 -9 = '-9 Missing';

 VALUE RGT_LFT
   1 = '1 Right'
   2 = '2 Left'
  -1 = '-1 Inapplicable'
  -9 = '-9 Missing';

 VALUE PERSON
    1 = '1 Interviewer'
    2 = '2 Sample person'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

 VALUE STAND
     1 = '1 Standing'
     2 = '2 Sitting'
     3 = '3 Lying down'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

 VALUE EFFORT
      1 = '1 Full effort'
      2 = '2 Less effort for health reason'
      3 = '3 Less effort for other reason'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0001AB
      1 = "1 AM"
      2 = "2 PM"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0003BA
      1 = "1 Completed, held for 10 seconds"
      2 = "2 Attempted, not held for 10 seconds"
      3 = "3 Not attempted"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

VALUE A0019BA
      1 = "1 Completed, held for 30 seconds"
      2 = "2 Attempted, not held for 30 seconds"
      3 = "3 Not attempted"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0002WA
      1 = "1 Yes, there is space to set up the walking course"
      2 = "2 No, there is not space to set up the walking course"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0004WA
      1 = "1 None"
      2 = "2 Cane"
      3 = "3 Walker or rollator"
      9 = "9 Other, specify"
     -1 = '-1 Inapplicable'
     -7 = '-7 RF'
     -8 = '-8 DK'
     -9 = '-9 Missing';

 VALUE A0004CH
      1 = "1 No, chair stand not completed"
      2 = "2 Yes, chair stand completed"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0008CH
      1 = "1 With arms"
      2 = "2 Without arms"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0014CH
      1 = "1 1 Chair stand completed"
      2 = "2 2 Chair stands completed"
      3 = "3 3 Chair stands completed"
      4 = "4 4 Chair stands completed"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

      VALUE OCCCODE
1   ='1 Management Occupations: 0010-0430'
2   ='2 Business and Financial Operations Occupations:  0500-0950'
3   ='3 Computer and mathematical occupations:  1000-1240'
4   ='4 Architecture and Engineering Occupations:   1300-1560'
5   ='5 Life, Physical, and Social Science Occupations: 1600-1965'
6   ='6 Community and Social Service Occupations:   2000-2060'
7   ='7 Legal Occupations:  2100-2160'
8   ='8 Education, Training, and Library Occupations:   2200-2550'
9   ='9 Arts, Design, Entertainment, Sports, and Media Occupations: 2600-2960'
10  ='10 Healthcare Practitioners and Technical Occupations:    3000-3540'
11  ='11 Healthcare Support Occupations:    3600-3655'
12  ='12 Protective Service Occupations:    3700-3955'
13  ='13 Food Preparation and Serving Related Occupations:  4000-4160'
14  ='14 Building and Grounds Cleaning and Maintenance Occupations: 4200-4250'
15  ='15 Personal Care and Service Occupations: 4300-4650'
16  ='16 Sales and Related Occupations: 4700-4965'
17  ='17 Office and Administrative Support Occupations: 5000-5940'
18  ='18 Farming, Fishing, and Forestry Occupations:    6000-6130'
19  ='19 Construction and Extraction Occupations:   6200-6940'
20  ='20 Installation, Maintenance, and Repair Occupations: 7000-7630'
21  ='21 Production Occupations:    7700-8965'
22  ='22 Transportation and Material Moving Occupations:    9000-9750'
23  ='23 Military Specific Occupations: 9800-9830'
24  ='24 NSOC: No current occ (Unemployed, no work in the last 5 years, never worked):  9920'
25 = '25 Blank field'
26 = '26 Code did not match'
94 = '94 Uncodable'
95 = '95 Never Worked Entire Life'
96 = '96 Homemaker/Raised Children'
-7 = '-7 RF'
-8 = '-8 DK'
-1 = '-1 Inapplicable'
-9 = '-9 Missing';

VALUE R1DSPPBM
-1="-1: Inapplicable"
1="1: PROXY INTERVIEW"
2="2: MISSING WALK AND REPEAT CHAIR AND BALANCE"
3="3: MISSING WALK AND REPEAT CHAIR"
4="4: MISSING WALK AND BALANCE"
5="5: MISSING REPEAT CHAIR AND BALANCE"
6="6: MISSING WALK"
7="7: MISSING REPEAT CHAIR"
8="8: MISSING BALANCE"
9="9: NO SPACE"
10="10: NO CHAIR"
11="11: NO SPACE WALK AND NO CHAIR"
12="12: NO SPACE WALK AND NON-SAFETY MISSING"
13="13: NO CHAIR AND NON-SAFETY MISSING"
14="14: NON-SAFETY WALK"
15="15: NON-SAFETY CHAIR"
16="16: NON-SAFETY BALANCE"
17="17: NON-SAFETY WALK AND CHAIR"
18="18: NON-SAFETY WALK AND BALANCE"
19="19: NON-SAFETY CHAIR AND BALANCE"
20="20: NON-SAFETY WALK AND CHAIR AND BALANCE"
;

VALUE dchntinhh
    1 = ' 1 Child identified in interview but not enumerated to OP File'
   -1 = '-1 Inapplicable';

 VALUE STAT1A
      0 = "0 No"
      1 = "1 Yes"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE $SPOUSEID
         '-1' = "-1 Inapplicable"
         '-9' = "-9 Missing";
RUN;


PROC FORMAT ;

    VALUE release
        1 = '1 Main Sample'
        2 = '2 Reserve Sample'
        9 = '9 New Release Sample';

    VALUE STAT_DTa
          4 = " 4 April"
          5 = " 5 May"
          6 = " 6 June"
          7 = " 7 July"
          8 = " 8 August"
          9 = " 9 September"
         10 = "10 October"
         11 = "11 November"
         99 = "99 Prior to start of field work"
         -1 = '-1 Inapplicable';

    VALUE $DISP
          '10' = "10 Not Available "
          '11' = "11 Ready"
          '12' = "12 Started "
          '20' = "20 Final "
          '24' = "24 Not Required "
          '60' = "60 Complete "
          '61' = "61 Complete, NH facility"
          '62' = "62 Complete SP Deceased, Proxy Intv"
          '63' = "63 Complete SP, FQ not complete"
          '64' = "64 Complete FQ, SP not complete"
          '75' = "75 Physically/mentally unable to participate, no proxy"
          '76' = "76 Too ill to participate, no proxy"
          '77' = "77 Refusal, SP"
          '78' = "78 Language barrier"
          '79' = "79 Unable to locate"
          '80' = "80 Unavailable during field period"
          '82' = "82 Outside of PSU"
          '83' = "83 Ineligible"
          '85' = "85 Refusal, facility"
          '86' = "86 Deceased"
          '87' = "87 Refusal, proxy"
          '88' = "88 Work stopped"    ;

VALUE DISP_a
          10 = "10 Not Available"
          11 = "11 Ready"
          12 = "12 Started"
          20 = "20 Final"
          24 = "24 Not Required"
          60 = "60 Complete"
          61 = "61 Complete, NH facility"
          62 = "62 Complete SP Deceased, Proxy Intv"
          63 = "63 Complete SP, FQ not complete"
          64 = "64 Complete FQ, SP not complete "
          75 = "75 Physically/mentally unable to participate, no proxy"
          76 = "76 Too ill to participate, no proxy"
          77 = "77 Refusal, SP"
          78 = "78 Language barrier"
          79 = "79 Unable to locate"
          80 = "80 Unavailable during field period"
          82 = "82 Outside of PSU"
          83 = "83 Ineligible"
          85 = "85 Refusal, facility"
          86 = "86 Deceased"
          87 = "87 Refusal, proxy"
          88 = "88 Work stopped"    ;

    VALUE DISP_
          10 = "10 Not Available"
          11 = "11 Ready"
          12 = "12 Started"
          20 = "20 Final"
          24 = "24 Not Required";

    VALUE DISP_F
     -1 = '-1 Inapplicable'
          10 = "10 Not Available"
          11 = "11 Ready"
          12 = "12 Started"
          20 = "20 Final"
          24 = "24 Not Required"
          60 = "60 Complete"
          61 = "61 Complete, NH facility"
          62 = "62 Complete SP Deceased, Proxy Intv"
          63 = "63 Complete SP, FQ not complete"
          64 = "64 Complete FQ, SP not complete "
          75 = "75 Physically/mentally unable to participate, no proxy"
          76 = "76 Too ill to participate, no proxy"
          77 = "77 Refusal, SP"
          78 = "78 Language barrier"
          79 = "79 Unable to locate"
          80 = "80 Unavailable during field period"
          82 = "82 Outside of PSU"
          83 = "83 Ineligible"
          85 = "85 Refusal, facility"
          86 = "86 Deceased"
          87 = "87 Refusal, proxy"
          88 = "88 Work stopped"
          89 = "89 Final, Other Specify";

    VALUE RFDK
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE $RFDK_F
    '-7' = '-7 RF'
    '-8' = '-8 DK'
    '-1' = '-1 Inapplicable'
    '-9' = '-9 Missing';

    VALUE RFDK_F
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE RFDK_B
    -1 = '-1 Inapplicable'
    1 = '1 Yes-Breakoff';

VALUE $RFDK_C
    '-1' = '-1 Inapplicable'
    'CL' ='CL - Closing'
    'EW' ='EW - Economic Well-Being'
    'FQ' ='FQ - Facility Questionnaire'
    'HL' ='HL - Helper'
    'HW' ='HW - Height and Weight'
    'IP' ='IP - Insurance Plans'
    'LF' ='LF - Labor Force'
    'PA' ='PA - Participation'
    'PE' ='PE - Performance'
    'WB' ='WB - Well-being' ;

VALUE $RFDK_2C
    '-1' = '-1 Inapplicable'
    '-7' = '-7 RF'
    '-8' = '-8 DK'
    '-9' = '-9 Missing';

    VALUE RFDK_Y
     1 = ' 1 Yes'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE RFDK_YN
     1 = ' 1 Yes'
     2 = ' 2 No'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE DSTRP_G
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    1 =  '1 X condition and word color condition accuracy below threshold (less than .42)'
    2 =  '2 word condition only below threshold (less than .42)'
    3 =  '3 X condition and word color condition meet criteria for accuracy'
    4 =  '4 fewer than 50% of X and word color condition trials answered'
    999 = '999 X condition only below threshold (less than .42)';

    VALUE DSTRP_R
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -999 = '-999 Inapplicable'
    other = 'Values ranging between -.353 and 1.115';

    VALUE DSTRP_M
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -999 = '-999 Inapplicable'
    other = 'Values ranging between -544.732 and 924.863';

VALUE FQ_4F
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
          1='1 YES'
          2='2 NO';

  VALUE CHILDDEC
    1 =  '1 CHILD DECEASED'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE W200001W
    12 = "12 STARTED"
    20 = "20 COMPLETE"
    21 = "21 INELIGIBLE - NOT 65+"   ;

  VALUE W200008x
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 UNDER 20"
    2 = "2 20-24"
    3 = "3 25-29"
    4 = "4 30-34"
    5 = "5 35-39"
    6 = "6 40-44"
    7 = "7 45-49"
    8 = "8 50-54"
    9 = "9 55-59"
    10 = "10 60-64"
    11 = "11 65-69"
    12 = "12 70-74"
    13 = "13 75-79"
    14 = "14 80-84"
    15 = "15 85-89"
    16 = "16 90 +";

  VALUE W200009W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SAMPLE PERSON"
    2 = "2 SPOUSE/ PARTNER"
    3 = "3 DAUGHTER"
    4 = "4 SON"
    5 = "5 DAUGHTER-IN-LAW"
    6 = "6 SON-IN-LAW"
    7 = "7 STEPDAUGHTER"
    8 = "8 STEPSON"
    9 = "9 SISTER"
    10 = "10 BROTHER"
    11 = "11 SISTER-IN-LAW"
    12 = "12 BROTHER-IN-LAW"
    13 = "13 MOTHER"
    14 = "14 STEPMOTHER"
    15 = "15 MOTHER-IN-LAW"
    16 = "16 FATHER"
    17 = "17 STEPFATHER"
    18 = "18 FATHER-IN-LAW"
    19 = "19 GRANDDAUGHTER"
    20 = "20 GRANDSON"
    21 = "21 NIECE"
    22 = "22 NEPHEW"
    23 = "23 AUNT"
    24 = "24 UNCLE"
    25 = "25 COUSIN"
    26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
    27 = "27 STEPSON'S SON/ DAUGHTER"
    28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
    29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
    30 = "30 BOARDER/RENTER"
    31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
    32 = "32 ROOMMATE"
    33 = "33 EX-WIFE/ EX-HUSBAND"
    34 = "34 BOYFRIEND/ GIRLFRIEND"
    35 = "35 NEIGHBOR"
    36 = "36 FRIEND"
    37 = "37 SOMEONE/SERVICE AT THE PLACE SP LIVES/LIVED"
    38 = "38 CO-WORKER"
    39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
    40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
    41 = "41 DECEASED SPOUSE/PARTNER"
    91 = "91 OTHER RELATIVE"
    92 = "92 OTHER NONRELATIVE"   ;

   VALUE W200002W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MALE"
    2 = "2 FEMALE";

   VALUE W200005W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 NO SCHOOLING COMPLETED"
    2 = "2 1ST-8TH GRADE"
    3 = "3 9TH-12TH GRADE (NO DIPLOMA)"
    4 = "4 HIGH SCHOOL GRADUATE (HIGH SCHOOL DIPLOMA OR EQUIVALENT)"
    5 = "5 VOCATIONAL, TECHNICAL, BUSINESS, OR TRADE SCHOOL CERTIFICATE OR DIPLOMA (BEYOND HIGH SCHOOL LEVEL)"
    6 = "6 SOME COLLEGE BUT NO DEGREE"
    7 = "7 ASSOCIATE'S DEGREE"
    8 = "8 BACHELOR'S DEGREE"
    9 = "9 MASTER'S, PROFESSIONAL, OR DOCTORAL DEGREE"  ;

  VALUE W200010W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MARRIED"
    2 = "2 LIVING WITH A PARTNER"
    3 = "3 SEPARATED"
    4 = "4 DIVORCED"
    5 = "5 WIDOWED"
    6 = "6 NEVER MARRIED";

  VALUE W200011W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 PREVIOUSLY REPORTED"  ;
VALUE W200012W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 REGULAR"
    2 = "2 VARIED"  ;

   VALUE W200013W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SP AND/OR FAMILY"
    2 = "2 GOVERNMENT PROGRAM"
    3 = "3 INSURANCE"
    91 = "91 OTHER (SPECIFY)"   ;

  VALUE W200015W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1='1 HOURLY'
    2='2 WEEKLY'
    3='3 MONTHLY'
    4='4 DID NOT PAY IN LAST MONTH'
	91 = "91 OTHER (SPECIFY)"   ;

  VALUE W200016W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MEDICAID"
    2 = "2 MEDICARE"
    3 = "3 STATE PROGRAM"
    91 = "91 OTHER (SPECIFY)"   ;

  VALUE W200018W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 FREE-STANDING (DETACHED) SINGLE HOUSE"
    2 = "2 SINGLE HOUSE BUT ATTACHED TO OTHERS (ROW HOUSE, TOWNHOUSE, DUPLEX, TRIPLEX, OR TRIPLE DECKER)"
    3 = "3 MOBILE HOME OR TRAILER"
    4 = "4 MULTI-UNIT (2+) BUILDING"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE W200020W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 HOME"
    2 = "2 MULTI-UNIT"
    3 = "3 OTHER"  ;

  VALUE W200021W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 BUILDING HAS ONE FLOOR"
    2 = "2 BUILDING HAS MULTIPLE FLOORS"   ;

  VALUE W200022W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 HOME"
    2 = "2 APARTMENT"
    3 = "3 ROOM"
    4 = "4 UNIT"
    5 = "5 SUITE"
    6 = "6 SOMETHING ELSE (SPECIFY)"  ;

  VALUE W200030W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SAMPLE PERSON (SP)"
    2 = "2 PROXY"  ;

  VALUE W200032W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 HOSPITAL"
    2 = "2 NURSING HOME/REHAB CENTER"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE W200035W
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SELF"
    2 = "2 SPOUSE/ PARTNER"
    3 = "3 DAUGHTER"
    4 = "4 SON"
    5 = "5 DAUGHTER-IN-LAW"
    6 = "6 SON-IN-LAW"
    7 = "7 STEPDAUGHTER"
    8 = "8 STEPSON"
    9 = "9 SISTER"
    10 = "10 BROTHER"
    11 = "11 SISTER-IN-LAW"
    12 = "12 BROTHER-IN-LAW"
    13 = "13 MOTHER"
    14 = "14 STEPMOTHER"
    15 = "15 MOTHER-IN-LAW"
    16 = "16 FATHER"
    17 = "17 STEPFATHER"
    18 = "18 FATHER-IN-LAW"
    19 = "19 GRANDDAUGHTER"
    20 = "20 GRANDSON"
    21 = "21 NIECE"
    22 = "22 NEPHEW"
    23 = "23 AUNT"
    24 = "24 UNCLE"
    25 = "25 COUSIN"
    26 = "26 STEPDAUGHTER'S SON/ DAUGHTER"
    27 = "27 STEPSON'S SON/ DAUGHTER"
    28 = "28 DAUGHTER-IN-LAW'S SON/ DAUGHTER"
    29 = "29 SON-IN-LAW'S SON/ DAUGHTER"
    30 = "30 BOARDER/RENTER"
    31 = "31 PAID AIDE/ HOUSEKEEPER/ EMPLOYEE"
    32 = "32 ROOMMATE"
    33 = "33 EX-WIFE/ EX-HUSBAND"
    34 = "34 BOYFRIEND/ GIRLFRIEND"
    35 = "35 NEIGHBOR"
    36 = "36 FRIEND"
    37 = "37 SOMEONE/SERVICE FROM THE PLACE SP LIVES/DIED"
    38 = "38 CO-WORKER"
    39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
    40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
    91 = "91 OTHER RELATIVE"
    92 = "92 OTHER NONRELATIVE"  ;

  VALUE W200036W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 VERY FAMILIAR"
    2 = "2 SOMEWHAT FAMILIAR"
    3 = "3 A LITTLE FAMILIAR"
    4 = "4 NOT AT ALL FAMILIAR"  ;

  VALUE W200037W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES, SAME ADDRESS"
    2 = "2 NO, DIFFERENT ADDRESS"
    3 = "3 YES, SAME ADDRESS WITH MINOR CORRECTIONS"  ;

  VALUE W200038W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 JANUARY"
    2 = "2 FEBRUARY"
    3 = "3 MARCH"
    4 = "4 APRIL"
    5 = "5 MAY"
    6 = "6 JUNE"
    7 = "7 JULY"
    8 = "8 AUGUST"
    9 = "9 SEPTEMBER"
    10 = "10 OCTOBER"
    11 = "11 NOVEMBER"
    12 = "12 DECEMBER"  ;

  VALUE W200039W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 2011"
    2 = "2 2012"
    3 = "3 YEAR2013"
    4 = "4 YEAR2014"
    5 = "5 YEAR2015"
    6 = "6 YEAR2016"
    7 = "7 YEAR2017"
    8 = "8 YEAR2018"
    9 = "9 YEAR2019"
    10 = "10 YEAR2020"  ;

  VALUE W200040W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 2011"
    2 = "2 2012"  ;

  VALUE W200041W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 AT SPS OR SOMEONE ELSES HOME"
    2 = "2 IN A HOSPITAL"
    3 = "3 IN A NURSING HOME"
    4 = "4 IN A HOSPICE RESIDENCE"
    5 = "5 IN TRANSIT (AMBULANCE TO HOSPITAL)"
    91 = "91 SOMEWHERE ELSE (SPECIFY)";

  VALUE W200042W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SP'S HOME"
    2 = "2 SOMEONE ELSE'S HOME"  ;

  VALUE W200043W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 INTENSIVE CARE UNIT"
    2 = "2 PALLIATIVE CARE UNIT"
    3 = "3 INPATIENT HOSPICE UNIT"
    4 = "4 EMERGENCY ROOM"
    5 = "5 ANOTHER KIND OF UNIT"  ;

  VALUE W200044W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 HOSPICE AT A HOSPITAL"
    2 = "2 HOSPICE AT A NURSING HOME"
    3 = "3 RESIDENTIAL HOSPICE"
    4 = "4 OTHER HOSPICE"  ;

  VALUE W200045W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 DAYS"
    2 = "2 WEEKS"
    3 = "3 MONTHS"
    4 = "4 YEARS"  ;

  VALUE W200046W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 AT SP'S HOME"
    2 = "2 IN A HOSPITAL"
    3 = "3 IN A NURSING HOME"
    4 = "4 IN A HOSPICE RESIDENCE"
    91 = "91 SOMEWHERE ELSE (SPECIFY)"  ;

  VALUE W200047W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY DAY"
    2 = "2 MOST DAYS"
    3 = "3 SOME DAYS"
    4 = "4 RARELY"
    5 = "5 NOT AT ALL"  ;

  VALUE W200048W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 LESS THAN WAS NEEDED"
    2 = "2 MORE THAN WAS NEEDED"
    3 = "3 ABOUT RIGHT AMOUNT"  ;

  VALUE W200049W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    3 = "3 DOES NOT APPLY/NO CARE IN LAST MONTH OF LIFE"  ;

  VALUE W200050W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 ALWAYS"
    2 = "2 USUALLY"
    3 = "3 SOMETIMES"
    4 = "4 NEVER"
    5 = "5 DOES NOT APPLY/NO CARE IN LAST MONTH OF LIFE"  ;

  VALUE W200051W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EXCELLENT"
    2 = "2 VERY GOOD"
    3 = "3 GOOD"
    4 = "4 FAIR"
    5 = "5 POOR"  ;

  VALUE W200052W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 NOT AT ALL"
    2 = "2 SEVERAL DAYS"
    3 = "3 MORE THAN HALF THE DAYS"
    4 = "4 NEARLY EVERY DAY"  ;

  VALUE W200053W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY NIGHT (7 NIGHTS A WEEK)"
    2 = "2 MOST NIGHTS (5-6 NIGHTS A WEEK)"
    3 = "3 SOME NIGHTS (2-4 NIGHTS A WEEK)"
    4 = "4 RARELY (ONCE A WEEK OR LESS)"
    5 = "5 NEVER"  ;

  VALUE W200054W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY NIGHT (7 NIGHTS A WEEK)"
    2 = "2 MOST NIGHTS (5-6 NIGHTS A WEEK)"
    3 = "3 SOME NIGHTS (2-4 NIGHTS A WEEK)"
    4 = "4 RARELY (ONCE A WEEK OR LESS)"
    5 = "5 NEVER"
    7 = "7 DON'T WAKE UP/NOT A PROBLEM"  ;

  VALUE W200055W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 PRIVATE RESIDENCE"
    2 = "2 A GROUP HOME, BOARD AND CARE, OR SUPERVISED HOUSING"
    3 = "3 ASSISTED LIVING FACILITY OR CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
    4 = "4 RELIGIOUS GROUP QUARTERS"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE W200056W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 PLACE DOES NOT HAVE A NAME"  ;

  VALUE W200057W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 APARTMENT"
    2 = "2 ROOM"
    3 = "3 UNIT"
    4 = "4 SUITE"
    91 = "91 SOMETHING ELSE (SPECIFY)"  ;

  VALUE W200058W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO, DIFFERENT PERSON"
    3 = "3 NO, NAME MISSPELLED"  ;

   VALUE W200060W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 PRIVATE RESIDENCE"
    2 = "2 A GROUP HOME, BOARD AND CARE, OR SUPERVISED HOUSING"
    3 = "3 ASSISTED LIVING FACILITY OR CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
    5 = "5 NURSING HOME"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE W200061W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SEPARATION OR DIVORCE"
    2 = "2 DECEASED"
    3 = "3 MOVED ELSEWHERE"
    5 = "5 LAST INTERVIEW INFORMATION INCORRECT"
    8 = "8 OTHER REASON"   ;

  VALUE W200067W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 COMMON OR SHARED ENTRANCE"
    2 = "2 ENTRANCE DIRECTLY INTO HOME"  ;

  VALUE W200068W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1"
    2 = "2"
    3 = "3"
    4 = "4+"  ;

  VALUE W200069W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 ALL ITEMS HERE"
    2 = "2 ADDED ONE OR MORE ITEMS"  ;

  VALUE W200070W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MORE THAN $500"
    2 = "2 LESS THAN $500"
    3 = "3 JUST ABOUT $500"  ;

  VALUE W200071W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MORE THAN $1,000"
    2 = "2 LESS THAN $1,000"
    3 = "3 JUST ABOUT $1,000"  ;

  VALUE W200072W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MORE THAN $100"
    2 = "2 LESS THAN $100"
    3 = "3 JUST ABOUT $100"  ;

  VALUE W200073W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 YES, DOESNT KNOW HOW TO USE A COMPUTER"  ;

  VALUE W200074W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MOST DAYS"
    2 = "2 SOME DAYS"
    3 = "3 RARELY"  ;

  VALUE W200076W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 DEAF"  ;

  VALUE W200077W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 BLIND"  ;

  VALUE W200078W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY DAY (7 DAYS A WEEK)"
    2 = "2 MOST DAYS (5-6 DAYS A WEEK)"
    3 = "3 SOME DAYS (2-4 DAYS A WEEK)"
    4 = "4 RARELY (ONCE A WEEK OR LESS)"
    5 = "5 NEVER"  ;

  VALUE W200080W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES, A CHANGE"
    2 = "2 NO, NO CHANGE"
    3 = "3 DEMENTIA/ALZHEIMER'S REPORTED BY PROXY"  ;

  VALUE W200081W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SP HAS DEMENTIA/ALZHEIMER'S/ NOT ABLE"
    2 = "2 SP IS UNABLE TO SPEAK"
    3 = "3 SP IS UNABLE TO HEAR"
    4 = "4 SP REFUSED"
    5 = "5 PROXY REFUSED"
    6 = "6 SP NOT PRESENT"
    7 = "7 SP TOO ILL"
    8 = "8 SP LANGUAGE BARRIER"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE W200082W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MUCH BETTER"
    2 = "2 BETTER"
    3 = "3 SAME"
    4 = "4 WORSE"
    5 = "5 MUCH WORSE"  ;

  VALUE W200083W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO/DON'T KNOW"  ;

  VALUE W200084W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 CONTINUE WITH ACTIVITY"
    2 = "2 SP REFUSES ACTIVITY"  ;

  VALUE W200085W
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "Word[1]"
    2 = "Word[2]"
    3 = "Word[3]"
    4 = "Word[4]"
    5 = "Word[5]"
    6 = "Word[6]"
    7 = "Word[7]"
    8 = "Word[8]"
    9 = "Word[9]"
    10 = "Word[10]"
    91 = "91 NO WORDS REMEMBERED"
    92 = "92 REFUSED"  ;

  VALUE W200086W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 DIFFICULTY HEARING ANY OF THE WORDS"
    2 = "2 INTERRUPTION OCCURRED WHILE LIST WAS BEING READ"
    91 = "91 OTHER PROBLEM (SPECIFY)"
    92 = "92 NO PROBLEMS OCCURRED"
    97 = "97 SP REFUSED WORD RECALL TASK"  ;

  VALUE W200087W
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SP ATTEMPTED CLOCK DRAWING"
    2 = "2 SP DID NOT ATTEMPT CLOCK DRAWING"
    97 = "3 SP REFUSED CLOCK DRAWING"  ;

  VALUE W200089W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY DAY (7 DAYS A WEEK)"
    2 = "2 MOST DAYS (5-6 DAYS A WEEK)"
    3 = "3 SOME DAYS (2-4 DAYS A WEEK)"
    4 = "4 RARELY (ONCE A WEEK OR LESS)"
    5 = "5 NEVER"  ;

  VALUE W200090W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY TIME"
    2 = "2 MOST TIMES"
    3 = "3 SOMETIMES"
    4 = "4 RARELY"
    5 = "5 NEVER"  ;

  VALUE W200092W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MOST TIMES"
    2 = "2 SOMETIMES"
    3 = "3 RARELY"
    4 = "4 NEVER"  ;

  VALUE W200093W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 NONE"
    2 = "2 A LITTLE"
    3 = "3 SOME"
    4 = "4 A LOT"  ;

  VALUE W200094W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MORE OFTEN"
    2 = "2 LESS OFTEN"
    3 = "3 ABOUT THE SAME"  ;

  VALUE W200095W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 JANUARY"
    2 = "2 FEBRUARY"
    3 = "3 MARCH"
    4 = "4 APRIL"
    5 = "5 MAY"
    6 = "6 JUNE"
    7 = "7 JULY"
    8 = "8 AUGUST"
    9 = "9 SEPTEMBER"
    10 = "10 OCTOBER"
    11 = "11 NOVEMBER"
    12 = "12 DECEMBER"
    90 = "90 LAST INTERVIEW INFORMATION INCORRECT"  ;

  VALUE W200096W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    90 = "90 LAST INTERVIEW INFORMATION INCORRECT"  ;

  VALUE W200097W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO / NO LONGER DRIVE"  ;

  VALUE W200098W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 NO, NO RAIN OR BAD WEATHER"  ;

  VALUE W200099W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 ALWAYS DID IT BY SELF"
    2 = "2 ALWAYS DID IT TOGETHER WITH SOMEONE ELSE"
    3 = "3 SOMEONE ELSE ALWAYS DID IT"
    4 = "4 IT VARIED (MORE THAN ONE WAY)"
    5 = "5 NOT DONE IN LAST MONTH"  ;

  VALUE W200102W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MORE OFTEN"
    2 = "2 LESS OFTEN"
    3 = "3 SAME"  ;

  VALUE W200106W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 ALWAYS FED THROUGH IV OR TUBE"  ;

  VALUE W200107W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY TIME"
    2 = "2 MOST TIMES"
    3 = "3 SOMETIMES"
    4 = "4 RARELY"  ;

  VALUE W200109W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SHOWERING"
    2 = "2 TAKING BATHS"
    3 = "3 WASHING UP SOME OTHER WAY"  ;


  VALUE W200114W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 VERY IMPORTANT"
    2 = "2 SOMEWHAT IMPORTANT"
    3 = "3 NOT SO IMPORTANT"  ;

  VALUE W200115W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    95 = "95 NO ACTIVITY LISTED"  ;

  VALUE W200116W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 LEFT"
    2 = "2 RIGHT"
    3 = "3 BOTH"  ;

  VALUE W200117W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 LEFT SIDE"
    2 = "2 RIGHT SIDE"
    3 = "3 BOTH SIDES"  ;

  VALUE W200118W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 ONE SIDE"
    2 = "2 BOTH SIDES"  ;

  VALUE W200119W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 RECEIVE ALL TREATMENTS"
    2 = "2 STOP/REJECT ALL TREATMENTS"  ;

  VALUE W200120W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 LIVING IN THEIR OWN HOME WITH HELP FROM FRIENDS AND FAMILY"
    2 = "2 LIVING IN THEIR OWN HOME WITH HELP FROM SOMEONE PAID TO COME IN"
    3 = "3 LIVING WITH AN ADULT CHILD"
    4 = "4 LIVING IN AN ASSISTED LIVING FACILITY OR CONTINUING CARE RESIDENCE"
    5 = "5 LIVING IN A NURSING HOME"  ;

  VALUE W200121W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    3 = "3 DOESNT HAVE ANY MONEY TO PAY A CAREGIVER"
    4 = "4 WOULD NOT USE A PAID CAREGIVER"  ;

  VALUE W200122W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MAKE DECISIONS WITHOUT MUCH ADVICE FROM THEM"
    2 = "2 GET THEIR ADVICE AND THEN MAKE DECISIONS"
    3 = "3 MAKE DECISIONS TOGETHER"
    4 = "4 LEAVE DECISIONS UP TO THEM"  ;

  VALUE W200123W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 HANDLE MOSTLY BY SELF"
    2 = "2 HANDLE TOGETHER WITH FAMILY OR CLOSE FRIENDS"
    3 = "3 FAMILY OR CLOSE FRIENDS MOSTLY HANDLE THESE THINGS"
    4 = "4 IT VARIES"  ;

  VALUE W200124W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 NEVER"
    2 = "2 RARELY"
    3 = "3 SOMETIMES"
    4 = "4 OFTEN"  ;

  VALUE W200126W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 AGREE A LOT"
    2 = "2 AGREE A LITTLE"
    3 = "3 DO NOT AGREE"  ;

  VALUE W200127W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 AGREE A LOT"
    2 = "2 AGREE A LITTLE"
    3 = "3 AGREE NOT AT ALL"  ;

  VALUE W200129W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $1,000,"
    2 = "2 $1,000 to less than $2,000,"
    3 = "3 $2,000 to less than $3,000,"
    4 = "4 $3,000 to less than $5,000, or"
    5 = "5 $5,000 or more?"  ;

  VALUE W200131W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"
    3 = "3 RETIRED/DON'T WORK ANYMORE"  ;

  VALUE W200132W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EVERY WEEK"
    2 = "2 EVERY TWO WEEKS"
    3 = "3 TWO TIMES A MONTH"
    4 = "4 ONCE A MONTH"
    5 = "5 DAILY"
    91 = "91 OTHER SCHEDULE (SPECIFY)"  ;

  VALUE W200133W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 OWN"
    2 = "2 RENT"
    3 = "3 SOME OTHER ARRANGEMENT"  ;

  VALUE W200134W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 PAID OFF"
    2 = "2 STILL MAKE PAYMENTS"
    3 = "3 REVERSE MORTGAGE"  ;

  VALUE W200135W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $250,"
    2 = "2 $250-$499,"
    3 = "3 $500-$999, or"
    4 = "4 $1,000 or more?"  ;

  VALUE W200136W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 5 YEARS"
    2 = "2 10 YEARS"
    3 = "3 LONGER THAN 10 YEARS"  ;

  VALUE W200137W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $50,000,"
    2 = "2 between $50,000 and $100,000, or"
    3 = "3 over $100,000?"  ;

  VALUE W200138W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $50,000,"
    2 = "2 $50,000-$74,999,"
    3 = "3 $75,000-$99,999,"
    4 = "4 $100,000-$199,999,"
    5 = "5 $200,000-$299,999,"
    6 = "6 $300,000-$499,999,"
    7 = "7 $500,000-$749,999, or"
    8 = "8 $750,000 or more?"  ;

  VALUE W200139W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 PAY OFF BALANCE"
    2 = "2 PAY MINIMUM"
    3 = "3 PAY MORE THAN MINIMUM, BUT NOT ENTIRE BALANCE"
    4 = "4 DON'T HAVE ANY CREDIT CARDS"  ;

  VALUE W200140W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $1,000,"
    2 = "2 $1,000 - $1,999,"
    3 = "3 $2,000 - $3,999,"
    4 = "4 $4,000 - $5,999,"
    5 = "5 $6,000 - $9,999,"
    6 = "6 $10,000 - $19,999, or"
    7 = "7 $20,000 or more?"  ;

  VALUE W200141W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MOST"
    2 = "2 SOME"
    3 = "3 A LITTLE"  ;

  VALUE W200142W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 less than $500,"
    2 = "2 $500 - $999,"
    3 = "3 $1,000 - $1,999,"
    4 = "4 $2,000 - $3,999,"
    5 = "5 $4,000 - $5,999,"
    6 = "6 $6,000 - $9,999,"
    7 = "7 $10,000 - $19,999, or"
    8 = "8 $20,000 or more?"  ;

  VALUE W200146W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 NEARLY EVERY DAY"
    2 = "2 MORE THAN HALF THE DAYS"
    3 = "3 SEVERAL DAYS (LESS THAN HALF)"
    4 = "4 A FEW DAYS"  ;

  VALUE W200147W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 INCLUDED"
    2 = "2 EXTRA CHARGE"  ;

  VALUE W200148W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"  ;

VALUE F200006W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 FREE STANDING NURSING HOME"
    2 = "2 FREE STANDING ASSISTED LIVING FACILITY"
    3 = "3 NURSING HOME AND ASSISTED LIVING FACILITY"
    4 = "4 CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
    5 = "5 ADULT FAMILY CARE HOME"
    6 = "6 GROUP HOME"
    7 = "7 BOARD AND CARE HOME"
    8 = "8 RETIREMENT COMMUNITY OR SENIOR HOUSING (NOT CCRC)"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE F200007W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"  ;

  VALUE F200008W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 INDEPENDENT LIVING"
    2 = "2 ASSISTED LIVING"
    3 = "3 SPECIAL CARE, MEMORY CARE, OR ALZHEIMER'S UNIT"
    4 = "4 NURSING HOME"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE F200009W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 ASSISTED LIVING"
    2 = "2 NURSING HOME"  ;

  VALUE F200011W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 YES, SERVICE PROVIDED AS PART OF PACKAGE"
    2 = "2 YES, SERVICE PROVIDED AT AN EXTRA CHARGE"
    3 = "3 NO, SERVICE NOT PROVIDED"  ;

  VALUE F200012W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SP/FAMILY"
    2 = "2 SOCIAL SECURITY/SSI"
    3 = "3 MEDICAID"
    4 = "4 MEDICARE"
    5 = "5 OTHER SOURCE"  ;

  VALUE I200002W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"  ;

  VALUE I200003W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 English"
    2 = "2 Spanish"
    3 = "3 Other (specify)"  ;

  VALUE I200005W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Friendly and interested"
    2 = "2 Cooperative but not particularly interested"
    3 = "3 Impatient and restless"
    4 = "4 Hostile"  ;

  VALUE I200006W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Good"
    2 = "2 Fair"
    3 = "3 Poor"  ;

  VALUE I200008W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 All of the time"
    2 = "2 Most of the time"
    3 = "3 Some of the time"
    4 = "4 Only for the cognition and/or performance parts"
    5 = "5 None of the time"  ;

   VALUE I200010W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"
    3 = "3 Interview was conducted by telephone"  ;

  VALUE I200012W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"
    3 = "3 Not Administered"  ;

  VALUE I200013W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"  ;

  VALUE I200016W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"
    3 = "3 Entire interview conducted by telephone"  ;

  VALUE I200017W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Not at all cluttered"
    2 = "2 Somewhat cluttered"
    3 = "3 Very cluttered"
    4 = "4 Could not see other rooms"  ;

  VALUE I200018W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 None"
    2 = "2 A little"
    3 = "3 Some"
    4 = "4 A lot"
    5 = "5 Could not observe"  ;

  VALUE I200019W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 Yes"
    2 = "2 No"
    7 = "7 Could not observe"  ;


/* DERIVED VARIABLE FORMATS */
  VALUE LVGARRG
    1 = '1 Alone'
    2 = '2 With spouse/partner only (spouse/partner in household]'
    3 = '3 With spouse/partner and with others'
    4 = '4 With others only'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE DOUTSFDF
    8 = '8 Not done in last month'
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE DOUTDEVI
    8 = '8 Not done in last month'
    1 = '1 No use of devices to go outside in last month'
    2 = '2 Use of devices to go outside in last month'
    3 = '3 DKRF If used devices to go outside in last month'
    4 = '4 DKRF If used devices in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE DOUTHELP
    8 = '8 Not done in last month'
    1 = '1 No help to go outside in last month'
    2 = '2 Had help to go outside in last month'
    3 = '3 DKRF If had help to go outside in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE DINSDSFD
    8 = '8 Not done in last month'
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE DINSDDEV
    8 = '8 Not done in last month'
    1 = '1 No use of devices inside in last month'
    2 = '2 Use of devices inside in last month'
    3 = '3 DKRF If used devices inside in last month'
    4 = '4 DKRF On use of devices'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dinsdhlp
    8 = '8 Not done in last month'
    1 = '1 No help to go around inside in last month'
    2 = '2 Had help to go around inside in last month'
    3 = '3 DKRF If had help to go around inside in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbedsfdf
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

   VALUE dbeddevi
    1 = '1 No use of cane or walker to get out of bed in last month'
    2 = '2 Use of cane or walker to get out of bed in last month'
    3 = '3 DKRF If Used cane or walker to get out of bed in last month'
    4 = '4 DKRF If used cane or walker in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbedhelp
    1 = '1 No help to get out of bed in last month'
    2 = '2 Had help to get out of bed in last month'
    3 = '3 DKRF If had help to get out of bed in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';


  VALUE dlaunsfd
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';



  VALUE dlaunrea
    1= '1 Health/functioning reason only'
    2= '2 Other reason only'
    3= '3 Both health/functioning and other'
    4= '4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dshopsfd
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dshoprea
    1= '1 Health/functioning reason only'
    2= '2 Other reason only'
    3= '3 Both health/functioning and other'
    4= '4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dmealsfd
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE dmealrea
    1= '1 Health/functioning reason only'
    2= '2 Other reason only'
    3= '3 Both health/functioning and other'
    4= '4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbanksfd
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbankrea
    1= '1 Health/functioning reason only'
    2= '2 Other reason only'
    3= '3 Both health/functioning and other'
    4= '4 Service/someone from the place SP lives'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE deatdevi
    1 = '1 No use of adapted utensils in last month'
    2 = '2 Use of adapted utensils in last month'
    8 = '8 Not done in last month'
    3 = '3 DKRF If used adapted utensils in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE deathelp
    1 = '1 No help eating in last month'
    2 = '2 Had help eating in last month'
    3 = '3 DKRF If had help eating in last month'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE deatsfdf
    1 = '1 Did not do by self in last month'
    2 = '2 No Difficulty by self (and when using utensils)'
    3 = '3 Difficulty by self (and when using utensils)'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbathdev
    1 = '1 No use of grab bars or bath seats in last month'
    2 = '2 Use of grab bars or bath seats in last month'
    3 = '3 DKRF If use of grab bars or bath seats in last month'
    4 = '4 DKRF If had grab bars or bath seats in last month'
    9 = '9 No bars/seats/shower/tub or washes up other way'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbathhel
    1 = '1 No help bathing in last month'
    2 = '2 Had help bathing in last month'
    3 = '3 DKRF If had help bathing in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dbathsfd
    1 = '1 Did not do by self in last month'
    2 = '2 No Difficulty by self (and when using grab bars or tub seat)'
    3 = '3 Difficulty by self (and when using grab bars or tub seat)'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dtoildev
    1 = '1 No use of toileting devices in last month'
    2 = '2 Use of toileting devices in last month'
    3 = '3 DKRF of some and no use of other toileting devices in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dtoilhel
    1 = '1 No help toileting in last month'
    2 = '2 Had help toileting in last month'
    3 = '3 DKRF If had help toileting in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dtoilsfd
    1 = '1 Did not do by self in last month'
    2 = '2 No Difficulty by self (and when using toileting devices)'
    3 = '3 Difficulty by self (and when using toileting devices)'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE ddresdev
    8 = '8 Not done in last month'
    9 = '9 DKRF If dressed in last month'
    2 = '2 Use of dressing devices in last month'
    1 = '1 No use of dressing devices in last month'
    3 = '3 DKRF If use of dressing devices in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE ddreshel
    8 = '8 Not done in last month'
    9 = '9 DKRF If dressed in last month'
    1 = '1 No help dressing in last month'
    2 = '2 Had help dressing in last month'
    3 = '3 DKRF If had help dressing in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE ddressfd
    1 = '1 Did not do by self in last month'
    2 = '2 No Difficulty by self (and when using dressing devices)'
    3 = '3 Difficulty by self (and when using dressing devices)'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';
  VALUE dmedssfd
    1 = '1 Did not do by self in last month'
    2 = '2 Did by self in last month/No Difficulty'
    3 = '3 Did by self in last month/Difficulty'
    4 = '4 DKRF Did by self in last month/No Difficulty'
    5 = '5 DKRF Did by self in last month/Difficulty'
    6 = '6 Did by self in last month/DKRF Difficulty'
    7 = '7 DKRF Did by self in last month/DKRF Difficulty'
    8 = '8 Not done in last month'
    9 = '9 No or DKRF if medications taken in last month'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dmedsrea
    1 = '1 HEALTH/FUNCTIONING REASON ONLY'
    2 = '2 OTHER REASON ONLY'
    3 = '3 BOTH HEALTH/FUNCTIONING AND OTHER'
    4 = '4 SERVICE/SOMEONE FROM THE PLACE SP LIVES'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

  VALUE dmarstat
    1 = '1 Married'
    2 = '2 Living with a partner'
    3 = '3 Separated'
    4 = '4 Divorced'
    5 = '5 Widowed'
    6 = '6 Never married'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';
  VALUE DSPSAGEC
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = " 1 UNDER 50"
      2 = " 2 50-54"
      3 = " 3 55-59"
      4 = " 4 60-64"
      5 = " 5 65-69"
      6 = " 6 70-74"
      7 = " 7 75-79"
      8 = " 8 80-84"
      9 = " 9 85-89"
     10 = "10 90 +"    ;

    VALUE f_dresid
        1 = '1 Community '
        2 = '2 Residential care not nursing home (SP interview)'
        3 = '3 Residential care not nursing home (FQ only)'
        4 = '4 Nursing home (SP interview)'
        5 = '5 Nursing home (FQ only)'
        6 = '6 Deceased'
        7 = '7 Residential care not nursing home in R1 and R2 (FQ only)'
        8 = '8 Nursing home in R1 and R2 (FQ only)' ;
    VALUE f3dresid
		-1='-1 Inapplicable'
		1 = '1 Community '
        2 = '2 Residential care not nursing home (SP interview)'
        3 = '3 Residential care not nursing home (FQ only)'
        4 = '4 Nursing home (SP interview)'
        5 = '5 Nursing home (FQ only)'
        6 = '6 Deceased'
        7 = '7 Residential care not nursing home in R1 and R3 (FQ only)'
        8 = '8 Nursing home in R1 and R3 (FQ only)' ;

VALUE QUARTILE
-9="-9 Missing"
-1="-1 Inapplicable";

VALUE SPPB
-9="-9 Missing"
-1="-1 Inapplicable";
VALUE SPPB_MIS
    -9="-9 Missing"
    -1="-1 Inapplicable"
    1="1 PROXY INTERVIEW"
    2="2 MISSING WALK AND REPEAT CHAIR AND BALANCE"
    3="3 MISSING WALK AND REPEAT CHAIR"
    4="4 MISSING WALK AND BALANCE"
    5="5 MISSING REPEAT CHAIR AND BALANCE"
    6="6 MISSING WALK"
    7="7 MISSING REPEAT CHAIR"
    8="8 MISSING BALANCE"
    9="9 NO SPACE"
    10="10 NO CHAIR"
    11="11 NO SPACE WALK AND NO CHAIR"
    12="12 NO SPACE WALK AND NON-SAFETY MISSING"
    13="13 NO CHAIR AND NON-SAFETY MISSING"
    14="14 NON-SAFETY WALK"
    15="15 NON-SAFETY CHAIR"
    16="16 NON-SAFETY BALANCE"
    17="17 NON-SAFETY WALK AND CHAIR"
    18="18 NON-SAFETY WALK AND BALANCE"
    19="19 NON-SAFETY CHAIR AND BALANCE"
    20="20 NON SAFETY WALK AND CHAIR AND BALANCE";

    VALUE DCLCKSC
      0 = '0 Not recognizable as a clock'
      1 = '1 Severely distorted depiction of a clock'
      2 = '2 Moderately distorted depection of a clock'
      3 = '3 Mildly distorted depiction of a clock'
      4 = '4 Reasonably accurate depiction of a clock'
      5 = '5 Accurate depiction of a clock (circular or square)'
    -7 = '-7 SP refused to draw clock'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -2 = '-2 Proxy says cannot ask SP'
    -3 = '-3 Proxy says can ask SP but SP unable to answer'
    -4 = '-4 SP did not attempt to draw clock'
    -9 = '-9 Missing';

    VALUE DCLCKCL
      1 = '1 Very clear'
      2 = '2 Somewhat clear'
      3 = '3 Somewhat unclear'
      4 = '4 Very unclear'
      5 = '5 Blank'
    -7 = '-7 SP refused to draw clock'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -2 = '-2 Proxy says cannot ask SP'
    -3 = '-3 Proxy says can ask SP but SP unable to answer'
    -4 = '-4 SP did not attempt to draw clock'
    -9 = '-9 Missing';

VALUE RESULT
    -9='-9: MISSING'
    1='1: COMPLETED W RESULTS'
    2='2: COMPLETED MISSING RESULTS'
    3='3: ATTEMPTED W RESULTS'
    4='4: ATTEMPTED MISSING RESULTS'
    5='5: NOT ATTEMPTED SAFETY'
    6='6: NOT ATTEMPTED NOT SAFETY REASON'
    7='7: NO CHAIR/NO SPACE'
    9='9: NOT ATTEMPTED/MISSING';

    VALUE RESULT_SCH
    -9='-9: MISSING'
    1='1: COMPLETED W/OUT ARMS'
    2='2: COMPLETED W ARMS'
    3='3: ATTEMPTED W RESULTS'
    4='4: ATTEMPTED MISSING RESULTS'
    5='5: NOT ATTEMPTED SAFETY'
    6='6: NOT ATTEMPTED NOT SAFETY REASON'
    7='7: NO CHAIR/SAFETY REASON'
    8='8: NO CHAIR/NOT SAFETY REAS'
    9='9: NOT ATTEMPTED/MISSING'
    10='10: CH4=1 SINGLE CHAIR NOT COMPL';

    VALUE RESULT_RCH
    -9='-9: MISSING'
    1='1: COMPLETED W/OUT ARMS'
    2='2: COMPLETED MISSING RESULTS'
    3='3: ATTEMPTED W RESULTS'
    4='4: ATTEMPTED MISSING RESULTS'
    5='5: NOT ATTEMPTED SAFETY'
    6='6: NOT ATTEMPTED NOT SAFETY REASON'
    9='9: NO CHAIR OR NOT ATTEMPTED/MISSING';

    VALUE ZEROSCORE
    1="1: NOT ELIGIBLE DUE TO EXCLUSION CRITERIA"
    2="2: NOT ATTEMPTED FOR SAFETY REASON"
    3="3: ATTEMPTED CHAIR STANDS/NOT ATTEMPTED FOR SAFETY"
    4="4: ATTEMPTED"
    5="5: NEW WALKING EXCLUSION"
    9="9: NOT ASSIGNED A ZERO SCORE";

   VALUE D_LMLLOC
    1 = '1 Community'
    2 = '2 Residential Care'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

      VALUE D_LOCSP
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
        1 = "1 Independent Living/Housing/Retirement"
        2 = "2 Assisted Living/Personal Care"
        3 = "3 Special Care, Memory or Alzheimer's Unit"
        4 = "4 Nursing Home"
        8 = "8 Not Reported" ;

        VALUE PA25FMT
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    111= '111 Sleeping Napping'
    131= '131 Eating'
    132= '132 Going out to eat'
    199= '199 Other self care activities'
    211= '211 Work and work-related activities'
    221= '221 Other income generating activities'
    241= '241 Volunteering'
    299= '299 Other productive activities'
    321= '321 Shopping for non-durable goods'
    399= '399 Other shopping'
    411= '411 Food and drink preparation'
    434= '434 Outdoor Maintenance'
    439= '439 Household chores (cannot tell if indoor/outdoor)'
    441= '441 Animal and pet care'
    442= '442 Walking and exercising pets'
    449= '449 Other animal and pet care'
    451= '451 Vehicle maintenance and repair'
    471= '471 Financial management'
    499= '499 Other household activities'
    511= '511 Physical care and assistance to others'
    599= '599 Other physical care'
    611= '611 Socializing with others in person'
    612= '612 Socializing with others on the phone'
    616= '616 Socializing and communicating on the computer'
    621= '621 Watching TV and movies'
    631= '631 Doing puzzles or games not on computer or online'
    632= '632 Gambling not online or at a casino'
    636= '636 Doing puzzles or games on a computer or online'
    641= '641 Arts and crafts or hobbies'
    642= '642 Reading'
    643= '643 Writing'
    644= '644 Listening to music'
    646= '646 Computer or online leisure activities'
    651= '651 Smoking or other tobacco use'
    652= '652 Drinking alcohol'
    661= '661 Doing nothing/relaxing'
    669= '669 No activity'
    699= '699 Other non active leisure'
    711= '711 Playing sports'
    712= '712 Walking or jogging'
    713= '713 Other outdoor recreating activities'
    714= '714 Attending sporting events'
    715= '715 Other physical activity, exercise, yoga, swimming, working out, dancing'
    718= '718 Watching sporting events'
    721= '721 Attending arts  including plays and concerts'
    723= '723 Attending movies'
    724= '724 Attending casinos'
    737= '737 Travel for leisure'
    799= '799 Other active leisure'
    811= '811 Attending religious activities'
    812= '812 Other religious and spirtual activities'
    821= '821 Attending meetings or events'
    899= '899 Other organizational activity'
    991= '991 Other miscellaneous'
    992= '992 No favorite activity'
    997= '997 Refused'
    998= '998 Dont Know'
    999= '999 Not Codeable';

          VALUE OCC_CODE
1   ='1 Management Occupations: 0010-0430'
2   ='2 Business and Financial Operations Occupations:  0500-0950'
3   ='3 Computer and mathematical occupations:  1000-1240'
4   ='4 Architecture and Engineering Occupations:   1300-1560'
5   ='5 Life, Physical, and Social Science Occupations: 1600-1965'
6   ='6 Community and Social Service Occupations:   2000-2060'
7   ='7 Legal Occupations:  2100-2160'
8   ='8 Education, Training, and Library Occupations:   2200-2550'
9   ='9 Arts, Design, Entertainment, Sports, and Media Occupations: 2600-2960'
10  ='10 Healthcare Practitioners and Technical Occupations:    3000-3540'
11  ='11 Healthcare Support Occupations:    3600-3655'
12  ='12 Protective Service Occupations:    3700-3955'
13  ='13 Food Preparation and Serving Related Occupations:  4000-4160'
14  ='14 Building and Grounds Cleaning and Maintenance Occupations: 4200-4250'
15  ='15 Personal Care and Service Occupations: 4300-4650'
16  ='16 Sales and Related Occupations: 4700-4965'
17  ='17 Office and Administrative Support Occupations: 5000-5940'
18  ='18 Farming, Fishing, and Forestry Occupations:    6000-6130'
19  ='19 Construction and Extraction Occupations:   6200-6940'
20  ='20 Installation, Maintenance, and Repair Occupations: 7000-7630'
21  ='21 Production Occupations:    7700-8965'
22  ='22 Transportation and Material Moving Occupations:    9000-9750'
23  ='23 Military Specific Occupations: 9800-9830'
24  ='24 No current occ (Unemployed, no work in the last 5 years, never worked):  9920'
25 = '25 Blank field'
26 = '26 Code did not match'
94 = '94 Uncodable'
95 = '95 Never Worked Entire Life'
96 = '96 Homemaker/Raised Children'
-7 = '-7 RF'
-8 = '-8 DK'
-1 = '-1 Inapplicable'
-9 = '-9 Missing';

    Value fl_Dfac
1 = '1 Should have routed as facility but did not'
2 = '2 Routed as facility but determined not facility resident'
-1 = '-1 Inapplicable';
VALUE PE_RSLT
    -9='-9 Missing'
    -1 = '-1 Inapplicable'
    1='1 Completed'
    2='2 Attempted'
    3='3 Not attempted' ;
VALUE dosfacd /* FOR FQ2dosfacd  */
        -9= "-9 Missing"
       -8 = "-8 DK"
       -1 = "-1 INAPPLICABLE"
        1 = " 1 FREE STANDING NURSING HOME"
        2 = " 2 FREE STANDING ASSISTED LIVING FACILITY / RESIDENTIAL CARE FACILITY"
        3 = " 3 NURSING HOME AND ASSISTED LIVING FACILITY"
        4 = " 4 CONTINUING CARE RETIREMENT COMMUNITY (CCRC)"
        5 = " 5 ADULT FAMILY CARE HOME"
        6 = " 6 GROUP HOME"
        7 = " 7 BOARD AND CARE HOME / PERSONAL CARE HOME"
        8 = " 8 RETIREMENT COMMUNITY OR SENIOR HOUSING (NOT CCRC)"
        9 = " 9 INDEPENDENT LIVING"
       10 = " 10 ASSISTED AND INDEPENDENT/RETIREMENT (NO NURSING HOME)"
       11 = " 11 HOUSING (APT, CONDO, ETC.)";
        ;
    VALUE dosfaca /* FOR FQ2dosfaca */
        -9= "-9 Missing"
       -8 = "-8 DK"
       -1 = "-1 INAPPLICABLE"
        1 = " 1 INDEPENDENT LIVING / HOUSING / RETIREMENT "
        2 = " 2 ASSISTED LIVING / PERSONAL CARE"
        3 = " 3 SPECIAL CARE, MEMORY CARE, OR ALZHEIMER'S UNIT"
        4 = " 4 NURSING HOME"   ;

VALUE INAP_YN
     1 = ' 1 Yes'
     2 = ' 2 No'
    -1 = '-1 Inapplicable' ;
VALUE CENDIV /* RE1DCENSDIV - Updated for R2 - Re-Release */
    1 =  '1 Northeast Region: New England Division (ME, NH, VT, MA, RI, CT)'
    2 =  '2 Northeast Region: Middle Atlantic Division (NY, NJ, PA)'
    3 =  '3 Midwest Region: East North Central Division (OH, IN, IL, MI, WI)'
    4 =  '4 Midwest Region: West North Central Division (MN, IA, MO, ND, SD, NE, KS)'
    5 =  '5 South Region: South Atlantic Division (DE, MD, DC, VA, WV, NC, SC, GA, FL)'
    6 =  '6 South Region: East South Central Division (KY, TN, AL, MS)'
    7 =  '7 South Region: West South Central Division (AR, LA, OK, TX)'
    8 =  '8 West Region: Mountain Division (MT, ID, WY, CO, NM, AZ, UT, NV)'
    9 =  '9 West Region: Pacific Division (WA, OR, CA, AK, HI)'
    -9 = '-9 Missing';

    VALUE W000002W
      -7 = '-7 RF'
      -8 = '-8 DK'
      -1 = '-1 Inapplicable'
      -9 = '-9 Missing'
       1 = "1 MALE"
       2 = "2 FEMALE"  ;

    VALUE W000005W
     1 = ' 1 Yes'
     2 = ' 2 No'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

    VALUE R1DRESID
     1 = '1 Community '
     2 = '2 Residential Care Resident not nursing home (SP interview complete)'
     3 = '3 Residential Care Resident not nursing home (FQ only)'
     4 = '4 Nursing Home Resident';

  VALUE W200016W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 MEDICAID"
    2 = "2 MEDICARE"
    3 = "3 STATE PROGRAM"
    91 = "91 OTHER (SPECIFY)"   ;

    VALUE W200012W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 REGULAR"
    2 = "2 VARIED"  ;

  VALUE W200061W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 SEPARATION OR DIVORCE"
    2 = "2 DECEASED"
    3 = "3 MOVED ELSEWHERE"
    5 = "5 LAST INTERVIEW INFORMATION INCORRECT"
    8 = "8 OTHER REASON"   ;

  VALUE d2hrsmth
    -13= '-13 Deceased '
    -12= '-12 Zero days/wk'
    -11= '-11 Hours missing'
    -10= '-10 Days missing'
    -9 = ' -9 Days and hrs missing'
    -1 = ' -1 Inapplicable'
    -7 = ' -7 RF'
    -8 = ' -8 DK'
     0-<1  ='<1'
     1-<10 =' 1-<10'
    10-<20 ='10-<20'
    20-<30 ='20-<30'
    30-<40 ='30-<40'
    40-<60 ='40-<60'
    60-<120 ='60-<120'
    120-<180='120-<180'
    180-744='180-744 (24/7)'
     9999='9999 Not codeable, <1 hour/day' ;

  VALUE dhrsmth
    -11= '-11:hours missing'
    -10= '-10:days missing'
    -9 = '-9:days and hrs missing'
    -1 = '-1 Inapplicable'
    -7 = '-7 RF'
    -8 = '-8 DK'
     0-<1  ='<1'
     1-<10 =' 1-<10'
    10-<20 ='10-<20'
    20-<30 ='20-<30'
    30-<40 ='30-<40'
    40-<60 ='40-<60'
    60-<120 ='60-<120'
    120-<180='120-<180'
    180-744='180-744 (24/7)'
     9999='9999 Not codeable, <1 hour/day' ;

 Value dmissadd
-1='-1 not applicable'
 1='1 no flags and added at CL section'
 2='2 no flags and added at DT section'
 3='3 no flags and added at EW section'
 4='4 no flags and added at HA section'
 5='5 no flags and added at HO section'
 6='6 no flags and added at MC section'
 7='7 no flags and added at MO section'
 8='8 no flags and added at PA section'
 9='9 no flags and added at PE section'
10='10 no flags and added at SC section'
11='11 no flags and added at SN section';

Value d2mssadd
-1='-1 Inapplicable'
 0='0 no flags and added at undetermined section'
 1='1 no flags and added at CL section'
 2='2 no flags and added at DT section'
 3='3 no flags and added at EW section'
 4='4 no flags and added at HA section'
 5='5 no flags and added at HO section'
 6='6 no flags and added at MC section'
 7='7 no flags and added at MO section'
 8='8 no flags and added at PA section'
 9='9 no flags and added at PE section'
10='10 no flags and added at SC section'
11='11 no flags and added at SN section'
12='12 no flags and added at CS section'
13='13 no flags and added at HH section'
14='14 no flags and added at IS section';

Value dopage3c
 -9='-9 Missing'
 -8='-8 RF'
 -7='-7 DK'
 -1='-1 Inapplicable'
  1='1 UNDER 30'
  2='2 30-39'
  3='3 40-49'
  4='4 50-59'
  5='5 60-69'
  6='6 70-79'
  7='7 80-89'
  8='8 90 +';

 Value dopagect
-9='-9 Missing'
-8='-8 DK'
-7='-7 RF'
-1='-1 Inapplicable'
 1='1 UNDER 20'
 2='2 20-24'
 3='3 25-29'
 4='4 30-34'
 5='5 35-39'
 6='6 40-44'
 7='7 45-49'
 8='8 50-54'
 9='9 55-59'
10='10 60-64'
11='11 65-69'
12='12 70-74'
13='13 75-79'
14='14 80-84'
15='15 85-89'
16='16 90 +';


  VALUE W200008W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 UNDER 20"
    2 = "2 20-24"
    3 = "3 25-29"
    4 = "4 30-34"
    5 = "5 35-39"
    6 = "6 40-44"
    7 = "7 45-49"
    8 = "8 50-54"
    9 = "9 55-59"
    10 = "10 60-65"
    11 = "11 66-69"
    12 = "12 70-74"
    13 = "13 75-79"
    14 = "14 80-85"
    15 = "15 86-89"
    16 = "16 90-94"
    17 = "17 95-99"
    18 = "18 100 +"
  ;
    VALUE NumCigs
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    999 = '999 SP smokes less than 1 cigarette / day';


  VALUE dlmlint
    1 = '1 Last month of life interview'
   -1 = '-1 Inapplicable'     ;

  VALUE d2intvra
     1 = '1 65 to 69'
     2 = '2 70 to 74'
     3 = '3 75 to 79'
     4 = '4 80 to 84'
     5 = '5 85 to 89'
     6 = '6 90+'
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'     ;

  VALUE dad8dem
    1 = '1 DEMENTIA RESPONSE TO ANY AD8 ITEMS IN PRIOR ROUNDS'
   -1 = '-1 Inapplicable'    ;

  VALUE dwrdinon
  1 = '1 NO WORDS REMEMBERED'
   -1 = '-1 Inapplicable'
     -9 = '-9 Missing'     ;

  VALUE dwrdirre
    1 = '1 REFUSED WORD RECALL TASK'
   -1 = '-1 Inapplicable'
      -9 = '-9 Missing'     ;

 VALUE A0001AB
      1 = "1 AM"
      2 = "2 PM"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0002WA
      1 = "1 Yes, there is space to set up the walking course"
      2 = "2 No, there is not space to set up the walking course"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0004WA
      1 = "1 None"
      2 = "2 Cane"
      3 = "3 Walker or rollator"
      9 = "9 Other, specify"
     -1 = '-1 Inapplicable'
     -7 = '-7 RF'
     -8 = '-8 DK'
     -9 = '-9 Missing';

 VALUE A0004CH
      1 = "1 No, chair stand not completed"
      2 = "2 Yes, chair stand completed"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0008CH
      1 = "1 With arms"
      2 = "2 Without arms"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

 VALUE A0014CH
      1 = "1 1 Chair stand completed"
      2 = "2 2 Chair stands completed"
      3 = "3 3 Chair stands completed"
      4 = "4 4 Chair stands completed"
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';

VALUE BA1SS
    1 = '1 Eligible and recorded result for SxS Balance'
    2 = '2 Eligible and no recorded result for SxS Balance'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1STAN
    1 = '1 Eligible and recorded result for Semi Tandem Balance'
    2 = '2 Eligible and no recorded result for Semi Tandem Balance'
    3 = '3 Not administered because did not complete prior balance test'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1TAN
    1 = '1 Eligible and recorded result for full tandem balance'
    2 = '2 Eligible and no recorded result for full tandem balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1OP
    1 = '1 Eligible and recorded result for one leg eyes open balance'
    2 = '2 Eligible and no recorded result for one leg eyes open balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE BA1CL
    1 = '1 Eligible and recorded result for one leg eyes closed balance'
    2 = '2 Eligible and no recorded result for one leg eyes closed balance'
    3 = '3 Not administered because did not complete prior balance tests'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE WA1WLK
    1 = '1 Eligible and recorded result for walking course'
    2 = '2 Eligible and no recorded result for walking course'
    4 = '4 Not Eligible due to exclusion criteria'
    5 = '5 Not Eligible on exclusion criteria but recorded result (SP changed mind)'
    -1 = '-1 Inapplicable '
    -9 = '-9 Missing';

VALUE CH1SCH
    1 = '1 Eligible and recorded result for single chair stand'
    2 = '2 Eligible and no recorded result for single chair stand'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE CH1RSH
    1 = '1 Eligible and recorded result for repeated chair stand'
    2 = '2 Eligible and no recorded result for repeated chair stand'
    3 = '3 Not administered because did not complete single chair stand w/o arms'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE GR1GRIP
    1 = '1 Eligible and recorded result for grip strength'
    2 = '2 Eligible and no recorded result for grip strength'
    4 = '4 Not Eligible due to exclusion criteria'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE WC1WAIST
    1 = '1 Eligible and recorded result for waist circumference'
    2 = '2 Eligible and no recorded result for waist circumference'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

VALUE PK1PEAK
    1 = '1 Eligible and recorded result for peak air flow'
    2 = '2 Eligible and no recorded result for peak air flow'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

 VALUE RGT_LFT
   1 = '1 Right'
   2 = '2 Left'
  -1 = '-1 Inapplicable'
  -9 = '-9 Missing';

 VALUE PERSON
    1 = '1 Interviewer'
    2 = '2 Sample person'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing';

 VALUE STAND
     1 = '1 Standing'
     2 = '2 Sitting'
     3 = '3 Lying down'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

 VALUE EFFORT
      1 = '1 Full effort'
      2 = '2 Less effort for health reason'
      3 = '3 Less effort for other reason'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing';
    VALUE WORDREC
        1 = ' 1 LIST 1'
        2 = ' 2 LIST 2'
        3 = ' 3 LIST 3'
       -1 = '-1 Inapplicable '
       -9 = '-9 Missing';
    VALUE WORDRE_N
        -1 = '-1 Inapplicable'
        -2 = '-2 Proxy says cannot ask SP'
        -3 = '-3 Proxy says can ask SP but SP unable to answer'
        -7 = '-7 SP refused activity'
        -9 = '-9 Missing';

        VALUE  DMH_GRP
            1 = "1 Help started"
            2 = "2 Help ended"
            3 = "3 Help both interviews with gap"
            4 = "4 Help both interviews with no gap"
            5 = "5 Help between interviews only (month ended missing)"
            6 = "6 No help either interview or between"
           11 = "11 Help started (month started missing)"
           21 = "21 Help ended (month ended missing)"
           41 = "41 Help both interviews (DK whether gap)"
           61 = "61 No help either interview (DK whether help between)"
           -9 = "-9 Missing"
           -1 = "-1 Inapplicable"
         -999 = "-999 Not determined" ;

        VALUE  DMU_GRP
            1 = "1 Use started"
            2 = "2 Use ended"
            3 = "3 Use both interviews with gap"
            4 = "4 Use both interviews with no gap"
            5 = "5 Use between interviews only (month ended missing)"
            6 = "6 No use either interview or between"
           11 = "11 Use started (month started missing)"
           21 = "21 Use ended (month ended missing)"
           41 = "41 Use both interviews (DK whether gap)"
           61 = "61 No use either interview (DK whether use between)"
           -9 = "-9 Missing"
           -1 = "-1 Inapplicable"
         -999 = "-999 Not determined" ;

       VALUE  DS_GRP
            1 = "1 Help started"
            2 = "2 Help ended"
            3 = "3 Help both interviews with gap"
            4 = "4 Help both interviews with no gap"
            5 = "5 Help between interviews only"
            6 = "6 No help either interview or between"
           11 = "11 Help started (month started missing)"
           21 = "21 Help ended (month ended missing)"
           41 = "41 Help both interviews (DK whether gap)"
           61 = "61 No help either interview (DK whether help between)"
           -9 = "-9 Missing"
           -1 = "-1 Inapplicable"
         -999 = "-999 Not determined" ;

        VALUE  DMDSINTV
            0 = "0 Less than 1 month"
            1 = "1 Month"
            2 = "2 Months"
            3 = "3 Months"
            4 = "4 Months"
            5 = "5 Months"
            6 = "6 Months"
            7 = "7 Months"
            8 = "8 Months"
            9 = "9 Months"
           10 = "10 Months"
           11 = "11 Months"
           12 = "12 Months"
           13 = "13 Months"
           14 = "14 Months"
           15 = "15 Months"
           16 = "16 Months"
           17 = "17 Months"
           18 = "18 Months"
           19 = "19 Months"
           20 = "20 Months"
           21 = "21 Months"
           22 = "22 Months"
           23 = "23 Months"
           24 = "24 Months"
           90 = "90 Last round disputed"
           -1 = "-1 Inapplicable"
           -7 = "-7 Refused"
           -8 = "-8 Dont know"
           -9 = "-9 Missing" ;

        VALUE  DMDS_DUR
            0 = "0 Less than 1 month"
            1 = "1 Month"
            2 = "2 Months"
            3 = "3 Months"
            4 = "4 Months"
            5 = "5 Months"
            6 = "6 Months"
            7 = "7 Months"
            8 = "8 Months"
            9 = "9 Months"
           10 = "10 Months"
           11 = "11 Months"
           12 = "12 Months"
           13 = "13 Months"
           14 = "14 Months"
           15 = "15 Months"
           16 = "16 Months"
           17 = "17 Months"
           90 = "90 Last round disputed"
           -1 = "-1 Inapplicable"
           -7 = "-7 Refused"
           -8 = "-8 Dont know"
           -9 = "-9 Missing"
          -10 = "-10 Not ascertained"
          -12 = "-12 Outside of range"
          -13 = "-13 None"
         -999 = "-999 Not determined" ;

        VALUE  DMDSFLG
            -1 = "-1 Inapplicable"
             1 = "1 No SP interview last round"
             2 = "2 Died and month death missing"
             3 = "3 Died <=1 month after last interview"
             4 = "4 Died 12-13 months after last interview"
             5 = "5 Died and not mobile (fl2notmobile=1)"
             6 = "6 Died and not alert (fl2notalert =1)"
             7 = "7 Skipped 1 or more help questions" ;
        VALUE  DMDS3FLG
            -1 = "-1 Inapplicable"
             1 = "1 No SP interview last round"
             2 = "2 Died and month death missing"
             3 = "3 Died <=1 month after last interview"
             4 = "4 Died 12-13 months after last interview"
             5 = "5 Died and not mobile (fl3notmobile=1)"
             6 = "6 Died and not alert (fl3notalert =1)"
             7 = "7 Skipped 1 or more help questions" ;
  VALUE SP30051W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 EXCELLENT"
    2 = "2 VERY GOOD"
    3 = "3 GOOD"
    4 = "4 FAIR"
    5 = "5 POOR"
    6 = "6 DOES NOT APPLY/NO CARE IN LAST MONTH OF LIFE"
  ;
    VALUE SP3019aW
       -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 JANUARY"
    2 = "2 FEBRUARY"
    3 = "3 MARCH"
    4 = "4 APRIL"
    5 = "5 MAY"
    6 = "6 JUNE"
    7 = "7 JULY"
    8 = "8 AUGUST"
    9 = "9 SEPTEMBER"
    10 = "10 OCTOBER"
    11 = "11 NOVEMBER"
    12 = "12 DECEMBER"
    90 = "90 LAST INTERVIEW INFORMATION INCORRECT"
  ;
  VALUE RACEHISP
        1 = ' 1 White, non-hispanic'
        2 = ' 2 Black, non-hispanic'
        3 = ' 3 Other (Am Indian/Asian/Native Hawaiian/Pacific Islander/other specify), non-Hispanic'
        4 = ' 4 Hispanic'
        5 = ' 5 More than one DKRF primary'
        6 = ' 6 DKRF'
       -9 = '-9 Missing';

/* The following may not need to be included on the public release file but are
        needed for internal Westat File processing  */

    VALUE SPPB_MISSING
       -7 = '-7 RF'
   -8 = '-8 DK'
   -9 = '-9 Missing'
    -1="-1 Inapplicable"
    1="1 PROXY INTERVIEW"
    2="2 MISSING WALK AND REPEAT CHAIR AND BALANCE"
    3="3 MISSING WALK AND REPEAT CHAIR"
    4="4 MISSING WALK AND BALANCE"
    5="5 MISSING REPEAT CHAIR AND BALANCE"
    6="6 MISSING WALK"
    7="7 MISSING REPEAT CHAIR"
    8="8 MISSING BALANCE"
    9="9 NO SPACE"
    10="10 NO CHAIR"
    11="11 NO SPACE WALK AND NO CHAIR"
    12="12 NO SPACE WALK AND NON-SAFETY MISSING"
    13="13 NO CHAIR AND NON-SAFETY MISSING"
    14="14 NON-SAFETY WALK"
    15="15 NON-SAFETY CHAIR"
    16="16 NON-SAFETY BALANCE"
    17="17 NON-SAFETY WALK AND CHAIR"
    18="18 NON-SAFETY WALK AND BALANCE"
    19="19 NON-SAFETY CHAIR AND BALANCE"
    20="20 NON SAFETY WALK AND CHAIR AND BALANCE";

    VALUE QUARTILES
-9="-9 Missing"
-1="-1 Inapplicable"
;
  VALUE SP30025W
       -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 FREE-STANDING (DETACHED) SINGLE HOUSE"
    2 = "2 SINGLE HOUSE BUT ATTACHED TO OTHERS (ROW HOUSE, TOWNHOUSE, DUPLEX, TRIPLEX, OR TRIPLE DECKER)"
    3 = "3 MOBILE HOME OR TRAILER"
    4 = "4 MULTI-UNIT (2+) BUILDING"
    91 = "91 OTHER (SPECIFY)"
  ;
    VALUE SP30046W
        -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
     1 = "1 AT SP'S HOME"
      2 = "2 IN A HOSPITAL"
      3 = "3 IN A NURSING HOME"
      4 = "4 IN A HOSPICE RESIDENCE"
      5 = "5 AT SOMEONE ELSE'S HOME"
      91 = "91 SOMEWHERE ELSE (SPECIFY)"
  ;
    VALUE SP30076W
       -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
      1 = "1 YES"
      2 = "2 NO"
      7 = "7 YES, DOESNT KNOW HOW TO USE"
  ;
    VALUE W300151W
     -7 = '-7 RF'
     -8 = '-8 DK'
     -1 = '-1 Inapplicable'
     -9 = '-9 Missing'
      1 = "1 VERY GOOD"
      2 = "2 GOOD"
      3 = "3 FAIR"
      4 = "4 POOR"
    5 = "5 VERY POOR"  ;

      VALUE SP30076H
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
    95 = "95 NO USUAL NUMBER OF HOURS OR DIFFERENT FROM DAY TO DAY"  ;
      VALUE SP30076G
       -7 = '-7 RF'
       -8 = '-8 DK'
       -1 = '-1 Inapplicable'
       -9 = '-9 Missing'
    95 = "95 NO USUAL TIME OR DIFFERENT FROM DAY TO DAY"  ;
          VALUE SP30076I
           -7 = '-7 RF'
           -8 = '-8 DK'
           -1 = '-1 Inapplicable'
           -9 = '-9 Missing'
        95 = "95 NO USUAL NUMBER OF HOURS OR DIFFERENT FROM NIGHT TO NIGHT"  ;
          VALUE SP30076J
           -7 = '-7 RF'
           -8 = '-8 DK'
           -1 = '-1 Inapplicable'
           -9 = '-9 Missing'
        95 = "95 NO USUAL TIME OR DIFFERENT FROM NIGHT TO NIGHT"  ;
          VALUE SP30076K
           -7 = '-7 RF'
           -8 = '-8 DK'
           -1 = '-1 Inapplicable'
           -9 = '-9 Missing'
		   0 = "0 LESS THAN AN HOUR"
        90 = "90 FELL ASLEEP RIGHT AWAY"  
        95 = "95 NO USUAL AMOUNT OF TIME TO FALL ASLEEP OR DIFFERENT FROM NIGHT TO NIGHT"  ;
          VALUE SP30155W
           -7 = '-7 RF'
           -8 = '-8 DK'
           -1 = '-1 Inapplicable'
           -9 = '-9 Missing'
            1 = "1 NAPS PLANNED"
            2 = "2 FELL ASLEEP WITHOUT MEANING TO"
            3 = "3 BOTH (SOME PLANNED/SOME NOT)"
  ;
  VALUE SP30120W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 OFTEN"
    2 = "2 SOMETIMES"
    3 = "3 RARELY"
    4 = "4 NEVER"  ;
Value HOURSF
 -13='-13 SP deceased/section not administered'
 -12='-12 Valid skip/staff'
 -11='-11 Hours missing'
 -10='-10 Days missing'
  -9='-9 Days and hrs missing'
  -1='-1 Inapplicable'
 0-  1='0-<1'
 1.01- 10='1-<10'
10.01- 20='10-<20'
20.01- 30='20-<30'
30.01-40='30-<40'
40.01-60='40-<60'
60.01-120='60-<120'
120.01-180='120-<180'
180.01-744='180-744 (24/7)'
9999='9999 Not codeable, <1 hour/day';
  VALUE SP30120W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 OFTEN"
    2 = "2 SOMETIMES"
    3 = "3 RARELY"
    4 = "4 NEVER"
  ;
  VALUE SP30118W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "1 A LOT"
    2 = "2 SOME"
    3 = "3 A LITTLE"
    4 = "4 NOT AT ALL"
  ;
  VALUE SP30141W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "less than $27,600,"
    2 = "$27,600-$41,999,"
    3 = "$42,000-$63,999,"
    4 = "$64,000-$107,999, or"
    5 = "$108,000 or more?"
  ;

  VALUE SP30142W
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    1 = "less than $14,000,"
    2 = "$14,000-$21,999,"
    3 = "$22,000-$35,999,"
    4 = "$36,000-$48,999, or"
    5 = "$49,000 or more?"
  ;
  VALUE INVENT
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
		104="104-Arthritis"
		107="107-Lung Disease"
		109="109-Dementia or Alzheimer's disease"
		110="110-Cancer"
		113="113-Other serious disease, illness, health problem"
		114="114-Knee surgery/problem"
		115="115-Hip repair or replacement/problem"
		117="117-Back or Spine Surgery/problem"
		121="121-Sleep Problems"
		201="201-Hearing problems"
		202="202-Sight problems"
		205="205-Pain"
		301="301-Breathing problems"
		302="302-Upper body strength movement"
		303="303-Lower body strength movement"
		304="304-Low energy"
		305="305-Balance or coordination problems"
		306="306-Walking distances"
		307="307-Climbing stairs"
		308="308-Lifting and carrying items"
		309="309-Kneeling"
		310="310-Bending"
		311="311-Reaching"
		312="312-Opening Jars"
		313="313-Grasping"
		401="401-Memory"
		501="501-Getting out of bed"
		502="502-Getting around inside"
		503="503-Getting outside"
		504="504-Travel/transportation"
		601="601-Eating"
		602="602-Washing"
		603="603-Toileting"
		604="604-Dressing"
		605="605-Grooming"
		701="701-Laundry"
		702="702-Shopping"
		703="703-Cooking"
		705="705-Money matters"
		706="706-Indoor cleaning and maintenance"
		707="707-Outdoor cleaning and maintenance"
		801="801-Medications"
		802="802-Doctor visits"
		804="804-Other medical self-care"
		1211="1211-Working"
		1442="1442-Walking/exercising pets"
		1451="1451-Vehicle repair and maintenance"
		1461="1461-Appliance tool, and toy use, set-up, repair, & maintenance"
		1462="1462-Computer use, set-up, repair, maintenance, and education"
		1473="1473-Household organization"
		1512="1512-Looking after someone else"
		1611="1611-Socializing and communicating with others-in person"
		1612="1612-Socializing and communication with others by talking on telephone"
		1613="1613-Attending or hosting party, wedding or social occasions"
		1614="1614-Reading and sorting through the mail"
		1621="1621-Watch television and movies"
		1631="1631-Games & puzzles"
		1641="1641-Arts and crafts, collecting, and hobbies, making music"
		1642="1642-Reading"
		1643="1642-Writing (personal, not on computer)"
		1644="1644-Listening to recorded music or radio"
		1711="1711-Playing/practicing sports or taking physical activity class/lessons"
		1712="1712-Walking/jogging for exercise or pleasure or working out"
		1713="1713-Other outdoor recreation activities"
		1813="1813-Religious & spiritual volunteer activities"
		1901="1901-Other, no existing code"
		1998="1998-Don't know"
		1999="1999-Refused/blank";

VALUE Imp_Flg
   -7 = '-7 RF'
   -8 = '-8 DK'
   -1 = '-1 Inapplicable'
   -9 = '-9 Missing'
    0 = "0 No"
    1 = "1 Yes"  ;
run;

proc format;
value homeboundf
	1 = "Homebound"
	2 = "Semi-homebound"
	3 = "Not homebound";
value homebound3f
	1 = "Homebound"
	2 = "Semi-homebound (never by self)"
	3 = "Semi-homebound (needs help or has difficulty)"
	4 = "Not homebound";
value assistance_numf
	1 = "No assistance"
	2 = "1-2 activities"
	3 = "=>3 activities"
	9 = "NA/missing";
value with_assistf
	1 = "With assistance"
	2 = "Without assistance"
	9 = "NA/missing";
value maritalf
	1 = "Married or living with a partner"
	2 = "Separated or divored"
	3 = "Widowed"
	4 = "Never married"
	9 = "DKRF";
value relationshipf
	1 = "Spouse or Partner"
	2 = "Adult Child"
	3 = "Other relative"
	4 = "Friend or neighbor"
	5 = "Paid caregiver"
	6 = "Other non-relative";
value cg_paidf
	1 = "Family and unpaid caregivers"
	2 = "Paid caregivers";
value relationshipf
	1 = "Spouse or Partner"
	2 = "Adult Child"
	3 = "Other relative"
	4 = "Friend or neighbor"
	5 = "Paid caregiver"
	6 = "Other non-relative";
value cg_numf
	1 = "0"
	2 = "1"
	3 = "2"
	4 = "3 or more";
value helpers_catf
	1 = "0"
	2 = "1-3"
	3 = "4-6"
	4 = "7 or more";
run;


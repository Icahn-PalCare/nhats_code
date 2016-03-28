libname NSOC '\\home\users$\lawk02\Documents\NHATS\Zipped\NSOC_Round_1_National_Study_of_Caregiving_Files_SAS';

/*  NSOC_Round_1_Combined_PROC_FORMAT_Statement.sas  */
PROC FORMAT;

  VALUE NSOC001W
    1 = "1 MALE"
    2 = "2 FEMALE"  ;

  VALUE NSOC002W
    1 = "1 SAMPLE PERSON"
    2 = "2 SPOUSE/PARTNER"
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
    26 = "26 STEPDAUGHTER'S SON/DAUGHTER"
    27 = "27 STEPSON'S SON/DAUGHTER"
    28 = "28 DAUGHTER-IN-LAW'S SON/DAUGHTER"
    29 = "29 SON-IN-LAW'S SON/DAUGHTER"
    30 = "30 BOARDER/RENTER"
    31 = "31 LIVE-IN HOUSEKEEPER/EMPLOYEE"
    32 = "32 ROOMMATE"
    33 = "33 EX-WIFE/EX-HUSBAND"
    34 = "34 BOYFRIEND/GIRLFIEND"
    35 = "35 NEIGHBOR"
    36 = "36 FRIEND"
    37 = "37 STAFF PERSON AT THE PLACE SP LIVES"
    38 = "38 CO-WORKER"
    39 = "39 MINISTER, PRIEST, OR OTHER CLERGY"
    40 = "40 PSYCHIATRIST, PSYCHOLOGIST, COUNSELOR, OR THERAPIST"
    91 = "91 OTHER RELATIVE"
    92 = "92 OTHER NONRELATIVE"  ;

  VALUE NSOC003W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
    1 = "1 YES"
    2 = "2 NO"  ;
/*
  VALUE NSOC004W
    1 = "Yes"
    2 = "No"  ;

  VALUE NSOC005W
    1 = "Yes"
    2 = "No"  ;

  VALUE NSOC006W
    1 = "Yes"
    2 = "No"  ;

  VALUE NSOC007W
    1 = "Yes"
    2 = "No"  ;*/

  VALUE NSOC008W
    1 = "1 RECORD INTERVIEW"
    2 = "2 DO NOT RECORD INTERVIEW"  ;

  VALUE NSOC009W
    1 = "1 Continue"  ;

  VALUE NSOC010W
     -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
   1 = "1 EVERY DAY"
    2 = "2 MOST DAYS"
    3 = "3 SOME DAYS"
    4 = "4 RARELY"
    5 = "5 NEVER"  ;

  VALUE NSOC011W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 YES"
    2 = "2 NO"
    7 = "7 SP DOES NOT TAKE ANY PRESCRIBED MEDICINES"  ;

  VALUE NSOC012W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 EVERY DAY"
    2 = "2 MOST DAYS"
    3 = "3 SOME DAYS"
    4 = "4 RARELY"  ;

  VALUE NSOC013W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 WALK"
    2 = "2 DRIVE"
    3 = "3 SOMEONE DRIVES ME"
    4 = "4 TAXI"
    5 = "5 BUS"
    6 = "6 SUBWAY/TRAIN/LIGHT RAIL"
    7 = "7 TRAIN"
    8 = "8 AIRPLANE/FLY"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE NSOC014W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 MINUTES"
    2 = "2 HOURS"  ;

  VALUE NSOC015W
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

  VALUE NSOC016W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 REGULAR SCHEDULE"
    2 = "2 VARIED"  ;

  VALUE NSOC017W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 LESS THAN HALF"
    2 = "2 ABOUT HALF"
    3 = "3 MORE THAN HALF"
    4 = "4 NEARLY ALL"  ;

  VALUE NSOC018W
     -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
   1 = "1 NUMBER OF YEARS"
    2 = "2 DATE"  ;

  VALUE NSOC019W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 A LOT"
    2 = "2 SOME"
    3 = "3 A LITTLE"
    4 = "4 NOT AT ALL"  ;

  VALUE NSOC020W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 VERY MUCH"
    2 = "2 SOMEWHAT"
    3 = "3 NOT SO MUCH"  ;

  VALUE NSOC021W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 A LITTLE DIFFICULT"
    2 = "2"
    3 = "3"
    4 = "4"
    5 = "5 VERY DIFFICULT"  ;

  VALUE NSOC022W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 VERY IMPORTANT"
    2 = "2 SOMEWHAT IMPORTANT"
    3 = "3 NOT SO IMPORTANT"  ;

  VALUE NSOC023W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 EXCELLENT"
    2 = "2 VERY GOOD"
    3 = "3 GOOD"
    4 = "4 FAIR"
    5 = "5 POOR"  ;

  VALUE NSOC024W
    1 = "1 SKIN CANCER"
    2 = "2 BREAST CANCER"
    3 = "3 PROSTATE"
    4 = "4 OTHER TYPE OF CANCER (SPECIFY)"  ;

  VALUE NSOC025W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 NOT AT ALL"
    2 = "2 SEVERAL DAYS"
    3 = "3 MORE THAN HALF THE DAYS"
    4 = "4 NEARLY EVERY DAY"  ;

  VALUE NSOC026W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 AGREE STRONGLY"
    2 = "2 AGREE SOMEWHAT"
    3 = "3 DISAGREE SOMEWHAT"
    4 = "4 DISAGREE STRONGLY"  ;

  VALUE NSOC027W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 MARRIED"
    2 = "2 LIVING WITH A PARTNER"
    3 = "3 SEPARATED"
    4 = "4 DIVORCED"
    5 = "5 WIDOWED"
    6 = "6 NEVER MARRIED"  ;

  VALUE NSOC028W
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

  VALUE NSOC029W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 YES"
    2 = "2 NO"
    3 = "3 RETIRED/DON'T WORK ANYMORE"  ;

  VALUE NSOC030W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 YES, LOOKING FOR A JOB"
    2 = "2 YES, ON LAYOFF"
    3 = "3 NO"
    4 = "4 RETIRED/DON'T WORK ANYMORE"  ;

  VALUE NSOC031W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 DAYTIME"
    2 = "2 SOME OTHER SCHEDULE"  ;

  VALUE NSOC032W
     -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 ENTER NUMBER OF HOURS"
    2 = "2 ENTER NUMBER OF DAYS"  ;

  VALUE NSOC033W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 8-HOUR DAYS"
    2 = "2 SOMETHING LESS"
    3 = "3 SOMETHING MORE"  ;

  VALUE NSOC034W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 ENTER OCCUPATION"
    2 = "2 CurrentOccupationSame"
    97 = "3 NEVER WORKED ENTIRE LIFE"
    98 = "4 HOMEMAKER/RAISED CHILDREN/WORKED IN THE HOME"  ;

  VALUE NSOC035W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 MEDICARE"
    2 = "2 MEDICAID"
    3 = "3 PRIVATE HEALTH INSURANCE"
    4 = "4 TRICARE/CHAMPVA"
    91 = "91 OTHER (SPECIFY)"  ;

  VALUE NSOC036W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "` LESS THAN"
    2 = "1 MORE THAN"  ;

  VALUE NSOC037W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 MORE THAN $1,000"
    2 = "2 LESS THAN $1,000"  ;

  VALUE NSOC038W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 MORE THAN $500"
    2 = "2 LESS THAN $500"  ;

  VALUE NSOC039W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 ENGLISH"
    2 = "2 SPANISH"
    91 = "91 OTHER"  ;

  VALUE NSOC040W
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing' 
    1 = "1 Yes"  ;

    VALUE RFDK
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable (nursing home resident or residential care no FQ)'
    -9 = '-9 Missing';

	VALUE RF997DK
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing'
	997 = '997 Number of hours vary each week';

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

	value OCC2010F /*with categories for distribution checking*/
       0010-0430 = "0010-0430 Management Occupations"
       0500-0950 = "0500-0950 Business and Financial Operations Occupations"
       1000-1240 = "1000-1240 Computer and Mathematical Occupations"
       1300-1560 = "1300-1560 Architecture and Engineering Occupations"
       1600-1965 = "1600-1965 Life, Physical, and Social Science Occupations"
       2000-2060 = "2000-2060 Community and Social Service Occupations"
       2100-2160 = "2100-2160 Legal Occupations"
       2200-2550 = "2200-2550 Education, Training, and Library Occupations"
       2600-2960 = "2600-2960 Arts, Design, Entertainment, Sports, and Media Occupations"
       3000-3540 = "3000-3540 Healthcare Practitioners and Technical Occupations"
       3600-3655 = "3600-3655 Healthcare Support Occupations"
       3700-3955 = "3700-3955 Protective Service Occupations"
       4000-4160 = "4000-4160 Food Preparation and Serving Related Occupations"
       4200-4250 = "4200-4250 Building and Grounds Cleaning and Maintenance Occupations"
       4300-4650 = "4300-4650 Personal Care and Service Occupations"
       4700-4965 = "4700-4965 Sales and Related Occupations"
       5000-5940 = "5000-5940 Office and Administrative Support Occupations"
       6000-6130 = "6000-6130 Farming, Fishing, and Forestry Occupations"
       6200-6940 = "6200-6940 Construction and Extraction Occupations"
       7000-7630 = "7000-7630 Installation, Maintenance, and Repair Occupations"
       7700-8965 = "7700-8965 Production Occupations"
       9000-9750 = "9000-9750 Transportation and Material Moving Occupations"
       9800-9830 = "9800-9830 Military Specific Occupations"
       9920 = "9920 Unemployed, with no work experience in the last 5 years or earlier or never worked"
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

	value OCC20_F /*with categories for distribution checking*/
       1 = " 1  0010-0430 Management Occupations"
       2 = " 2  0500-0950 Business and Financial Operations Occupations"
       3 = " 3  1000-1240 Computer and Mathematical Occupations"
       4 = " 4  1300-1560 Architecture and Engineering Occupations"
       5 = " 5  1600-1965 Life, Physical, and Social Science Occupations"
       6 = " 6  2000-2060 Community and Social Service Occupations"
       7 = " 7  2100-2160 Legal Occupations"
       8 = " 8  2200-2550 Education, Training, and Library Occupations"
       9 = " 9  2600-2960 Arts, Design, Entertainment, Sports, and Media Occupations"
       10 = "10  3000-3540 Healthcare Practitioners and Technical Occupations"
       11 = "11  3600-3655 Healthcare Support Occupations"
       12 = "12  3700-3955 Protective Service Occupations"
       13 = "13  4000-4160 Food Preparation and Serving Related Occupations"
       14 = "14  4200-4250 Building and Grounds Cleaning and Maintenance Occupations"
       15 = "15  4300-4650 Personal Care and Service Occupations"
       16 = "16  4700-4965 Sales and Related Occupations"
       17 = "17  5000-5940 Office and Administrative Support Occupations"
       18 = "18  6000-6130 Farming, Fishing, and Forestry Occupations"
       19 = "19  6200-6940 Construction and Extraction Occupations"
       20 = "20  7000-7630 Installation, Maintenance, and Repair Occupations"
       21 = "21  7700-8965 Production Occupations"
       22 = "22  9000-9750 Transportation and Material Moving Occupations"
       23 = "23  9800-9830 Military Specific Occupations"
       24 = "24  9920 Unemployed, with no work experience in the last 5 years or earlier or never worked"
	   25 = "25  Blank field"
	   94 = "94  Uncodeable"
	   97 = "97  Never worked entire life"
	   98 = "98  Homemaker / raised children"
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';

	value $OCCF /*with categories for distribution checking*/
       "0010"-"0430" = "0010-0430 Management Occupations"
       "0500"-"0950" = "0500-0950 Business and Financial Operations Occupations"
       "1000"-"1240" = "1000-1240 Computer and Mathematical Occupations"
       "1300"-"1560" = "1300-1560 Architecture and Engineering Occupations"
       "1600"-"1965" = "1600-1965 Life, Physical, and Social Science Occupations"
       "2000"-"2060" = "2000-2060 Community and Social Service Occupations"
       "2100"-"2160" = "2100-2160 Legal Occupations"
       "2200"-"2550" = "2200-2550 Education, Training, and Library Occupations"
       "2600"-"2960" = "2600-2960 Arts, Design, Entertainment, Sports, and Media Occupations"
       "3000"-"3540" = "3000-3540 Healthcare Practitioners and Technical Occupations"
       "3600"-"3655" = "3600-3655 Healthcare Support Occupations"
       "3700"-"3955" = "3700-3955 Protective Service Occupations"
       "4000"-"4160" = "4000-4160 Food Preparation and Serving Related Occupations"
       "4200"-"4250" = "4200-4250 Building and Grounds Cleaning and Maintenance Occupations"
       "4300"-"4650" = "4300-4650 Personal Care and Service Occupations"
       "4700"-"4965" = "4700-4965 Sales and Related Occupations"
       "5000"-"5940" = "5000-5940 Office and Administrative Support Occupations"
       "6000"-"6130" = "6000-6130 Farming, Fishing, and Forestry Occupations"
       "6200"-"6940" = "6200-6940 Construction and Extraction Occupations"
       "7000"-"7630" = "7000-7630 Installation, Maintenance, and Repair Occupations"
       "7700"-"8965" = "7700-8965 Production Occupations"
       "9000"-"9750" = "9000-9750 Transportation and Material Moving Occupations"
       "9800"-"9830" = "9800-9830 Military Specific Occupations"
       "9920" = "9920 Unemployed, with no work experience in the last 5 years or earlier or never worked"
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';


	value OCC_SI /*with categories for distribution checking*/

		11	= '11 Agriculture, Forestry, Fishing and Hunting'
		21	= '21 Mining, Quarrying, and Oil and Gas Extraction'
		22	= '22 Utilities'
		23	= '23 Construction'
		31-33	='31-33 Manufacturing'
		42	= '42 Wholesale Trade'
		44-45 = '44-45 Retail Trade'
		48-49 = '48-49 Transportation and Warehousing'
		51	= '51 Information'
		52	= '52 Finance and Insurance'
		53	= '53 Real Estate and Rental and Leasing'
		54	= '54 Professional, Scientific, and Technical Services'
		55	= '55 Management of Companies and Enterprises'
		56	= '56 Administrative and Support and Waste Management and Remediation Services'
		61	= '61 Educational Services'
		62	= '62 Health Care and Social Assistance'
		71	= '71 Arts, Entertainment, and Recreation'
		72	= '72 Accommodation and Food Services'
		81	= '81 Other Services (except Public Administration)'
		92	= '92 Public Administration'
	   94 = "94  Uncodeable"
		99	= '99 None'
    -7 = '-7 RF'
    -8 = '-8 DK'
    -1 = '-1 Inapplicable'
    -9 = '-9 Missing';


    VALUE dnsoc
1 = '1 Eligible and interviewed' 
2 = '2 Eligible and not interviewed phone number provided'
3 = '3 Eligible and not interviewed SP refused'  
4 = '4 Eligible and not interviewed other'
5 = '5 Eligible and not fielded for NSOC'
6 = '6 5+ caregivers and not sampled'
7 = '7 Ineligible'
-1 = '-1 Inapplicable';

    VALUE fdnsoc
1 = '1 SP NSOC Eligible'
-1 = '-1 Inapplicable';
    VALUE fdintdys
1 ='1 30 days or less'
2 ='2 31-60 days'
3 ='3 61-90 days'
4 ='4 91-120 days'
5 ='5 121 days or more'
-1 = '-1 Inapplicable';

	VALUE $fdTRCcd
'CO'  =	'CO Complete Interview '
'IE'=	'IE Ineligible Interview'
'I2'=	'I2 Ineligible - error'
'I3'=	'I3 Ineligible - other'
'LH'=	'LH Final Language Problem - Hearing/Speech'
'LP'=	'LP Final Language Problem'
'MC'=	'MC Max Call'
'NA'=	'NA No Answer'
'ND'=	'ND Subject deceased'
'NL'=	'NL Not Locatable'
'NM'=	'NM No Answer: Answering Machine'
'NP'=	'NP Not available in Field Period'
'NS'=	'NS Subject Sick'
'NX'=	'NX Eligible, not fielded'
'RB'=	'RB Final refusal'
'RF'=	'RF Refusal - preload from SP interview'
'RP'=	'RP Final refusal - inbound call'
'OO'=	'OO Oth Out of scope- SP deceased';

value relationshipf
	1 = "Spouse or Partner"
	2 = "Child"
	3 = "Other relative"
	4 = "Friend or neighbor"
	5 = "Paid caregiver"
	6 = "Other non-relative";

value help_yrf
	1 = "1 or less"
	2 = "2-3 years"
	3 = "4-5 years"
	4 = "6 or more years"
	5 = "NA";

RUN;



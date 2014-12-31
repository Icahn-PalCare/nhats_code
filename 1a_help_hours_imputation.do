/*this section uses the SP and OP R1,2&3 data files and imputes
hours of help provided to SP per methods in NHATS Technical Paper #7

Variables from this dataset are then brought in to the SP R 1,2,3 dataset
and also the NSOC caregiver dataset*/

capture log close
clear all
set more off

local logs C:\data\nhats\logs\
//local logs /Users/rebeccagorges/Documents/data/nhats/logs/
log using `logs'help_hours_imputation-LOG.txt, text replace

local r1raw C:\data\nhats\round_1\
local r2raw C:\data\nhats\round_2\
local r3raw C:\data\nhats\round_3\
local work C:\data\nhats\working
local r1s C:\data\nhats\r1_sensitive\
local r2s C:\data\nhats\r2_sensitive\

/*local r1raw /Users/rebeccagorges/Documents/data/nhats/round_1/
local r2raw /Users/rebeccagorges/Documents/data/nhats/round_2/
local r3raw /Users/rebeccagorges/Documents/data/nhats/round_3/
local work /Users/rebeccagorges/Documents/data/nhats/working
local r1s /Users/rebeccagorges/Documents/data/nhats/r1_sensitive/
local r2s /Users/rebeccagorges/Documents/data/nhats/r2_sensitive/ 
 */
 
cd `work'

//
use round_1_1.dta, clear

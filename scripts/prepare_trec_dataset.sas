********************************************************;
* Title: prepare_trec_dataset.sas
* Purpose: QC and prepare clean dataset for phenotypes
*           for TREC subjects.
********************************************************;

********************************************************;
* Establish TREC options and libraries
********************************************************;

%include "\\rfa01\bwh-sleepepi-home\projects\cohorts\TREC\SAS\TREC options and libnames.sas";

libname nsrrdata "&newtrecpath\nsrr-prep\_datasets";

libname obf "&newtrecpath\nsrr-prep\_ids";

%let release = 0.2.0;

********************************************************;
* Import TREC data
********************************************************;

*previously combined data;

data trec_in;
  set nsrrdata.trec;
run;

data trec_out;
  set trec_in;

  *clean SAS missing codes out of numeric variables;
  if bp1dias1 in (.m,.n,.i) then bp1dias1 = "";
  if bp1dias2 in (.m,.n,.i) then bp1dias2 = "";
  if bp1dias3 in (.m,.n,.i) then bp1dias3 = "";
  if bp1hr1 in (.m,.n,.i) then bp1hr1 = "";
  if bp1hr2 in (.m,.n,.i) then bp1hr2 = "";
  if bp1hr3 in (.m,.n,.i) then bp1hr3 = "";
  if bp1sys1 in (.m,.n,.i) then bp1sys1 = "";
  if bp1sys2 in (.m,.n,.i) then bp1sys2 = "";
  if bp1sys3 in (.m,.n,.i) then bp1sys3 = "";
  if bp1time in (.m,.n,.i) then bp1time = "";
  if bp2dias1 in (.m,.n,.i) then bp2dias1 = "";
  if bp2dias2 in (.m,.n,.i) then bp2dias2 = "";
  if bp2dias3 in (.m,.n,.i) then bp2dias3 = "";
  if bp2hr1 in (.m,.n,.i) then bp2hr1 = "";
  if bp2hr2 in (.m,.n,.i) then bp2hr2 = "";
  if bp2hr3 in (.m,.n,.i) then bp2hr3 = "";
  if bp2sys1 in (.m,.n,.i) then bp2sys1 = "";
  if bp2sys2 in (.m,.n,.i) then bp2sys2 = "";
  if bp2sys3 in (.m,.n,.i) then bp2sys3 = "";
  if bp2time in (.m,.n,.i) then bp2time = "";
  if sleepy_adult in (.m,.n,.i) then sleepy_adult = "";

  *variable list taken from TREC covariates indicator in Excel data dictionary;
  keep
    nslp
    mslp
    cslp
    nslpend
    nslpwk
    mslpend
    mslpwk
    cslpwk
    cslpend
    mseff
    mseffend
    mseffwk
    pctfat_houtkooper
    pctfat_kotler
    personid
    ethnicity
    racewhite
    raceblack
    raceasian
    racepacific
    raceamerind
    male
    age
    race
    essscore
    sleepy
    nmiss_adult
    essscore_adult
    sleepy_adult
    pbmi_mom
    pbmi_dad
    htcm
    wtkg
    bp1sys1
    bp1dias1
    bp1hr1
    bp1sys2
    bp1dias2
    bp1hr2
    bp1sys3
    bp1dias3
    bp1hr3
    bp2sys1
    bp2dias1
    bp2hr1
    bp2sys2
    bp2dias2
    bp2hr2
    bp2sys3
    bp2dias3
    bp2hr3
    bp1time
    bp2time
    bpsys
    missbpsys
    bpdias
    missbpdias
    bphr
    missbphr
    bmi
    waz
    wtpct
    bmiz
    bmipct
    haz
    htpct
    bmicat
    bmige85
    bmige95
    nutndays
    mrigrams
    mrikcal
    mrifat
    mritcho
    mripro
    mnmeal
    mnsnack
    msnackgrams
    msnackkcal
    msnackfat
    msnacktcho
    msnackpro
    slpprdp
    slp_eff
    timest1p
    timest1
    timest2p
    timest2
    times34p
    timest34
    timeremp
    timerem
    ai_all
    rdi3p
    oahi3
    oai0p
    pctlt95
    pctlt90
    pctlt85
    pctlt80
    pctlt75
    pctlt70
    avgsat
    minsat
    yevrsmk
    yevrsmkstaa
    yevrsmkstpa
    ycursmk
    ydrkcaf
    ystatus
    wd_bedtime
    wd_waketime
    wd_slpmid
    wd_slpdur
    wd_slpdur_hr
    we_bedtime
    we_waketime
    we_slpmid
    we_slpdur
    we_slpdur_hr
    ysleeptime_min
    ysleeptime_hr
    ysleeplatency
    ywd_slpdur
    ywe_slpdur
    ysleeptime_s
    ywd_napdur
    ywe_napdur
    ynaptime_s
    yacwlk
    yacjog
    yacrun
    yacbike
    yacten
    yacswim
    yacaer
    yacloin
    yacvig
    yacarm
    yacleg
    yacother
    waistcm
    waistpctcat
    waistgt75
    waistge75
    waistgt90
    waistge90
;
run;


*create obfuscated ID -- dataset #18 on sleepdata.org so IDs follow 18xxxxxx format;
*create outside of SAS in Excel, then re-import IDs for merging into final dataset;

/*
*do once;
proc import datafile="\\rfa01\bwh-sleepepi-home\projects\cohorts\TREC\nsrr-prep\_ids\ccshs_obfuscated_ids.csv"
  out=obf
  dbms=csv
  replace;
run;

data obf.ccshs_obfuscated_ids;
  set obf;
run;
*/

*bring list of obfuscated IDs in and merge with TREC dataset;
data obf_ids;
  set obf.ccshs_obfuscated_ids;
run;

proc sort data=obf_ids;
  by personid;
run;

*make trec_final by merging in obf_pptid;
data trec_final;
  length obf_pptid 8.;
  merge trec_out (in=a) obf_ids (in=b);
  by personid;

  if a;

  *create combined race variable (1=w, 2=b, 3=o);
  if race = 1 then race3 = 1;
  else if race = 2 then race3 = 2;
  else if race ne . then race3 = 3;

  *add visit variable;
  visit = 3;

  *only keep obf_pptid in final dataset;
  drop personid racewhite -- raceamerind race;
run;

*sort by obf_pptid before exporting;
proc sort data=trec_final;
  by obf_pptid;
run;


*export dataset;
proc export data=trec_final outfile="\\rfa01\bwh-sleepepi-home\projects\cohorts\TREC\nsrr-prep\_releases\&release\ccshs-trec-dataset-&release..csv" dbms=csv replace;
run;

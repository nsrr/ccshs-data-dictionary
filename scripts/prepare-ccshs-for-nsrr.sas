*******************************************************************************;
* Program           : prepare-ccshs-for-nsrr.sas
* Project           : National Sleep Research Resource (sleepdata.org)
* Author            : Michael Rueschman (MR)
* Date Created      : 20180206
* Purpose           : Prepare Cleveland Children's Sleep and Health Study data
*                       for deposition on sleepdata.org.
* Revision History  :
*   Date      Author    Revision
*   20190530  mr447     Add variables for 0.4.0 dataset
*   20170206  mr447     Clean up SAS program 
*******************************************************************************;

*******************************************************************************;
* Establish CCSHS options and libraries
*******************************************************************************;
  %include "\\rfawin\bwh-sleepepi-home\projects\cohorts\TREC\SAS\TREC options and libnames.sas";

  libname nsrrdata "&newtrecpath\nsrr-prep\_datasets";
  libname obf "&newtrecpath\nsrr-prep\_ids";

  %let release = 0.8.0;

*******************************************************************************;
* Import CCSHS-TREC data
*******************************************************************************;
  data trec_in;
    set nsrrdata.trec;

    format _all_;
  run;

  data trec_out;
    set trec_in;

    *create new AHI variables for icsd3;
    ahi_a0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      carbp + carop + canbp + canop +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      carbp + carop + canbp + canop +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_o0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                    carbp + carop + canbp + canop ) / slpprdp;

    *create ODI indices;
    if minremp ne 0 then do;
      odi3 = ((dsrem3 * minremp) + (dsnr3 * (slpprdp - minremp))) / slpprdp;
      odi4 = ((dsrem4 * minremp) + (dsnr4 * (slpprdp - minremp))) / slpprdp;
    end;
    else do; 
      odi3 = dsnr3;
      odi4 = dsnr4;
    end;

    *createm PLMs w/ arousal per hour of sleep index;
    if slpprdp gt 0 then do;
      avgplma = 60*(plmaslp/slpprdp);
    end;

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

    *add sleep maintenance efficiency;
    if timebedp ne 0 then do;
        if slplatp > . then slp_maint_eff = 100*(slpprdp/(timebedp-slplatp));
        else if slplatp = . then slp_maint_eff = 100*(slpprdp/timebedp);
    end;

    *add new decimal hour variables;
    format stloutp_dec stonsetp_dec stlonp_dec 8.2;
    if stloutp < 43200 then stloutp_dec = stloutp/3600 + 24;
    else stloutp_dec = stloutp/3600;
    if stonsetp < 43200 then stonsetp_dec = stonsetp/3600 + 24;
    else stonsetp_dec = stonsetp/3600;
    stlonp_dec = stlonp/3600 + 24;

    *apply formats;
    format 
      bp1time
      bp2time 
      wd_bedtime
      wd_waketime
      wd_slpmid
      we_bedtime
      we_waketime
      we_slpmid
      time5. 
      stlonp 
      stloutp 
      stonsetp 
      time8.;

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
      slp_maint_eff
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
      hrembp3
      hrop3
      hnrbp3
      hnrop3
      hrembp4
      hrop4
      hnrbp4
      hnrop4
      hremba3
      hroa3
      hnrba3
      hnroa3
      hremba4
      hroa4
      hnrba4
      hnroa4
      carbp
      carop
      canbp
      canop
      oarbp
      oarop
      oanbp
      oanop
      ahi_a0h3--ahi_c0h4a
      odi3
      odi4
      ydifal
      yexsl
      ypara
      ytirfa
      yslpco
      ycafdr
      ynorst
      yydifal
      yyexsl
      yypara
      yytirfa
      yyslpco
      yycafdr
      yynorst
      ynitwu
      ydrclass
      ydrhw
      yalert
      ytired
      ytrgetup
      yfallback
      yhelpgetup
      ymoreslp
      ytv
      yread
      yeat
      ywork
      ytalkface
      ytalkphon
      yfrnd
      ycanc
      ydep
      ydiab
      yhtn
      yins
      yinsdx
      sitread
      watchtv
      inact
      passeng
      lying
      sittalk
      sitquiet
      homework
      driving
      yevrsmkno
      yevrsn
      ymnthsn
      yplmsdx
      yplms
      ydxsa
      slewake
      overall
      stg1stg2pr
      stg2stg3pr
      remnrempr
      arunrel
      remarunrel
      respevpr
      apnhyppr
      slplatp
      remlaip
      remlaiip
      waso
      STLOUTP 
      STLONP 
      stonsetp
      stlonp_dec
      stloutp_dec
      stonsetp_dec
      avgplm
      avgplma
      ;
  run;

  /*

  proc means data=trec_out;
    var avgplm avgplm2;
  run;

  */

  *bring list of obfuscated IDs in and merge with TREC dataset;
  data obf_ids;
    set obf.ccshs_obfuscated_ids;
  run;

  proc sort data=obf_ids;
    by personid;
  run;

  *make trec_final by merging in nsrrid;
  data trec_final;
    length nsrrid 8.;
    merge trec_out (in=a) obf_ids (in=b);
    by personid;

    if a;

    *create combined race variable (1=w, 2=b, 3=o);
    if race = 1 then race3 = 1;
    else if race = 2 then race3 = 2;
    else if race ne . then race3 = 3;

    *add visit variable;
    visit = 3;

    *only keep nsrrid in final dataset;
    drop personid racewhite -- raceamerind;
  run;


  *sort by nsrrid before exporting;
  proc sort data=trec_final;
    by nsrrid;
  run;

*******************************************************************************;
* create harmonized datasets ;
*******************************************************************************;
data trec_final_harmonized;
  set trec_final;
*demographics
*age;
*use age;
  format nsrr_age 8.2;
  if age gt 89 then nsrr_age = 90;
  else if age le 89 then nsrr_age = age;

*age_gt89;
*use age;
  format nsrr_age_gt89 $100.; 
  if age gt 89 then nsrr_age_gt89='yes';
  else if age le 89 then nsrr_age_gt89='no';

*sex;
*use male;
  format nsrr_sex $100.;
    if male = 1 then nsrr_sex='male';
  else if male = 0 then nsrr_sex='female';

*race;
*use race;
    format nsrr_race $100.;
    if race = 1 then nsrr_race = 'white';
    else if race = 2 then nsrr_race = 'black or african american';
    else if race = 3 then nsrr_race = 'asian';
  else if race = 4 then nsrr_race = 'american indian or alaska native';
  else if race = 5 then nsrr_race = 'native hawaiian or other pacific islander';
  else if race = 6 then nsrr_race = 'multiple';
  else  nsrr_race = 'not reported';

*ethnicity;
*use ethnicity;
  format nsrr_ethnicity $100.;
    if ethnicity = 1 then nsrr_ethnicity = 'hispanic or latino';
    else if ethnicity = 2 then nsrr_ethnicity = 'not hispanic or latino';
  else if ethnicity = . then nsrr_ethnicity = 'not reported';

*anthropometry
*bmi;
*use bmi;
  format nsrr_bmi 10.9;
  nsrr_bmi = bmi;

*clinical data/vital signs
*bp_systolic;
*use bpsys;
  format nsrr_bp_systolic 8.2;
  nsrr_bp_systolic = bpsys;

*bp_diastolic;
*use bpdias;
  format nsrr_bp_diastolic 8.2;
  nsrr_bp_diastolic = bpdias;

*lifestyle and behavioral health
*current_smoker;
*use ycursmk and yevrsmk;
  format nsrr_current_smoker $100.;
  if yevrsmk = 0  then nsrr_current_smoker = 'no';
  else  if ycursmk = 0 then nsrr_current_smoker = 'no';
  else if ycursmk = 1  then nsrr_current_smoker = 'yes';
  else if ycursmk = .  then nsrr_current_smoker = 'not reported';

*ever_smoker;
  *use yevrsmk;
  format nsrr_ever_smoker $100.;
  if yevrsmk = 0 then nsrr_ever_smoker = 'no';
  else if yevrsmk = 1 then nsrr_ever_smoker = 'yes';
  else if yevrsmk = .  then nsrr_ever_smoker = 'not reported';

*polysomnography;
*nsrr_ahi_hp3u;
*use ahi_a0h3;
  format nsrr_ahi_hp3u 8.2;
  nsrr_ahi_hp3u = ahi_a0h3;

*nsrr_ahi_hp3r_aasm15;
*use ahi_a0h3a;
  format nsrr_ahi_hp3r_aasm15 8.2;
  nsrr_ahi_hp3r_aasm15 = ahi_a0h3a;
 
*nsrr_ahi_hp4u_aasm15;
*use ahi_a0h4;
  format nsrr_ahi_hp4u_aasm15 8.2;
  nsrr_ahi_hp4u_aasm15 = ahi_a0h4;
  
*nsrr_ahi_hp4r;
*use ahi_a0h4a;
  format nsrr_ahi_hp4r 8.2;
  nsrr_ahi_hp4r = ahi_a0h4a;
 
*nsrr_tst_f1;
*use slpprdp;
  format nsrr_tst_f1 8.2;
  nsrr_tst_f1 = slpprdp;
  
*nsrr_phrnumar_f1;
*use ai_all;
  format nsrr_phrnumar_f1 8.2;
  nsrr_phrnumar_f1 = ai_all;  

*nsrr_flag_spsw;
*use slewake;
  format nsrr_flag_spsw $100.;
    if slewake = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if slewake = 0 then nsrr_flag_spsw = 'full scoring';
    else if slewake = 8 then nsrr_flag_spsw = 'unknown';
  else if slewake = . then nsrr_flag_spsw = 'unknown';  

*nsrr_ttleffsp_f1;
*use ai_all;
  format nsrr_ttleffsp_f1 8.2;
  nsrr_ttleffsp_f1 = slp_eff;  
  
*nsrr_pctdursp_s1;
*use timest1p;
  format nsrr_pctdursp_s1 8.2;
  nsrr_pctdursp_s1 = timest1p;

*nsrr_pctdursp_s2;
*use timest2p;
  format nsrr_pctdursp_s2 8.2;
  nsrr_pctdursp_s2 = timest2p;

*nsrr_pctdursp_s3;
*use times34p;
  format nsrr_pctdursp_s3 8.2;
  nsrr_pctdursp_s3 = times34p;

*nsrr_pctdursp_sr;
*use timeremp;
  format nsrr_pctdursp_sr 8.2;
  nsrr_pctdursp_sr = timeremp;
 
*nsrr_ttllatsp_f1;
*use slplatp;
  format nsrr_ttllatsp_f1 8.2;
  nsrr_ttllatsp_f1 = slplatp;
 
*nsrr_begtimbd_f1;
*use stloutp;
  format nsrr_begtimbd_f1 time8.;
  nsrr_begtimbd_f1 = stloutp;

*nsrr_begtimsp_f1;
*use stonsetp;
  format nsrr_begtimsp_f1 time8.;
  nsrr_begtimsp_f1 = stonsetp;

*nsrr_endtimbd_f1;
*use stlonp;
  format nsrr_endtimbd_f1 time8.;
  nsrr_endtimbd_f1 = stlonp;

*nsrr_ttlmefsp_f1;
*use slp_maint_eff;
  format nsrr_ttlmefsp_f1 8.2;
  nsrr_ttlmefsp_f1 = slp_maint_eff;  

*nsrr_cai;
*use cai0p;
  format nsrr_cai 8.2;
  nsrr_cai = 60*(canbp+canop+carbp+carop)/slpprdp;

*nsrr_oai;
*use oai0p;
  format nsrr_oai 8.2;
  nsrr_oai = oai0p;

*nsrr_oahi_hp4u;
*use ahi_o0h4;
  format nsrr_oahi_hp4u 8.2;
  nsrr_oahi_hp4u = ahi_o0h4;

*nsrr_oahi_hp3u;
*use ahi_o0h3;
  format nsrr_oahi_hp3u 8.2;
  nsrr_oahi_hp3u = ahi_o0h3;

*nsrr_avglvlsa;
*use avgsat;
  format nsrr_avglvlsa 8.2;
  nsrr_avglvlsa = avgsat;

*nsrr_minlvlsa;
*use minsat;
  format nsrr_minlvlsa 8.2;
  nsrr_minlvlsa = minsat;
  
  keep 
    nsrrid
    visit
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_bmi
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_tst_f1
    nsrr_phrnumar_f1
    nsrr_flag_spsw
    nsrr_pctdursp_s1
    nsrr_pctdursp_s2
    nsrr_pctdursp_s3
    nsrr_pctdursp_sr
    nsrr_ttleffsp_f1
    nsrr_ttllatsp_f1
    nsrr_begtimbd_f1
    nsrr_begtimsp_f1
    nsrr_endtimbd_f1
    nsrr_ttlmefsp_f1
    nsrr_cai
  nsrr_oai
  nsrr_oahi_hp4u
  nsrr_oahi_hp3u
  nsrr_avglvlsa
  nsrr_minlvlsa
    ;
run;

*******************************************************************************;
* checking harmonized datasets ;
*******************************************************************************;

/* Checking for extreme values for continuous variables */

proc means data=trec_final_harmonized;
VAR   nsrr_age
    nsrr_bmi
    nsrr_bp_systolic
    nsrr_bp_diastolic
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_tst_f1
    nsrr_phrnumar_f1
    nsrr_pctdursp_s1
    nsrr_pctdursp_s2
    nsrr_pctdursp_s3
    nsrr_pctdursp_sr
    nsrr_ttleffsp_f1
    nsrr_ttlmefsp_f1
    nsrr_ttllatsp_f1
  nsrr_cai
  nsrr_oai
  nsrr_oahi_hp4u
  nsrr_oahi_hp3u
  nsrr_avglvlsa
  nsrr_minlvlsa
  ;
run;

/* Checking categorical variables */

proc freq data=trec_final_harmonized;
table   nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
      nsrr_current_smoker
        nsrr_ever_smoker
    nsrr_flag_spsw;
run;


*******************************************************************************;
* make all variable names lowercase ;
*******************************************************************************;
  options mprint;
  %macro lowcase(dsn);
       %let dsid=%sysfunc(open(&dsn));
       %let num=%sysfunc(attrn(&dsid,nvars));
       %put &num;
       data &dsn;
             set &dsn(rename=(
          %do i = 1 %to &num;
          %let var&i=%sysfunc(varname(&dsid,&i));    /*function of varname returns the name of a SAS data set variable*/
          &&var&i=%sysfunc(lowcase(&&var&i))         /*rename all variables*/
          %end;));
          %let close=%sysfunc(close(&dsid));
    run;
  %mend lowcase;

  %lowcase(trec_final);
  %lowcase(trec_final_harmonized);




*******************************************************************************;
* create permanent dataset ;
*******************************************************************************;
  data nsrrdata.nsrr_trec_&sasfiledate;
    set trec_final;
  run;

*******************************************************************************;
* export to csv ;
*******************************************************************************;
  proc export data=trec_final
    outfile="\\rfawin\bwh-sleepepi-home\projects\cohorts\TREC\nsrr-prep\_releases\&release\ccshs-trec-dataset-&release..csv"
    dbms=csv
    replace;
  run;

    proc export data=trec_final_harmonized
    outfile="\\rfawin\bwh-sleepepi-home\projects\cohorts\TREC\nsrr-prep\_releases\&release\ccshs-trec-harmonized-&release..csv"
    dbms=csv
    replace;
  run;

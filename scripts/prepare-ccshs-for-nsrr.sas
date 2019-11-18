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

  %let release = 0.6.0;

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
      ;
  run;

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
    drop personid racewhite -- raceamerind race;
  run;

  *sort by nsrrid before exporting;
  proc sort data=trec_final;
    by nsrrid;
  run;

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

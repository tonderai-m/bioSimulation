breed [ Icebergs Iceberg]
breed [ Romaine Romain]

globals [
  Mass-Processed Mass-Entering MassPackaged
  conveyor-speed phase  FC-0-1 ConseContaminatedBag
  ListTIS lettuce-counter romaine-counter iceberg-counter
  Contamination-counter counter-L
  counter-L-2 speed-in-tank
  Throughput Temperature
  Current-Packaged-Bacteria Bacteria-At-The-Source
  ContaminatedBag time time-counter-1  time-counter-2 time-counter-3
  TimeVariable lettuce-352 lettuce-s lettuce-s5
  FC-0 FC COD-0 COD CummulativeMass_Vs_Volume
  L6-Counter L7-Counter
  L7.1-Counter L7.2-Counter
  decays last-count
  U1 Turminate-BL
  counter
  watch-parameter watch-parameter-2
  plot-color plot-color-2 CFU-Water]

turtles-own [
  LogCFU mass CFU
  time-created
  a-t-e-shaker-dewatering a-t-shaker-dewatering-s
  a-t-e-tank time-in-tank time-system-s-tank
  timeInSystem-h time-system-s
  Ft Ho  Umax LogCFU_0 CFU_0 CFU_Max
  bin_ct PackagedTime
  time-entering-centrifuge time-in-centrifuge
  Process-Initiate-1 Process-Initiate-2
 time-entering-washtank count-1 ]

patches-own [
  p-LogCFU  p-CFU
  bin_ct1  Conveyor#
  Location Location-a Location-b location-at
  Cross-Contamination-Location
  all-location
  Facililty-Location-ID ]

links-own [ c-flow ]

to setup
  clear-all
  set-default-shape turtles "circle"
  Lettuce-Facility-Setup
  Setup-Facility-Temperature setup-chlorinaiton
  show-labels
  set-globals
  Initial-Contamination-of-patches
  Setup-Baseline
  reset-ticks
end

to go
     Grow-Bacteria
  if ( Minutes > 0 and count turtles = 0 )[stop]
  Do-Experiment-Buchholz Do-Baseline
  Lettuce-Ispection Calclculate-TimeIn-System
   Cross_Contamination Change-CFU-to-LogCFU
  Facility-Temperature
  Sprouting-Lettuce Chopping-process-Manual-Trim
  Transporting-Process-Conveyor Color-Change-Conveyor
  Shredding-process conveyor-process
  Washing-Processs Excecute-chlorinaiton
  setup-time-system-s-tank setup-time-system-s
  Death-in-water Transfer-in-water
  Shaker-Dewatering-Processs Centrifugation-Process
  Package-area Package
   show-labels
  Contact-Time-calculation

   Change-p-CFU-to-p-CFU
  tick
end

to-report amount-purches
 report amount-p 1 + amount-p 2 + amount-p 3 + amount-p 4
end

to-report amount-purches-2
 report amount-p 6 + amount-p 7
end

to Do-Experiment-Buchholz
  if ( Baseline = True ) [ set Experiment-Buchholz False ]
  if Experiment-Buchholz  [
   if (Mass-entering <= 22.5  ) [ set Contamination-Level  0 set probality-Of-Contamination  0 set SD 0 ]
   if (Mass-entering  > 22.5 and  Mass-entering  <= 45 ) [ set Contamination-Level  Contamination-Buchholz set probality-Of-Contamination  1 set SD 0 ]
   if (Mass-entering > 45  ) [ set Contamination-Level  0 set probality-Of-Contamination  0 ]
   set Mass-to-Process 90.5 + 22.5 + 22.5
   set Allow-Chlorination False
   set allow-transfer-in-water True
   set Cross_Contamination? True ]
end

to Do-Baseline
  ifelse Baseline  [
  set Mass-to-Process  45 * 36 ;; 45 kg/m * 60 min * 8 hour shift * 3 days of opration Max time length
  set Contamination-Level Field-Contamination set probality-Of-Contamination  Probability-BL
  set Allow-Chlorination True
  set allow-transfer-in-water True
  set Cross_Contamination? True
 if Mass-entering = 45 * 36   [ set Turminate-BL  True ] ]
[ if Mass-entering >=  Mass-to-Process  [ set Turminate-BL  True ] ]
end

to-report Field-Contamination
 report Contamination-BL ; + log ( ( random-normal 0.108  0.019  ) * 235 / 100) 10
end

to Lettuce-Facility-Setup
  let x1  19 let x2  11  let x3 9
  ;; Gray patch where lettuce inicially sprout
  ask patches with [pxcor = -1 and pycor = 0  ] [ set pcolor 5 set location 0 ]
  ;; Green patches representing people
  ask patches with [pxcor = 1 and pycor > -3 and pycor < 3 ] [ set Facililty-Location-ID 1 set all-location 1 set Location 1 set Cross-Contamination-Location 1  if (pycor) mod 2 = 0 [ set pcolor green ]  ]
  ;; ask patches with [pxcor = 1 and pycor = 1  ] [ set pcolor green set Location 1 set Cross-Contamination-Location 1 set Facililty-Location-ID 1 ]
  ;; Red and black checkered pattern     cuttingboard
  ask patches with [pxcor <= 5 and pxcor > 2 and pycor < 3 and pycor > -3  ][  set Facililty-Location-ID 2 set all-location 1 set Location 2 set Cross-Contamination-Location 1  if (pxcor + pycor) mod 2 = 0 [ set pcolor red ] ]
  ;; Shredding-proccess size is reduced to 8 peaces yellow patches
  ask patches with [pxcor <= 10 and pxcor > 6 and pycor < 5 and pycor > -5  ][ set Facililty-Location-ID 1 set all-location 1 set Location 3 set Cross-Contamination-Location 1  if (pxcor + pycor) mod 2 =  0 [ set pcolor sky ] ]
  ; Convayor
  ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][ set Facililty-Location-ID 2 set all-location 1 set Location 4 set conveyor# 1 set Cross-Contamination-Location 1   if (pxcor + pycor) mod 2 = 0 [ set pcolor white ] ]
  ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][ set Facililty-Location-ID 2 set all-location 1 set Location 4 set conveyor# 2 set Cross-Contamination-Location 1 if (pxcor + pycor) mod 2 = 1 [ set pcolor black] ]
  ;; Wash-Area size
  ask patches with [pxcor <= 32 and pxcor > 20 and pycor < 15 and pycor > -15  ][ set Facililty-Location-ID 1 set all-location 1 set Location 5.1 set Location-a 5 set Location-b 5 set pcolor cyan ] ;; set pcolor white
  ask patches with [pxcor <= 44 and pxcor > 32 and pycor < 15 and pycor > -15  ][ set Facililty-Location-ID 1 set all-location 1 set Location 5.2 set Location-a 5 set Location-b 5 set pcolor cyan ]
  ask patches with [pxcor = 45 and pycor < 15 and pycor > -15 ] [ set Location 5.3 set Location-b 5 set all-location 1  set pcolor cyan ]
  ;;  ask patches with [location-a = 5] [ set pcolor orange ]
  ;; Shaker-dewatering
  ask patches with [pxcor <= 61 and pxcor > 46 and pycor < 15 and pycor > -15  ][set Facililty-Location-ID 2 set all-location 1 set Location 6 set Cross-Contamination-Location 1 set location-at 1   if (pxcor + pycor) mod 2 =  0 [ set pcolor brown] ]
  ;; Centrifugation Area
  ask patches with [pxcor <= 77 and pxcor > 62 and pycor < 13 and pycor > 0  ][ set Facililty-Location-ID 1 set all-location 1 set Location 7 set location-at 1 set Cross-Contamination-Location 1  if (pxcor + pycor) mod 2 =  0 [ set pcolor violet ] ]
  ;; Packaging Area
  ask patches with [pxcor <= 77 and pxcor > 62 and pycor < -2 and pycor > -13  ][ set Location 8 set all-location 1 set location-at 1 if (pxcor + pycor) mod 2 =  0 [ set pcolor magenta ] ]
  ask patches with [pxcor <= 80 and pxcor > 77 and pycor < -4 and pycor > -11  ][ set Location 9 set all-location 1 set location-at 1 set pcolor pink ]
end

to Transporting-Process-Conveyor
  let x1  19 let x2  11  let x3 9
  if-else phase < conveyor-speed / 2
  [ ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][if (pxcor + pycor) mod 2 = 0 [ set pcolor black ]]
    ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][if (pxcor + pycor) mod 2 = 1 [ set pcolor white ]]]
  [ ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][if (pxcor + pycor) mod 2 = 0 [ set pcolor white ]]
    ask patches with [ pxcor <= x1 and pxcor > x2 and pycor < x3 and pycor > -1 * x3 ][if (pxcor + pycor) mod 2 = 1 [ set pcolor black ]]]
end

to setup-time-system-s-tank
 ask turtles [ set time-system-s-tank  time-in-tank / Time-In-System-Ratio * 3600 ]
end


to-report cq
  report 0.02
end

to-report pq
  report 0.095
end

to Setup-Baseline
    if Baseline  [  set Set-Temperature 7
     set Temp-Offset  3
     set Contamination-Level Contamination-BL
    ask up-to-n-of ( amount-purches * ask-patches )  patches with [ Location = 1 or Location = 3 or Location = 2 or Location = 4 and Baseline ] [ set p-CFU 10 ^ (random-normal p-L1-to-L4-nc p-sd-1) set pcolor blue]
   ask up-to-n-of ( amount-purches-2 * ask-patches-2 )  patches with [ Location = 6 or Location = 7 and Baseline ] [ set p-CFU 10 ^ (random-normal p-L6-to-L7-nc p-sd-2) set pcolor blue] ]
end

to set-globals
  set   speed-in-tank 0.4 ;; Transitional Probability
  set  conveyor-speed 100
  set  watch-parameter -1
  ask patches with [ Cross-Contamination-Location = 1 ] [ set p-cfu 10 ^ (-10 - 0.0001 +  random-float 0.0001 )]
  set  watch-parameter-2 -1
  set Turminate-BL  False
  set  ListTIS [ ]
  if ( Experiment-Buchholz = True ) [ set Baseline False ]
  random-seed behaviorspace-run-number
end

to setup-time-system-s
  ask turtles [ set time-system-s timeInSystem-h * 3600 ]
end

to  Color-Change-Conveyor
  set phase phase + 1                                                           ;; The phase cycles from 0 to ticks-per-cycle, then starts over.
  if phase mod conveyor-speed  = 0 [ set phase 0 ]
end

to Sprouting-Lettuce
 ask patches with [  pxcor = -1 and pycor = 0 and not any? turtles-here and Turminate-BL = false ][
    sprout 1 [
       ifelse (random-float 1 < iceberg-to-romaine) [ set breed Romaine set romaine-counter romaine-counter + 1 ]
      [ set breed Icebergs set iceberg-counter iceberg-counter + 1 ]
      set mass 500
      set color blue
      set shape "circle"
      set Umax  ( 0.0169 * (Temperature - 4.012) ) ^ 2 ;; NOTE THAT THIS A NEGATIVE
      set Ho  Umax  * (189.285 * exp(-0.110 * Temperature) - 3.617  )
      set CFU ifelse-value ( random-float 1  < probality-Of-Contamination )  [ 10 ^ (random-normal Contamination-Level SD) ] [ random-float Detection-Limit ]
      set logCFU log CFU 10
      set LogCFU_0 logCFU
      set CFU_0 CFU
      set CFU_Max 8.676 / (1 + exp ( - ( Temperature - 3.52 ) / 2.876 ))
      if CFU > Detection-Limit [set color red set counter-L counter-L + 1 ]
      if CFU <=  Detection-Limit [set color blue set counter-L-2 counter-L-2 + 1 ]
      if ( counter-L = 1 and color = red )[ set watch-parameter who set plot-color one-of base-colors]
      if ( counter-L-2 = 1 and color = blue )[ set watch-parameter-2 who set plot-color-2 one-of base-colors]
      if (color = red)  [set Contamination-counter Contamination-counter + 1 ]
      if ( lettuce-counter <= floor ( Mass-to-Process / 0.5 )) [ set Turminate-BL False ]
      set lettuce-counter lettuce-counter + 1
      set time-created ticks
      set Mass-Entering Mass-Entering + mass / 1000 ]]
end

to Lettuce-Ispection
  ask turtles [ stop-inspecting-dead-agents ]
end

to plot-highlighted
 ask turtles with [ who = watch-parameter ] [ plotxy time-system-s  logCFU  set-plot-pen-color plot-color
    ifelse switch [  watch-me INSPECT one-of turtles with [ color = red and who = watch-parameter ] ] [ reset-perspective  stop-inspecting one-of turtles with [ color = red and who = watch-parameter ] ] ]
end

to plot-highlighted-2
; ask turtles with [ who = watch-parameter-2 ] [ plotxy time-system-s  logCFU  set-plot-pen-color plot-color
;    ifelse switch-2 [  watch-me  INSPECT one-of turtles with [ color = blue and who = watch-parameter-2 ] ] [ reset-perspective  stop-inspecting one-of turtles with [ color = blue and who = watch-parameter-2 ] ] ]
end

to Chopping-process-Manual-Trim
  ;; Move lettuce to manual trim process
  if count turtles with [ Location = 1 ]  < 2 [ ask turtles with [ pcolor = 5 ] [ move-to one-of patches with [ Location = 1 and not any? turtles-here  ]]]
  ;;  Chopping process use hatch to duplicate lettucesF
  if llamount 1 > 0 and ticks mod 4 = 0 and (( amount-p 2 - llamount 2 * Manual-Trim_#) >= llamount 1) = true [
    ask turtles with [ Location = 1 ][hatch Manual-Trim_# [set size size / 2 set mass mass / ( Manual-Trim_# + 1 )  move-to one-of patches with [ Location = 2  and not any? turtles-here  ]  ]
      move-to one-of patches with [ Location = 2  and not any? turtles-here ] set mass mass / ( Manual-Trim_# + 1 ) set size size / 2 ] ]
end

to Shredding-process
  if llamount 2  > 0 and ticks mod 3 = 0 [
    ask turtles with [ Location = 2 ][hatch Shred_# [ move-to one-of patches with
      [ Location = 3    ] set size size / 2  set mass mass / ( Shred_# + 1 ) ]  ;; and not any? turtles-here
         move-to one-of patches with [ Location = 3  ] set size size / 2  set mass mass / ( Shred_# + 1 ) ] ]
end

to conveyor-process
  if llamount 3  > 0 and ticks mod 5 = 0 and (( ( amount-p 4 ) / 2  - llamount 4 ) >= llamount 3) = true [                                                                          ;;
    ask turtles with [ Location = 3 ] [ move-to one-of patches with [ pcolor = white  and not any? turtles-here  ]  ]]
end

to setup-chlorinaiton
  set FC-0 R-1
  set COD-0 286.43
  set FC FC-0
  set COD COD-0
  set last-count amount-p 5 + amount-p 5.3
  set decays 0
end

to Excecute-chlorinaiton
  start-timer
  chlorineprocess
end

to-report chlorine-patches
report count patches with [ pcolor = cyan ]
end

to chlorineprocess
   if mod-28-number_Of_processes =  0 and time4 = 1[
    if counter = 0 [ set FC-0 R-2 ]
    if counter = 1 [ set FC-0 R-3 set counter 0]
    set counter counter + 1 ]

 set COD COD-0 + 0.6524 * Washed-Mass-kg  ;; fit R^2 0.9907
  if ticks mod ticks-12-m-intval = 0 and Allow-Chlorination [ set FC-0-1 FC-0  ]
  if Allow-Chlorination = False [ set FC-0-1 0 ]
  let  kc 0.0017
  let beta-c 4.828 * 10 ^ (-4)
  let ko/2  62.5 / 2
  let Oo 312.5
  let t ( time-passed-m mod 12 )
  if ( time-stoper > 0) [ set FC  max ( list 0 ( FC-0-1 * e ^ ( -(kc * ( t ) + beta-c * ( ( ko/2 )  * ( t ) + Oo ) * t )) ) ) ]
end

to-report   Processed-Mass
  report ( ( number_Of_processes  ) * (19500 / 45000) * 45  )
end

to-report   Detection-Limit
  report 1.0E-10
end

to start-timer
  ifelse mod-28-number_Of_processes = 0 [ set time-counter-1 ticks   ]
  [ set time-counter-1 0  ]
  ifelse mod-28-number_Of_processes != 0  [  set time-counter-2 ticks
  set time-counter-3  time-counter-2 - time-counter-1][ set time-counter-2 0 ]
end

to Washing-Processs
  let washtank-input-location (patches with [pxcor = 21 and pycor < 15 and pycor > -15 ] )
  if llamount 4  > 0 and ticks mod 3 = 0 [ ask turtles with [ Location = 4][
    move-to one-of washtank-input-location set time-entering-washtank ticks set Mass-Processed Mass-Processed + mass set lettuce-352  lettuce-352 + 1 if number = 0 [set lettuce-s5 lettuce-s5 + 1 ]
    set a-t-e-tank ticks if ( CFU > 0 and allow-transfer-in-water)[
      if ( log-reduction > 0.9  ) [ set CFU 10 ^ ( logCFU - log-reduction ) ]
      if ( log-reduction <= 0.9  ) [
        let X1 0.8 + random-float 0.1
        let X2 ifelse-value (log-reduction > X1) [ 0.9 ] [ X1 ]
        set CFU-Water CFU-Water + cfu - 10 ^ ( logCFU - X2 )
        set CFU 10 ^ (logCFU - X2 )
      ]
    ]
    set lettuce-s count turtles with[pxcor = 21 and pycor < 15 and pycor > -15 ] ]]
  ask turtles with [Location-a = 5] [ set  heading 90 if (random-float 1 > speed-in-tank ) [ fd random 2 ] set time-in-tank ticks - a-t-e-tank  ]
end

to Transfer-in-water
 ask turtles with [ #-of-lettuces-In-Water > 0 and Location-a = 5 and FC < 0.5 and allow-transfer-in-water ] [ if CFU  > mean-cfu
  [create-links-to   other turtles with [ cfu < [CFU] of myself and not any? my-links and Location-a = 5 ] ] ]
  if any? links [
    ask turtles [  ask out-link-neighbors [ ask in-link-from myself [ set c-flow CFU-Water / Count-links   ] ] ]
    ask turtles with [ llamount 5.1 > 0 ] [ ask out-link-neighbors [
      let T1   speed-in-tank * random 2 * ( random-triangle 1.20443316 1.239661651	1.267931694 ) * 0.0038
      set U1 ifelse-value (CFU-Water < 10000 and L7.1-Counter = 1) [cq] [1]
      let Y1  [c-flow] of one-of my-in-links * (  U1 * T1  / 100 )
      set CFU  CFU + Y1
      set CFU-Water CFU-Water - Y1
      ask in-link-from myself [  set c-flow c-flow - Y1  ] ]]
    ask turtles with [ ticks mod 2 = 0] [ ask links [ die ] ] ]
end

to Shaker-Dewatering-Processs
if llamount 5.3  > 0 and ticks mod 3 = 0 [
    ask turtles with [ Location = 5.3 ] [  move-to one-of patches with [ Location = 6] set LogCFU_0 LogCFU if (Collect-TIT)[set ListTIS insert-item 0 ListTIS time-system-s-tank set a-t-e-shaker-dewatering ticks] ]] ;;if CFU > 0 [ set LogCFU log CFU 10 ]
  ask turtles with [ Location = 6] [ set a-t-shaker-dewatering-s ticks - a-t-e-shaker-dewatering ]
end

to Centrifugation-Process
  ask turtles [
    let X1 ifelse-value (L6-Counter > 0) [ 0 ] [ fill-Dewatering-mass  ]
    if count turtles with [Location = 6  ]  > X1
    and llamount 7 = 0
    [ ifelse (L7.1-Counter  = 0 and Experiment-Buchholz) [ask up-to-n-of mass-to-centrifuge  turtles with [Location = 6 and color = blue]
      [ move-to one-of patches with [ Location = 7  ] set L6-Counter L6-Counter + 1  set L7.1-Counter 1 set time-entering-centrifuge ticks ]]
      [ask up-to-n-of mass-to-centrifuge  turtles with [Location = 6] [ move-to one-of patches with [ Location = 7  ] set L6-Counter L6-Counter + 1  set time-entering-centrifuge ticks ]]]]
  if llamount 7 > 0 [ ask one-of turtles with [ location = 7 ] [ set L7-Counter L7-Counter + 1 ] ]   ;; Counting the time ticks in centrifuge counter only moves if lettuce is present
  ask turtles with [Location = 7 ] [ set time-in-centrifuge ticks - time-entering-centrifuge  ]
end

to Package-area
  ask turtles [ if llamount 7  > 0 and L7-Counter mod 61 = 0
    [ask  turtles with [ Location = 7 ] [ move-to one-of patches with [ Location = 8 ] ]] ];; and not any? turtles-here
end

to Package
  if llamount 8 >= ( Shred_# + 1) * ( Manual-Trim_# + 1) and ticks mod 2 = 0
  [ask n-of (( Shred_# + 1) * ( Manual-Trim_# + 1)) turtles with [Location = 8]
    [ move-to one-of patches with [Location = 9   ] ]]
  ask turtles with [Location = 9] [set PackagedTime  PackagedTime + 1 ]
  if count turtles with [ Location = 9 and PackagedTime = 1  ] = ( Shred_# + 1) * ( Manual-Trim_# + 1) [set Throughput  Throughput + 1 ]
  if QC-Counting-Critarion-1 [ set  ContaminatedBag ContaminatedBag + 1  set ConseContaminatedBag 0 ]
  if QC-Counting-Critarion-2  [ set ConseContaminatedBag ConseContaminatedBag + 1 ]
  ;; ifelse (log mean [ CFU ] of turtles  with [ Location = 9] 10 ) <= QC-Max-LogCFU [ set ConseContaminatedBag ConseContaminatedBag + 6][set ConseContaminatedBag 0]
  if count turtles with [Location = 9 ] > 0 and ticks  mod 3 = 0 [ ask turtles with [Location = 9] [set MassPackaged MassPackaged + mass / 1000  ask turtles with [ who = watch-parameter and Location = 9 ] [ set counter-L 0 ]
    ask turtles with [ who = watch-parameter-2 and Location = 9 ] [ set counter-L-2 0 ] Die  ]]
end

to Initial-Contamination-of-patches
  ask n-of L1-nc patches with [ location = 1][
    ifelse  Allow-Initial-Contamination-of-patches
    [ set p-CFU 10 ^ L1-LC ]
    [ set p-CFU random-float Detection-Limit ]]
  ask n-of L2-nc patches with [ location = 2][
    ifelse  Allow-Initial-Contamination-of-patches
    [ set p-CFU 10 ^ L2-LC]
    [ set p-CFU random-float Detection-Limit ]]
  ask n-of L3-nc patches with [ location = 3][
    ifelse  Allow-Initial-Contamination-of-patches
    [ set p-CFU 10 ^ L3-LC ]
    [ set p-CFU random-float Detection-Limit]]
  ask n-of L4-nc patches with [ location = 4][
    ifelse  Allow-Initial-Contamination-of-patches
    [ set p-CFU 10 ^ L4-LC ]
    [ set p-CFU random-float Detection-Limit ]]
end

to Setup-Facility-Temperature
  set Temperature Set-Temperature
end

to Facility-Temperature
  set Temperature Set-Temperature - Temp-Offset * sin ((ticks * Temp-Oscillation-Speed) * 2 * pi / 60 )
end

to Calclculate-TimeIn-System
  ask turtles [ set timeInSystem-h ( ticks -  time-created ) / Time-In-System-Ratio ]
end

to Grow-Bacteria
;ask turtles with [ Cross-Contamination-Location = 1 ] [
;  set Ft timeInSystem-h + ln(( exp(- Umax * timeInSystem-h ) + exp(- Ho) - exp( (- Umax * timeInSystem-h) - Ho ))) *(1 / Umax)
;  let X1 ( Umax * Ft) - ln (1 + (((exp(Umax * Ft)) - 1) / exp( CFU_Max - LogCFU_0 )))          ;; Umax is the maximum growth rate (log CFU/g/h)
;    set CFU  CFU - CFU_0 + 10 ^ ( LogCFU_0 + X1 )]
end

to Contact-Time-calculation
 ask turtles with [ Facililty-Location-ID = 1 ] [ set Process-Initiate-2 0 set Process-Initiate-1 Process-Initiate-1 + 1 ]
 ask turtles with [ Facililty-Location-ID = 2 ] [ set Process-Initiate-1 0 set Process-Initiate-2 Process-Initiate-2 + 1 ]
end

to Cross_Contamination
ask Romaine with [ Location = 1 and Process-Initiate-1 = 1 ]
  [ if Cross_Contamination?
    [ let  Lettuce-to-Worker random-triangle 0 0.01 0.03
      let Worker-to-Lettuce  random-triangle 0.03 0.10 0.3
      repeat CFU [ if random-float 1 < Lettuce-to-Worker [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Worker-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]
  ]

ask Romaine with [ Location = 2 and Process-Initiate-2 = 1 ]
  [ if Cross_Contamination?
    [let Lettuce-to-ManTrim  random-triangle 0 0.025 0.050
      let ManTrim-to-Lettuce  random-triangle 0 0.296 0.592
      repeat CFU [ if random-float 1 < Lettuce-to-ManTrim [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < ManTrim-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Romaine with [ Location = 3 and Process-Initiate-1 = 1 ]
  [ if Cross_Contamination?
    [let Lettuce-to-Conveyor random-triangle 0 0.0062 0.0136
      let Conveyor-to-Lettuce  random-triangle 0.15 0.18 0.22
      repeat CFU [ if random-float 1 < Lettuce-to-Conveyor [set bin_ct bin_ct + 1] ]
      repeat  p-CFU [ if random-float 1 < Conveyor-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Romaine with [ Location = 4 and Process-Initiate-2 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Shredder random-triangle 0 0.0025 0.0053
      let Shredder-to-Lettuce  random-triangle 0.16 0.20 0.28
      repeat CFU [ if random-float 1 < Lettuce-to-Shredder [set bin_ct bin_ct + 1] ]
      repeat  p-CFU [ if random-float 1 < Shredder-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Romaine with [ Location = 6 and Process-Initiate-2 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Shaker random-triangle 0 0.0006 0.0038
      let Shaker-to-Lettuce random-triangle 0.06 0.28 0.30
      repeat CFU [ if random-float 1 < Lettuce-to-Shaker [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Shaker-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ] ]

ask Romaine with [ Location = 7 and Process-Initiate-1 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Centrifugation random-triangle 0 0.0035 0.0159
      let Centrifugation-to-Lettuce random-triangle 0.23 0.27 0.31
      repeat CFU [ if random-float 1 < Lettuce-to-Centrifugation [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Centrifugation-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Icebergs with [ Location = 1 and Process-Initiate-1 = 1 ]
  [ if Cross_Contamination?
    [ let  Lettuce-to-Worker random-triangle 0 0.01 0.03
      let Worker-to-Lettuce  random-triangle 0.03 0.10 0.3
      repeat CFU [ if random-float 1 < Lettuce-to-Worker * pq [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Worker-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Icebergs with [ Location = 2 and Process-Initiate-2 = 1 ]
  [ if Cross_Contamination?
    [let Lettuce-to-ManTrim  random-triangle 0 0.025 0.050
      let ManTrim-to-Lettuce  random-triangle 0 0.296 0.592
      repeat CFU [ if random-float 1 < Lettuce-to-ManTrim * pq  [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < ManTrim-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ] ]

ask Icebergs with [ Location = 3 and Process-Initiate-1 = 1 ]
  [ if Cross_Contamination?
    [let Lettuce-to-Conveyor random-triangle 0 0.0062 0.0136
      let Conveyor-to-Lettuce  random-triangle 0.15 0.18 0.22
      repeat CFU [ if random-float 1 < Lettuce-to-Conveyor * pq  [set bin_ct bin_ct + 1] ]
      repeat  p-CFU [ if random-float 1 < Conveyor-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ] ]

ask Icebergs with [ Location = 4 and Process-Initiate-2 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Shredder random-triangle 0 0.0025 0.0053
      let Shredder-to-Lettuce  random-triangle 0.16 0.20 0.28
      repeat CFU [ if random-float 1 < Lettuce-to-Shredder * pq  [set bin_ct bin_ct + 1] ]
      repeat  p-CFU [ if random-float 1 < Shredder-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ] ]

ask Icebergs with [ Location = 6 and Process-Initiate-2 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Shaker random-triangle 0 0.0006 0.0038
      let Shaker-to-Lettuce random-triangle 0.06 0.28 0.30
      repeat CFU [ if random-float 1 < Lettuce-to-Shaker * pq  [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Shaker-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ]]

ask Icebergs with [ Location = 7 and Process-Initiate-1 = 1  ]
  [ if Cross_Contamination?
    [let Lettuce-to-Centrifugation random-triangle 0 0.0035 0.0159
      let Centrifugation-to-Lettuce random-triangle 0.23 0.27 0.31
      repeat CFU [ if random-float 1 < Lettuce-to-Centrifugation * pq [set bin_ct bin_ct + 1] ]
      repeat p-CFU [ if random-float 1 < Centrifugation-to-Lettuce [set bin_ct1 bin_ct1 + 1 ] ]
      set  CFU CFU - bin_ct + bin_ct1
      set  p-CFU p-CFU  - bin_ct1 + bin_ct
      set bin_ct 0
      set bin_ct1 0 ] ]
end

to show-labels
   ask patches with [ Cross-Contamination-Location = 1 and p-CFU >  0][
   ifelse Show-Surface_Bacteria [ set plabel ( word precision p-logCFU 2 " "  location) ][ set plabel "" ] ]
   ask turtles [ ifelse Show-Surface_Bacteria [ set label precision logCFU 2] [ set label "" ] ]
end

to Death-in-water
 if FC > 0.5 [ set CFU-Water  0]
end

to Change-CFU-to-LogCFU
  ask turtles with [CFU > 0][set logCFU log CFU 10]
end

to Change-p-CFU-to-p-CFU
 ask patches with [ p-CFU > 0] [ set p-logCFU log p-CFU 10 ]
end

to show-labels-2
  ask turtles[
  ifelse Activate-Label
   [ set label precision CFU 3 ]
   [ set label "" ]]
   ask turtles [
  ifelse Activate-Label
   [ set label precision CFU 3 ]
   [ set label "" ]]
  ask links[
  ifelse Activate-Label
   [ set label c-flow ]
   [ set label "" ]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Chlorination

to-report  ticks-12-m-intval
  report 10920 / 5
end

to-report  mass-in-centrifuge
  report sum [ mass ] of turtles with [ location = 7]
end

to-report  mass-on-Dewatering-table
  report sum [ mass ] of turtles with [ location = 6]
end

to-report mod-28-number_Of_processes   ;; it takes 28 batches of 19.50 kg to reach 540 kg to trigger that process
report number_Of_processes mod 28
end

to-report percentage [ X1 ]            ;; Change the rate of decay from a percentage FC = FCo*( Percent-depletion )^n
  report  0.0223 * X1 + 0.945          ;; n is the number of the descrete times the mass
end

to-report Cumulative-Mass              ;; Change the rate of decay from a percentage FC = FCo*( Percent-depletion )^n
  report  floor ( ( number_Of_processes  ) * 45 / 2.3 )          ;; n is the number of the descrete times the mass
end

to-report mass-to-centrifuge
 report 15 *( Shred_# + 1) * ( Manual-Trim_# + 1) / 0.500  ;; Centfifuge 15 kgs at a time in 18 seconds
end

to-report fill-Dewatering-mass
 report 16 *( Shred_# + 1) * ( Manual-Trim_# + 1) / 0.500  ;; After accumilating 16 kgs at the dewatering then send to centrifuge
end

to-report time4 ;;
  report time-counter-1 - time-counter-3
end

to-report number
report lettuce-352 mod number1 ;; count lettuce heads that make up 19500g
end

to-report number_Of_processes
 report  lettuce-s5
end

to-report number1
 let x1 ( 45000 / 500  ) * ( 26 / 60 )  ;; The number of lettuce heads that make up 19500g = 39
 report  ( x1 * ( Shred_# + 1 )*(Manual-Trim_# + 1 ) ) ;; Number of lettuce pieces that make up 39 lettu
end

to-report Washed-Mass-kg
report precision ( Mass-Processed / 1000) 2
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Chlorination CFU Links

to-report  #-of-lettuces-In-Water
  report count turtles with [Location-a = 5  ]
end

to-report Count-links
 report count links
end

to-report max-links
 report max [count my-in-links] of turtles
end

to-report max-flow
  if any? links [ report max [c-flow] of links ]
end

to-report mean-flow
  if any? links [ report mean [c-flow] of links ]
end

to-report min-flow
  if any? links [ report min [c-flow] of links]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Counting Patches and Lettuces

to-report amount-p [ # ]
  report count patches with [ Location = # ]
end

to-report amount-p-b [ # ]
  report count patches with [ Location-b = # ]
end

to-report llamount [ # ]
  report count turtles with [ Location = # ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Time

to-report time-stoper
  report count turtles with [ location = 0 ]  + count turtles with [ location = 1 ]
end

to-report  Time-In-System-Ratio
  report 10920
end

to-report time-passed-h
  report ticks / Time-In-System-Ratio
end

to-report time-passed-s
  report ticks / Time-In-System-Ratio * 3600
end

to-report time-passed-m
  report ticks / Time-In-System-Ratio * 60
end

to-report Minutes
report floor time-passed-m mod 60
end

to-report Seconds
report floor ( ( time-passed-m - floor time-passed-m ) * 60 )
end

to-report Hour
 report floor (time-passed-h)
end

to-report Centrifuge-Timer
 report floor ( (L7-Counter mod 61) / Time-In-System-Ratio * 3600 )
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Plotting and Statistics

to-report average-time-in-system
  ;; this reporter returns the
  report mean [ time-system-s ] of turtles  with [ Location  = 9]                        ;; average Growth in the
end                                                      ;; population of Lettuce In the System (needs Verification)

to-report TimeInTank
report ( [ time-system-s-tank ] of turtles with [ location = 9 ]) ;;show mean ([wealth] of turtles)
end

to-report  AverageLoad
  ;; this reporter returns the
  report   log ( mean [CFU] of turtles  with [ Location  = 9] ) 10              ;; average Growth in the
end                                                      ;; population of Lettuce In the System (needs Verificatio

to-report  AverageLoadCFU
  ;; this reporter returns the
  report   mean [CFU] of turtles  with [ Location  = 9]            ;; average Growth in the
end

to-report StandardDiviationGrowth
  report   standard-deviation [logCFU] of turtles  with [ Location  = 9]
end

to-report standard-error-growth-packaged-lettuce
  ;; se = sd / sqrt ( n )
  report  ( StandardDiviationGrowth ) / sqrt ( count turtles with  [ Location  = 9])
end

to-report UpperCL
  report  AverageLoad +  standard-error-growth-packaged-lettuce * 1.96 ; Z score
end

to-report lowerCL
  report  AverageLoad -  standard-error-growth-packaged-lettuce * 1.96 ;
end

to-report max-val
 report max [ CFU ] of turtles with [Location-a = 5]
end

to-report min-val
 report min [ CFU ] of turtles with [Location-a = 5]
end

to-report  mean-cfu
  report mean [ CFU ] of turtles with [Location-a = 5  ]
end

to-report max-val-2
 report ceiling ( max ListTIS  )
end

to-report min-val-2
 report floor ( min ListTIS  )
end

to-report Median-For-Plot2
  report median ListTIS
end

to-report Lettuces-Close-to-Median2
  report count turtles with [location-at =  1 and time-system-s-tank >= Median-For-Plot2 - 0.05 and time-system-s-tank <= Median-For-Plot2 + 0.05  ]
end

to plot-histogram-of-lettuces
set-plot-pen-mode 1
set-plot-pen-interval ( 10 ^ Contamination-Level ) / 10
set-plot-x-range floor ( min-val - 0.01 ) ceiling ( max-val + 0.01 )
set-plot-y-range 0 ( Lettuces-Close-to-Median )
set-histogram-num-bars ceiling (sqrt (count turtles with [Location-b  = 5]))
histogram [CFU] of turtles with [Location-b = 5]
end

to plot-histogram-of-lettuces2
set-plot-pen-mode 1
set-plot-pen-interval 0.5
set-plot-x-range min-val-2 max-val-2
set-plot-y-range 0 ( Lettuces-Close-to-Median2)
set-histogram-num-bars ceiling (sqrt (length ListTIS))
histogram ListTIS
end

to plotty
plot-pen-reset
set-plot-pen-color red
plot-pen-up
set-plot-x-range min-val-2 max-val-2
plotxy AverageTimeInTank 0
plot-pen-down
plotxy AverageTimeInTank plot-y-max
end

to-report AverageTimeInTank
 report precision ( mean ListTIS ) 2
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Miscillanious

to-report random-triangle [#a #b #c]
  if not (#a < #b and #b < #c) [error "Triangular Distribution parameters are in the wrong order"]
  let DF ((#b - #a) / (#c - #a))
  let U random-float 1
  ifelse U < DF[ report (#a + (sqrt (U * (#c - #a) * (#b - #a)))) ]
  [ report (#c - (sqrt ((1 - U ) * (#c - #a) * (#c - #b)))) ]
end

to-report ATS-D
  report ( mean [ a-t-shaker-dewatering-s ] of turtles with [ location > 5 ] ) / Time-In-System-Ratio * 3600  ;; seconds
end

to-report Volume-Tank
  report 3.2 * 10 ^ 6
end

to-report Median-For-Plot
  report median [LogCFU] of turtles with [Location-b = 5]
end

to-report Lettuces-Close-to-Median
  report count turtles with [Location-b = 5 and LogCFU >= Median-For-Plot - 0.05 and LogCFU <= Median-For-Plot + 0.05  ]
end

to-report calculate-bacteria-at-source
  report mean [ LogCFU_0 ] of turtles  with [ pcolor = 5]
end

to-report log-reduction
  ifelse ( FC != 0 ) [ report 0.214 * ln(FC) + 0.22 + 0.9 + 0.000000001 - random-float 0.000000001] [report FC * 0]
end

to-report NIS
  report Count turtles
end

to-report QC-Counting-Critarion-1
  report count turtles with [ Location = 9 and PackagedTime = 1 and mean [ CFU ]  of turtles  with [ Location = 9]  >= 10 ^ QC-Max-LogCFU ]=( Shred_# + 1) * ( Manual-Trim_# + 1)
end

to-report QC-Counting-Critarion-2
  report count turtles with [ Location = 9 and PackagedTime = 1 and mean [ CFU ] of turtles  with [ Location = 9] < 10 ^ QC-Max-LogCFU ]=( Shred_# + 1) * ( Manual-Trim_# + 1)
end

to-report infected-rate
report ( Contamination-counter / lettuce-counter )
end

to-report package-size
report ( Shred_# + 1) * ( Manual-Trim_# + 1)
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Average Bacteria Amount On Lettuce In area useful for Buchheloz session 2
to-report Average-Amount-LogCFU-L0
   report log mean [ CFU ] of turtles  with [ Location = 0 ] 10
end

to-report Average-Amount-LogCFU-L1
  report log mean [ CFU ] of turtles  with [ Location = 1 ] 10
end

to-report Average-Amount-LogCFU-L2
  report log mean [ CFU ] of turtles  with [ Location = 2 ] 10
end

to-report Average-Amount-LogCFU-L3
  report log mean [ CFU ] of turtles  with [ Location = 3 ] 10
end

to-report Average-Amount-LogCFU-L4
  report log mean [ CFU ] of turtles  with [ Location = 4 ] 10
end

to-report Average-Amount-LogCFU-L5
  report log mean [ CFU ] of turtles  with [ Location-b = 5 ] 10
end

to-report Average-Amount-LogCFU-L6
  report log mean [ CFU ] of turtles  with [ Location = 6 ] 10
end

to-report Average-Amount-LogCFU-L7
  report log mean [ CFU ] of turtles  with [ Location = 7 ] 10
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Average Bacteria Amount Of LettuceFt Different Locations

to-report Average-Amount-p-LogCFU-L1
report  log mean [ p-CFU ] of patches  with [ Location = 1] 10
end

to-report Average-Amount-p-LogCFU-L2
report  log mean [ p-CFU ] of patches  with [ Location = 2] 10
end

to-report Average-Amount-p-LogCFU-L3
report log mean [ p-CFU ] of patches  with [ Location = 3] 10
end

to-report Average-Amount-p-LogCFU-L4
report  log mean [ p-CFU ] of patches  with [ Location = 4] 10
end

to-report Average-Amount-p-LogCFU-L6
report  log mean [ p-CFU ] of patches  with [ Location = 6] 10
end

to-report Average-Amount-p-LogCFU-L7
report  log mean [ p-CFU ] of patches  with [ Location = 7] 10
end
@#$#@#$#@
GRAPHICS-WINDOW
199
10
1269
550
-1
-1
12.95122
1
10
1
1
1
0
0
0
1
-1
80
-20
20
1
1
1
ticks
30.0

BUTTON
7
10
62
43
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
122
10
177
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
213
189
246
Shred_#
Shred_#
0
7
7.0
1
1
A
HORIZONTAL

SLIDER
7
180
188
213
Manual-Trim_#
Manual-Trim_#
0
3
1.0
1
1
B
HORIZONTAL

SWITCH
9
386
191
419
Show-Surface_Bacteria
Show-Surface_Bacteria
0
1
-1000

TEXTBOX
223
226
249
249
L1
19
9.9
1

TEXTBOX
263
228
283
246
L2
19
9.9
1

TEXTBOX
324
202
348
220
L3
19
9.9
1

TEXTBOX
1127
95
1150
118
L7 
19
9.9
1

TEXTBOX
424
149
446
167
L4
19
9.9
1

BUTTON
64
10
119
43
Next
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
315
188
348
Temp-Oscillation-Speed
Temp-Oscillation-Speed
0.05
4
4.0
0.05
1
NIL
HORIZONTAL

PLOT
739
552
1003
768
Temperature Vs Time
Time [ m ]
Temperature °C
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Temperature" 1.0 0 -16777216 true "" "plotxy  time-passed-m Temperature"

PLOT
476
552
738
768
Packaged-logCFU
Throughput Mass [ kg ]
LogCFU
0.0
10.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy MassPackaged  AverageLoad"
"pen-1" 1.0 0 -12087248 true "" "plotxy MassPackaged UpperCL"
"pen-2" 1.0 0 -2674135 true "" "plotxy MassPackaged LowerCL"

MONITOR
199
769
249
814
 Arrivals
lettuce-counter
17
1
11

MONITOR
318
769
385
814
NIL
Throughput
17
1
11

SWITCH
9
453
191
486
Allow-Initial-Contamination-of-patches
Allow-Initial-Contamination-of-patches
1
1
-1000

SLIDER
8
492
100
525
L1-nc
L1-nc
0
amount-p 1
5.0
1
1
NIL
HORIZONTAL

SLIDER
7
525
99
558
L2-nc
L2-nc
0
amount-p 2
15.0
1
1
NIL
HORIZONTAL

SLIDER
8
559
100
592
L3-nc
L3-nc
0
amount-p 3
36.0
1
1
NIL
HORIZONTAL

SLIDER
8
594
100
627
L4-nc
L4-nc
0
amount-p 4
136.0
1
1
NIL
HORIZONTAL

SLIDER
99
493
191
526
L1-LC
L1-LC
0
4
4.0
0.05
1
log
HORIZONTAL

SLIDER
100
526
192
559
L2-LC
L2-LC
0
4
4.0
0.05
1
log
HORIZONTAL

SLIDER
101
560
193
593
L3-LC
L3-LC
0
4
4.0
0.05
1
log
HORIZONTAL

SLIDER
101
594
193
627
L4-LC
L4-LC
0
4
4.0
0.05
1
log
HORIZONTAL

PLOT
199
552
475
768
NIS, TIS VS Time
Time [ s ]
Number In System
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"NIS" 1.0 0 -16777216 true "" "plotxy ( floor time-passed-s ) NIS "

SLIDER
7
247
189
280
Set-Temperature
Set-Temperature
7
32
7.0
0.5
1
NIL
HORIZONTAL

SLIDER
7
281
189
314
Temp-Offset
Temp-Offset
0
3
3.0
1
1
±°C
HORIZONTAL

SWITCH
7
350
189
383
Cross_Contamination?
Cross_Contamination?
0
1
-1000

MONITOR
387
769
444
814
Bad Bags
ContaminatedBag
17
1
11

MONITOR
1811
771
1891
816
 P-L4-LogCFU
precision Average-Amount-p-LogCFU-L4 4
17
1
11

TEXTBOX
931
62
952
85
L6
19
9.9
1

TEXTBOX
652
62
674
86
L5
19
9.9
1

TEXTBOX
227
383
351
537
Key \nL# = Location Number\nL0 = Lettuce Source\nL1 = Worker\nL2 = Manual-Trim \nL3 = Shredding\nL4 = Conveyor\nL5 = Wash-Tank\nL6 = Shaker-Dewatering\nL7 = Centrifugation\nL8 = Packaging
11
9.9
1

TEXTBOX
1133
293
1155
316
L8
19
9.9
1

PLOT
1270
10
1574
192
Contaminated-Lettuce-In -Water 
CFU
Frequency
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.0 0 -16777216 true "" "plot-histogram-of-lettuces\n"
"pen-1" 1.0 0 -7500403 true "" ""

PLOT
1271
193
1576
373
CFU-Water vs Time
Time
CFU-Water
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy Minutes CFU-Water "

TEXTBOX
201
297
226
320
L0
19
9.9
1

MONITOR
783
702
860
747
Temperature
precision Temperature 2
17
1
11

MONITOR
281
701
352
746
  Time [ s ]
floor time-passed-s
17
1
11

MONITOR
209
21
306
66
Hr : Min : Sec 
word Hour \" :   \"  Minutes \"  :  \"  Seconds
17
1
11

MONITOR
352
701
402
746
  NIS
NIS
17
1
11

PLOT
1271
374
1574
552
COD
Mass [ kg ]
COD
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy Washed-Mass-kg COD "

PLOT
1005
552
1269
768
FC vs Mass
mass [ kg ]
FC
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy Washed-Mass-kg  FC"

MONITOR
768
767
818
812
  fc
precision fc 2
17
1
11

MONITOR
687
767
766
812
Washed [ kg ]
Washed-Mass-kg
17
1
11

MONITOR
1007
770
1085
815
 log-reduction
precision log-reduction 2
17
1
11

MONITOR
1034
657
1087
702
FC-0-1
precision FC-0-1 2
17
1
11

MONITOR
547
652
610
697
  Log_CFU
precision  AverageLoad 4
17
1
11

MONITOR
1035
703
1086
748
    FC
precision FC 2
17
1
11

SWITCH
7
80
162
113
Allow-Chlorination
Allow-Chlorination
0
1
-1000

SLIDER
9
671
195
704
probality-Of-Contamination
probality-Of-Contamination
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
8
747
194
780
SD
SD
0
0.4
0.0
0.001
1
±
HORIZONTAL

SLIDER
8
709
194
742
Contamination-Level
Contamination-Level
Detection-Limit - 2
6
0.1
0.01
1
LogCFU
HORIZONTAL

SLIDER
9
634
194
667
Mass-to-Process
Mass-to-Process
22
540 * 3
1620.0
0.5
1
kg
HORIZONTAL

MONITOR
1354
769
1418
814
IC-Lettuce
precision mean [ logCFU ] of turtles with [ color = red and location = 6] 2
17
1
11

MONITOR
1165
770
1252
815
L7-mass [ kg]
precision ( mass-in-centrifuge / 1000 ) 2
17
1
11

MONITOR
1505
311
1568
356
CFU-water
precision ( CFU-water / Volume-Tank )2
17
1
11

MONITOR
1086
770
1164
815
L6-mass [ kg]
precision ( mass-on-Dewatering-table / 1000 ) 2
17
1
11

SWITCH
7
114
162
147
Activate-Label
Activate-Label
1
1
-1000

MONITOR
250
769
314
814
Mass [ kg ]
Mass-entering
17
1
11

MONITOR
449
769
522
814
Mass [ kg ]
precision MassPackaged 2
17
1
11

MONITOR
1273
769
1352
814
 L7-timer [ s ]
centrifuge-timer
17
1
11

MONITOR
1422
768
1481
813
Track-ID
max [ watch-parameter ] of turtles
17
1
11

SWITCH
7
420
191
453
allow-transfer-in-water
allow-transfer-in-water
0
1
-1000

PLOT
1270
553
1575
767
Sample-Growth-Profile-of-Lettuce
NIL
NIL
0.0
10.0
0.0
3.0
true
true
"" ""
PENS
"default" 1.0 2 -16777216 true "" "plot-highlighted"

SWITCH
1416
571
1519
604
Switch
Switch
1
1
-1000

SWITCH
7
45
162
78
Experiment-Buchholz
Experiment-Buchholz
1
1
-1000

SLIDER
8
781
194
814
QC-Max-LogCFU
QC-Max-LogCFU
-2.1
1
-2.0
0.05
1
NIL
HORIZONTAL

SLIDER
7
146
188
179
Contamination-Buchholz
Contamination-Buchholz
0
6
4.0
1
1
NIL
HORIZONTAL

PLOT
1578
12
1875
187
Histogram Of Time In Tank Seconds L6 to L8
Time [ s ]
Frequency
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "plot-histogram-of-lettuces2"
"pen-1" 1.0 0 -7500403 true "" "plotty"

TEXTBOX
1689
190
1803
208
Mean in red vertical line 
11
15.0
1

MONITOR
1583
203
1690
248
AverageTimeInTank
precision AverageTimeInTank 2
17
1
11

SWITCH
1700
207
1800
240
Collect-TIT
Collect-TIT
1
1
-1000

MONITOR
1638
250
1693
295
Romaine
romaine-counter
17
1
11

MONITOR
1583
250
1637
295
Iceberg
iceberg-counter
17
1
11

SLIDER
1700
258
1839
291
iceberg-to-romaine
iceberg-to-romaine
0
1
1.0
0.001
1
NIL
HORIZONTAL

MONITOR
1734
771
1810
816
P-L3-LogCFU
precision Average-Amount-p-LogCFU-L3 4
17
1
11

MONITOR
1660
771
1733
816
P-L2-LogCFU
precision Average-Amount-p-LogCFU-L2 4
17
1
11

MONITOR
1585
771
1659
816
P-L1-LogCFU
precision  Average-Amount-p-LogCFU-L1 4
17
1
11

MONITOR
1739
66
1799
111
ATS-D
precision ATS-D 4
17
1
11

MONITOR
1679
66
1736
111
NIL
U1
17
1
11

SWITCH
1582
300
1697
333
Baseline
Baseline
0
1
-1000

SLIDER
1690
369
1816
402
Contamination-BL
Contamination-BL
-2
6
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
1578
369
1687
402
Probability-BL
Probability-BL
0
1
0.0
0.01
1
NIL
HORIZONTAL

TEXTBOX
1846
219
1873
241
E2
18
0.0
1

TEXTBOX
167
51
191
73
E1
18
0.0
1

MONITOR
600
768
686
813
Contamn-Ratio
precision ( ContaminatedBag / Throughput ) 4
17
1
11

PLOT
1581
558
1879
770
Sample-One-Of-Uncontaminated-Letuuce
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot-highlighted-2"

MONITOR
526
769
601
814
infected-rate
precision infected-rate 4
17
1
11

MONITOR
1487
768
1573
813
NIL
watch-parameter-2
17
1
11

SLIDER
1578
402
1688
435
ask-patches
ask-patches
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
1691
402
1803
435
p-L1-to-L4-nc
p-L1-to-L4-nc
0
5
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
1803
403
1895
436
p-sd-1
p-sd-1
0
2
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
821
767
886
812
ContEqmnt
count patches with [ p-CFU > 1]\n;number contaminated equipment (patches) L1 to L4 based on
17
1
11

MONITOR
1502
264
1568
309
CFU-water
precision CFU-water 2
17
1
11

INPUTBOX
1703
301
1753
361
R-1
0.0
1
0
Number

INPUTBOX
1754
301
1804
361
R-2
0.0
1
0
Number

INPUTBOX
1804
301
1854
361
R-3
0.0
1
0
Number

SLIDER
1694
436
1803
469
p-L6-to-L7-nc
p-L6-to-L7-nc
0
5
3.0
0.01
1
NIL
HORIZONTAL

SLIDER
1578
436
1688
469
ask-patches-2
ask-patches-2
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1803
436
1897
469
p-sd-2
p-sd-2
0
1
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
1591
483
2413
528
NIL
Average-Amount-LogCFU-L7
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-scene-7d" repetitions="13" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>Average-Amount-LogCFU-L0</metric>
    <metric>Average-Amount-LogCFU-L1</metric>
    <metric>Average-Amount-LogCFU-L2</metric>
    <metric>Average-Amount-LogCFU-L3</metric>
    <metric>Average-Amount-LogCFU-L4</metric>
    <metric>Average-Amount-LogCFU-L5</metric>
    <metric>Average-Amount-LogCFU-L6</metric>
    <metric>Average-Amount-LogCFU-L7</metric>
    <metric>AverageLoad</metric>
    <metric>lowerCL</metric>
    <metric>UpperCL</metric>
    <metric>AverageLoadCFU</metric>
    <metric>MassPackaged</metric>
    <metric>log-reduction</metric>
    <metric>Temperature</metric>
    <metric>FC</metric>
    <metric>infected-rate</metric>
    <metric>package-size</metric>
    <enumeratedValueSet variable="probality-Of-Contamination">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Collect-TIT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Contamination-BL">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="QC-Max-LogCFU">
      <value value="-2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="R-1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-sd-1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iceberg-to-romaine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="R-2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-sd-2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Allow-Initial-Contamination-of-patches">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Allow-Chlorination">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L4-nc">
      <value value="136"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switch">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Contamination-Level">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L3-nc">
      <value value="36"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ask-patches">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-L6-to-L7-nc">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ask-patches-2">
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Contamination-Buchholz">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L4-LC">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L2-nc">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Mass-to-Process">
      <value value="1620"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L1-nc">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L3-LC">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Show-Surface_Bacteria">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L2-LC">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Temp-Oscillation-Speed">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Activate-Label">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Set-Temperature">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L1-LC">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="allow-transfer-in-water">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Cross_Contamination?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shred_#">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="R-3">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-L1-to-L4-nc">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Manual-Trim_#">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Probability-BL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Experiment-Buchholz">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Temp-Offset">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

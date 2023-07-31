extensions [ ls ]
patches-own [heat]
turtles-own [
  LogCFU mass k1 k2 k3 k4 B
  time-created Log_CFU
  timeInSystem-h Q
  Ft Ho  Umax LogCFU_0 LogCFU_Max ]
globals[ ID step_size value value-2 value-3 value-6 Temperature Mass-Entering lettuce-counter e-value storage-time-start facility_seed storage_seed facility_contamination.BL ]
to setup
  clear-all
  ls:reset
  ;;ls:create-models 1 "Processing_facility.nlogo\"" ; takes a string and creates a child model from that path
  ls:create-interactive-models 1 "FS-ABS-F.nlogo\"" ; takes a string and creates a child model from that path
  ls:ask ls:models [setup
  set Experiment-Buchholz False
  set Baseline False  ]
  set facility_seed [seed] ls:of ls:models
  set facility_contamination.BL [Contamination-BL] ls:of ls:models
  set storage_seed  random 2147483647
  random-seed storage_seed
  set e-value False
  set Temperature Set-Temperature
  reset-ticks
end

to-report countmodels
  report length ls:models
end

to Sprouting-Lettuce
 ask one-of patches with [ value-3 !=  AverageLoad  and not any? turtles-here][
    sprout 1 [
      set mass 500
      set color blue
      set shape "circle"
      set LogCFU_0 AverageLoad
      set LogCFU AverageLoad
      set lettuce-counter lettuce-counter + 1
      ;set time-created ticks
      set Mass-Entering Mass-Entering + mass / 1000
      set value-3 AverageLoad
      set color green
      set shape "circle"]]
end

to Operate_Facility_Model
  if ( countmodels != 0)[
    ls:ask ls:models [ go ]
    if (mean [count turtles ] ls:of ls:models = 0 and mean [Mass-entering ] ls:of ls:models = mean [Mass-to-Process ] ls:of ls:models)[ ls:close ls:models set e-value true ] ;; and Mass-entering = Mass-to-Process
    if (e-value = false ) [set value-2 ( ls:report 0 [ a-t -> [ cfu ] of turtles  with  [ Location = a-t ] ] 9)
      set value-3  [count turtles with [ location = 9]] ls:of ls:models
      if ( countmodels != 0)[  set value [Mass-Processed] ls:of 0
        if mean value-3 != 0 [Sprouting-Lettuce ] ] ]
    if (e-value = true )[  set storage-time-start ticks set ID random ( count turtles - 1 ) ask turtles [ set time-created ticks ] ] ]
end

to go
  Operate_Facility_Model
  if (countmodels = 0 and time-passed-h-Storage = 80)[stop]
  ;Grow-Bacteria
 ;Calclculate-TimeIn-System
  if ( countmodels = 0  )[ Calclculate-TimeIn-System Facility-Temperature]
 Grow-Bacteria_II
  tick
end

to Calclculate-TimeIn-System
  ask turtles [ set timeInSystem-h ( ticks -  time-created )  ]
end

to Grow-Bacteria_II
  ask turtles with [ timeInSystem-h > 0 ] [
   set step_size 1
   set Q 0.73
   set B timeInSystem-h / 2
   set Umax  ( 0.0169 * (Temperature + 4.012) ) ^ 2
   set LogCFU_Max  8.676 / (1 + exp ( - ( Temperature - 3.52 ) / 2.876 ))
   set k1  ( Umax / ( 1 + exp( - Q))) * ( 1 - exp( logCFU - LogCFU_Max))
   set k2  ( Umax / ( 1 + exp(-( Q +( k1 * timeInSystem-h / 2))))) * ( 1 - exp( logCFU + ( k1 * step_size / 2) - LogCFU_Max))
   set k3  ( Umax / ( 1 + exp(-( Q +( k2 * step_size / 2))))) * ( 1 - exp( logCFU + ( k2 * step_size / 2) - LogCFU_Max))
   set k4  ( Umax / ( 1 + exp(-( Q +( k3 * step_size ))))) * ( 1 - exp( logCFU + ( k3 * step_size) - LogCFU_Max))
   set logCFU logCFU +  ( k1 + ( 2 * k2 )+ ( 2 * k3 ) + k4 ) * ( step_size / 6 )]
end

;to plot_this
;  if ( countmodels = 0)[ ask turtles with [ who = ID ] [ plotxy time-passed-h-Storage  logCFU ]]
;end

to plot_this
  if ( countmodels = 0)[ ask turtles [ plotxy time-passed-h-Storage  mean [ logCFU] of turtles ]]
end

to-report BagCount
  if ( countmodels = 0)[ report count turtles ]
end

to-report LogCFU.With.Time
  if ( countmodels = 0)[ report [ LogCFU ] of turtles ]
end

to-report CFU.With.Time
  if ( countmodels = 0)[ report [ 10 ^ LogCFU ] of turtles ]
end

to-report mean.CFU.With.Time
  if ( countmodels = 0)[ report mean [ 10 ^ LogCFU ] of turtles ]
end

to-report mean.logCFU.With.Time
  if ( countmodels = 0)[ report log ( mean [ 10 ^ LogCFU ] of turtles ) 10 ]
end

to-report LogCFU.When.Entering
  if ( countmodels = 0)[ report [ LogCFU_0 ] of turtles ]
end

to-report AverageLoad
  report (log (mean value-2) 10 )
end

to-report AverageLoad_CFU
  report mean value-2
end

to-report  Time-In-System-Ratio
  report 10920
end

to-report time-passed-h-Processing-Facility
  if ( countmodels != 0)[ report ticks / Time-In-System-Ratio ]
end

to-report time-passed-h-Storage
  if ( countmodels = 0)[  report ticks - storage-time-start ]
end

to-report Hour-storage
report floor time-passed-h-Storage mod 24
end

to-report Days-storage
report floor ( time-passed-h-Storage / 24 )
end

to-report time-passed-s-Processing-Facility
  if ( countmodels != 0)[ report ticks / Time-In-System-Ratio * 3600 ]
end

to-report time-passed-m-Processing-Facility
  if ( countmodels != 0)[report ticks / Time-In-System-Ratio * 60]
end

to-report Minutes
report floor time-passed-m-Processing-Facility mod 60
end

to-report Seconds
  if ( countmodels != 0)[report floor ( ( time-passed-m-Processing-Facility - floor time-passed-m-Processing-Facility ) * 60 )]
end

to-report Hour
  if ( countmodels != 0)[report floor (time-passed-h-Processing-Facility)]
end

to-report NIS
 report count turtles
end

to Facility-Temperature
  set Temperature Set-Temperature + Temp-Offset * sin (  time-passed-h-Storage * 180 / Temp-Oscillation-Speed)
end
@#$#@#$#@
GRAPHICS-WINDOW
262
10
810
619
-1
-1
10.0
1
10
1
1
1
0
1
1
1
0
53
0
59
1
1
1
ticks
30.0

BUTTON
0
14
67
47
Setup
setup
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
135
14
202
47
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
70
14
133
47
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

MONITOR
180
628
366
673
NIL
[Mass-entering ] ls:of ls:models
17
1
11

MONITOR
367
628
565
673
NIL
[Mass-to-Process ] ls:of ls:models
17
1
11

MONITOR
566
628
648
673
NIL
countmodels
17
1
11

SLIDER
0
164
172
197
Set-Temperature
Set-Temperature
7
35
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
199
172
232
Temp-Offset
Temp-Offset
0
10
2.0
0.1
1
NIL
HORIZONTAL

SLIDER
1
233
173
266
Temp-Oscillation-Speed
Temp-Oscillation-Speed
0
30
15.0
1
1
NIL
HORIZONTAL

PLOT
833
15
1402
296
NI
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
833
339
1401
620
Temperature VS Time
Time [ h ]
Temperature [°C]
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy time-passed-h-Storage Temperature"
"pen-1" 1.0 0 -7500403 true "" "plot_this"

MONITOR
4
298
90
343
 Hr :  Min : Sec 
word Hour \"  :   \" Minutes \"   :   \"  Seconds
17
1
11

MONITOR
6
401
71
446
NIL
step_size
17
1
11

MONITOR
668
629
808
674
NIL
time-passed-h-Storage
17
1
11

MONITOR
6
349
73
394
Day  :  Hr
word  Days-storage\"  :   \"Hour-storage
17
1
11

TEXTBOX
102
309
173
334
Facility
20
0.0
1

TEXTBOX
84
360
163
385
Storage
20
0.0
1

MONITOR
3
451
85
496
NIL
temperature
17
1
11

MONITOR
1
61
83
106
NIL
facility_seed
17
1
11

MONITOR
0
106
81
151
NIL
storage_seed
17
1
11

MONITOR
0
629
150
674
NIL
facility_contamination.BL
17
1
11

MONITOR
0
539
83
584
mass [kg]
count turtles / 2
17
1
11

@#$#@#$#@
## WHAT IS IT?

This project depicts a simple cellular automata model that resembles a pot of boiling water. Heat is applied evenly to the entire pot, but when the temperature of a patch reaches the boiling temperature, the bubble pops and that patch's temperature drops to zero.

This process is analogous to the way in which a hot enough region of water gives up some heat by forming a bubble of steam. The water right around the steam bubble cools off for a moment.

## HOW IT WORKS

If all of a cell's neighbors are at the maximum value of 212, then that cell's new value will be 213 which gets wrapped down to zero. At the next tick, the presence of this zero-valued cell will lower the values of the cell's nearest neighbors.

## HOW TO USE IT

Click the SETUP button to set up a random field of heat.

Click the BOIL button to start adding heat to the pot and watch it boil. The redder the color, the hotter the patch (Black is very cool and white is very hot).

## THINGS TO NOTICE

Watch how the added heat diffuses through the pot. When bubbles pop, the resulting drop in heat affects nearby patches too by taking away their heat.

What happens to the average heat in the pot?

## EXTENDING THE MODEL

Try diffusing the heat more slowly through the system.

Change the diffuse parameter from 1 to a smaller fraction.

Add "ice cubes".

Add a heat sink, such as edges that constantly cool the liquid.

## CREDITS AND REFERENCES

This model is described on page 79 in "Artificial Life Lab", by Rudy Rucker, published in 1993 by Waite Group Press.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1998).  NetLogo Boiling model.  http://ccl.northwestern.edu/netlogo/models/Boiling.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1998 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 2001.

<!-- 1998 2001 -->
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
setup
repeat 110 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-facility" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>storage_seed</metric>
    <metric>facility_seed</metric>
    <metric>LogCFU.With.Time</metric>
    <metric>LogCFU.When.Entering</metric>
    <metric>CFU.With.Time</metric>
    <metric>mean.CFU.With.Time</metric>
    <metric>temperature</metric>
    <metric>time-passed-h-Storage</metric>
    <metric>Hour-storage</metric>
    <metric>mean.logCFU.With.Time</metric>
    <metric>BagCount</metric>
    <metric>facility_contamination.BL</metric>
    <enumeratedValueSet variable="Temp-Oscillation-Speed">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Set-Temperature">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Temp-Offset">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed">
      <value value="1"/>
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

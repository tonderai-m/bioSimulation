breed [lettuces lettuce]

lettuces-own [timecreated timevalue  CFU trigger ]
links-own [ c-flow ]

globals [ In-line time time1  time2 time3 ]
to setup
  clear-all
  set-default-shape turtles "circle"
  ask n-of number-nuclei patches [ set pcolor cyan ]
  reset-ticks
end


to go
  to-create-lettuces
  move-lettuce-in-the-washer
  ask lettuces [ ifelse cfu > mean-cfu  [ set color red ] [set color blue] ]
  create-linkage
  ask Lettuces with [ ticks mod 2 = 0] [ ask up-to-n-of 10 my-links [ die ] ]
  ask lettuces with [ pxcor >= 15] [ die ]
  tick
end

to move-lettuce-in-the-washer
   ask lettuces [ set  heading 90 fd random 5 ]
end

to to-create-lettuces
  if count lettuces with [ pxcor <= -15]  = 0 [ ask patches with [ pxcor <= -15]
    [sprout-lettuces  1 [set color blue set shape "circle"
      if( random-float 1 < Chance-Of-Contamination ) [set CFU 1000 ]  ] ] ]
; create-lettuces  50 [ setxy random-xcor random-ycor set color blue if( random-float 1 < Chance-Of-Contamination ) [set CFU 1000 set color red] ]
end

to create-linkage
 ask lettuces with [ CFU  > mean-cfu ] [create-links-to   up-to-n-of number-links other lettuces with [ cfu < [CFU] of myself and not any? my-links ]]

 if any? links [
  ask lettuces with [ CFU  > mean-cfu ]  [
    let X1 CFU *  (1 - diffusion-rate / 100)
    let X2 CFU - X1
    set CFU X1
    set In-line In-line + X2 ]
ask lettuces with [ CFU  > mean-cfu ] [  ask out-link-neighbors [ ask in-link-from myself [ set c-flow In-line / Count-links   ] ] ]
ask lettuces with [ CFU  > mean-cfu ] [   ask out-link-neighbors [
    let Y1  [c-flow] of one-of my-in-links * ( 1 - link-diffusion-rate / 100 )
    set CFU  Y1
    set In-line In-line  - Y1
      ask in-link-from myself [  set c-flow c-flow - Y1  ] ]] ]
end

to-report  mean-cfu
 report mean [ CFU ] of lettuces
end
to-report total-val
 report sum [ CFU ] of lettuces
end

to-report max-val
 report max [ CFU ] of lettuces
end

to-report Count-links
 report count links
end

to-report max-links
 report max [count my-in-links] of lettuces
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
@#$#@#$#@
GRAPHICS-WINDOW
0
71
358
430
-1
-1
10.0
1
10
1
1
1
0
0
0
1
-17
17
-17
17
1
1
1
ticks
30.0

SLIDER
378
125
618
158
decay-chance
decay-chance
17
18.80
17.0
0.05
1
%
HORIZONTAL

BUTTON
6
14
75
47
setup
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
86
14
151
47
go
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
159
15
222
48
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
726
172
920
205
Chance-Of-Contamination
Chance-Of-Contamination
0
1
0.045
0.001
1
NIL
HORIZONTAL

MONITOR
1337
516
1523
561
NIL
Count lettuces with [ CFU > 0 ]
17
1
11

MONITOR
1338
564
1432
609
NIL
Count lettuces
17
1
11

MONITOR
1438
559
1590
604
NIL
Count lettuces with [ CFU > 0 ]  / Chance-Of-Contamination
17
1
11

SLIDER
729
111
901
144
number-links
number-links
0
5
2.0
1
1
NIL
HORIZONTAL

SLIDER
729
210
901
243
diffusion-rate
diffusion-rate
0
100
94.0
1
1
NIL
HORIZONTAL

SLIDER
733
261
905
294
link-diffusion-rate
link-diffusion-rate
0
100
2.0
1
1
NIL
HORIZONTAL

PLOT
953
12
1386
299
plot 1
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" "set-plot-y-range 0 150"
PENS
"default" 1.0 1 -16777216 true "" "set-plot-x-range 0 ceiling (max-flow + 0.5)\nhistogram [ c-flow ] of links"

PLOT
494
539
694
689
plot 2
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
"default" 1.0 1 -16777216 true "" "Histogram [ CFU ] of lettuces "

MONITOR
900
621
1017
666
NIL
In-line
17
1
11

MONITOR
508
804
567
849
NIL
min-flow
17
1
11

MONITOR
914
740
978
785
NIL
max-flow
17
1
11

MONITOR
568
803
639
848
NIL
mean-flow
17
1
11

SLIDER
378
82
618
115
number-nuclei
number-nuclei
1
count patches
1225.0
1
1
NIL
HORIZONTAL

MONITOR
374
216
445
261
NIL
count links
17
1
11

BUTTON
3
444
113
477
NIL
create-linkage
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
289
517
489
667
plot 3
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
"default" 1.0 1 -16777216 true "" "set-plot-x-range 0 ceiling (max-flow + 0.5)\nhistogram [ count my-in-links ] of lettuces"

MONITOR
451
215
584
260
NIL
mean [ CFU ] of lettuces
17
1
11

MONITOR
374
265
466
310
NIL
count lettuces
17
1
11

MONITOR
902
672
959
717
NIL
In-line
17
1
11

MONITOR
529
264
700
309
NIL
count lettuces with [cfu > 0]
17
1
11

MONITOR
375
165
626
210
NIL
count  lettuces with [ cfu < mean[cfu] of lettuces]
17
1
11

MONITOR
1339
722
1538
767
NIL
mean [ cfu] of  lettuces with [cfu > 0]
17
1
11

MONITOR
1294
454
1644
499
NIL
mean [ cfu] of  lettuces with [cfu > 0] * count lettuces with [cfu > 0]
17
1
11

MONITOR
978
552
1111
597
NIL
sum [CFU] of lettuces
17
1
11

MONITOR
373
363
611
408
NIL
sum [CFU] of lettuces with [color = blue]
17
1
11

MONITOR
374
317
607
362
NIL
sum [CFU] of lettuces with [color = red]
17
1
11

MONITOR
666
460
1083
505
NIL
sum [ c-flow] of links + sum [ cfu ] of lettuces with [ color = red]
17
1
11

MONITOR
761
350
964
395
NIL
count lettuces with [ color = blue ]
17
1
11

MONITOR
662
407
924
452
NIL
In-line / ( count lettuces with [ color = blue ])
17
1
11

MONITOR
409
461
663
506
NIL
sum [CFU] of turtles + sum [ c-flow] of links
17
1
11

MONITOR
171
804
421
849
NIL
mean [ cfu ] of lettuces with [ color = blue]
17
1
11

MONITOR
1020
346
1308
391
NIL
In-line + sum [ cfu ] of lettuces with [ color = red]
17
1
11

MONITOR
844
554
970
599
NIL
sum [ c-flow] of links
17
1
11

MONITOR
178
759
424
804
NIL
mean [CFU] of lettuces with [color = blue]
17
1
11

MONITOR
647
742
895
787
NIL
sum [ c-flow] of links + sum [cfu] of turtles
17
1
11

MONITOR
21
604
249
649
NIL
count turtles with [ color = red] * 1000
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model simulates the spontaneous decay of a collection of radioactive nuclei.  As they decay and become stable, the plot of the number that are still radioactive demonstrates the notion of "half-life".

## HOW IT WORKS

At each time tick, each undecayed (light blue) nucleus has a certain chance of decaying.  When a nucleus decays, it briefly flashes bright yellow (as if giving off radiation), then turns dark blue.  Eventually, if you wait long enough, all of the nuclei will have decayed and the model will stop.

## HOW TO USE IT

Set the initial number of nuclei (NUMBER-NUCLEI slider) and the likelihood of decay during each time interval (DECAY-CHANCE slider). Then push the SETUP button. Push the GO button to run the model.

The number of radioactive nuclei that remain is shown in the "Radioactive Nuclei" plot.  Each time the number of nuclei is reduced by half, red and green lines appear on the plot to mark the place where each halfway mark was reached.  The "Decay Rate" plot shows the number of decays that occur during each clock tick.

## THINGS TO NOTICE

What is the shape of the decay curve (Radioactive Nuclei)?  How is this affected by the initial conditions?

Why is the decay curve this shape?  Is it the same as the decay curve shown in books?

The time between red lines is called the half-life.  What is its physical meaning?  Is it constant as the number of nuclei decreases?  Is it affected by the initial number of nuclei or the decay-chance?  Do you think it's a useful way to characterize a radioactive material?

How long does it take for all the nuclei to decay?

Watch one nucleus carefully.  When will it decay?

Radioactivity depends on the number of decays per unit time (Decay Rate), because each decay event gives off radiation.  What happens to the radioactivity of this sample over time?  What is the shape of the decay rate curve?  How is it related to the shape of the decay curve?

Examine the standard equation for nuclear decay:

> N = No (e exp -(T/tau))

No is the initial number of nuclei, N is the number at a later time T, and tau is the "mean lifetime".  Compare its behavior to what you see in this model.  The corresponding equation for radiation is:

> R = Ro (e exp -(T/tau))

Why are these two equations so similar?

## THINGS TO TRY

Try the extremes of the initial conditions: many or few nuclei, high or low decay-chance.  How does this affect the "jaggedness" of the decay rate plot?

What does the plot do when very few nuclei are left?

What instructions would you give each turtle be to make it behave like an unstable nucleus?  Check the code in the Code tab and see if it's what you thought it should be.

Carbon-14 dating involves comparing the ratio of a stable (C-12) to an unstable (C-14) nucleus.  Explain that method in terms of this model.

## EXTENDING THE MODEL

It is often the case in nature that two nuclei with different decay rates are present in the same sample.  Modify this model to have two or more types of nuclei.  What happens to the radiation curve?

In this model, the nuclei don't affect their neighbors when they decay --- they just disappear. Get them to emit particles that in turn cause reactions in other nuclei.  See if you can model a chain reaction.  (See the Reactor Top Down and Reactor X-Section models.)

## RELATED MODELS

* Reactor Top-Down
* Reactor X-Section

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1997).  NetLogo Decay model.  http://ccl.northwestern.edu/netlogo/models/Decay.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1997 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 2001.

<!-- 1997 2001 -->
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
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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

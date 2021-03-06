globals [
  ;;; globals initialized on interface (with i- and setup on setup_globals.nls):
  Iinit rProd Svar1 Svar2 Svar3 tpsExtermination radiusInfestMax file_name nb_managers alpha betap Sd_M Sa_M Sd_C Sa_C deltaSa actionManagers actionControllers
  Controleur_Survey_Capacity_Global deltaSd
  Diffuse_Risque_Global
  ;;; other globals:
  sigma rInfest
  ;;; calculated global
  pct_infected_tot pct_var1 pct_var2
  nb_patchCutted
  nb_patchHidded
  nb_patchCuttedByC
  closestManagerToInit
]
extensions [csv]
breed [ managers manager]        ; managers of patches (farmers)
breed [ controllers controller ]  ; controllers of level of desease (from institutions)
breed [ flags flag ] ; flags are put on patches that are checked by the controllers. They disapear at the end of the year

;;;;; State variables :


turtles-own [ Sa Sd ]       ; both managers and controllers

flags-own [ age ]

controllers-own [ Controleur_Survey_Capacity ]        ; controllers only
managers-own [working_force Income  myAnnualProdTot  myPatches  meanSensibility  myPatchToCut  myPatchesInfested myPatchToHide memProd]     ; managers only
patches-own [ Variety Sensibility Quality Production Infest t_PotentielInfest myManager myneighbors detectInfest Risque pIncome tpsLatence]

;; files with procedures:
__includes["setup_globals.nls" "set_patches.nls"
           "set-managers.nls" "set-controller.nls"
           "develop_patches.nls" "aggr_infest.nls"
           "action_managers.nls" "action_controller.nls" "action_flags.nls"
           "lotterie.nls"
           "yearly_update.nls" "statistic.nls"
           "cosmetics.nls" ]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;                  SETUP                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  setup_globals ; Make a link between the interface variables and the global variables / set a few variables
  set-patches ; Load the map ,initialize the patches according to the map data (Variety ...), give it to a manager
  set-managers ;
  set-controller ; initialize the controler and hide it (visualization of the controller processes are done with the flags)

  ;Infest one patch as seed:
  ask one-of patches [
    set Infest Sensibility * Iinit
  ]
  set closestManagerToInit min-one-of managers [distance one-of patches with [infest != 0]]
  calcul_index ; (in statistics.nls)
  reset-ticks
end

to setup-openmole
  setup_globals_openmole
  set-patches
  set-managers
  set-controller
  ;Infest one patch as seed:
  ask one-of patches [
    set Infest Sensibility * Iinit
  ]
  set closestManagerToInit min-one-of managers [distance one-of patches with [infest != 0]]
  calcul_index ; Calcul statistics (in statistics.nls) on the infested patchs
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;                  GO                                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go

  ask patches [set t_PotentielInfest 0] ;reset temporary variables
  ask patches [develop_patches] ;update the patches according to their own state and propagate the malady on the potential infestation  map
  ask patches [aggr_infest] ; calcul the probability of getting infested according to the potential infestation map and infest the patch if needed
  if actionManagers [ ask managers [action_managers] ] ; Managers sample their field and either hide the infested patches or cut them depending on their acceptation rate
  if actionControllers [
    diffuse risque Diffuse_Risque_Global ; The controler update its risque mental map. This map allows him to give to each patch an index of potential risque
    ask controllers [action_controller] ; Controlers sample all the patches and cut all production if it is too infested
  ]
  if (ticks mod 30) = 0 [   ; happen every 30 ticks at the end of the year of vegetative production
    yearly_update
  ]
  calcul_index ; (in statistics.nls)
  cosmetics
  tick
end

to go-openmole
  while [ticks <= 450 and any? patches with [Infest > 0]] [
    go
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
471
23
979
532
-1
-1
5.0
1
10
1
1
1
0
0
0
1
0
99
0
99
1
1
1
ticks
30.0

BUTTON
3
10
66
43
NIL
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
74
10
137
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

INPUTBOX
11
366
70
426
i-rProd
0.25
1
0
Number

SLIDER
9
253
176
286
i-Iinit
i-Iinit
0
0.1
0.005
0.001
1
NIL
HORIZONTAL

SLIDER
8
181
176
214
i-tpsExtermination
i-tpsExtermination
0
300
60.0
5
1
NIL
HORIZONTAL

BUTTON
140
10
203
43
step
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
8
217
175
250
i-radiusInfestMax
i-radiusInfestMax
1
100
4.0
1
1
NIL
HORIZONTAL

INPUTBOX
0
64
168
124
i-file_name
polygon_gem100_rep
1
0
String

SLIDER
18
428
110
461
i-nb_managers
i-nb_managers
0
100
100.0
1
1
NIL
HORIZONTAL

TEXTBOX
18
335
168
363
Parameters that may not change much:
11
0.0
1

PLOT
988
23
1242
202
Infestation levels of infested plots
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [Infest] of patches with [Infest > 0]"

PLOT
1249
22
1501
203
Number of infested plots
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
"default" 1.0 0 -16777216 true "" "plot count patches with [Infest > 0]"
"pen-1" 1.0 0 -13840069 true "" "plot count patches with [Infest > 0 and Variety = 1]"
"pen-2" 1.0 0 -13345367 true "" "plot count patches with [Infest > 0 and Variety = 0]"

BUTTON
209
11
304
44
go-15years
repeat 15 * 30 [ go ]
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
8
145
175
178
i-alpha
i-alpha
0
2
1.0
0.1
1
NIL
HORIZONTAL

INPUTBOX
80
365
130
425
i-betap
0.5
1
0
Number

TEXTBOX
11
132
161
150
desease parameters:
11
0.0
1

TEXTBOX
6
46
156
64
plots parameters:
11
0.0
1

BUTTON
992
212
1142
245
visualisation potentiel
ask patches [set pcolor scale-color green t_PotentielInfest 0 1]
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
993
249
1143
282
visualisation Infestation
ask patches [set pcolor scale-color orange Infest 0 1]
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
994
286
1135
319
visualisation variety
update_pcolors\nask turtles [show-turtle]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
180
63
249
123
i-file_number
5.0
1
0
Number

MONITOR
1149
211
1254
256
NIL
pct_infected_tot
17
1
11

MONITOR
1260
211
1323
256
NIL
pct_var1
17
1
11

MONITOR
1330
210
1393
255
NIL
pct_var2
17
1
11

MONITOR
1153
260
1267
305
nb_patchCutted
nb_patchCutted
17
1
11

SLIDER
232
168
404
201
i-Sd_M
i-Sd_M
0
1
0.1
0.01
1
NIL
HORIZONTAL

MONITOR
1276
261
1390
306
NIL
nb_patchHidded
17
1
11

SLIDER
234
206
406
239
i-Sa_M
i-Sa_M
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
232
350
404
383
i-Sd_C
i-Sd_C
0
1
0.05
0.01
1
NIL
HORIZONTAL

SLIDER
226
387
398
420
i-Sa_C
i-Sa_C
0
1
0.05
0.01
1
NIL
HORIZONTAL

SLIDER
4
469
202
502
i-Controleur_Survey_Capacity_Global
i-Controleur_Survey_Capacity_Global
0
250
50.0
25
1
NIL
HORIZONTAL

SLIDER
219
428
421
461
i-Diffuse_Risque_Global
i-Diffuse_Risque_Global
0
1
0.5
0.01
1
NIL
HORIZONTAL

BUTTON
990
323
1141
356
visualisation risque
ask patches [set pcolor scale-color green Risque 0 (i-Sa_C / 2)]\nask turtles [hide-turtle]\nask patches [set plabel \"\"]
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
234
243
406
276
i-deltaSa
i-deltaSa
0
0.1
0.0
0.01
1
NIL
HORIZONTAL

SWITCH
268
62
418
95
i-actionManagers
i-actionManagers
0
1
-1000

SWITCH
264
99
420
132
i-actionControllers
i-actionControllers
0
1
-1000

TEXTBOX
238
143
388
161
Managers
11
0.0
1

TEXTBOX
248
326
398
344
Controller
11
0.0
1

SLIDER
232
285
404
318
i-deltaSd
i-deltaSd
0
0.1
0.0
0.01
1
NIL
HORIZONTAL

PLOT
997
363
1228
513
Sd and Sa of managers
NIL
NIL
0.0
10.0
0.0
0.5
true
true
"" ""
PENS
"Sd" 1.0 0 -16777216 true "" "plot mean [sd] of managers"
"Sa" 1.0 0 -955883 true "" "plot mean [sa] of managers"

PLOT
1239
368
1497
518
Manager / Controller activities
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
"Cut" 1.0 0 -16777216 true "" "plot nb_patchCutted"
"Hide" 1.0 0 -1184463 true "" "plot nb_patchHidded"
"CutC" 1.0 0 -2674135 true "" "plot nb_patchCuttedByC"

PLOT
1510
243
1867
518
Incomes (from different points of view)
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Mean of managers" 1.0 0 -16777216 true "" "plot mean [Income] of managers / 100"
"Mean of plots" 1.0 0 -7500403 true "" "plot mean [pIncome] of patches"
"Min of managers" 1.0 0 -2674135 true "" "plot min [Income] of managers / 100"
"Min of plots" 1.0 0 -955883 true "" "plot min [pIncome] of patches"
"Max of managers" 1.0 0 -13840069 true "" "plot max [Income] of managers / 100"
"Max of plots" 1.0 0 -8732573 true "" "plot max [pIncome] of patches"
"Closest manager to init" 1.0 0 -2064490 true "" "plot [Income] of closestManagerToInit / 100"

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
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-dynDesease" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="450"/>
    <metric>pct_infected_tot</metric>
    <metric>pct_var1</metric>
    <metric>pct_var2</metric>
    <enumeratedValueSet variable="i-nb_managers">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Svar1">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-betap">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Svar2">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-rProd">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-radiusInfestMax">
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
      <value value="8"/>
      <value value="16"/>
      <value value="32"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-file_number" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="i-file_name">
      <value value="&quot;random_rep&quot;"/>
      <value value="&quot;polygon_gem10_rep&quot;"/>
      <value value="&quot;polygon_gem100_rep&quot;"/>
      <value value="&quot;polygon_gem1000_rep&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-tpsExtermination" first="30" step="30" last="180"/>
    <enumeratedValueSet variable="i-Svar3">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Iinit">
      <value value="0.005"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EffetControleurs30_8" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="450"/>
    <metric>pct_infected_tot</metric>
    <metric>pct_var1</metric>
    <metric>pct_var2</metric>
    <metric>nb_patchCutted</metric>
    <metric>nb_patchHidded</metric>
    <metric>nb_patchCuttedByC</metric>
    <enumeratedValueSet variable="i-nb_managers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionControllers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionManagers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Controleur_Survey_Capacity_Global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Diffuse_Risque_Global">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_M">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_M">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-betap">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-rProd">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Iinit">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSa">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSd">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-tpsExtermination">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-radiusInfestMax">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-file_name">
      <value value="&quot;polygon_gem10_rep&quot;"/>
      <value value="&quot;polygon_gem1000_rep&quot;"/>
      <value value="&quot;random_rep&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-file_number" first="1" step="1" last="5"/>
  </experiment>
  <experiment name="EffetControleurs180_4" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="450"/>
    <metric>pct_infected_tot</metric>
    <metric>pct_var1</metric>
    <metric>pct_var2</metric>
    <metric>nb_patchCutted</metric>
    <metric>nb_patchHidded</metric>
    <metric>nb_patchCuttedByC</metric>
    <enumeratedValueSet variable="i-nb_managers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionControllers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionManagers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Controleur_Survey_Capacity_Global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Diffuse_Risque_Global">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_M">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_M">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-betap">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-rProd">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Iinit">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSa">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSd">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-tpsExtermination">
      <value value="180"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-radiusInfestMax">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-file_name">
      <value value="&quot;polygon_gem10_rep&quot;"/>
      <value value="&quot;polygon_gem1000_rep&quot;"/>
      <value value="&quot;random_rep&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-file_number" first="1" step="1" last="5"/>
  </experiment>
  <experiment name="EffetControleurs180_4_Doryan" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="450"/>
    <metric>pct_infected_tot</metric>
    <metric>pct_var1</metric>
    <metric>pct_var2</metric>
    <metric>nb_patchCutted</metric>
    <metric>nb_patchHidded</metric>
    <metric>nb_patchCuttedByC</metric>
    <enumeratedValueSet variable="i-nb_managers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionControllers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionManagers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Controleur_Survey_Capacity_Global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Diffuse_Risque_Global">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_M">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_M">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-betap">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-rProd">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Iinit">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSa">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSd">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-tpsExtermination">
      <value value="180"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-radiusInfestMax">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-file_name">
      <value value="&quot;polygon_gem10_rep&quot;"/>
      <value value="&quot;polygon_gem1000_rep&quot;"/>
      <value value="&quot;random_rep&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_C">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-file_number" first="1" step="1" last="5"/>
  </experiment>
  <experiment name="EffetControleurs180_4_David" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="450"/>
    <metric>pct_infected_tot</metric>
    <metric>pct_var1</metric>
    <metric>pct_var2</metric>
    <metric>nb_patchCutted</metric>
    <metric>nb_patchHidded</metric>
    <metric>nb_patchCuttedByC</metric>
    <enumeratedValueSet variable="i-nb_managers">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionControllers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-actionManagers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Controleur_Survey_Capacity_Global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-alpha">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Diffuse_Risque_Global">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_M">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_M">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-betap">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-rProd">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Iinit">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSa">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-deltaSd">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-tpsExtermination">
      <value value="180"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-radiusInfestMax">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-file_name">
      <value value="&quot;polygon_gem10_rep&quot;"/>
      <value value="&quot;polygon_gem1000_rep&quot;"/>
      <value value="&quot;random_rep&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sa_C">
      <value value="0.3"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="i-Sd_C">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="i-file_number" first="1" step="1" last="5"/>
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

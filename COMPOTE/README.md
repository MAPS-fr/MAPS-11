# COMPOTE - COntrole des Maladies Propagées par l'Observation du TErritoire


**Auteurs** : Etienne Delay, Cyril Piou, David Sheeren, Doryan Kaced, Sébastien Rey Coyrehourcq.

# Avant-propos
copie du [hackmd](https://hackmd.io/Itvx7mtlR2uh_j0Zdxzo6A?both)

## Todo fiche

- Introduction du contexte de la réalisation de ce modèle (MAPS 11)
- Overview, diagramme activité, partie processus : _david seb (pour inkscape)_
- replacer les hypothèses dans objectifs du modele + description ds sous modeles + reprise dans le plan de simulation _cyril_
- design concept (repasser dessus et mettre dans l'ordre) : _doryan_
-- description *triade* et *triade de triade* (ref Bruno B + JP Muller?) dc dans grand principe dans Design Concept (_Etienne_)
-- Controleur apprend, paysan s'adapte (_David_)
-- pas de prediction
-- Ajout interaction / indirecte
- partie explo à détailler : _etienne, cyril, seb_
- discussion résultats : _tous_

La présentation est visible [ici](https://rawgit.com/MAPS-fr/MAPS-11/master/COMPOTE/slides/slides-deck-22.html)

## Lexique
Variété = relatif à une espèce (ex : peuplier de variété Beaupré, I35...)
Unité spatiale = 1 peuplement homogène/hétérogène = un ensemble d'arbre d'une même variété

Risque = Probabilité d'un évènement * l'effet négatif de cet événement

## brouillon (pour garder du texte avant de l'effacer...)

**Hypothèses:**

Nous nous sommes intéresser à 3 jeux d'hypothèses :

* N°1
    * H0 Controleur bouge par secteur Et/Ou Transect
* N°2
    * H0 Acteurs proprio cpt homogène
    * H1 Acteurs proprio cpt hétérogène
* N°3
    * H0 Aléatoires sur variété et dans l'espace
    * H1 Structuration spatiale
    * H2 complexité sur propriétaire

~~L'agent qui va observer les peuplements va être amené à prendre des décisions sur une connaissance du système non-intuitif.~~

State Variables:
Environnement
* précipitation
* etc.

A. Parcelles
* Espèce cible / refuge / rien / barrière ?
* (Densité)

B. Gestionnaires:
* Échantillonnage, Perception, Action
* fréquence, saison, nature de l'intervention
* objectifs
* production => maquillage ? L'infestation fait baisser les rendements, production de sortie modulo degré d'infestation par la parcelle, et aussi à l'échelle de l'exploitation
 nature

C. Controleur:

* objectifs
* Modèle d'acceptabilité plus qu'un seul seuil trop simplifié :
* fréquence, saison, nature de l'intervention

Interaction entre Contrôleur et Gestionnaires : Une remontée d'information lors des éradications faites par le gestionnaire, ce qui aura pour effet de mettre à jour la carte de potentiels d'infestation du contrôleur (préalable il ne faut pas punir), et potentiellement accès à de nouvelles zones infestation.

Des gestionnaires pourraient donc réduire leur seuil d'acceptabilité en fonction du passage du contrôleur (il prend + risque au bénéfice d'une meilleure gestion globale).

Inter Saisonalité => Remettre à zéro ou pas infection par parcelle ?

_" process "_
**Parcelle/Maladie**
Apparition aléatoire à l'initialisation.
Estimation du niveau d'infestation en fonction de S
Sensibilité (S) = $f(Q)$
Retribution = $f(Q,P)$ et $Pr = f(I)$
Infection initiale => $f(I_{init},S)$

**Gestionnaire**
Probabilité d'échantillonage => $P(parcelle) = f(Q)$
Probabilité d'action = $f(I_i, Sd, Env, Q_i, Sa, Triade)$
- Eradiquer $S$,$Q$,$P$,$I = 0$
- Camouflage $I$, $P$ baisse (Ce camouflage peut ne pas être qu'en fonction du niveau d'infestation, mais en fonction du manque à gagner potentiel (I*P*Q))
- Replanter les parcelles : probabilité ?

:::warning
 :grey_exclamation: exemple : une parcelles qui produit de la qualité est peut infecté, le gestionnaire n'agira pas. Par contre s'il en percois beaucoup il coupera la parcelle et replantera
:::


**Controleur**
Probabilité d'échantillonnage => par secteur / par transect
Perception
Action

Triade :
Seuil d'acceptabilité de la maladie + mémoire


L'initialisation du modèle a été effectué en plusieurs temps. Une première exploration du modèle a eu lieu. Au cours de celle-ci, les processus des humains n'ont pas été utilisés. Seules les dynamiques de propagation de la maladie ont été utilisées.

Cela a permis d'établir les valeurs que nous avons utilisé pour la propagation de la maladie.


# Introduction

Le travail suivant s'inscrit dans le cadre du 11ème atelier [MAPS dédié aux risques](https://maps.hypotheses.org/). Les objectifs du modèle, sa structure (entités, processus, initialisation, etc.) ont été discuté en groupe puis l'implémentation a été faite en utilisant [Github](https://github.com/MAPS-fr/MAPS-11/tree/master/COMPOTE) afin de développer le code du modèle en parallèle. Les explorations du modèle ont été réalisées à l'aide de la plateforme [OpenMOLE](https://www.openmole.org/).

Le document qui suit présente l'ODD (Grimm et al. 2006) du modèle COMPOTE, le plan de simulation, les résultats de ces simulations et les enseignements que l'on peut en tirer.

# ODD

## 1 - Objectifs

Ce modèle - COMPOTE - a pour objectif de simuler la dynamique de propagation de maladies végétales dans des systèmes cultivés de plantes pérennes (vigne, vergers, plantations arborées) afin de mesurer l'impact des risques inhérents aux pratiques individuelles des acteurs sur cette dynamique. De façon plus précise, le modèle vise à :

- Explorer l'influence de la composition et de la configuration spatiale du paysage sur la propagation de la maladie &#x2713;
- Comprendre et quantifier l'influence des pratiques individuelles divergentes sur le fonctionnement du système &#x2713;
- Explorer les effets d'une réponse institutionnelle et de son efficacité sur l'enrayement de la maladie
- Explorer les effets d'une prise de risque (par volonté de dissimulation de la maladie) ou les effets liés à l'absence de détection de cette maladie, sur les pertes et bénéfices individuels et collectif. &#x2713;

Le modèle a été développé en considérant des traits fonctionnels de propagation de maladies. Les vecteurs de propagation eux ne sont pas spécifiquement représentés.


## 2 - Entités et variables d'état

Le modèle est composé d'espaces cultivés (entité "Parcelle") appartenant à des agents gestionnaires (entité "Gestionnaire") et suivis par un agent contrôleur (entité "Contrôleur"). Ces différentes entités sont situées dans l'espace.

Les **parcelles** sont caractérisées par différentes propriétés (cf. diagramme de classes UML) :
* Sensibilité à la maladie **(S)**
* Degré d'infestation **(I)**
* Qualité de la production **(Q)**
* Quantité de la production **(Pr)**
* Probabilité d'être infestée en fonction du voisinage **(Pi)**

Les **gestionnaires** ont les caractéristiques propres suivantes:
* Seuil detection **(Sd)** - évolutif (capacité d'apprentissage)
* Seuil d'acceptation / tolérance de la maladie **(Sa)**
* Propention au camouflage selon **I** et **Sa**
* Revenu annuel **(Rv)**

Ils conservent aussi des informations sur:
* La sensibilité moyenne de leurs parcelles **($Sm=\sum$S/100)**
* Les historiques des parcelles
* Leurs productions en cours et passées **($Sp=\sum$Pr)**


:::info
 :mag: Triade  du Gestionnaires:
- Sur des variétés peu sensible, il y a incertitudes sur l'issue et il va prendre un risque sur cette incertitude.
- Modèle à seuil
:::


Le **contrôleur** est caractérisé par:
* Seuil detection **(Sd)**
* Seuil d'acceptation / tolérance de la maladie **(Sa)**
* Capacité de prospection **(Sc)**
* Carte mentale de la probabilité de présence de la maladie **(heatmap)**

:::info
 :mag: Triade  du Contrôleur:
- Agir par secteur
- Agit sur des cartes de potentiels (heatmap) préconçues/partielles ou construite lors des collectes précédentes => écrete le I sur la carte
:::


## 3 - Echelles
- Etendue / résolution spatiale : l'espace est représenté par une grille de cellules de 100 x 100 (avec 1 cellule = 1 ha)
- temporelle : Pas de temps d'une semaine, horizon de 15 ans, 1 pas de temps integratif par an (bilan des production à la fin de l'année) après 30 semaines
- 1 propriétaire = 100 ha (10 x 10 cellules chacun)


## 4 - Processus  


### 4.1 - Planification de chaque pas de temps


1. Met à jour l'état des parcelles.
    - Créer de la production si elles ne sont pas totalement infectées (_SM1_).
    - Les infeste plus si elles le sont déjà et propage la maladie sur une  carte d'infestation potentielle (_SM2_).
    - Calcul les probabilités d'être infesté par rapport à la carte d'infestation potentielle (_SM3_).
2. Les fermiers recherchent les parcelles infestés et traitent celles qu'ils trouvent. Un fermier peut soit couper les arbres qui semblent malades soit raser la parcelle si son état est trop grave (_SM4_).
3. Le contrôleur construit sa carte mentale du risque de maladie (_SM5_).
4. Le contrôleur recherche des parcelles malades et les rase (_SM6_).


### 4.2 - Planification du changement d'année ( Tous les 30 pas de temps)


1. Calcul les revenus de chaque producteur (_SM7_).
2. Décision des fermier de replanter les parcelles qui ont été rasées et qui sont à nouveau prêtes à produire avec une variété plus resistante (mais de meilleure qualité) (_SM8_).
3. Actualise le compteur des parcelles qui ne sont pas encore prêtes à produire (_SM9_).


## 5 - Design Concepts

### 5.1 - Adaptation

Deux formes d'adaptations sont présentes dans le modèle et à disposition du gestionnaire. Elles ont pour objectifs de contrer la propagation de la maladie.

- À la fin de l'année, chaque gestionnaire va comparer ses revenus à ceux de l'année précédente. Si ses revenus sont en baisse du à la maladie, il va se former à mieux reperer la maladie et va baiser le seuil d'infestation à partir duquel il rase une parcelle infesté.
- Si une parcelle est rasée à cause de la maladie, le gestionnaire va décider de planter sur cette parcelle une variété moins sensible afin de réduire les chances que cette parcelle ne tombe à nouveau malade.

### 5.2 - Objectifs

Nos deux types d'agents ont des objectifs différents :

- L'objectif des contrôleurs est d'arrêter la maladie.
- L'objectif des gestionnaires est de maximiser ses revenus. Pour ce faire, il doit produire avec ses parcelles et réduire l'avancée de la maladie.

### 5.3 - Apprentissage : approche théorique des triades de Minsky

Pour implementer l'apprentissages dans le modèle compote, nous nous sommes inspiré des travaux de B. Bonté ([2011](https://ur-green.cirad.fr/content/download/4529/34280/version/1/file/These_Bonte.pdf)) sur les triades de Minsky.

> Nous proposons de considérer le triplet "objet, model et observateur" (l'observateur observe l'objet, construit et utilise le modèle). Nous appellons ce triplet la "triade de Minsky" en référence à la définition de modèle données par Marvin Minsky et qui fait intervenir ces trois entités. Bonté (2011, p.3)


Dans le cadre de ce modèle nous avons définit une triade très simple :
* L'observateur (le contrôleur) va évoluer dans un monde qu'il ne perçois qu'en partie. Basé sur cette percetion il va au fur et à mesure se construire une carte d'infection à partir de laquelle il va prendre ses décisions de contrôle. À chaque fois qu'il trouve une parcelle infestée, il va attribuer à sa carte de perception une valeur de risque égale à son niveau d'infestation. À la fin du tour, chaque case de sa carte de potentiel va diffuser sa valeur à son voisin. C'est-à-dire qu'elle va baisser sa valeur et augmenter celle de ses voisins d'un certain pourcentage de sa valeur.
De cette manière, le contrôleur peut oublier avec le temps les zones qui ont un jour été infesté, mais qui ne le sont plus et peut également prendre en compte la notion de propagation dans le voisinage dans son calcul de risque.

:::danger
:fire: Est-ce qu'on a une triade pour le gestionnaire/producteur ? :fire:
Le gestionnaire et le contrôleur possèdent un seuil de détection qui va évoluer au fur et à mesure du temps et en fonction du nombre de fois où ils auront été confronté à la maladie.
:::


### 5.4 - Sensing

Chaque agent contrôleur et gestionnaire possèdent un seuil de détection. C'est-à-dire que parmi les cellules à prospecter qu'il aura sélectionner selon ses critères, il ne va pas obligatoirement repérer toutes les parcelles infestés.
Ici, nous considérons que l'agent ne repère une parcelle infesté que si son degré d'infestation est supérieur à son seuil de perception de l'infestation.

### 5.5 - Stochasticité

Dans notre modèle, de l'aléatoire peut être trouvé sur trois points

- Sur la propagation de la maladie.
À chaque pas de temps, une carte de potentiel de propagation de l'infestation est calculée à partir des cellules infestées decouvertes et de la capacité de propagation de la maladie. Après ce calcul, chaque parcelle a une chance, proportionnelle à ce risque, de devenir infesté.

- Sur la sélection des parcelles à prospecter par le contrôleur
Le contrôleur connaît le niveau de risque de chaque parcelle, mais cherche tout de même à prospecter des terrains qu'il ne connaît pas pour ne pas laisser une potentielle autre infestation dévorer une autre partie du terrain.
Les chances qu'une parcelle soit sélectionnée pour la prospection sont proportionnelles au risque qu'elle a d'être infecté

- Sur la sélection de parcelles à prospecter par le producteur
Le producteur a un biais sur la sélection de parcelles. Il cherche majoritairement à protéger les parcelles les plus sensibles, qui possèdent ici également une plus grande qualité et produisent donc un plus grand revenu.
Il sélectionne donc 15 parcelles aléatoirement parmi celles qui ont une sensibilité supérieure à la moyenne et 5 aléatoirement parmi celles qui ont une sensibilité inférieure à la moyenne.

 ### 5.6 Observations
- Retribution
    - totale moyenne
    - par stratégie
- Taux d'infestation
    - $I$ final
    - trajectoire de $I$ par variété
- nb parcelle detecté / nb parcelle visité
- nb parcelle detecté / nb infesté réel
- Degré de connectivité des parcelles infectés (fragmentation)
Influence du climat micro local &#x2192; influence de la topologie &#x2192; influence sur la maladie

## 6 - Initialisation

### Planification de l'initialisation:

1. Initialiser les parcelles selon un fichier de carte
2. Initialiser les managers
3. Initialiser le contrôleur avec le nombre de parcelles observables par pas de temps et sa carte mentale
4. Infester une parcelle au hasard avec Infection initiale : $I_i = I_{init} \times S$


## 7 - Input Data

En entrée, nous avons utilisé différentes cartes générées avec la bibliothèque nlmr (Neutral Landscape Models for R). Grâce à celle-ci, nous avons pu générer 120 cartes.

- 30 cartes composées de 10 polygones
- 30 cartes composées de 100 polygones
- 30 cartes composées de 1000 polygones
- 30 cartes à attribution de variété totalement aléatoire

Ces cartes servent à tester l'effet de l'influence des configurations spatiales du paysage sur la propagation des maladies.

## 8 - Sous modèles

### 8.1 Actualisation des parcelles / dynamique de la maladie
#### SM1. - Calcul de la production suivant une croissance logistique :
$Pr_{i,t+1} = Pr_{i,t} + (r_P \times (1 - Pr_{i,t} / (1 - I_{i,t})))$

#### SM2 - Evolution linéaire de la maladie en fonction de la sensibilité :
$I_{i,t+1} = I_{i,t} + r \times S_i$

#### SM 3 - Propagation de  la maladie aux voisins suivant une loi Guaussienne de propagation :
$Pi(I_i>0|I_i=0) = \frac{S_i \times \sum( I_j   \times \exp(-dist_{ij}^2/(2\times\sigma^2))}{ (1 + \exp( - ( \alpha * ((S_i \times \sum( I_j   \times \exp(-dist_{ij}^2/(2\times\sigma^2))) - \beta)))) \times radiusIMax ^ 2}$

### 8.2 Actions hebdomadaires du producteur

#### SM4 - Recherche et gestion de la maladie
Au moment de l'action du producteur, il effectue les étapes suivantes:
1. Sélectionne 15 parcelles avec une sensibilité inférieure à la moyenne ($S_i \leq Sm$)
2. Sélectionne 5 parcelles avec une sensibilité supérieur à la moyenne ($S_i \geq Sm$)
3. Sélectionne parmi les 20 parcelles sélectionnées celles qui sont infestées. Les infestations sont détectés si elles sont supérieures au seuil propre à l'agent ($S_i > Sd$)

Pour chaque parcelle infestée trouvée :

4. Si son infestation est supérieure à un seuil d'acceptation propre au producteur ($S_i \geq Sa$), il décide de raser la parcelle pour protéger le reste de son terrain.
5. Sinon ($S_i < Sa$) il décide de ne couper que la partie infestée de son terrain, au risque de ne pas supprimer l'infestation s'il en manque une partie.

Il ne pourra en une semaine que couper l'équivalent d'une parcelle totale arrivée à la production maximale. Ainsi, chaque fois que l'action décidée est de raser, la capacité de travail $W$ est réduite de la valeur $P_i$ de la parcelle rasée. De la même manière $W$ est diminué d'un nombre aléatoire entre 0 et $0.9 \times Sd$ ...


:::danger
Figure  :fire:
L'algorithme n'est pas clair pour hideMyPatch: ne devrait on pas faire un tirage entre 0 et $0.9 \times S_i$ plutôt?
:::

### 8.2 Actions hebdomadaires du controleur
#### SM5 - Actualisation de la carte mentale

:::danger
TODO :fire:  
:::

:::info
NETLOGO:
diffuse risque Diffuse_Risque_Global ; The controler update its risque mental map. This map allows him to give to each patch an index of potential risque
:::

#### SM6 - Recherche et gestion de la maladie

Au moment de l'action du controleur, il effectue les étapes suivantes:

1. Sélectionne un certain nombre de parcelles.
    - Plus une parcelle a un grand risque d'être infesté selon la carte de potentiels, plus elle a de chance d'etre selectionnée

2. Sélectionne parmi les parcelles sélectionnés celles qui sont infestées. Les infestations sont détectés si elles sont supérieures à un seuil propre à l'agent ($S_i > Sd$). Chaque parcelle sélectionnée est rasée.

:::danger
Sa_c n'est pas utilisé!! :scream: :fire: :fire: :fire: :fire_engine:  
:::

:::danger
Figure + Equation :fire:
:::
### Actions annuelles
#### SM7 - Calcul des revenus des producteurs
:::danger
TODO
:::
#### SM8 - Replantation
Décision des fermier de replanter les parcelles qui ont été rasées et qui sont à nouveau prêtes à produire avec une variété plus resistante (mais de meilleure qualité) (_SM8_).

Actualise le compteur des parcelles qui ne sont pas encore prêtes à produire (_SM9_).
:::danger
TODO et décider si 2 SM différents
:::

# Plan de simulation

## DOE explo

Le sampling utilisé pour la première expérience est de type plan complet dans OpenMOLE (voir les scripts dans _[workflow](https://github.com/MAPS-fr/MAPS-11/tree/master/COMPOTE/workflow)_ sur le dépot github du projet)

```scala
val sampling = (seed in (UniformDistribution[Int]() take 5)) x
(tpsExtermination in (20 to 300 by 20)) x
(radiusInfestMax in (1 to 50 by 1)) x
(ifile_name in List("random_rep","polygon_gem10_rep","polygon_gem100_rep","polygon_gem1000_rep")) x
(ifile_number in (1 to 30 by 1))
```

Paramètres :
* $P_{Camouflage}$ => 0..1
* Surface visité

# Resultats


## Pour résumer

| 	                    | Maladie Lente     |	Maladie Rapide    |
|-----------------------|-------------------|-------------------|
|Sa<=Sd (cut)           |	↘☺              |	☹↗ (pas suffisant)|
|Sa > Sd (triche)       | ↗ (la ca ca la catastrophe) |	☹↗ (encore pire)|
|Sa <= Sd (autoritaire) | ↘ pour la maladie |	↗?|
|Sa > Sd (confiance)    | 	↘☺              |	↗?|

# Conclusion


# Bibliographie

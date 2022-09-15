@def title = "Probabilités mathématiques"
@def hascode = true

# Quelques compléments au cours

## Ensemble non mesurable

Un étudiant m'a fait remarquer, ce lundi 12 septembre, que la tribu borélienne de $\mathbb{R}$ n'est pas égale à l'ensemble des parties de $\mathbb{R}$. C'est vrai, et cela implique qu'il y a des parties de $\mathbb{R}$ qui ne sont pas boréliennes. En fait, il existe même des parties qui ne sont pas dans la tribu de Lebesgue. C'est un grand classique et je ne connais pas d'autre exemple que celui que je vais exposer maintenant. 

Pour rappel, la [tribu de Lebesgue](https://fr.wikipedia.org/wiki/Tribu_de_Lebesgue) est la tribu contenant toutes les parties de $\mathbb{R}$ pour lesquelles la mesure de Lebesgue peut être définie. Elle est un peu plus grosse que la tribu borélienne. On va construire un ensemble qui ne peut pas avoir de mesure de Lebesgue.

On part donc de la mesure de Lebesgue sur $\mathbb{R}$, disons $\lambda$. On munit $\mathbb{R}$ de la relation d'équivalence suivante : 
$$ x \sim y \quad \Leftrightarrow \qquad x - y \in \mathbb{Q}.$$
On note $\mathscr{C}$ l'ensemble des classes d'équivalence de cette relation. On choisit exactement un représentant dans chaque classe : disons, pour une classe $C$, on choisit un élément $x \in C$ que l'on notera dorénavant $\tau(C)$. C'est un élément de $\mathbb{R}$. En fait, comme chaque classe $C$ est dense dans $\mathbb{R}$, on peut même choisir $\tau(C)$ dans $[0,1]$. La classe $C$ peut alors s'écrire $C = \tau(C) + \mathbb{Q}$. Enfin, on note $E$ l'ensemble des représentants choisis : 
$$ E = \{ \tau(C) : C \in \mathscr{C}\}.$$

@@important
**Constatation choquante : ** l'ensemble $E$ ne peut pas avoir de mesure de Lebesgue. 
@@

--- 
*Démonstration*. On commence par supposer que $E$ possède une mesure de Lebesgue (c'est-à-dire, qu'il est dans la tribu de Lebesgue), disons $\lambda(E)=a$, et on va démontrer par l'absurde que $a$ ne peut pas être nul et qu'il ne peut pas non plus être non nul. 

Commençons donc par supposer $a=\lambda(E)=0$. 

Chaque nombre réel $x \in \mathbb{R}$ peut s'écrire de façon unique $x = \tau + q$, avec $\tau \in E$ et $q \in \mathbb{Q}$, autrement dit 
$$ \mathbb{R} = \bigcup_{q \in \mathbb{Q}}q + E$$
et les ensembles $q+E$ sont tous disjoints. Si $E$ était Lebesgue-mesurable, ses translatés $q+E$ le seraient aussi, et donc en utilisant les axiomes de la mesure de Lebesgue, on aurait la chose suivante : 
$$\lambda(\mathbb{R}) = \sum_{q \in \mathbb{Q}} \lambda(q+E) = \sum_{q \in \mathbb{Q}} \lambda(E) = 0, $$
ce qui est absurde. Si $E$ possède donc une mesure de Lebesgue, elle ne peut pas être nulle : $\lambda(E) = a >0$, éventuellement $a=\infty$. 

Comme les éléments de $E$ sont entre $0$ et $1$, on voit que
$$ \bigcup_{q \in \mathbb{Q}\cap [0,1]}q+E \subset [0,2]$$
ce qui implique, encore par les axiomes de la mesure de Lebesgue, que
$$\sum_{q \in \mathbb{Q}\cap [0,1]}\lambda(q+E) \leqslant \lambda([0,2]) = 2.$$
C'est encore une absurdité, car $\lambda(q+E) = \lambda(E) = a >0$, et donc la somme de gauche est égale à $\infty$ (on rappelle, à toutes fins utiles, qu'il y a une infinité dénombrable de nombres rationnels entre $0$ et $1$). 

Par conséquent, l'ensemble $E$ ne peut pas avoir de mesure de Lebesgue. Il n'est pas Lebesgue-mesurable. 

---

Max Fathi me dit qu'il y a un théorème disant essentiellement que toute construction d'un ensemble non-Lebesgue-mesurable nécessite l'axiome du choix (que nous avons utilisé ici). Je ne connais pas ce théorème. 
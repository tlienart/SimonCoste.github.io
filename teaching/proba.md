@def title = "Probabilités mathématiques"
@def hascode = true

\toc

# Quelques compléments au cours

## Un ensemble non mesurable

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

## Un ensemble équilibré

Le résultat suivant donne l'existence d'ensembles boréliens qui sont un peu partout dans $[0,1]$, mais pas *vraiment* partout. Ils seraient parfois appelés « ensembles bien équilibrés ». 
@@important
Il existe un ensemble $A \subset [0,1]$, borélien, qui vérifie la propriété suivante : pour tout intervalle $I\subset ]0,1[$, 
$$ 0 < \lambda(A \cap I) < \lambda(I), $$
où $\lambda$ est la mesure de Lebesgue. 
@@

L'existence de cet ensemble n'est pas évidente et je propose une construction facile. D'abord, chaque $x\in[0,1]$ peut s'écrire en binaire $0,x_1x_2x_3\dotsc$ où $x_i \in \{0,1\}$. On pose
$$ S(x) = \sum_{n=1}^\infty \frac{(-1)^{x_n}}{n}.$$
Il se trouve que
1. cette fonction est mesurable, 
2. pour $\lambda$-presque tout $x$, cette somme est finie, 
3. les ensembles $\{S>a\}$ ont bien la propriété demandée, quel que soit $a$. 
Évidemment, c'est surtout le point 3 qui est difficile à démontrer, ce qu'on considérera donc comme un bon exercice (difficile). Accessoirement, le point 2 peut être vérifié de façon probabiliste : en effet, si $x$ est une variable aléatoire uniforme sur $[0,1]$, alors il est facile de voir que $x_n$ est une variable de Rademacher (elle prend les valeurs $\pm 1$ avec probabilité $1/2$). Il n'est alors plus très difficile de vérifier, par exemple, que $S$ est une variable aléatoire $L^2$, donc finie presque sûrement.


## Sur le volume des sphères (on refait les calculs vus en TD)

Aujourd'hui, lundi 3 octobre, nous avons utilisé le théorème de Fubini à de multiples reprises pour calculer le volume (= la mesure de Lebesgue) de la boule unité en toute dimension : 
$$ B_n(r) = \{(x_1, \dotsc, x_n) : \sqrt{\sum_{i=1}^n |x_i|^n} \leqslant r\}.$$
Nous avons vu que l'homogénéité de la mesure de Lebesgue implique que
$$ \lambda(B_n(r)) = r^n \lambda(B_n(1))$$ 
et nous avons montré que
@@important
$$ \lambda(B_n(1)) = \frac{\pi^{n/2}}{\Gamma\left(\frac{n}{2}+1\right)}$$
@@
En fait nous avons démontré une formule équivalente à celle-ci. 

### Calcul

Les grandes lignes de la démonstration qu'on a vue en TD sont les suivantes : 
1) En utilisant le théorème de Fubini pour intégrer seulement sur la variable $x_{n+1}$, on a 
$$ \lambda(B_{n+1}(1)) = \lambda(B_n(1))\int_{-1}^1 (1 - x^2)^{n/2}dx.$$
2) En utilisant de judicieux changements de variables, on a $$\int_{-1}^1 (1 - x^2)^{n/2}dx = \beta(n/2, 1/2)$$ où $\beta$ désigne la célèbre [fonction Bêta](https://fr.wikipedia.org/wiki/Fonction_b%C3%AAta), définie par $\beta(x,y) = \int_0^1 (1-u)^{x-1}u^{y-1}du$. Cette fonction vérifie en outre la belle identité $$ \beta(x,y) = \frac{\Gamma(x)\Gamma(y)}{\Gamma(x+y)}$$ dûe à Euler, et démontrable par un habile changement de variables. 
3) On obtient donc la formule de récurrence suivante : 
$$\lambda(B_{n+1}(1)) = \lambda(B_n(1))\times \frac{\Gamma\left(\frac{n}{2}+1\right)\Gamma(1/2)}{\Gamma\left(\frac{n+1}{2}+1\right)} $$
laquelle se résout par récurrence, permettant d'obtenir
$$ \lambda(B_{n+1}(1)) = \lambda(B_1(1))\times \prod_{i=1}^n\frac{\Gamma(1/2)^n\Gamma(n/2 + 1)}{\Gamma((n+1)/2 + 1)} = \frac{\Gamma(1/2)^n}{\Gamma\left(\frac{n+1}{2}+1\right)}$$
puisque les termes du produit se téléscopent facilement. Il ne reste plus qu'à utiliser la formule (déjà vue en exercice) $\Gamma(1/2) = \sqrt{\pi}$. 

Il existe d'autres démonstrations.

### Remarques 

Il y a plusieurs choses à dire sur cet exercice. 

*Premièrement*, le volume de la sphère unité tend très vite vers zéro (utiliser la formule de Stirling). Son maximum est atteint en $n=5$ ; le volume de la boule unité en dimension 5 est égal à $8\pi^2 / 15 \approx 5,624$, c'est un peu étonnant (je ne sais pas ce que la dimension 5 a de particulier), mais c'est comme ça. Un très bon exercice consiste à essayer de démontrer que ce volume tend vers zéro lorsque la dimension tend vers l'infini, sans passer par le calcul exact. Mon ami Mi-Song m'indique d'ailleurs une bonne intuition sur ce phénomène : le volume du cube unité en dimension $n$ (c'est-à-dire les points dont toutes les coordonnées sont comprisese ntre 0 et 1) est égale à 1, c'est évident; or, son diamètre (la plus grande longueur séparant deux points contenus dans le cube)  est égal à $\sqrt{n}$, qui tend vers l'infini. La boule unité possède un diamètre constant, pas étonnant que son volume tende vers zéro (attention, ceci n'est pas une preuve). 

*Deuxièmement*, un calcul parfaitement équivalent à celui fait plus haut permet de calculer le volume de la boule $L^p$, c'est-à-dire
$$ B_n^p(r) = \{ (x_1, \dotsc, x_n) \in \mathbb{R}^n : |x|_p \leqslant r\}$$
où $|x|_p = (|x_1|^p + \dotsb + |x_n|^p)^{1/p}$. Le calcul donne
$$\lambda(B_n^p(r)) = r^n \frac{\left(2\Gamma\left(\frac{1}{p}+1\right)\right)^n}{\Gamma\left(\frac{n}{p}+1\right)}.$$

*Troisèmement*, un [article de Dirichlet lui-même](http://sites.mathdoc.fr/JMPA/PDF/JMPA_1839_1_4_A11_0.pdf) (en français), daté de 1839, fait le calcul encore plus général suivant : si l'on note
$$A_{p_1, \dotsc, p_n} = \{x \in \mathbb{R}^n, \sum_{i=1}^n |x_i|^{p_i} \leqslant 1 \}$$
alors 
$$\lambda(A_{p_1, \dotsc, p_n}) = \frac{2^n \prod_{i=1}^n\Gamma\left(\frac{1}{p_i} + 1\right)}{\Gamma\left(\frac{1}{p_1} + \dotsb + \frac{1}{p_n}+1\right)}.$$
C'est un calcul qui est parfaitement faisable et qui pourra, par exemple, faire l'objet d'une interrogation. 
 

## Petit point de notation

La fonction de répartition d'une variable aléatoire réelle $X$ est la fonction croissante $F$ définie par
$$ F(t) = \mathbb{P}(X \leqslant t).$$
Attention : si l'on voulait étudier la variable aléatoire $F(X)$, on pourrait être tenté d'écrire
$$F(X) = \mathbb{P}(X \leqslant X) = 1$$
ce qui est évidemment très faux -- c'est un abus de notation. 

Pour que les choses soient claires et justes, il vaut mieux noter $\mu$ la loi de probabilité de $X$ et écrire $F(t) = \mu(]-\infty, t])$ et ainsi, 
$$F(X)(\omega) = \mu(]-\infty, X(\omega)]).$$
  


## Exercice sur les lois conditionnelles

Nous avons vu en exercice de nombreux exemples de variables aléatoires $X,Y$, positives, indépendantes, $L^1$, pour lesquelles 
$$ \mathbb{E}[X | X+Y] = \frac{\alpha}{\alpha + \beta}(X+Y)$$
où $\alpha = \mathbb{E}[X], \beta = \mathbb{E}[Y]$. Par exemple, lorsque $X,Y$ sont des lois de Poisson, ou des lois Gammas avec même paramètre de taux $\lambda$, etc. C'est essentiellement le contenu de l'exercice 4 de la feuille 6.

Est-ce toujours vrai ? Existe-t-il des variables aléatoires $X,Y$ telles que la relation ci-dessus n'est pas valable ?

##  Un corrigé de l'exercice 4 du TD 7

On rappelle que 
$$\alpha = \inf \{t \in \mathbb{R} : \mathbb{P}(X \leqslant t) > 0 \}.$$

On suppose que $\alpha$ n'est pas égal à $-\infty$, c'est le seul cas que je corrigerai. 

Soit $u<\alpha$. Par définition de $\alpha$, on a $\mathbb{P}(X \leqslant u) = 0$. On en déduit que 
$$ \mathbb{P}(\exists n, X_n \leqslant u) = \mathbb{P}\left(\cup_n \{X_n \leqslant u\}\right) \leqslant \sum_{n=1}^\infty \mathbb{P}(X_n \leqslant u) = 0. $$

On pose $A_u = \cap_n \{X_n > u\}$; par ce qui vient d'être dit, $\mathbb{P}(A_u) = 1$. Soit $\omega \in A_u$. Comme $X_n(\omega)>u$ pour tout $n$, on a $\inf_{k\geqslant n}X_k(\omega) \geqslant u$, et donc $\sup_n \inf_{k\geqslant n}X_k(\omega) \geqslant u$, c'est-à-dire $\liminf X_k(\omega) \geqslant u$. On a démontré que : 
@@important
$\forall u < \alpha$, $\mathbb{P}(A_u)=1$ et $\forall \omega \in A_u, \liminf X_k \geqslant u$. 
@@

Maintenant, soit $v>\alpha$. Si l'on avait $\mathbb{P}(X\leqslant v) = 0$, alors on aurait aussi $\mathbb{P}(X \leqslant t) = 0$ pour tout $t \leqslant v$, par croissance de $t\mapsto \mathbb{P}(X \leqslant t)$. Mais alors, par définition de $\alpha$, on devrait avoir $\alpha \geqslant v$, une contradiction. On en déduit que $\mathbb{P}(X \leqslant v)>0$. Ainsi, 
$$\sum_{n=1}^\infty \mathbb{P}(X_n \leqslant v)= +\infty, $$
et par le second lemme de Borel-Cantelli (les $X_n$ étant indépendantes), on a $\mathbb{P}(\limsup \{X_n \leqslant v\})=1$. Notons $B_v =  \limsup \{X_n \leqslant v\}$. Pour tout $\omega \in B_v$, on a: 
\begin{align} \omega \in \bigcap_{n \geqslant 1} \bigcup_{k\geqslant n}\{X_k \leqslant v\} & \Leftrightarrow \forall n \geqslant 1, \exists k \geqslant n, X_k(\omega) \leqslant v\\
& \Rightarrow \forall n \geqslant 1, \inf_{k\geqslant n} X_k(\omega) \leqslant v \\
& \Rightarrow \sup_{n\geqslant 1}\inf_{k\geqslant n}X_k(\omega) \leqslant v
\end{align}
et donc, $\omega \in B_v$ entraîne que $\liminf X_k(\omega) \leqslant v$. Attention, comme dûment remarqué en classe par de nombreuses personnes, **ce n'est pas une équivalence** (plus précisément, le passage de la première ligne à la seconde n'est pas une équivalence). J'adresse donc à la classe mes plus plates excuses pour cet embrouillamini. Bon an, mal an, nous avons démontré que 
@@important
$\forall v > \alpha, \mathbb{P}(B_v) = 1$ et $\forall \omega \in B_v, \liminf X_k (\omega) \leqslant v$. 
@@

On pose finalement 
$$\mathscr{E} = \cap_{\ell = 1}^\infty (A_{\alpha - 1/\ell} \cap B_{\alpha + 1/\ell}).$$ 
Cet événement est une intersection dénombrable d'ensembles de probabilité 1, donc $\mathbb{P}(\mathscr{E})=1$. De plus, soit $\omega \in \mathscr{E}$. Comme $\omega$ est dans $A_{\alpha-1/\ell}$ et dans $B_{\alpha +1/\ell}$, on a 
$$ \alpha - \frac{1}{\ell}\leqslant \liminf X_k(\omega) \leqslant \alpha + \frac{1}{\ell} $$
et ceci est valable pour tout $\ell$, donc on a bien $\liminf X_k(\omega) = \alpha$. 



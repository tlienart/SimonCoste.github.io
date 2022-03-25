+++
titlepost = "Super-Catalan"
date = "Janvier 2022"
abstract = "Une question non-résolue, vieille de 150 ans, et probablement très inutile. "
+++

Les « nombres de Super-Catalan » sont :
$$ S(n,m)=\frac{(2n)!(2m)!}{n!m!(n+m)!} $$
où $m$ et $n$ sont des nombres entiers. En 1867, Catalan propose aux étudiants de lycée de classes préparatoires de démontrer le théorème suivant (c'est dans les *Nouvelles Annales Mathématiques*) : 


@@important
**Théorème.** $S(n,m)$ est un nombre entier.
@@


[![](/posts/img/catalan.png)](http://www.numdam.org/item/NAM_1874_2_13__207_0.pdf)

## Peu intéressant : une démonstration arithmétique

C'est pas compliqué, il suffit de vérifier que les diviseurs du dénominateur $B$ sont aussi des diviseurs du numérateur $A$, et on peut se restreindre aux diviseurs premiers. On calcule la puissance $\beta$ de $p$ dans la décomposition de $B$, la puissance $\alpha$ de $p$ dans celle de $A$, et on vérifie que $\alpha \geqslant \beta$. Il est facile de voir que la plus grande puissance de $p$ qui divise $n!$ est
$$ \sum_{k=1}^\infty \lfloor n/p^k \rfloor $$   
et donc 
$$\beta = \sum_{k=1}^\infty \lfloor n/p^k \rfloor +  \lfloor m/p^k \rfloor +  \lfloor (n+m)/p^k \rfloor $$
Reproduisez donc l'argument pour le numérateur, et obtenez
$$ \alpha = \sum_{k=1}^\infty  \lfloor 2n/p^k \rfloor +  \lfloor 2m/p^k \rfloor $$
Pour terminer, vérifiez que chaque terme de cette seconde somme est plus grand que le terme correspondant dans la première, autrement dit que 
$$ \lfloor n/p^k \rfloor +  \lfloor m/p^k \rfloor +  \lfloor (n+m)/p^k \rfloor \leqslant  \lfloor 2n/p^k \rfloor +  \lfloor 2m/p^k \rfloor  .$$
C'est certainement vrai. 

## Plus intéressant : une identité de Von Szily

La démonstration précédente est un assez nulle, parce que c'est une vérification brutale. En réalité, les $S(n,m)$ sont entiers parce qu'ils peuvent s'écrire sous une forme intéressante : l'identité suivante est appelée *identité de Von Szily*. 

@@important 
$$ S(n,m) = \sum_k (-1)^k \binom{2m}{m+k}\binom{2n}{n+k}$$
@@

**Démonstration.** En identifiant le coefficient de $z^{2m}$ dans l'identité triviale $(1+z)^{n+m}(1-z)^{n+m} = (1-z^2)^{n+m}$, on obtient
$$ (-1)^m \binom{m+n}{m} = \sum (-1)^{m-k}\binom{m+n}{m+k}\binom{m+n}{n+k}$$
et il suffit de multiplier par $(-1)^m (2m)!(2n)!/(m+n)!^2$ pour tomber sur ce qu'on cherche. 

Cette identité est déjà plus parlante : quand il y a des sommes de nombres combinatoires avec des $(-1)^k$, on pense tout de suite à la [formule du crible](https://fr.wikipedia.org/wiki/Principe_d%27inclusion-exclusion). En particulier, on aimerait bien croire que les nombres $S(n,m)$ comptent quelque chose...

## Très intéressant : qu'est-ce qu'une « interprétation combinatoire » ?

Une interprétation combinatoire d'une suite d'entiers $(a_n)$ consiste à trouver des ensembles intéressants, disons $A_n$, tels que $a_n = \mathrm{Card}(A_n)$. Typiquement, il n'est pas difficile de montrer arithmétiquement que les nombres de Catalan, les vrais, à savoir
$$C_n = \frac{1}{n+1}\binom{2n}{n}$$
sont des nombres entiers, mais il est beaucoup plus élégant de voir qu'ils comptent des objets bien connus, par exemple le nombre de bons parenthésages de taille $2n$. La plupart des combinatoriciens apprécient particulièrement ces démonstrations, qui sont souvent élégantes, satisfaisantes, et parfois très subtiles. Parmi les bijections combinatoires bien connues, citons les plus classiques : 

- $\binom{n}{k}$ compte les parties à $k$ éléments d'un ensemble à $n$ éléments

- $n^k$ compte les suites à $k$ éléments à valeurs dans $[n]$

- $2^n$ compte les parties d'un ensemble à $n$ éléments

- $n^{n-2}$ compte [les arbres sur $n$ sommets](https://fr.wikipedia.org/wiki/Formule_de_Cayley)

- $C_n$ compte tellement de choses que Richard Stanley en a rempli [un livre](https://www.cambridge.org/core/books/catalan-numbers/5441FB5B09E9C01185834D9CBB9DFAD9)

- Légèrement moins trivial (!), le nombre $$ \prod_{i=1}^r \prod_{j=1}^s\frac{i+j+t-1}{i+j-1}$$ est entier et compte le nombre de [partitions planes](https://en.wikipedia.org/wiki/Plane_partition) d'une boîte de taille $(r,s,t)$. 


Et donc, que comptent les nombres de Super-Catalan ? 

### Chemins dans le plan

Dans la plupart des problèmes concernant l'interprétation combinatoire de nombres définis avec des quotients de factorielles, on réussit d'abord à trouver une interprétation en termes de chemins sur une grille : par exemple, $\binom{n+m}{n}$ compte le nombre de chemins de la grille $\mathbb{Z}^2$ qui partent à l'origine, qui font $n+m$ pas vers le haut ou la droite, et qui finissent au point $(n,m)$. Voilà les $\binom{8}{4}=70$ chemins qui vont de $(0,0)$ à $(4,4)$ 

[![](/posts/img/latticepath.png)](https://www.robertdickau.com/lattices.html)


Les nombres de Catalan comptent exactement les mêmes chemins, mais qui restent au-dessus de la diagonale : voici les $C_3 = \binom{6}{3} / (3+1) = 5$ chemins, 

[![](/posts/img/catalanpaths.png)](https://www.robertdickau.com/lattices.html)


Mais pour les nombres de Super-Catalan, on n'a encore rien trouvé de la sorte.


### Et donc…


Évidemment, on peut très bien faire celui qui ne comprend pas, et dire que $S(n,m)$ compte le nombre d'éléments de l'ensemble $\{1, \dotsc, S(n,m)\}$. Ça n'est pas si bête, car ça pose la *vraie* question : **qu'est-ce qu'une interprétation combinatoire ?** On veut que les ensembles $A_n$ aient une structure plus riche que $\{1,\dotsc,a_n\}$ : typiquement, on demande une représentation de $A_n$ permettant de vérifier qu'un élément appartient à $A_n$ de façon algorithmiquement efficace. Igor Pak propose la définition suivante: soient $A_n$ des ensembles de cardilan $|A_n| = a_n$. 

@@important
On dit que $A_n$ est une interprétation combinatoire de $A_n$ lorsque l'appartenance à $A_n$ peut être décidée en espace $O(\log n)$. 
@@ 

Avec cette définition, les nombres de Super-Catalan ont une interprétation combinatoire à base d'ensembles de chemins construits par récurrence (voir le Théorème 4.4 dans [cet article](https://arxiv.org/pdf/1803.06636.pdf)), mais il n'y a pas vraiment de description de ces ensembles, ce qui n'est guère satisfaisant...



## Références

- [Un article de référence d'Igor Pak](https://arxiv.org/pdf/1803.06636.pdf) sur les conjectures actuelles en combinatoire. 

- [L'article d'Ira Gessel](https://www.sciencedirect.com/science/article/pii/0747717192900342) sur les généralisations des nombres de Catalan. 

- [Sur l'identité de Von Szily](https://www.researchgate.net/publication/268864619_On_the_Identity_of_von_Szily_Original_Derivation_and_a_New_Proof)

- [Le numéro des *Annales*](http://www.numdam.org/volume/NAM_1874_2_13/) dans lequel Catalan a posé son exercice (voir les questions p.207). 

- Les images des chemins viennent [du site de Robert Dickau](https://www.robertdickau.com/lattices.html). 

Et enfin, un portrait quand même très austère d'Eugène C. en 1884 par Émile Delpérée : 

![pépé Catalan](/posts/img/papi_catalan.jpg)
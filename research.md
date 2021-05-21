+++
title = "Research"
hascode = true
date = Date(2019, 3, 22)
+++
@def tags = ["syntax", "code"]

# Preprints, papers, documents

\toc

# The spectral point of view on large networks

I study spectral properties of random objects like graphs and matrices, and their application to statistical inference problems. The use of low-dimensional spectral embeddings has proven to be a fruitful method in such problems as matrix completion, community detection, graph alignment, etc. I recently got into spectral convolutions in graph neural networks. 


### The spectral gap of sparse random digraphs 

[Arxiv link](https://arxiv.org/abs/1708.00530) -- published in *Annales de l'IHP*. 

I prove an asymptotic upper bound for the second eigenvalue of the transition matrix of the simple random walk, over a random directed graph with given degree sequence. An immediate consequence of this result is a proof of the Alon conjecture for directed regular graphs. The proof is based on a variation of the trace method introduced by Bordenave (2015). 

### Emergence of extended states in random graphs

Joint work with [Justin Salez](https://www.ceremade.dauphine.fr/~salez/). 

[Arxiv link](https://arxiv.org/abs/1809.07587) -- published in *Annals of Probability*. 

We confirm the long-standing prediction that $c=e \approx 2.718$ is the threshold for the emergence of a non-vanishing absolutely continuous part (extended states) at zero in the limiting spectrum of the Erdös-Renyi random graph with average degree $c$.

### Detection thresholds in very sparse matrix completion

Joint work with [Charles Bordenave](http://www.i2m.univ-amu.fr/perso/charles.bordenave/start) and [Raj Rao Nadakuditi](https://web.eecs.umich.edu/~rajnrao/). 

[Arxiv link](https://arxiv.org/abs/2005.06062) -- in revision. 

We completely describe the extremal elements in the eigendecomposition of some very sparse matrices, with a new and efficient point of view regarding the problem of matrix completion in the very hard regime. We show how non-symmetric matrices can sometimes be quite beneficial in such regimes.


### A simpler spectral approach for clustering directed networks

Joint work with [Ludovic Stephan](https://www.lstephan.fr/).

 [Arxiv link](https://arxiv.org/abs/2102.03188) -- submitted. 

 We prove spectral asymptotics for very sparse inhomogeneous random matrices, as well as limits for eigenvector distributions. We apply these results to clustering in sparse, directed networks and we show that the simplest method based on the eigenvectors of the adjacency matrix provably works well. We provide numerical evidence for the superiority of Gaussian mixture against Kmeans when doing the last step of the spectral clustering pipeline.. 



### Eigenvalues of the non-backtracking operator detached from the bulk

Joint work with [Yizhe Zhu](https://sites.google.com/ucsd.edu/yizhe). 

[Arxiv link](https://arxiv.org/abs/1907.05603) -- Published in *Random Matrix Theory and Applications*.

This is a note on "bulk insider" eigenvalues for the non-backtracking spectrum of SBM. We prove their existence in the $\omega(\log n)$ regime, which partially answers a question of [Dall'Amico et al 2019](https://arxiv.org/abs/1901.09715). The existence is still not proved in the sparse regime (feb. 2021).

 
### The characteristic polynomial of sparse matrices seen from infinity

Following the recent paper of [Bordenave, Chafaï and Garcia-Zelada](https://arxiv.org/pdf/2012.05602.pdf), I show that when $A_n$ is a random $n\times n$ matrix with all $n^2$ entries independent random variables with distribution $\mathrm{Bernoulli}(d/n)$ and $d>1$ is fixed while $n \to \infty$, then the random polynomial $q_n(I_n - zA_n)$ converges weakly in distribution towards a random analytic function on $D(0, 1/\sqrt{d})$. This function is a Poisson analog of the *Gaussian Holomorphic Chaos*, see [Najnudel, Paquette, Simm 2020](https://arxiv.org/pdf/2011.01823.pdf). This entails a short proof for the asymptotics of the high eigenvalues of sparse directed Erdos-Réniy matrices, which was proved in  [Arxiv link](https://arxiv.org/abs/2102.03188).

Work in preparation (May 18th, 2021); I'm also working on an extension for random regular graphs.



# Other works


### Order and fluctuations in point processes

In parallel, I'm interested in the rigidites of random point processes, such as number-rigidities, fluctuations reductions, hyperuniformity, and the possible links between these notions. There are different ways in which point processes in $\mathbb{R}^d$ can exhibit a stronger order than the totally chaotic Poisson process; *hyperuniformity* is when the (random) number of points $N_r$ falling in a large domain $B_r$ of radius $r$ has a reduced variance, that is, when 
$$ \lim_{r \to \infty} \frac{\mathrm{Var}(N_r)}{\mathrm{Vol}(B_r)} = 0. $$ 
In this survey, I try to give a mathematical overview of this rich domain. Topics: the Fourier caracterization of hyperuniformity, the fluctuation scale, the links with number-rigidity and maximal rigidity for stealthy processes, the example of pertubed lattices. 

Here is a version of this survey. It's still work in progress.

[Hyperuniformity survey](/assets/survey_hyperuniformity.pdf) (may 2021: added a paragraph on the zeroes of the GEF)

### A note on a generalization of the Erdos-Gallai Theorem

Joint work with Charles Bordenave. 

[Arxiv link](https://arxiv.org/abs/1712.03520)
 -- Published in *Journal of Combinatorial Theory (series B)*.

This is a short note on a generalization of the Erdös-Gallai theorem on graphical sequences.


+++
title = "Research"
hascode = true
date = Date(2019, 3, 22)
+++
@def tags = ["syntax", "code"]

# Preprints, papers, work in progress

\toc



## Extremal eigenvalues


### The spectral gap of sparse random digraphs 

[Arxiv link](https://arxiv.org/abs/1708.00530) -- published in *Annales de l'IHP*. 

I prove an asymptotic upper bound for the second eigenvalue of the transition matrix of the simple random walk, over a random directed graph with given degree sequence. An immediate consequence of this result is a proof of the Alon conjecture for directed regular graphs. The proof is based on a variation of the trace method introduced by Bordenave (2015). 

### Emergence of extended states in random graphs

Joint work with [Justin Salez](https://www.ceremade.dauphine.fr/~salez/). 

[Arxiv link](https://arxiv.org/abs/1809.07587) -- published in *Annals of Probability*. 

We confirm the long-standing prediction that $c=e \approx 2.718$ is the threshold for the emergence of a non-vanishing absolutely continuous part (extended states) at zero in the limiting spectrum of the Erdös-Renyi random graph with average degree $c$.

### Detection thresholds in very sparse matrix completion

Joint work with [Charles Bordenave](http://www.i2m.univ-amu.fr/perso/charles.bordenave/start) and [Raj Rao Nadakuditi](https://web.eecs.umich.edu/~rajnrao/). 

[Arxiv link](https://arxiv.org/abs/2005.06062) -- published in [JoFoCM](https://www.springer.com/journal/10208).  

We completely describe the extremal elements in the eigendecomposition of some very sparse matrices, with a new and efficient point of view regarding the problem of matrix completion in the very hard regime. We show how non-symmetric matrices can sometimes be beneficial in such regimes.


### A simpler spectral approach for clustering directed networks

Joint work with [Ludovic Stephan](https://www.lstephan.fr/).

 [Arxiv link](https://arxiv.org/abs/2102.03188) -- in rework. 

 We prove spectral asymptotics for very sparse inhomogeneous random matrices, as well as limits for eigenvector distributions. We apply these results to clustering in sparse, directed networks and we show that the simplest method based on the eigenvectors of the adjacency matrix provably works well. We provide numerical evidence for the superiority of Gaussian mixture against Kmeans when doing the last step of the spectral clustering pipeline.. 



### Eigenvalues of the non-backtracking operator detached from the bulk

Joint work with [Yizhe Zhu](https://sites.google.com/uci.edu/yizhezhu). 

[Arxiv link](https://arxiv.org/abs/1907.05603) -- published in *Random Matrix Theory and Applications*.

This is a note on "bulk insider" eigenvalues for the non-backtracking spectrum of SBM. We prove their existence in the $\omega(\log n)$ regime, which partially answers a question of [Dall'Amico et al 2019](https://arxiv.org/abs/1901.09715). The existence is still not proved in the sparse regime (feb. 2021).

 
### The characteristic polynomial of sparse matrices seen from infinity

[Arxiv link](https://arxiv.org/abs/2106.00593) -- published in *Electronic Journal of Probability*. 

Following the recent paper of [Bordenave, Chafaï and Garcia-Zelada](https://arxiv.org/pdf/2012.05602.pdf), I show that when $A_n$ is a random $n\times n$ matrix with all $n^2$ entries independent random variables with distribution $\mathrm{Bernoulli}(d/n)$ and $d>1$ is fixed while $n \to \infty$, then the random polynomial $det(I_n - zA_n)$ converges weakly in distribution towards a random analytic function on $D(0, 1/\sqrt{d})$. This function is a Poisson analog of the *Gaussian Holomorphic Chaos*, see [Najnudel, Paquette, Simm 2020](https://arxiv.org/pdf/2011.01823.pdf).  The result is also proved when $d$ is allowed to grow to infinity with $n$ slowly. In this semi-sparse regime, the limits are more classical Gaussian objects and the statement on the eigenvalues is still valid: in particular, the second eigenvalue sticks to the bulk of the circular distribution. 

### The characteristic polynomial of sums of permutations

Joint work with [Yizhe Zhu](https://sites.google.com/uci.edu/yizhezhu) and [Gaultier Lambert](http://user.math.uzh.ch/gaultier/) 

[Arxiv link](https://arxiv.org/abs/2204.00524) -- published in *International Mathematical Research Notices*

Following the preceding item, we proved a similar result for the characteristic polynomial of sums of random uniform permutation matrices. The paper contains an appendix on sums of Ewens-distributed permutations. 

### The spectrum of fullerenes and graphenes

Joint work with Artur Bille, [Evgeny Spodarev](https://www.uni-ulm.de/en/mawi/institute-of-stochastics/staff/staff/evgeny-spodarev/), [Victor Buchstaber](https://en.wikipedia.org/wiki/Victor_Buchstaber) and [Satoshi Kuriki](https://www.ism.ac.jp/~kuriki/)

[Arxiv link](https://arxiv.org/abs/2306.01462), submitted

Graphene is the infinite tiling of the plane with hexagons. Fullerenes are finite planar 3-regular graphs with all faces being hexagons or pentagons. We explore the eigenvalues of these two graphs from various point of views: global convergence of the spectrum of fullerenes (and local weak convergence), analytic formulas for the density of states on the graphene, combinatorial identities. 

### Stability of scattering transforms on sparse graphs

We show that scattering transforms on graphs are continuous with respect to local-weak distance: as a consequences, these graph descriptors are transferable among network models sharing the same local properties and show a remarkable degree of stability, even in very sparse graph models. From an experimental perspective, we examine how these non-learned transforms characterize graph models and graph signals through moment-constrained sampling. 

Work in progress with Bartek B. and Bharatt Chowdhuri. 


## Generative models

### Wavelet Score-Based Generative Modeling

[Arxiv link](https://arxiv.org/abs/2208.05003), joint work with Florentin Guth, [Valentin de Bortoli](https://vdeborto.github.io/) and [Stéphane Mallat](https://www.di.ens.fr/~mallat/) -- accepted at *Neurips 2022*

In deep learning, score-based diffusion models recently achieved very impressive results in generating samples from unknown distributions, especially in images. However, training these models and sampling from them is very costly. In this collaboration with Florentin Guth, Valentin de Bortoli and Stéphane Mallat, we propose a multi-scale approach and show why sampling high frequencies conditionnaly on lower scales can considerably accelerate everything; we provide a theoretic analysis of this and show how separating scales is similar to preconditioning the data distribution. 

### Training EBMs with Jarczynski reweighting

[Arxiv link](https://arxiv.org/abs/2305.19414), joint work with Davide Carbone, Mengjian Hua and [Eric Vanden-Eijnden](https://wp.nyu.edu/courantinstituteofmathematicalsciences-eve2/)

Energy-based models (EBMs) are generative models inspired by statistical physics. Their performance is measured by the cross-entropy (CE) of the model distribution relative to the data distribution. Using the CE as the objective for training is challenging because the computation of its gradient wrt the model parameters requires sampling the model distribution. We show how results for nonequilibrium thermodynamics based on Jarzynski equality can be used to perform this computation efficiently and avoid the uncontrolled approximations made using the standard contrastive divergence algorithm. 

## Order and fluctuations in point processes

### Hyperuniformity survey

In parallel, I'm interested in the rigidites of random point processes, such as number-rigidities, fluctuations reductions, hyperuniformity, and the possible links between these notions. There are different ways in which point processes in $\mathbb{R}^d$ can exhibit a stronger order than the totally chaotic Poisson process; *hyperuniformity* is when the (random) number of points $N_r$ falling in a large domain $B_r$ of radius $r$ has a reduced variance, that is, when 
$$ \lim_{r \to \infty} \frac{\mathrm{Var}(N_r)}{\mathrm{Vol}(B_r)} = 0. $$ 
In this survey, I try to give a mathematical overview of this rich domain. Topics: the Fourier caracterization of hyperuniformity, the fluctuation scale, the links with number-rigidity and maximal rigidity for stealthy processes, the example of pertubed lattices. 

Here is a version of this survey. It's still work in progress.

[Hyperuniformity survey](/assets/survey_hyperuniformity.pdf) (june 2021: added a paragraph on JLM laws)



### Effective rigidity with neural networks

Many stationary point processes have recently been shown to be *rigid*, that is, the number of points of the process inside a disk is a measurable function of the point configuration outside the disk. However, most of these functions are limits of linear statistics of the point process and they frequently have an exponential radius of stabilization, making it nearly impossible to effectively recover the number of points in a small disk by the observation of the configuration in a large window. Can we construct more explicit reconstruction functions ? With a deep learning perspective, one can try to train invariant neural networks to get back this number and evaluate the complexity of the solutions. 

Work in progress with Antoine Brochard. 



## Misc




### A note on a generalization of the Erdos-Gallai Theorem

Joint work with Charles Bordenave. 

[Arxiv link](https://arxiv.org/abs/1712.03520)
 -- Published in *Journal of Combinatorial Theory (series B)*.

This is a short note on a generalization of the Erdös-Gallai theorem on graphical sequences.


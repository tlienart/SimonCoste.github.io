+++
title = "Directed Erdos-Rényi graphs"
date = "today"
abstract = "On the global shape of the spectrum of non-normal random matrices."
+++

# The spectrum of directed random graphs: global aspects



A directed Erdos-Rényi graph is the simplest of directed random graphs: you put $n$ nodes, and each one of the $n^2$ potential edges (including self-loops) is put independently with probability $p$. The resulting graph is $G_n$, and we'll note $\mathcal{G}(n,p)$ its probability distribution, even though this notation is usually kept for undirected graphs. 

The mean number of edges in $G_n$ is clearly $n^2 p$. When $p=d/n$, this is $nd$, a regime called sparse because the mean number of edges has the same order as the number of vertices, as opposed to dense regimes where $p$ does not depend on $n$, and the mean number of edges has order $n^2$. 

## The spectrum 

The adjacency matrix of $G_n$ is thus an $n \times n$ matrix filled with zeros (a lot) and ones (a few), and it is not symmetric nor normal in any way. Consequently, its $n$ eigenalues are complex numbers, say
$$\Lambda = \{\{ \lambda_1, \dotsc, \lambda_n \} \} .$$
Obviously, since $A_n$ is *real*, the spectrum $\Lambda$ is symmetric with respect to the x-axis. In fact, if $\lambda$ is an eigenvalue and $v$ an eigenvector, then 
$$ A \overline{v} = \overline{ A v } = \overline{ \lambda v} = \overline{\lambda} \overline{v} $$
which proves that $\overline{\lambda}$ is also an eigenvalue of $A$. All the information on $\Lambda$ is encapsulated in the spectral measure, a purely atomic measure on $\mathbb{C}$ defined as 
$$ \mu = \frac{1}{n}\sum_{\lambda \in \Lambda} \delta_{\lambda}. $$

![test](/assets/anim_er.gif)

## The questions

There are not so much results on the properties of $\mu$ in the sparse regime and when $n$ is large. There are results when the underlying graph is undirected ; there are results when $d$ goes to $\infty$ with $n$ ; but otherwise, there is almost nothing. 

**Theorem**. Fix any small $\epsilon$. With probability going to 1 as $n \to \infty$, the largest eigenvalue is simple, real, and asymptotically close to $d$. All the other eigenvalues have modulus smaller than $\sqrt{d} + \epsilon$. Moreover, zero is an eigenvalue of $A$ with multiplicity greater than $e^{-d}$. 

I don't know any other spectral results in this regime. Among the interesting ones, here is a list of conjectures. 

- $\mu$ converges weakly towards a radial complex measure $\rho$. 

- $\rho$ is supported on the disk of radius $\sqrt{d}$. 

- 



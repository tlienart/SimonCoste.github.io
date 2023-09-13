+++
titlepost = "The Kullback-Leibler divergence between Gaussians"
date = "June 2022"
abstract = "I'll know once and for all where to find this damn formula. "
+++

For two probability measures $\mathbb{P}, \mathbb{Q}$ supported on $\mathbb{R}^d$ and with densities $p,q$ with respect to the Lebesgue measure, the Kullback-Leibler divergence between them is defined as
$$ \mathrm{kl}(\mathbb{P}\Vert \mathbb{Q}) = \mathbb{E}_{X \sim \mathbb{P}}\left[ \ln \left(\frac{p(X)}{q(X)}\right)\right] = \int_{\mathbb{R}^d} p(x)\ln(p(x)) - p(x)\ln(q(x))\mathrm{d}x.$$

**Reminders on the $\mathrm{kl}$ divergence**. 

If $f$ is a density function, the « relative entropy of $p$ with respect to $f$ » is the nonnegative quantity defined as
$$H_p(f)=-\int p(x) \ln f(x)\mathrm{d}x.$$
Information theory *à la Shannon* tells us that this is the mean cost of « [encoding](https://en.wikipedia.org/wiki/Entropy_coding) » random variables drawn for $p$ using the density $f$. This cost is minimized for $h=p$ and the minimal cost is $H_p(p)$, the entropy of $p$ -- that's Shannon's theorem. The Kullback-Leibler divergence is thus the difference $H_p(f) - H_p(p)$; in other words, it quantifies what is lost when encoding $p$ with $q$, or in other words what quantity of information on $p$ is **not** contained in $q$. 

## The KL divergence between two Gaussian distributions

In dimension $d$, the Gaussian distribution $\mathscr{N}(\mu, \Sigma)$ with mean $\mu$ and covariance $\Sigma$ (a $d\times d$ positive, nonsingular matrix) is given by
$$ g_{\mu, \Sigma}(x) = \frac{1}{\sqrt{(2\pi)^d |\Sigma|}}\exp\left\lbrace - \frac{\langle x- \mu, \Sigma^{-1}(x-\mu)\rangle }{2}\right\rbrace$$
where $|\Sigma|$ is the determinant of the matrix $\Sigma$. The point of this note is the following formula --- no one remembers it and I always have to google it myself.

@@important
\begin{equation}\label{1}
\mathrm{kl}(\mathscr{N}(\mu_1, \Sigma_1)\Vert \mathscr{N}(\mu_2, \Sigma_2)) = \frac{1}{2}\ln |\Sigma_2\Sigma_1^{-1}| - \frac{d}{2} + \frac{1}{2}\mathrm{trace}(\Sigma_1 \Sigma_2^{-1}) + \frac{1}{2}\langle \mu_2 - \mu_1,  \Sigma_2^{-1}(\mu_2-\mu_1)\rangle.
\end{equation}
@@


### The proof, if someones needs it

We'll note $p = g_{\mu_1, \Sigma_1}$ and $q=g_{\mu_2, \Sigma_2}$, so that
$$ \mathrm{kl}(\mathscr{N}(\mu_1, \Sigma_1)\Vert \mathscr{N}(\mu_2, \Sigma_2)) = \mathbb{E}[\ln(p(X)/q(X))]$$
where $X \sim \mathscr{N}(\mu_1, \Sigma_1)$. From the definitions, $\ln p(x)/q(x)$ is equal to
\begin{align}\label{5}
 \frac{\ln |\Sigma_2| - \ln |\Sigma_1|}{2} - \frac{1}{2}\langle x-\mu_1, \Sigma_1^{-1}(x-\mu_1)\rangle + \frac{1}{2}\langle (x-\mu_2), \Sigma_2^{-1}(x-\mu_2)\rangle .
 \end{align}

 We recall that for any vector $x\in\mathbb{R}^d$ and matrix $M$, we can write $\langle x, Mx\rangle = \mathrm{trace}(xx^\top M)$; moreover, we recall that 
- expectations can be swapped with linear maps, ie if $\ell : \mathbb{R}^d \to \mathbb{R}$ is linear then $\mathbb{E}[\ell(X)] = \ell(\mathbb{E}[X])$, 
- if $X \sim \mathscr{N}(\mu_1, \Sigma_1)$ then $\mathbb{E}[(x-\mu_1)(x-\mu_1)^\top] = \Sigma_1$.  
Consequently, 
    \begin{align}\mathbb{E}[\langle x-\mu_1, \Sigma_1^{-1}(x-\mu_1)\rangle] &= \mathbb{E}[\mathrm{trace}((x-\mu_1)(x-\mu_1)^\top \Sigma_1^{-1})] \\
    &= \mathrm{trace}(\mathbb{E}[(x-\mu_1)(x-\mu_1)^\top] \Sigma_1^{-1})\\
    &= \mathrm{trace}(\Sigma_1 \Sigma_1^{-1}) \\&= d.\end{align}
For the second term in \eqref{5}, since $X-\mu_1$ is centered we note that $\mathbb{E}[(x-\mu_2)(x-\mu_2)^\top] = \Sigma_1 + (\mu_2 - \mu_1)(\mu_2-\mu_1)^\top$, so that
    \begin{align}\mathbb{E}[\langle x-\mu_2, \Sigma_2^{-2}(x-\mu_2)\rangle] &= \mathrm{trace}(\Sigma_1^{-1}\Sigma_2) + \langle \mu_2 - \mu_1,  \Sigma_2^{-1}(\mu_2-\mu_1)\rangle.\end{align}
Gathering everything into \eqref{5} we get exactly \eqref{1}. 


+++
titlepost = "Gaussian conditioning "
date = "September 2023"
abstract = "The conditional distribution of some part of a gaussian vector given the other"
+++

Let $X $ be a Gaussian vector over $\mathbb{R}^n$ with mean $\mu$ and covariance matrix $\Sigma$. Split $X$ in two bits, say $X = (X_1, X_2)$ with respective sizes $n_1, n_2$ (here $n_1 + n_2 = n$). What is the conditional distribution of $X_1$ given $X_2$? First, let us split the mean and covariance of $X$ into the corresponding blocks: 
\begin{align}\mu = \begin{bmatrix}\mu_1 \\ \mu_2 \end{bmatrix}&&&&\Sigma = \begin{bmatrix} \Sigma_{1,1}&\Sigma_{1,2}\\ \Sigma_{2,1} & \Sigma_{2,2}\end{bmatrix}\end{align}
so that for example $X_1$ is a Gaussian with mean $\mu_1$ and covariance $\Sigma_{1,1}$. Obviously, since $\Sigma$ is symmetric, $\Sigma_{2,1} = \Sigma_{1,2}^\top$. 

@@deep

**Theorem.**
The distribution of $X_1$ conditionally on $X_2$ is a Gaussian random variable with mean
\begin{equation}
m=\mu_1 +  \Sigma_{1,2}\Sigma_{2,2}^{-1}(X_2 - \mu_2)
\end{equation}
and with covariance
\begin{equation}\label{var}  S=\Sigma_{1,1} - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{1,2}^\top .\end{equation}
@@

## Proof 

### By block-inversion

Let $f(x,y)$ be the joint density for $(X_1,X_2)$, namely
$$ f(x,y) = \frac{\exp\left(- \frac{1}{2} \langle z, \Sigma^{-1} z\rangle \right)}{(2\pi)^{n/2}\sqrt{\det \Sigma}} \quad \text{where} \quad z = (x,y)^\top.$$
It is well known that the conditional distribution of $X_1$ given $X_2=y$ is 
$$f(x\mid y)= \frac{f(x,y)}{\int f(x,y)dx}.$$
We could perform this exact computation and find the claim in the theorem but. To proceed, we need to find the expression of the inverse of $\Sigma$. That is doable, and indeed the famous [Schur formulas](https://en.wikipedia.org/wiki/Block_matrix) tell us that 
\begin{equation}\label{block} \Sigma^{-1} = \begin{bmatrix}S^{-1} & - S^{-1}\Sigma_{1,2}\Sigma_{2,2}^{-1} \\ 
-\Sigma_{2,2}^{-1}\Sigma_{2,1}S^{-1} & \Sigma_{2,2}^{-1} + \Sigma_{2,2}^{-1}\Sigma_{2,1} S^{-1}\Sigma_{1,2}\Sigma_{2,2}^{-1}\end{bmatrix}\end{equation}
where $S$ is called the *Schur complement* of the first block of $\Sigma$, 
$$ S = \Sigma_{1,1} - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,1}.$$
We immediately recognize \eqref{var}. By carefully reorganizing the terms inside $f(x,y)$ we would readily find that $f(x\mid y)$ is proportional to 
$$ \exp\left( - \frac{1}{2}\langle x-m, S^{-1}(x-m)\rangle\right)$$
hence the theorem would be proved. 

I find this method computational and I never remember the block-inversion formula \eqref{block}. 

Instead, there is a simpler, more conceptual path: observe that $\log f(x,y)$ is a quadratic function in $(x,y)$, hence when $y$ is fixed, $\log f(x,y)$ is still a quadratic function in $x$. But obviously, log-quadratic probability densities are precisely Gaussian densities. We just proved that
@@important 
\begin{equation}\label{st}\text{the conditional distribution of a Gaussian vector remains Gaussian.}\end{equation}
@@
Hence, all we have to do is to compute the conditional mean and the conditional variance, namely
\begin{align}\label{eq}&\mathbb{E}[X_1 \mid X_2] &\quad\text{and}\quad& \mathrm{Var}(X_1\mid X_2) = \mathbb{E}[(X_1 -\mathbb{E}[X_1 \mid X_2] )(X_1 -\mathbb{E}[X_1 \mid X_2] )^\top \mid X_2] . \end{align}
 

### Decorrelating $X_1$ and $X_2$


To compute \eqref{eq}, there is a clever trick. The idea is to remove the part of $X_1$ wich depends on $X_2$, to get something independent of $X_2$. Indeed, we want to find a matrix $M$ such that $Z=X_1 + MX_2$ is independent of $X_2$. Since $Z,X_2$ are jointly Gaussian, they only need to be decorrelated, that is $\mathbb{E}[ZX_2^\top]=0$ which translates into $\mathbb{E}[X_1 X_2^\top] + M \mathbb{E}[X_2X_2^\top]=0$, hence 
\begin{equation}M = - \Sigma_{1,2}\Sigma_{2,2}^{-1}\end{equation}
and for future reference, 
@@proof
\begin{align}&Z = X_1 -  \Sigma_{1,2}\Sigma_{2,2}^{-1} X_2 &&& X_1 = Z +  \Sigma_{1,2}\Sigma_{2,2}^{-1}X_2.\end{align}
@@

### Conditional mean

Now, we can compute the conditional mean: 
\begin{align}\mathbb{E}[X_1\mid X_2] &= \mathbb{E}[Z \mid X_2] + \Sigma_{1,2}\Sigma_{2,2}^{-1}\mathbb{E}[X_2 \mid X_2] \\&=  \mathbb{E}[Z] + \Sigma_{1,2}\Sigma_{2,2}^{-1} X_2\\
&= \mathbb{E}[X_1] - \Sigma_{1,2}\Sigma_{2,2}^{-1}\mathbb{E}[X_2]  + \Sigma_{1,2}\Sigma_{2,2}^{-1}\mid X_2\\
&= \mu_1 -  \Sigma_{1,2}\Sigma_{2,2}^{-1}\mu_2 + \Sigma_{1,2}\Sigma_{2,2}^{-1}X_2 \\
&= \mu_1 +  \Sigma_{1,2}\Sigma_{2,2}^{-1}(X_2 - \mu_2).
\end{align}

### Conditional variance

For the conditional variance, we note that 
$$ X_1 -\mathbb{E}[X_1 \mid X_2] = Z - MX_2 - (\mathbb{E}[Z] - MX_2)  = Z-\mathbb{E}[Z]$$
hence $X_1 -\mathbb{E}[X_1 \mid X_2] $ is independent of $X_2$, and in particular $\mathrm{Var}(X_1 \mid X_2) = \mathrm{Var}(Z)$ and
\begin{align}
\mathrm{Var}(Z)&= \mathrm{Var}(X_1) + M\mathrm{Var}(X_2)M^\top + \mathrm{Cov}(X_1, MX_2) + \mathrm{Cov}(MX_2, X_1) \\
&= \Sigma_{1,1} + \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,2}(\Sigma_{1,2}\Sigma_{2,2}^{-1})^\top + \Sigma_{1,2}M^\top + M\Sigma_{2,1}\\
&= \Sigma_{1,1} + \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{1,2}^\top - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{1,2}^\top - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,1}\\
&= \Sigma_{1,1} + \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,1} - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,1} - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{2,1}\\
&= \Sigma_{1,1} - \Sigma_{1,2}\Sigma_{2,2}^{-1}\Sigma_{1,2}^\top .
\end{align}
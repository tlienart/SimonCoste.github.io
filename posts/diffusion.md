+++
titlepost = "Diffusion models"
date = "March 2023"
abstract = "A small mathematical summary. "
+++


These are my own notes for the formulation of the celebrated Denoising Diffusion Probabilistic Models; they're intended for mathematicians, hence the notations and style is quite different than in the original papers. In particular, I completely formulate everything as a continuous stochastic problem, then only in the end discretize the theoretical losses. This is exactly the opposite to what was done in the papers. 

References will be added soon. 

\tableofcontents

## The problem 

Let $p$ be a probability density on $\mathbb{R}^d$. The goal of generative modelling is twofold: given a training sample $x^1, \dotsc, x^n$ of realizations of $p$, we want to 
1) learn $p$ from the samples; 
2) learn how to sample from $p$. 
Let $(p_\theta)$ be a family of probability densities parametrized by $\theta$; for example, one can choose $p_\theta$ to be the centered Gaussian distribution on $\mathbb{R}^d$ with covariance $\theta$, although this family is not extremely expressive. One could also take a family of functions, say $E_\theta : \mathbb{R}^d \to \mathbb{R}$, and set $p_\theta(x) = e^{-E_\theta(x)}/Z_\theta$ with $Z_\theta = \int_{\mathbb{R}^d}e^{-E_\theta(y)}dy$. These are called *energy-based models* (EBMs). There are many ways in which we can parametrize a family of distribution functions, we'll go back at this problem later. 

One the parametrization is chosen, our goal is to find the $\theta_\star$ such that $p_{\theta_\star}$ is as close as possible to $p$. If we knew $p$, we would simply take 
$$ \theta_\star \in \argmin_\theta \mathrm{dist}(p,p_\theta)$$
where $\mathrm{dist}$ is some may to measure the dissimilarity between distribution functions -- it doesn't have to be a measure, it can be a divergence. Typically, one takes $\mathrm{kl}$, the Kullback-Leibler divergence: 
$$ \mathrm{kl}(p\mid q) = \int p(x) \log (p(x)/q(x))dx.$$
Minimizing $\mathrm{kl}(p\mid p_\theta)$ with respect to $\theta$ is the same thing as maximizing $\mathbb{E}_{X \sim p}[\log p_\theta(X)]$ -- both criteria yield the same optimal $\theta$, called the *maximum-likelihood estimator*. Now, since we do not have access to $p$, we have to approximate it using $\hat{p} = n^{-1}\sum \delta_{x^i}$. The objective function becomes
$$\ell(\theta) = \frac{1}{n}\sum_{i=1}^n \log p_\theta(x^i). $$


## Stochastic diffusions

### SDEs transport the data distribution towards a near-Gaussian

Let $(t,x)\to f_t(x)$ and $t\to \sigma_t$ be two smooth functions. Consider the stochastic differential equation
\begin{equation}\label{SDE}dX_t = f_t(X_t)dt + \sqrt{2\sigma_t ^2}dB_t, \qquad \qquad X_0 \sim p\end{equation}
where $dB_t$ denotes integration with respect to a Brownian motion. Under mild conditions on $f$, an almost-surely continuous stochastic process satisfying this SDE exists.  

Let $p_t$ be the probability density of $X_t$. It is a solution of the [Fokker-Planck equation](https://en.wikipedia.org/wiki/Fokker%E2%80%93Planck_equation): 
$$ \partial_t p_t(x) = \Delta (\sigma_t^2 p_t(x)) - \nabla \cdot (f_t(x)p_t(x)).$$
Importantly, this equation be recast as a transport equation: noting $v_t(x) = \sigma_t^2 \nabla \log p_t(x) - f_t(x)$ (called the **velocity field**), the equation \eqref{SDE} is equivalent to
@@important
\begin{equation}\label{TE} \partial_t p_t(x) = \nabla \cdot (v_t(x)p_t(x)).\end{equation}
@@ 

For simple functions $f$, we can completely solve \eqref{SDE} with an explicit representation.  Here we focus on the case where $f_t(x) = -\alpha_t x$ for some function $\alpha$, that is
\begin{equation}\label{ou}
dX_t = -\alpha_t X_t + \sqrt{2\sigma_t^2}dB_t.
\end{equation}
@@important
Define $\mu_t = \int_0^t \alpha_s ds$. Then, the solution of \eqref{ou} is given by the following stochastic process: 
\begin{equation}\label{sde_sol} X_t  = e^{-\mu_t}X_0 + \sqrt{2}\int_0^t e^{\mu_s-\mu_t} \sigma_s dB_s.\end{equation}
@@
In particular, the second term reduces to a Wiener Integral; it is a centered Gaussian with variance $2\int_0^t e^{2(\mu_s-\mu_t)}\sigma_s^2 ds$, hence 
\begin{equation}\label{pt} X_t \stackrel{\mathrm{law}}{=} e^{-t}X_0 + \mathscr{N}\left(0, 2\int_0^t e^{2\mu_s - 2\mu_t}\sigma_s^2 ds\right).\end{equation}
In the pure Orstein-Uhlenbeck case where $\sigma_t = \sigma$ and $\alpha_t = 1$, we get $\mu_t = t$ and $X_t = e^{-t}X_0 + \mathscr{N}(0,1 - e^{-2t})$. 

@@proof 
**Proof of \eqref{sde_sol}.** We set $F(x,t) = xe^{\mu_t}$ and $Y_t = F(X_t, t) = X_t e^{\mu_t}$; it turns out that $Y_t$ satisfies a nicer SDE. Since $\Delta_x f = 0$, $\partial_t f(x,t) = xe^{\mu_t}\alpha_t$ and $\nabla_x f(x,t) = e^{\mu_t}$, [Itô's formula](https://en.wikipedia.org/wiki/It%C3%B4%27s_lemma) says that 
\begin{align}dY_t &= \partial_tF(t,X_t)dt + \partial_x F(t,X_t)dX_t + \frac{1}{2}\Delta_x F(t,X_t)dt \\
&= X_te^{\mu_t}\alpha_tdt + e^{\mu_t} dX_t \\
&= \sqrt{2\sigma_t^2 e^{2\mu_t}}dB_t.
\end{align}
Consequently, $Y_t = Y_0 + \int_0^t \sqrt{2\sigma_s^2e^{2\mu_t}}dB_s$ and the result holds. 
@@ 



A consequence of the preceding result is that when the variance $$\bar{\sigma}_t^2 = 2\int_0^t e^{2\mu_s - 2\mu_t}\sigma_s^2 ds$$ is big compared to $e^{-\mu_t}$, then the distribution of $X_t$ is well-approximated by $\mathscr{N}(0,\bar{\sigma}_t^2)$. Indeed, for $\sigma_t = 1$, we have $\bar{\sigma}_T = \sqrt{1 - e^{-2T}} \approx 1$ if $T$ is sufficiently large.  

In other words, we found a path $(p_t)_{t\in [0,T]}$ connecting the unknown density $p_0 = p$ to another probability density $p_T$, which is still unknown, but if $T$ is large enough we can safely approximate $p_T$ by a Gaussian with a known variance $\bar{\sigma}_T^2$. 

### Can you reverse this probability flow?

Given a sample $X_T$ of $p_T$ (which is well approximated by a Gaussian), we want to solve \eqref{TE} backwards starting from $X_T$, and we'll obtain a new sample $X_0$ approximately distributed as $p_0$. That would solve our second objective given in the introduction. 

Now, there are many ways in which we can backward solve \eqref{TE}. First, we could note that \eqref{TE} is nothing but the transport equation associated with a simple ODE. 

@@important
Let $x(t)$ be the solution of the differential equation with random initial condition
\begin{equation}\label{ode}x'(t) = v_t(x(t))\qquad \qquad x(0) =X_0.\end{equation}
Then the probability density of $x(t)$ is $p_t$. 
@@

@@proof
**Proof.** Let $p_t$ be the probability density of $x_t$ and let $\varphi$ be any smooth, compactly supported test function. Then, $\mathbb{E}[\varphi(x(t))] = \int p_t(x)\varphi(x)dx$, so by derivation under the integral, 
\begin{align}\int \partial_t p_t(x)\varphi(x)dx = \partial_t \mathbb{E}[\varphi(x(t))]&= \mathbb{E}[\nabla\varphi(x(t))x'(t)]\\
&= \int \nabla \varphi(x)v_t(x)p_t(x)dx = -\int \varphi(x) \nabla \cdot (v_t(x)p_t(x))dx
\end{align}
where the last line uses the multidimensional integration by parts formula (remember that $\nabla \cdot$ is nothing but the divergence). 
@@ 

Simple ODEs can be reversed. The time-reversal of \eqref{ode} is just $y'(t) = -v_t(y(t))$. More precisely, the solution of the system
$$ y'(t) = -v_t(y(t))\qquad \qquad y(0) = X_T$$
is exactly $x(T-t)$, and in particular $y(0) = X_0$. We could thus sample one realization of $X_T$, or approximate it with a Gaussian, then solve the backward ODE, and obtain a near realization of $X_0$. But solving \eqref{ode} requires to know the flow $v_t$, which we recall here when $f(x) = -x$: 
$$ v_t(x) = \sigma_t^2 \nabla \log p_t(x)  + \alpha_t x.$$
That looks like a miss: if we want to evaluate $v_t$, we need to know $p_t$ for all $t$, which requires knowledge of $p$. But thanks to the Gods of Statistics, we can very efficiently *estimate* $\nabla \log p_t$. This is due to two things. 

1) **First: we have samples from $p_t$**. Remember that our only information about $p$ is a collection $x^1, \dotsc, x^n$ of samples. But thanks to \eqref{pt}, we can represent $x^i_t = e^{-\mu_t}x^i + \bar{\sigma}_t \xi^i$ with $\xi^i \sim \mathscr{N}(0,I)$ are samples from $p_t$. They are extremely easy to access, since we only need to generate iid standard Gaussian variables $\xi^i$. 

2) **Second: score matching.** If $p$ is a probability density and $x^i$ are samples from $p$, estimating $\nabla \log p$ (called *score*) has been thoroughly examined and is fairly doable, a technique known as *score matching*. 


## Learning the score

### Vanilla score matching

Let $p$ be a smooth probability density function supported over $\mathbb{R}^d$ and let $X$ be a random variable with density $p$. The following elementary identity is due to [Hyvärinen, 2005](https://www.jmlr.org/papers/volume6/hyvarinen05a/hyvarinen05a.pdf); it is the basis for score matching estimation in statistics. 

@@important
Let $s : \mathbb{R}^d \to \mathbb{R}^d$ be any smooth function with sufficiently fast decay at $\infty$. Then,
\begin{equation}\label{SM}
\mathbb{E}[\vert \nabla \log p(X) - s(X)\vert^2] = c + \mathbb{E}\left[|s(X)|^2 +  2 \mathrm{div}(s(X))\right]
\end{equation}
where $c$ is a constant not depending on $s$. 
@@ 

@@proof
**Proof.** We start by expanding the square norm: 
\begin{align}\int p(x)|\nabla \log p(x) - s(x)|^2 dx &= \int p(x)|\nabla \log p(x)|^2 dx + \int p(x)|s(x)|^2 dx - 2\int  \nabla \log p(x)\cdot p(x)s(x) dx.
\end{align} 
The first term does not depend on $s$, it is our constant $c$. For the last term, we use $\nabla \log p = \nabla p / p$ then we use the integration-by-parts formula: 
$$2\int  \nabla \log p(x)\cdot p(x)s(x) dx = 2\int \nabla p(x) \cdot s(x) dx = -2 \int p(x)( \nabla \cdot s(x))dx$$
and the identity is proved. 
@@ 

Now, \eqref{SM} is particularly interesting for us. Remember that if we want to reverse \eqref{ode}, we do not really need to estimate $p_t$ but only $\nabla \log p_t$. We do so by approximating it using a parametrized family of functions, say $s_\theta$ (typically, neural networks): 
\begin{equation}\label{opt_theta} \theta_t \in \argmin_\theta \mathbb{E}[\vert \nabla \log p_t(X_t) - s_{\theta}(X_t)\vert^2] = \argmin_\theta \mathbb{E}[|s_{\theta}(X_t)|^2 + 2 \mathrm{div}(s_{\theta}(X_t))].\end{equation}
Once we have $\theta_t$, we can approximate the **velocity field** $v_t$ with 
$$\hat{v}_t(x) = \sigma_t^2 s_{\theta_t}(x) + \alpha_t x,$$
then backward solve the approximated ODE 
$$y'(t) = -\hat{v}_t(y(t))$$
initialized at $t=0$ with $Y_0 = \mathscr{N}(0,\bar{\sigma}_T^2)$, an approximation of $X_T$. 

### How do you do empirically?

How do we solve \eqref{opt_theta}? 

1) First, we need not solve this optimization problem for every $t$. We could obviously discretize $[0,T]$ with $t_1, \dots, t_N$ and only solve for $\theta_{t_i}$ independently,  but it is actually smarter and cheaper to approximate the whole function $(t,x) \to \nabla \log p_t(x)$ by a single neural network. That is, we use a parametrized family $s_\theta(t,x)$. This enforces a form of time-continuity which seems natural. Now, since we want to aggregate the losses at each time, we solve the following problem: 
\begin{equation}\label{20}\argmin_\theta \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t)|^2 + 2 \mathrm{div}(s_{\theta}(t, X_t))]dt\end{equation} where $w(t)$ is a weighting function (for example, $w(t)$ can be higher for $t\approx 0$, since we don't really care about approximating $p_T$ as precisely as $p_0$). 

2) In the preceding formulation we cannot exactly compute the expectation with respect to $p_t$, but we can approximate it with our samples $x_t^i$. Additionnaly, we need to approximate the integral, for instance we can discretize the time steps with $t_0=0 < t_1 < \dots < t_N = T$. Our objective function becomes
$$ \ell(\theta) =\frac{1}{n}\sum_{t \in \{t_0, \dots, t_N\}} w(t)\sum_{i=1}^n |s_{\theta}(t, x_t^i)|^2 + 2 \mathrm{div}(s_{\theta}(t, x_t^i))$$
which looks computable… except it's not ideal.  Suppose we perform a gradient descent on $\theta$ to find the optimal $\theta$ for time $t$. Then at each gradient descent step, we need to evaluate $s_{\theta}$ as well as its divergence; *and then* compute the gradient in $\theta$ of the divergence in $x$. In high dimension, this can be too costly. 

### Denoising Score Matching

Fortunately, there is another way to perform score matching when $p_t$ is the distribution of a random variable with gaussian noise added, as in our setting. We'll present this result in a fairly abstract setting; we suppose that $p$ is a density function, and $q = p*g_\sigma$ where $g_\sigma$ is the Gaussian density with variance $\sigma$. The following result is due to [Vincent, 2010](https://www.iro.umontreal.ca/~vincentp/Publications/smdae_techreport.pdf). 



@@important
**Denoising Score Matching Objective**

Let $s:\mathbb{R}^d \to \mathbb{R}^d$ be a smooth function. Let $X$ be a random variable with density $p$, $\varepsilon$ an independent random variable with density $g$, and $X_\varepsilon = X + \varepsilon$, whose density is $p_g = p * g$. Then, 
\begin{equation}\label{dsm}
\mathbb{E}[\vert \nabla \log p_g(X_\varepsilon) - s(X_\varepsilon)\vert^2] = c + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X_\varepsilon)|^2]
\end{equation}
where $c$ is a constant not depending on $s$. 
@@

@@proof
**Proof.** By the same computation as for vanilla score matching, we have 
$$ \mathbb{E}[\vert \nabla \log p_g(X_\varepsilon) - s(X_\varepsilon)\vert^2] = c + \int p_g(x)|s(x)|^2dx -2\int \nabla p_g(x)\cdot s(x)dx.$$
Now by definition, $p_g(x) = \int p(y)g(x-y)dy$, hence $\nabla p_g(x) = \int p(y)\nabla g(x-y)dy$, and the last term above is equal to 
\begin{align} -2\int \int p(y)\nabla g(x-y)\cdot s(x)dxdy &= -2\int \int p(y)g(x-y)\nabla \log g(x-y)\cdot s(x)dydx\\
&= -2\mathbb{E}[\nabla \log g(\varepsilon)\cdot s(X + \varepsilon)].
\end{align}
This last term is equal to $-2\mathbb{E}[\nabla \log g(\varepsilon)\cdot s(X_\varepsilon)]$. But then, upon adding and subtracting the term $\mathbb{E}[|\nabla \log g(\varepsilon)|^2]$ which does not depend on $s$, we get another constant $c'$ such that
$$ \mathbb{E}[\vert \nabla \log p_g(X) - s(X)\vert^2] = c' + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X + \varepsilon)|^2].$$
@@ 

Let us apply this to our setting. Remember that $p_t$ is the density of $e^{-\mu_t}X_0 + \varepsilon_t$ where $\varepsilon_t \sim \mathscr{N}(0,\bar{\sigma}_t^2)$, hence in this case $g(x) = (2\pi\bar{\sigma}_t^2)^{-d/2}e^{-|x|^2 / 2\bar{\sigma}_t^2}$ and $\nabla \log g(x) = - x / \bar{\sigma}^2_t$. The objective in \eqref{20} becomes
$$ \argmin_\theta \int_0^T w(t)\mathbb{E}\left[\left|-\frac{\varepsilon_t}{\bar{\sigma}_t^2} - s_\theta(t, e^{-\mu_t}X_0 + \varepsilon_t) \right|^2\right]dt.$$
This can be further simplified. Indeed, let us slightly change the parametrization and use $r_\theta(t,x) = -\bar{\sigma}_t s_\theta(t,x)$. Then,  
$$ \argmin_\theta \int_0^T \frac{w(t)}{\bar{\sigma}_t}\mathbb{E}\left[\left|\xi - r_\theta(t, e^{-\mu_t}X_0 + \bar{\sigma}_t \xi) \right|^2\right]dt.$$
Intuitively, the neural network $r_\theta$ tries to guess the scaled noise $\xi$ from the observation of $X_t$. 
## The Diffusion loss function

Let us wrap everything up. 

@@important
**The Denoising Diffusion Score Matching loss**
Let $\tau$ be a random time on $[0,T]$ with density proportional to $w(t)$; let $\xi$ be a standard Gaussian random variable. The DDPM theoretical objective is
\begin{equation}
\ell(\theta) =  \mathbb{E}\left[\frac{1}{\bar{\sigma}_\tau}\left|\xi - r_\theta(\tau, e^{-\mu_\tau}X_0 + \bar{\sigma}_\tau \xi )\right|^2\right].
\end{equation}
Its empirical version is 
$$\hat{\ell}(\theta) = \frac{1}{n}\sum_{i=1}^n \mathbb{E}\left[\frac{1}{\bar{\sigma}_\tau}|\xi - r_\theta(e^{-\mu_\tau}x^i + \bar{\sigma}_\tau \xi)|^2\right].$$
@@
Up to the constants and the choice of the drift $\alpha_t$ and variance $\sigma_t$, this is exactly the loss function (14) from the paper [DDPM](https://arxiv.org/abs/2006.11239), for instance. 

Once the algorithm has converged to $\theta$, the sampling consists in solving \eqref{ode} backwards, ie
$$ y'(t) = -v_t(y(t)).$$ A simple Euler scheme can be sufficient: let $\delta$ be a small step size. We initialize $y_0 \sim \mathscr{N}(0,\bar{\sigma}_T^2)$, then for $t=1, \dots, T/\delta$ we do one update: 
$$y_{t-1} = y_t - \delta v_t(y_t) = y_t - \delta (\frac{\sigma_t^2}{\bar{\sigma_t}}r_\theta(t, y_t) + \alpha_t y_t) = (1 - \delta \alpha_t)y_t - \frac{\delta \sigma_t^2}{\bar{\sigma}_t} r_\theta(t, y_t).$$

### Special choices for $\alpha_t$ and $\sigma_t$

Considerable work has been done (mostly experimentally) to find good functions $\alpha_t,\beta_t$. Some choices seem to stand out. 

- the **Variance Exploding** path takes $\alpha_t = 0$ (that is, no drift) and $\sigma_t$ a continuous, increasing function over $[0,1)$, such that $\sigma_0 = 0$ and $\sigma_1 = +\infty$; typically, $\sigma_t = (1-t)^{-1}$. 
- the **Variance-Preserving** takes $\sigma_t = \sqrt{\alpha_t}$. 
- the **pure Ornstein-Uhlenbeck** path takes $\alpha_t = \sigma_t = 1$, it is a special case of the previous one, mostly suitable for theoretical purposes. 


## A variational bound

Let $s : [0,T]\times \mathbb{R}^d \to \mathbb{R}^d$ be a smooth function, meant as a proxy for $\nabla \log p_t$. As explained earlier, the **generative process** consists in sampling some $y(0)=Z$ with a probability density $\pi$ (close to $p_T$, hopefully), and then solving the ODE $y'(t) = -u_t(y(t))$ for 
$$u_t(x) = \sigma_t^2 s(t,x) + \alpha_t x.$$
We will note $q_t$ the distribution of $y(T-t)$; in fact, $q_t$ is a solution to $\partial_t q_t(x) = \nabla \cdot (u_t(x)q_t(x))$ (the minus sign is removed, this is a forward ODE) subject to the *terminal condition* $q_T = \pi$. If things were correctly done, $q_t$ should be close to $p_{t}$ at every $t$, and in particular $q_0$ should be close to $p_0$. In particular, if we perfectly learnt the score, that is, if $s(t,x) = \nabla \log p_t(x)$ for every $t$, then clearly $u_t = v_t$ and the two probability flows $q_t, p_t$ only differ by their terminal condition; but in general, $s(t,x)$ is only *close* to $\nabla \log p_t(x)$ and these training errors diffuse in the system. The next fundamental lemma quantifies this. 

This theorem restricts to the case where the weights $w(t)$ are constant, and for simplicity, they are set to 1. 


@@important 
**Variational lower-bound for score-based diffusion models**

\begin{equation}\label{vlb}
\mathrm{kl}(p \mid q_0) \leqslant \mathrm{kl}(p_T \mid \pi) +\int_0^T \mathbb{E}\left[\vert  \nabla \log p_t(X_t) - s(t,X_t)\vert^2\right]dt. 
\end{equation}
@@

The proof of this formula will use a few technical lemmas. The original proof can be found in [this paper](https://arxiv.org/abs/2101.09258) and uses a fact completely shunned in this note, which is that instead of solving bacward the ODE \eqref{ode}, we could also solve backward the original SDE \eqref{SDE} with another SDE, then use the Girsanov theorem. This is utterly complicated and the following proof is indeed more elementary. 

We recall that $$ \mathrm{kl}(p_t \mid q_t) = \int p_t(x)\log(p_t(x) - q_t(x))dx.$$
@@important We have, 
\begin{equation}\label{36}\frac{d}{dt}\mathrm{kl}(p_t \mid q_t) = \int p_t(x) \nabla \log\left(\frac{p_t(x)}{q_t(x)}\right) \cdot \left(s(t,x) - \nabla \log p_t(x) \right)dx\end{equation}
and:
\begin{equation}\label{37}\frac{d}{dt}\mathrm{kl}(p_t \mid q_t) \leqslant \frac{1}{2}\int p_t(x) |s(t,x) - \nabla \log p_t(x) |^2 dx.\end{equation}

@@

@@proof

We recall for the reader that $p_t$ satisfies $\partial_t p_t = \nabla \cdot v_t p_t$ and $q_t$ satisfies $\partial_t q_t = \nabla \cdot u_t q_t$. The proofs of \eqref{vlb}-\eqref{36}-\eqref{37} will only need this fact. 

**Proof of \eqref{36}.**

A small differentiation shows that  $ \frac{d}{dt}\mathrm{kl}(p_t \mid q_t) $ is equal to $$\int \nabla \cdot (v_t(x)p_t(x))\log(p_t(x)/q_t(x))dx + \int p_t(x)\frac{\nabla \cdot (v_t(x)p_t(x))}{p_t(x)}dx - \int p_t(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx.$$
By an integration by parts, the first term is also equal to $-\int p_t(x)v_t(x)\cdot \nabla \log(p_t(x)/q_t(x))dx$. For the second term, it is clearly zero. Finally, for the last one, 
\begin{align}
- \int p_t(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx &= \int \nabla (p_t(x)/q_t(x)) \cdot u_t(x)q_t(x)dx \\
&= \int \nabla \log(p_t(x)/q_t(x))\cdot u_t(x)p_t(x)dx.
\end{align}
Now, since $u_t(x) - v_t(x) = \sigma_t^2 (s(t,x) - \nabla \log p_t(x))$, the result holds. 

**Proof of \eqref{37}.**

We momentarily note $a = \nabla \log p_t(x)$ and $b = \nabla \log q_t(x)$ and $s=s(t,x)$. Then, 
$$|a-s|^2 =|a-b|^2 + |b-s|^2 + 2 (a-b)\cdot (b-s)$$ 
which clearly shows that $$2 (a - b)\cdot (b - s) = 2\nabla \log (p_t(x)/q_t(x)) \cdot (s(t,x) - \nabla \log p_t(x))$$ is smaller than $|\nabla \log p_t(x) - s(t,x)|^2$, as requested. 

**Proof of \eqref{vlb}.**

Now, we simply write
\begin{align} \mathrm{kl}(p_t \mid q_t) - \mathrm{kl}(p_0 \mid q_0) &= \int_0^T \frac{d}{dt}\mathrm{kl}(p_t \mid q_t) dt \\
&\leqslant \frac{1}{2}\int_0^T \mathbb{E}[|s(t,X_t) - \nabla \log p_t(X_t)|^2]dt.
\end{align}
Now the result readily comes, since $q_T = \pi$. 

@@




## Beyond SDEs: Flow matching techniques

In this section I'll explain the Flow Matching [paper](https://arxiv.org/abs/2210.02747). 


## References

[Variational perspective on Diffusions](https://openreview.net/forum?id=bXehDYUjjXi) or [arxiv](https://arxiv.org/abs/2106.02808)

[Maximum likelihood training of Diffusions](https://arxiv.org/abs/2101.09258)

[Probability flow for FP](https://arxiv.org/pdf/2206.04642.pdf)


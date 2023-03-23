+++
titlepost = "Diffusion models"
date = "March 2023"
abstract = "A small mathematical summary. "
+++


These are my notes on generative models using stochastic diffusions, eg the celebrated Denoising Diffusion Probabilistic Models; they're intended for mathematicians, hence the notations and style is different than in the original papers. In particular, everything is fitted into the continuous-time framework (which is not how it is done in practice). A special attention is given to the differences between ODE sampling and SDE sampling, and the analysis of the time evolution  for the probability densities though Fokker-Planck and Transport Equations.  

\tableofcontents

## The problem 

Let $p$ be a probability density on $\mathbb{R}^d$. The goal of generative modelling is twofold: given a training sample $x^1, \dotsc, x^n$ of realizations of $p$, we want to 
1) learn $p$ from the samples; 
2) learn how to sample from $p$. 

There were a certain number of methods to solve these two problems: Energy-Based Models, Normalizing Flows and the famous Neural ODEs, vanilla Score-Matching. Each of those methods seemed to be limited for some reason I'll not detail here: for example, EBMs are very hard to train, NFs are not very expressive and SM fails to capture multimodal distributions. Diffusion models have sufficient flexibility to overcome these limitations, at least partly. 


### Stochastic interpolation

Diffusion models fall into the general framework of [stochastic interpolants](https://arxiv.org/abs/2303.08797). The idea is to continuously transform the samples of $p$ into samples from a known, easy-to-sample probability density $\pi$ (often called *the target*), and then to reverse the process: that is, to generate a sample from $\pi$, and to inverse the transformation to get a new sample from $p$. In other words, we seek a path $(p_t: t\in [0,T])$ with $p_0=p$ and $p_T=q$, such that generating samples $x_t \sim p_t$ is doable. 

The success of *diffusion models* came from the realization that some stochastic processes (eg, Ornstein-Uhlenbeck processes, which connects $p_0$ with a distribution $p_T$ very close to pure noise $\mathscr{N}(0,I)$) can be reversed, as long as access is given to the *score function* $\nabla \log p_t$ at each time $t$. Although unknown, this score can efficiently be learnt using statistical procedures called *score matching*. 


## Original formulation: Gaussian noising process and its inversion

Let $(t,x)\to f_t(x)$ and $t\to \sigma_t$ be two smooth functions. Consider the stochastic differential equation
\begin{equation}\label{SDE}dX_t = f_t(X_t)dt + \sqrt{2\sigma_t ^2}dB_t, \qquad \qquad X_0 \sim p\end{equation}
where $dB_t$ denotes integration with respect to a Brownian motion. Under mild conditions on $f$, an almost-surely continuous stochastic process satisfying this SDE exists. Let $p_t$ be the probability density of $X_t$; it is known that this process [could easily be reversed in time](https://www.sciencedirect.com/science/article/pii/0304414982900515). More precisely, the SDE
\begin{equation}\label{bsde} dY_t = -\left(  f_t(Y_t)+ 2\sigma_t^2 \nabla \log p_t(Y_t) \right)dt + \sqrt{2\sigma_t^2}dB_t \qquad \qquad Y_T \sim p_T 
\end{equation}
has the same marginals as $X_t$, that is $Y_{T-t}$ has exactly the same distribution as $p_t$. This inversion needs access to $\nabla \log p_t$, and we'll explain later how this can be done. A crucial feature of of \eqref{SDE} is that for simple functions $f$, it can be solved with an explicit representation.  Here we focus on the case where $f_t(x) = -\alpha_t x$ for some function $\alpha$, that is
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

### The Fokker-Planck point of view

It was recently realized that there is nothing special with the Ornstein-Uhlenbeck representation of $p_t$ as in \eqref{SDE}, nor with the stochastic process \eqref{BSDE} which has the same marginals as $p_t$. In fact, the important features are (i) that $p_t$ provides a path connecting $p$ and $p_T \sim \mathscr{N}(0,I)$ and (ii) that its marginal are easy to sample. But there are many processes beyond \eqref{SDE} with $p_t$ as its marginals, processes that can also be reversed. The key is that $p_t$  is a solution of the [Fokker-Planck equation](https://en.wikipedia.org/wiki/Fokker%E2%80%93Planck_equation): 
@@important
\begin{equation}\label{FP} \partial_t p_t(x) = \Delta (\sigma_t^2 p_t(x)) - \nabla \cdot (f_t(x)p_t(x)).\end{equation}
@@

Importantly, this equation can be recast as a transport equation: noting $v_t(x) = \sigma_t^2 \nabla \log p_t(x) - f_t(x)$ (called the **velocity field**), the equation \eqref{SDE} is equivalent to
@@important
\begin{equation}\label{TE} \partial_t p_t(x) = \nabla \cdot (v_t(x)p_t(x)).\end{equation}
@@ 
Transport equations come from simple ODEs; there is a simple, *deterministic* process with the same marginals as \eqref{SDE}. 
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


### Time-reversal of Transport Equations and Fokker-Planck equations

\newcommand{\pbt}{p^{\mathrm{b}}_t}
\newcommand{\vbt}{v^{\mathrm{b}}_t}
\newcommand{\wbt}{w^{\mathrm{b}}_t}


Our goal is to reverse the process going from $p_0$ to $p_T$. Let us take a look first at the time-reversal of the equations satisfied by $p_t$. 
@@important
Let $p^{\mathrm{b}}_t$ be the time-reversal of $p_t$, that is $p^{\mathrm{b}}_t = p_{T-t}$. It solves the *backward* Transport Equation: 
\begin{equation}\label{BTE}\partial \pbt(x)= \nabla \cdot \vbt(x) \pbt(x) \end{equation}
where $\vbt(x) = -v_t(x) = -\sigma_{T-t}^2 \nabla \log p_t(x) - \alpha_{T-t} x$. 

It also solves the *backward* Fokker-Planck Equation: 
\begin{equation}\label{BFP}\partial \pbt(x) =\sigma_t^2 \Delta \pbt(x) - \nabla \cdot w_t^{\mathrm{b}}(x)\pbt(x)\end{equation}
where $w^{\mathrm{b}}_t(x) = 2\sigma_{T-t}^2 \nabla \log \pbt(x) + \alpha_{T-t} x$. 
@@ 

@@proof
**Proof.** It is a mere verification. The time-reversal of the solution of a transport equation solves the same equation, with a minus sign. For the backward Fokker-Planck, note that
\begin{align}\partial_t \pbt(x) &= -\partial_t p_t\mid_{T-t}(x) = -\sigma_{T-t}^2\Delta p_{T-t}(x) + \nabla\cdot f_{T-t}(x)p_{T-t}(x)\\
&=\sigma_{T-t}^2\Delta p_{T-t}(x) -2\sigma_{T-t}^2\Delta p_{T-t}(x) + \nabla \cdot f_{T-t}(x)p_{T-t}(x)\\
&=\Delta \sigma_{T-t}^2\pbt(x) - \nabla \cdot [2\sigma_{T-t}^2\nabla \log p_{T-t}(x) - f_{T-t}(x)]\pbt(x)
\end{align}
@@

Of course, these two equations are exactly the same, but they represent the (identical) probability density $p_{T-t}$ of two different random processes. As explained before, the Transport version \eqref{BTE} represents the time-evolution of the density of the ODE system 
\begin{equation}\label{BODE}y'(t) = \vbt(y(t)) \qquad \qquad y(0) = X_T\end{equation} 
but the Fokker-Planck version \eqref{BFP} represents the time-evolution of the SDE system
\begin{equation}\label{BSDE2}dY_t = w^{\mathrm{b}}_t(Y_t)dt + \sqrt{2\sigma_t^2}dB_t \qquad \qquad Y_0 = X_T.\end{equation}
Of course, in both cases this time-evolution is the same, but the *processes $y(t)$ and $Y_t$* are not the same ($y$ is smooth and $Y_t$ is rough). They only have the same marginals $\pbt$. Each of these two processes can be sampled: there are many ODE and SDE solvers, the simplest of which being the Euler scheme and the Euler-Maruyama scheme. But these solvers need access to the functions $\vbt$ and $\wbt$, which in turn depend on the unknown score $\nabla \log p_t$. Fortunately, we can efficiently *estimate* $\nabla \log p_t$. This is due to two things. 

1) **First: we have samples from $p_t$**. Remember that our only information about $p$ is a collection $x^1, \dotsc, x^n$ of samples. But thanks to the representation \eqref{pt}, we can represent $x^i_t = e^{-\mu_t}x^i + \bar{\sigma}_t \xi^i$ with $\xi^i \sim \mathscr{N}(0,I)$ are samples from $p_t$. They are extremely easy to access, since we only need to generate iid standard Gaussian variables $\xi^i$. 

2) **Second: score matching.** If $p$ is a probability density and $x^i$ are samples from $p$, estimating $\nabla \log p$ (called *score*) has been thoroughly examined and is fairly doable, a technique known as *score matching*. 


## Methods for learning the score

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


### How do you do empirically?

How do we solve \eqref{opt_theta}? 

1) First, we need not solve this optimization problem for every $t$. We could obviously discretize $[0,T]$ with $t_1, \dots, t_N$ and only solve for $\theta_{t_i}$ independently,  but it is actually smarter and cheaper to approximate the whole function $(t,x) \to \nabla \log p_t(x)$ by a single neural network (a U-net, in general). That is, we use a parametrized family $s_\theta(t,x)$. This enforces a form of time-continuity which seems natural. Now, since we want to aggregate the losses at each time, we solve the following problem: 
\begin{equation}\label{20}\argmin_\theta \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t)|^2 + 2 \mathrm{div}(s_{\theta}(t, X_t))]dt\end{equation} where $w(t)$ is a weighting function (for example, $w(t)$ can be higher for $t\approx 0$, since we don't really care about approximating $p_T$ as precisely as $p_0$). 

2) In the preceding formulation we cannot exactly compute the expectation with respect to $p_t$, but we can approximate it with our samples $x_t^i$. Additionnaly, we need to approximate the integral, for instance we can discretize the time steps with $t_0=0 < t_1 < \dots < t_N = T$. Our objective function becomes
$$ \ell(\theta) =\frac{1}{n}\sum_{t \in \{t_0, \dots, t_N\}} w(t)\sum_{i=1}^n |s_{\theta}(t, x_t^i)|^2 + 2 \mathrm{div}(s_{\theta}(t, x_t^i))$$
which looks computable… except it's not ideal.  Suppose we perform a gradient descent on $\theta$ to find the optimal $\theta$ for time $t$. Then at each gradient descent step, we need to evaluate $s_{\theta}$ as well as its divergence; *and then* compute the gradient in $\theta$ of the divergence in $x$, in other words to compute $\nabla_\theta \nabla_x \cdot s_\theta$. In high dimension, this can be too costly. 

### Denoising Score Matching

Fortunately, there is another way to perform score matching when $p_t$ is the distribution of a random variable with gaussian noise added, as in our setting. We'll present this result in a fairly abstract setting; we suppose that $p$ is a density function, and $q = p*g$ where $g$ is an other density. The following result is due to [Vincent, 2010](https://www.iro.umontreal.ca/~vincentp/Publications/smdae_techreport.pdf). 



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


Now, this Denoising Score Matching loss does not involve any computation of a « double gradient » like $\nabla_\theta \nabla_x \cdot s_\theta$. 

Let us apply this to our setting. Remember that $p_t$ is the density of $e^{-\mu_t}X_0 + \varepsilon_t$ where $\varepsilon_t \sim \mathscr{N}(0,\bar{\sigma}_t^2)$, hence in this case $g(x) = (2\pi\bar{\sigma}_t^2)^{-d/2}e^{-|x|^2 / 2\bar{\sigma}_t^2}$ and $\nabla \log g(x) = - x / \bar{\sigma}^2_t$. The objective in \eqref{20} becomes
$$ \argmin_\theta \int_0^T w(t)\mathbb{E}\left[\left|-\frac{\varepsilon_t}{\bar{\sigma}_t^2} - s_\theta(t, e^{-\mu_t}X_0 + \varepsilon_t) \right|^2\right]dt.$$
This can be further simplified. Indeed, let us slightly change the parametrization and use $r_\theta(t,x) = -\bar{\sigma}_t s_\theta(t,x)$. Then,  
$$ \argmin_\theta \int_0^T \frac{w(t)}{\bar{\sigma}_t}\mathbb{E}\left[\left|\xi - r_\theta(t, e^{-\mu_t}X_0 + \bar{\sigma}_t \xi) \right|^2\right]dt.$$
Intuitively, the neural network $r_\theta$ tries to guess the scaled noise $\xi$ from the observation of $X_t$. 

## Generative models: training and sampling

Let us wrap everything up in this section. 

### Training

@@important
**The Denoising Diffusion Score Matching loss**

Let $\tau$ be a random time on $[0,T]$ with density proportional to $w(t)$; let $\xi$ be a standard Gaussian random variable. The DDPM theoretical objective is
\begin{equation}
\ell(\theta) =  \mathbb{E}\left[\frac{1}{\bar{\sigma}_\tau}\left|\xi - r_\theta(\tau, e^{-\mu_\tau}X_0 + \bar{\sigma}_\tau \xi )\right|^2\right].
\end{equation}
Its empirical version is 
\begin{equation}\label{empirical_loss}\hat{\ell}(\theta) = \frac{1}{n}\sum_{i=1}^n \mathbb{E}\left[\frac{1}{\bar{\sigma}_\tau}|\xi - r_\theta(e^{-\mu_\tau}x^i + \bar{\sigma}_\tau \xi)|^2\right].\end{equation}
@@
Up to the constants and the choice of the drift $\alpha_t$ and variance $\sigma_t$, this is exactly the loss function (14) from the paper [DDPM](https://arxiv.org/abs/2006.11239), for instance. Note that \eqref{empirical_loss} can be optimized using mini-batch methods. 

### Sampling


Once the algorithm has converged to $\theta$, we get $s_\theta(t,x)$ which is a proxy for $\nabla \log p_t(x)$. Now, we simply plug this expression in the functions $\vbt$ if we want to solve the ODE \eqref{BODE} or $\wbt$ if we want to solve the SDE \eqref{BSDE2}. 

\newcommand{\hbt}{\hat{v}^{\mathrm{b}}_t}
\newcommand{\hwbt}{\hat{w}^{\mathrm{b}}_t}

@@important
The **ODE sampler** solves $ y'(t) = \hbt(y(t))$ started at $y(0) \sim \mathscr{N}(0,I)$, 
where $\hbt(x) = -\sigma_t^2 s_\theta(t,x) - \alpha_t x$. 
@@

@@important 
The **SDE sampler** solves $dY_t = \hwbt(Y_t)dt + \sqrt{2\sigma_t^2}dB_t$ started at $Y_0 \sim \mathscr{N}(0,I)$, where $\hwbt(x) = 2\sigma_t^2 s_\theta(t,x) + \alpha_t x$. 
@@
\newcommand{\qo}{q^{\mathrm{ode}}_t}
\newcommand{\qs}{q^{\mathrm{sde}}_t}
We must stress a subtle fact. Equations \eqref{FP} and \eqref{TE}, or their backward counterparts, are exactly the same equation accounting for $p_t$. But since now we replaced $\nabla \log p_t$ by its *approximation* $s_\theta$, this is no longer the case for our two samplers: their probability densities are not the same. In fact, let us note $\qo,\qs$ the densities of $y(T-t)$ and $Y_{T-t}$; the first one solves a Transport Equation, the second one a Fokker-Planck equation, and these two equations are different. 
@@important 
\begin{equation}\label{TE-a}\partial \qo(x) = -\nabla \cdot \hbt(x)\qo(x)\qquad \qquad q_0^{\mathrm{ode}} = \mathscr{N}(0,I) \end{equation}
\begin{equation}\label{FP-a}\partial \qs(x) = -\nabla \cdot [\nabla \log \qs(x) - \hwbt(x)]\qs(x) \qquad \qquad q_0^{\mathrm{sde}} = \mathscr{N}(0,I) \end{equation}
@@
Importantly, the drift $\nabla \log \qs(x) - \hwbt(x)$ is in general *not equal* to the drift $\hbt(x)$. They would be equal only in the case $s_\theta(t,x) = \nabla \log p_t(x)$. 
@@proof 
**Proof.** Since $y(t)$ is an ODE, it directly satisfies the transport equation with velocity $\hbt$. Since $Y_t$ is an SDE, it satisfies the Fokker-Planck equation associated with the drift $\hwbt$, which in turn can be transformed in the transport equation shown above. 
@@ 

### Special choices for $\alpha_t$ and $\sigma_t$

Considerable work has been done (mostly experimentally) to find good functions $\alpha_t,\beta_t$. Some choices seem to stand out. 

- the **Variance Exploding** path takes $\alpha_t = 0$ (that is, no drift) and $\sigma_t$ a continuous, increasing function over $[0,1)$, such that $\sigma_0 = 0$ and $\sigma_1 = +\infty$; typically, $\sigma_t = (1-t)^{-1}$. 
- the **Variance-Preserving** takes $\sigma_t = \sqrt{\alpha_t}$. 
- the **pure Ornstein-Uhlenbeck** path takes $\alpha_t = \sigma_t = 1$, it is a special case of the previous one, mostly suitable for theoretical purposes. 


## A variational bound for the SDE sampler

Let $s : [0,T]\times \mathbb{R}^d \to \mathbb{R}^d$ be a smooth function, meant as a proxy for $\nabla \log p_t$. Our goal is to quantify the difference between $\qo, \qs$ and $p_t$. It turns out that controlling the Fisher divergence $\mathbb{E}[|\nabla \log p_t(X) - s(t,X)|^2]$ results in a bound for $\mathrm{kl}(p \mid q_0^{\mathrm{sde}})$, but not for $\mathrm{kl}(p \mid q_0^{\mathrm{ode}})$. We recall the notations defined up to now: first, $\pbt = p_{T-t}$, which satisfies the backward equation
$$ \partial_t \pbt(x) = \nabla \cdot \vbt(x)\pbt(x)\qquad \qquad \vbt(x) = -\nabla \log \pbt(x) - \alpha_{T-t}x.$$
The density of the generative process is $\qs$, but we'll simply note $q_t$. It satisfies the equation
$$\partial_t q_t(x) = \nabla\cdot u_t(x)q_t(x)\qquad u_t(x) = \nabla \log q_t(x) - 2s(t,x) - \alpha_{T-t}x. $$
The original distribution we want to sample is $p = p_0 = p^{\mathrm{b}}_T$, and the final distribution of our SDE sampler is $q^{\mathrm{sde}}_T = q_T$. Finally, the distribution $p_T = p_0^{\mathrm{b}}$ is approximated with $\pi$ (in practice, $\mathscr{N}(0,I)$).  

The KL divergence between densities $\rho_1, \rho_2$ is $$ \mathrm{kl}(\rho_1 \mid \rho_2) = \int \rho_2(x)\log(\rho_2(x)/ \rho_1(x))dx.$$

This theorem restricts to the case where the weights $w(t)$ are constant, and for simplicity, they are set to 1. 


@@important 
**Variational lower-bound for score-based diffusion models with SDE sampler**

\begin{equation}\label{vlb}
\mathrm{kl}(p \mid q_T^{\mathrm{sde}}) \leqslant \mathrm{kl}(p_T \mid \pi) +\int_0^T \int p_t(x) |\nabla \log p_t(x) - s(t,x)\vert^2 dx dt. 
\end{equation}
@@

The original proof can be found in [this paper](https://arxiv.org/abs/2101.09258) and uses the Girsanov theorem applied to the SDE representations \eqref{SDE}-\eqref{BSDE} of the forward/backward process. This is utterly complicated and is too dependent on the SDE representation. The proof presented below only needs the Fokker-Planck equation and is done directly at the level of probability densities. 
The following lemma is interesting on its own since it gives an exact expression for the KL divergence between transport equations. 
@@important 
\begin{equation}\label{36}\frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) = \int \pbt(x) \nabla \log\left(\frac{\pbt(x)}{q_t(x)}\right) \cdot \left(u_t(x)- \vbt(x) \right)dx\end{equation}
@@
In our case, 
@@important
\begin{align}\label{37}\frac{d}{dt}\mathrm{kl}(p_t \mid q_t) \leqslant \int \pbt(x) |s(t,x) - \nabla \log \pbt(x) |^2 dx \end{align}

@@

@@proof
 The proofs of \eqref{vlb}-\eqref{36}-\eqref{37} will only need this fact. 

**Proof of \eqref{36}.**

A small differentiation shows that  $ \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) $ is equal to $$\int \nabla \cdot (\vbt(x)\pbt(x))\log(\pbt(x)/q_t(x))dx + \int \pbt(x)\frac{\nabla \cdot (\vbt(x)\pbt(x))}{\pbt(x)}dx - \int \pbt(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx.$$
By an integration by parts, the first term is also equal to $-\int \pbt(x)\vbt(x)\cdot \nabla \log(\pbt(x)/q_t(x))dx$. For the second term, it is clearly zero. Finally, for the last one, 
\begin{align}
- \int \pbt(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx &= \int \nabla (\pbt(x)/q_t(x)) \cdot u_t(x)q_t(x)dx \\
&= \int \nabla \log(\pbt(x)/q_t(x))\cdot u_t(x)\pbt(x)dx.
\end{align}

**Proof of \eqref{37}.**
We recall that $u_t(x) = \nabla \log q_t(x) - 2s(t,x) - \alpha_{T-t}x$ and $\vbt(x) = -\nabla \log \pbt(x) - \alpha_{T-t}x$, so that
\begin{align}  u_t - \vbt &= \nabla \log q_t - 2s + \nabla \log \pbt\\ &= \nabla \log q_t - \nabla \log \pbt + 2 (\nabla \log \pbt - s).\end{align}
We momentarily note $a = \nabla \log \pbt(x)$ and $b = \nabla \log q_t(x)$ and $s=s(t,x)$. Then, \eqref{36} shows that
\begin{align} \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) &=  \int \pbt(x)(a - b)\cdot ((b-a) + 2(s - a))dx\\
&= - \int p_t(x)|a-b|^2 dx + 2 \int p_t(x)(a-b)\cdot (s-a)dx.
\end{align}
We now use the classical inequality $2(x\cdot y) \leqslant  |x|^2  + |y|^2$; we get
$$ \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) \leqslant \int \pbt(x)|s(t,x) - \nabla\log \pbt(x)|^2dx.$$

**Proof of \eqref{vlb}.**

Now, we simply write
\begin{align}\label{integ} \mathrm{kl}(p^{\mathrm{b}}_T \mid q^{\mathrm{sde}}_T) - \mathrm{kl}(p^{\mathrm{b}}_0 \mid q_0^{\mathrm{sde}}) &= \int_0^T \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) dt 
\end{align}
and plug \eqref{37} inside the RHS. Here $q_0 = \pi$ and $p^{\mathrm{b}}_T= p$, hence the result. 

@@

### What about the ODE ?

It turns out that the ODE solver, whose density is $\qo$, does not have such a nice upper bound. In fact, since $\qo$ solves a Transport Equation, we can still use \eqref{36} but with $u_t$ replaced with $\hat{v}^{\mathrm{b}}_t$, and integrate in $t$ just as in \eqref{integ}. We have 
\begin{align}\hbt(x) - \vbt(x) &= \nabla \log \pbt(x)-s(t,x) \\
&= \nabla \log \pbt(x) - \nabla\log q_t(x) + \nabla\log q_t(x) - s(t,x).
\end{align}
Using the Cauchy-Schwarz inequality, we could obtain the following upper bound. 
@@important
\begin{align}
\mathrm{kl}(p \mid q_T^{\mathrm{ode}}) - \mathrm{kl}(p_T \mid \pi) &\leqslant \int_0^T \int p_t(x)\left|\nabla\log p_t(x) - \nabla\log q_t(x)\right|^2 +  p_t(x)\left|\nabla \log q_t(x) - s(t,x)\right|^2 dx dt\\
&\leqslant \int_0^T \mathbb{E}\left[|\nabla\log p_t(X_t) - \nabla\log q_t(X_t)|^2 + |\nabla\log q_t(X_t) - s(t,X_t)|^2\right]dt.  
\end{align}
@@
Minimizing the score matching objective function does not minimize this upper bound, a striking difference with the SDE version. The reason is that the Fisher divergence provides no control whatsoever on the kl divergence between the solutions of two transport equations; but, due to the presence of a diffusive term, it provides a control on the kl divergence between the solutions of the associated Fokker-Planck equations. This might be one of the explanations for the notorious underperformance of the ODE solvers, observed in practice by many practicioners. Such an analysis was brought by the remarkable paper  on [stochastic interpolants](https://arxiv.org/abs/2303.08797). 





## References

### On diffusion models

[The original paper on diffusion models](https://arxiv.org/abs/1503.03585)

[DDPM](https://arxiv.org/abs/2006.11239) (seminal paper for image generation)

[Diffusion beat GANs](https://arxiv.org/abs/2105.05233) (pushing diffusions well beyond the SOTA)

[Variational perspective on Diffusions](https://openreview.net/forum?id=bXehDYUjjXi) or [arxiv](https://arxiv.org/abs/2106.02808) (the analytical SDE approach)

[Maximum likelihood training of Diffusions](https://arxiv.org/abs/2101.09258) (proofs of the variational lower-bound)

[Sampling is as easy as learning the score](https://arxiv.org/abs/2209.11215) (theoretical analysis under minimal assumptions)


### Beyond diffusions

[Diffusion Schrodinger Bridge](https://proceedings.neurips.cc/paper/2021/file/940392f5f32a7ade1cc201767cf83e31-Paper.pdf)

[Probability flow for FP](https://arxiv.org/pdf/2206.04642.pdf)

[Flow matching paper](https://arxiv.org/abs/2210.02747)

[Stochastic interpolants](https://arxiv.org/abs/2303.08797)

[Consistency models](https://arxiv.org/pdf/2303.01469.pdf)

[Rectified Flow](https://arxiv.org/pdf/2209.03003.pdf)


+++
titlepost = "The Jarzynski connection"
date = "March 2022"
abstract = "Change-of-measure for out-of-equilibrium systems"
+++

Let $V_t$ be a family of smooth potentials on $\mathbb{R}^n$, continuously evolving with time $t\in[0,1]$. Let $p_t$ be their associated Gibbs measure: 
\begin{align} &p_t(x) = \frac{e^{-V_t(x)}}{Z_t}&& \text{where}&& Z_t = \int_{\mathbb{R}^n} e^{-V_t(x)}dx.\end{align}
It is not easy to find a continuous dynamic $X_t$, such that at each time $t$ the distribution of $X_t$ matches $p_t$. One might be tempted to use the overderdamped Langevin dynamics, 
\begin{equation}\label{sde}dX_t = - \nabla V_t(X_t)dt + \sqrt{2}dW_t \end{equation}
with $(W_t)$ a Brownian motion. But the density $\rho_t$ of $X_t$  **is not equal to $p_t$ in general**. Indeed, $\rho_t$ solves the Fokker-Planck equation 
$$\dot{\rho}_t = \Delta\rho_t - \nabla \cdot [\rho_t \nabla V_t].$$ 
If $\rho_t$ was equal to $p_t$, then $p_t$ should also satisfy this equation; but for $p_t$ one easily checks that the RHS is zero, resulting in $\dot{p}_t=0$ which is false in general if we choose a family of evolving potentials; it would only be true at equilibrium when $V_t$ is constant.  


The Jarczynski trick allows to reconnect the distribution of $X_t$ with $p_t$. It introduces a weight, the solution of an auxiliary ODE, such that its conditional expectation given $X_t=x$ gives $p_t(x)$, hence correcting the mismatch between $\rho_t$ and $p_t$. 

*(In the sequel we note $F_t = \log Z_t$, and the dot in $\dot{V}_t$ or $\dot{F}_t$ always represents a derivative with respect to time. )*


@@important
Let $(X_t, W_t)$ be the solution of the following *augmented system*: 
\begin{align}\label{sde2}
&dX_t = - \nabla V_t(X_t)dt + \sqrt{2}dW_t &&& X_0 \sim p_0 \\&dW_t = (-\dot{V}_t(X_t) - \dot{F_t})W_t dt &&& W_0=1. 
\end{align}
Then, for any test function $\varphi$, 
\begin{equation}\label{main}\mathbf{E}[\varphi(X_t)W_t] = \int \varphi(x)\frac{e^{-V_t(x)}}{Z_t}dx. \end{equation}
In other words, the probability measure $P(A) = \mathbf{E}[\mathbf{1}_A W_t]$ is exactly $p_t$. 
@@




Jarczynski's goal was to compute, at least numerically, the partition functions $Z_t$ or equivalently the free energy $F_t = - \log Z_t$.  The *Jarczynski estimator*, discovered in 1996, simply consists in applying \eqref{main} to $\varphi=1$, and noting that $W_t$ is a simple ODE solved by 
\begin{equation}\label{W}W_t = W_0e^{-\int_0^t \dot{V}_s(X_s) - \dot{F}_s ds} = \frac{Z_t}{Z_0}e^{-\int_0^t \dot{V}_s(X_s)ds}.\end{equation}

@@important
**Jarzynski's identity** states that 
$$\mathbf{E}[e^{-\int_0^t \dot{V}_s(X_s) - \dot{F}_sds}] = 1. $$
@@

The consequence  of this identity is that 
$$ \log \mathbf{E}[e^{-\int_0^t \dot{V}_s(X_s)ds}] = F_t - F_0, $$
giving rise to a natural estimator for the *free energy difference* $F_t-F_0$: one samples many paths from the dynamics \eqref{sde}, then computes the path integral $w_t = \int_0^t \dot{V}_s(X_s)ds$ along each path, and then average the values of $e^{-w_t}$ and take the log. 

In general, exponential of paths integrals are not easy to study. The classical way to prove Jarczynski's identity directly is to use the [Feynman-Kac](https://en.wikipedia.org/wiki/Feynman%E2%80%93Kac_formula) representation of PDEs, but this proof seems quite involved; instead, the trick above with the augmented system seems to be easier. It was shown to me by Eric Vanden-Eijnden. 


## Proof
Equation \eqref{main} can be reformulated as follows: if we note $\varrho_t(x,w)$ the density of $(X_t, W_t)$, then 
$$ p_t(x) = \int_0^\infty w \varrho_t(x,w)dw.$$
Note that the integral is only on the positive axis because $W_t$ is always positive from \eqref{W}. We note $q_t(x)$ the term on the right; we are going to prove $p_t=q_t$ by proving that both  satisfy the same parabolic equation, then invoke a uniqueness result. 

From now on, we'll set $U_t = V_t - F_t$, so that $p_t(x) = e^{-U_t(x)}$ is normalized. Clearly, $\nabla U_t = \nabla V_t$. 

### The augmented system


We consider the system $Z_t=  (X_t, W_t)$ in \eqref{sde2} as a single SDE 
$$d Z_t = f_t(Z_t)dt + \sigma dW_t$$ 
with 
\begin{align}&f_t(x,w) = \begin{pmatrix} - \nabla U_t(x) \\ -\dot{U}_t(x)w \end{pmatrix} &&\text{ and }&& \sigma = \mathrm{diag}(\sqrt{2}, \dotsc, \sqrt{2}, 0).\end{align}
Let us note $\varrho_t(x,y)$ the density of $(X_t, W_t)$, and write the associated [Fokker-Planck](https://en.wikipedia.org/wiki/Fokker%E2%80%93Planck_equation) equation; here and after, $\nabla$ is a gradient and $\nabla \cdot$ is the divergence. For clarity in this section, subscripts denote partial differentiation with respect to the corresponding variables. 

\begin{align}\dot{\varrho}_t &= -\nabla_{x,w} \cdot  \left[ f_t\varrho_t \right] + \Delta_x \varrho_t\\
&= - (\nabla_{x,w} \cdot f_t) \varrho_t - f_t \cdot  \nabla_{x,w} \varrho_t + \Delta_x \varrho_t \\
 \end{align}
Now by the definition of $f_t$, we have $\nabla_{x,w}f_t(x,w) = - \nabla_x \nabla_x U_t(x) - \dot{U}_t(x)$, hence finally
$$\dot \varrho_t(x,w)=- (\Delta_x U_t(x)) \varrho_t(x,w) + \dot{U}_t(x)\varrho_t(x,w) - f_t(x,w) \cdot \nabla_{x,w} \varrho_t (x,w) + \Delta_x \varrho_t(x,w). 
$$
### The marginal integration

We already set $q_t(x) = \int_0^\infty w \varrho_t(x,w)dw$, so that $\mathbf{E}[W_t] = \int q_t(x)dx$ for example. Multiplying the last equation by $w$, integrating, and swapping integrals and derivatives, we get 
 \begin{align}\dot{q}_t &= \int w \dot{\varrho}_t(x,w)dw \\
 &= - (\Delta_x U_t) q_t + \dot{U}_t q_t - \int w (f_t \cdot \nabla_{x,w} \varrho_t)  + \Delta_x q_t
 \end{align}
 We have $f_t \cdot \nabla_{x,w} \varrho_t = - \nabla_x U_t \cdot \nabla_x \varrho_t - \dot{U}_t w \nabla_w \varrho_t$, hence 
\begin{align}\dot{q}_t &=  - (\Delta U_t) q_t + \dot{U}_t q_t + \nabla_x U_t \cdot \nabla_x q_t   + \dot{U}_t \int w^2 \nabla_w \varrho_t(x,w)dw+ \Delta_x q_t. 
\end{align}

 An integration by parts shows that $\int_0^\infty w^2 \nabla_w \varrho_t(x,w)dw = -2 \int_0^\infty w \varrho_t(x,w)dw = -2q_t(x)$, provided a sufficient decay of $w \to w^2 \varrho(x,w)$ at infinity. We obtain the following equation:
 \begin{align}\label{fp} \dot{q}_t &= -(\Delta_x U_t)q_t - \dot{U}_t q_t + \nabla_x U_t \cdot \nabla_x q_t + \Delta_x q_t \\ &=  \Delta q_t - \nabla \cdot [q_t \nabla U_t  ] - \dot{U}_t q_t \end{align}
 where I removed the subscript for clarity. This equation is a Fokker-Planck equation (first terms) but with a birth-death term added at the end. 

 It turns out that the density $p_t(x) = e^{-U_t(x)}$ is a solution of this equation. Indeed, $\dot{p}_t = - \dot{U}_t p_t$ and $\nabla p_t = -\nabla U_t p_t$, so that it is easy to check that \eqref{fp} is satisfied. 

### Uniqueness of solutions to parabolic PDEs

We're now left with checking that the solutions of \begin{equation}\label{pde}\dot{u}_t = \Delta u_t - \nabla \cdot [u_t B_t] + C_tu_t\end{equation}
are essentially unique if they start with the same initial conditions, which is the case here. In the equation $B_t = \nabla U_t$ and $ C_t=-\dot{U}_t$. Uniqueness for solutions of parabolic equations is well-known to PDE theorists and can be found in [Evans' book](https://math24.files.wordpress.com/2013/02/partial-differential-equations-by-evans.pdf), chapter 7. We provide a proof for completeness. Indeed, by linearity, it is sufficient to check that the only solution of \eqref{pde} started at $u_0(x) = 0$ is identically zero. Set $\gamma(t):=\int |u_t(x)|^2dx$; we're going to bound its derivative using "energy estimates". We have
\begin{align}\dot{\gamma}(t) &= \int u_t  \Delta u_t - u_t\nabla\cdot [u_t B_t] + |u_t|^2 C_t. 
\end{align}
The first term is $-\int |\nabla u_t|^2$. The second term is equal to $+\int \nabla u_t \cdot u_t B_t$ by integration by parts. Young's inequality $a \cdot b \leqslant \lambda |a|^2 +  |b|^2 / 4\lambda$, valid for any $\lambda>0$, yields 
$$\int \nabla u_t \cdot u_tF_t \leqslant \lambda \int |\nabla u_t|^2 + \frac{1}{4\lambda}\int |u_t|^2 |B_t|^2.$$
In particular with $\lambda=1$ we cancel the first term and we obtain 
$$\dot{\gamma}(t) \leqslant \frac{1}{4\lambda}\int |u_t|^2 (|B_t|^2 + C_t).$$ 
Now, if $B_t, C_t$ are bounded by some constant $c$, we get $\dot{\gamma}(t) \leqslant c \gamma(t)$. Grönwall's lemma yields $\gamma(t)\leqslant \gamma(0)e^{ct}=0$ and since $\gamma(t)$ is always positive, we get $\gamma(t)=0$ and $u_t=0$ for all $t$. 



 ## References

 - [Jarzynski's paper](https://arxiv.org/abs/cond-mat/9610209), written in 1996.